export class Contract {
    contractAbi: any;
    wallet: string;
    network: string;
    to: string;
    from: string;
    value: number;
}

export class Transfer {
    address: string;
    args: string [];
}
