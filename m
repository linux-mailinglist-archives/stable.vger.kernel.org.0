Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2AE3F78B6
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 17:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241801AbhHYPet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 11:34:49 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:26632 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240903AbhHYPes (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 11:34:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1629905641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TaASlo3kEP+tIcse3/IS9fig1jXh82gJGe1JjbdvD4g=;
        b=T+Ee6JhAperIWxhRPSt9S6Jxzp84ktnXvXZ02VuXjHE7n4ULtgWD3oCrtOus4WzJHJuWwF
        f8bY0Lgz5ECwDNkUXnGxki4UNAxeXWW3RupZygPqbhwuhrtlLmpnjOCxpVSclW/4yiXz2o
        aIQGRl7ZkSl4YD+GPTecUG6Pt11d8yE=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2054.outbound.protection.outlook.com [104.47.13.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-38-N7QO3d3aNmGnjhCscygfAQ-1; Wed, 25 Aug 2021 17:33:59 +0200
X-MC-Unique: N7QO3d3aNmGnjhCscygfAQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c5R1g+q19jxA98L+PEXNmL/vvYLqYS9H7yysU/SvsT+j/yyd6VeV1zZmu9sOFc7yKuAQ33KAgNFLpydDou7yQb+BwsLoUtcnbIkMquy8uSXTpOKuEnXsdDRHywPvgch/y0iSMN6kBDnP28eHDW7Qa+U2PNgk22CEL7uaq7vimZU5kfEA0qkZK180wO9xiOTNQ40lGoo4BOgpsdF7qL2bSIAhSLYD2ZXAYhxGNvM1L7oivPO1Vcl1eJPlN7MG9PVlzVPH8mx07WO50j2zdjdYsHaRiyynY5Kvbb/S4Qbv0PL2SbBMVKVB4mr84W/5GOHgKjrczeJ+hPIo3C0Jiq5ljA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HpWmp5RS0cYU5Up6i9e3qSuhhXjCGqAHRW+Kc+kGyOg=;
 b=Eyl3XxrcsVWJm/U2O94ouoaSt0YfEYOl8HaCKUoRJ4c4/J+045iYnN7k82oJDkhFEkxzusDwesj3G+GcCD9jGf0dX8sn2D+/KPI41SMVB0ns2WOi4lIIGmsQ8vhFFpUVw7iYq/unBZ1GxadhZ6kIGgbKK6T0e4imDj3HM06aDlxhfg6m1e+j+q1WKPhIBM0zkOfbT5DCg0uFQm4KdF4VD/FN5er9YVQy740edpW1HRNO4ilONIMWtsGDGYibk6/EfvF/nUeBZTOXAgrorjDaOHTccCteFdt+fQFfGaFnDedclmY38A5GX3jTl+LDg/1C+dJYinWcvWEuEIMeb/mD3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com (2603:10a6:803:e7::16)
 by VI1PR0401MB2336.eurprd04.prod.outlook.com (2603:10a6:800:27::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Wed, 25 Aug
 2021 15:33:57 +0000
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::4d37:ec64:4e90:b16b]) by VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::4d37:ec64:4e90:b16b%7]) with mapi id 15.20.4457.017; Wed, 25 Aug 2021
 15:33:57 +0000
Subject: Re: Kernel panic in __pci_enable_msix_range on Xen PV with PCI
 passthrough
To:     =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>
CC:     linux-pci@vger.kernel.org, stable@vger.kernel.org,
        regressions@lists.kernel.dev,
        xen-devel <xen-devel@lists.xenproject.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <YSZgkQY1B+WNH50r@mail-itl>
From:   Jan Beulich <jbeulich@suse.com>
Message-ID: <3e72345b-d0e1-7856-de51-e74714474724@suse.com>
Date:   Wed, 25 Aug 2021 17:33:54 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YSZgkQY1B+WNH50r@mail-itl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: PR3P191CA0020.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:54::25) To VI1PR04MB5600.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.156.60.236] (37.24.206.209) by PR3P191CA0020.EURP191.PROD.OUTLOOK.COM (2603:10a6:102:54::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 25 Aug 2021 15:33:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1b5d543-656d-4f2c-2d68-08d967ddc0f4
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2336:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2336A379798ABEFD78D738A2B3C69@VI1PR0401MB2336.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JNi70bZ7vN9cixLmr31BPbGNwt860iMpPwoYbiWAmNIKmpbE6BjEFi18rIZZvkTnXjAFsLr5QviV06MQiFyvtYC237rfIyOWvw5v0HZ82v6RAnBnrFL2loKx3FtHssAtn4rIuDzqhcDsM7TAOmbrUAIThcAD84V4qbjih7wJDeYqqTT4LQ5nEapi3UenI+LU5DLRE4BRbr5BRRAChH59HHH68ydgch2Myv3up48P3afGhc57N4BoH/uowcsvjBXE2KtubCzG5VfFd8/hHBLkPlZ4Cyh9bPmkzfYbdr0C9zYfEvWAXGA4vrExidPKhJWsHQGmX6lb491nNDCnQKVhoCxdbiAs9BpdtdCwS8Bdjg1qVb+si4v+OWUgGgq6S0hZfCvN7EmuGtjzc+ngrv9VrqwgncBAnesVRjGxCJ2DCnfl+4zaxzd7F4I/zyyuSiEGUgxcqgssgx/vLIO81bRxoSWaG0IThNEm5UJEo2IEM7H+DXi/OfV40EyvNAWHlmfB/voFBDgH9eqiyY6ur+GfUa7kxRH1zOryavtoPXz/av/S4cU2ynSu+vnLNZUIaDNfvpOG3qO8uhioOp+2emNBqx9CUu19KiNF2dLJC2gGYDjcjJZLqBIbgG9/m1PZBDD97TfNa4QwpZysmB0l5fq5p000dS7GThuxn5nww7LW+NANRoRnAl06Y7B9LZrmsSHwX5gqerFOHGAgP1M+Z2t49pRx+GOey7OXERI+7rWnt4w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39850400004)(136003)(366004)(396003)(346002)(31696002)(38100700002)(66476007)(53546011)(8676002)(66556008)(86362001)(8936002)(316002)(956004)(66574015)(66946007)(26005)(2906002)(186003)(5660300002)(478600001)(4326008)(83380400001)(36756003)(54906003)(6486002)(16576012)(31686004)(6916009)(2616005)(45080400002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zm/D5lxC7AT+DAdMMfnkrPtyj3O1wKidk7Gfsu4PHTyvBhApcKSxdTPmaykP?=
 =?us-ascii?Q?qci+vXY84NsdDw2d1rIfIdmOvfNnssEHX8vdpAHDc/VAGbkcfL1MnfQjYIZr?=
 =?us-ascii?Q?FzdoYsNrVvgHrG7p0CT/IADJ0LLP06uriGHC27S2s1p3vhd3Cga7VTSLWmnq?=
 =?us-ascii?Q?OJeOuFCJrUsEEJtLenivI8x380JXh/JZF3wk/uWHDivAfgwj7ntAKaSjdwPW?=
 =?us-ascii?Q?nEVeDfIxOhqFjOv3I+aYRmyD1oGMGEUDKi6hmhS4+8Zz3dNzGewYG8zlZRML?=
 =?us-ascii?Q?IC33ZMeVgT46H1x5pjkBmPDTiMDrcawCdIiZ4eETayMk/dE/6utSDp9S/k7B?=
 =?us-ascii?Q?UXDcqHZVcvFuOI5z5EaeC8GPtbksqp/ozkaXHwFS6t2uYrR2xZPpYwRdc/tR?=
 =?us-ascii?Q?tPxuAtXXj8Dv1NN/mjJYphUn9y/Rr0E3rDBr+55gsa9CPDNezJwh6BnmkEwW?=
 =?us-ascii?Q?Jw0nH26xXCgaW3w92Jn5Kwle4c5uiWF1+pXm/8HLjAZPLg3IbAIW31FGhpSa?=
 =?us-ascii?Q?QPqIrurm+gkIdWmjRLmRCn9nd6cP/IK+UFxoSPhc+5GnlDz2Xe4cvfLCWILR?=
 =?us-ascii?Q?MnD87vooZFqQomFhrpE+L95M+ZLedovpY+FVS1LUf514Ggd3o0ixC0KxsrmH?=
 =?us-ascii?Q?DBv4HeltGJLcCiSpIReMz+jjmCkx/jtigwZO8tegt1Lgu2qA94tDfFYwiQnp?=
 =?us-ascii?Q?nohl0HVb6Fo62i1rz08W3DR1iG4XCCrZmDQ7eJQlnLuXGvrEG0DTIl7K5N+w?=
 =?us-ascii?Q?jcvch3QIh8zCtsPJN0tD/pteC21pP3fveE5r5Xm0a/DhA27RiDIGf1CJT7f5?=
 =?us-ascii?Q?/pq7YygIletEtmYv0ScjtIl/GzlgEP494Ju0/uyVw29gWcTJz75FWBTuVLxg?=
 =?us-ascii?Q?t+XqW0QAwIIwma2FXaJ8dtzKlf8W5jcWvf+xaYAZpmUdfNfuGEDfNCgiCAsA?=
 =?us-ascii?Q?danz39lU5cGvtzOJygvw6NurHWNMYRoP9OyCzf7DciZ9JZ4iIOlYqNRKJLH7?=
 =?us-ascii?Q?HtAeFYcW2eAQ1YJ5hagBYpWdI9hjQV0UJXbYVJI15yTqvpOOVTqrSPJ2b+1w?=
 =?us-ascii?Q?jky7wsarduKiScsIoQQdjH6zImBo3Pa8qG5ijO3hNSpehgmzoBl7oBHuZRQ2?=
 =?us-ascii?Q?KqZ3AOWTIlOXGNRczpX+ADvEcV+tZBb6yXklthexGToB9TrBoxPooGdob7as?=
 =?us-ascii?Q?HuYncO6GwKF1Sfk1krBKWQSzum/uq4kBTLgQ96u8kUmhhqOyF1gUgkcIGA4u?=
 =?us-ascii?Q?0ADHc+Dg2BoEgIrmnkRXNRrUmyWhqD7S4MYq0302fnKBNxse/AwpGtnH4O97?=
 =?us-ascii?Q?456BbXfa0cfS/s+dpknZpW+4?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1b5d543-656d-4f2c-2d68-08d967ddc0f4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 15:33:57.3496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cig7oXyIz+2NW14NzRnkty1UqIeu3zdV1jgWa9qyhK4+LbtSmbYHO7S2/SrymX4LyMODW1EwZ/AaFD+8VnmSCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2336
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25.08.2021 17:24, Marek Marczykowski-G=C3=B3recki wrote:
> On recent kernel I get kernel panic when starting a Xen PV domain with
> PCI devices assigned. This happens on 5.10.60 (worked on .54) and
> 5.4.142 (worked on .136):=20
>=20
> [   13.683009] pcifront pci-0: claiming resource 0000:00:00.0/0
> [   13.683042] pcifront pci-0: claiming resource 0000:00:00.0/1
> [   13.683049] pcifront pci-0: claiming resource 0000:00:00.0/2
> [   13.683055] pcifront pci-0: claiming resource 0000:00:00.0/3
> [   13.683061] pcifront pci-0: claiming resource 0000:00:00.0/6
> [   14.036142] e1000e: Intel(R) PRO/1000 Network Driver
> [   14.036179] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
> [   14.036982] e1000e 0000:00:00.0: Xen PCI mapped GSI11 to IRQ13
> [   14.044561] e1000e 0000:00:00.0: Interrupt Throttling Rate (ints/sec) =
set to dynamic conservative mode
> [   14.045188] BUG: unable to handle page fault for address: ffffc9004069=
100c
> [   14.045197] #PF: supervisor write access in kernel mode
> [   14.045202] #PF: error_code(0x0003) - permissions violation
> [   14.045211] PGD 18f1c067 P4D 18f1c067 PUD 4dbd067 PMD 4fba067 PTE 8010=
0000febd4075

I'm curious what lives at physical address FEBD4000. The maximum verbosity
hypervisor log may also have a hint as to why this is a read-only PTE.

> [   14.045227] Oops: 0003 [#1] SMP NOPTI
> [   14.045234] CPU: 0 PID: 234 Comm: kworker/0:2 Tainted: G        W     =
    5.14.0-rc7-1.fc32.qubes.x86_64 #15
> [   14.045245] Workqueue: events work_for_cpu_fn
> [   14.045259] RIP: e030:__pci_enable_msix_range.part.0+0x26b/0x5f0
> [   14.045271] Code: 2f 96 ff 48 89 44 24 28 48 89 c7 48 85 c0 0f 84 f6 0=
1 00 00 45 0f b7 f6 48 8d 40 0c ba 01 00 00 00 49 c1 e6 04 4a 8d 4c 37 1c <=
89> 10 48 83 c0 10 48 39 c1 75 f5 41 0f b6 44 24 6a 84 c0 0f 84 48
> [   14.045284] RSP: e02b:ffffc9004018bd50 EFLAGS: 00010212
> [   14.045290] RAX: ffffc9004069100c RBX: ffff88800ed412f8 RCX: ffffc9004=
069105c
> [   14.045296] RDX: 0000000000000001 RSI: 00000000000febd4 RDI: ffffc9004=
0691000
> [   14.045302] RBP: 0000000000000003 R08: 0000000000000000 R09: 00000000f=
ebd404f
> [   14.045308] R10: 0000000000007ff0 R11: ffff88800ee8ae40 R12: ffff88800=
ed41000
> [   14.045313] R13: 0000000000000000 R14: 0000000000000040 R15: 00000000f=
eba0000
> [   14.045393] FS:  0000000000000000(0000) GS:ffff888018400000(0000) knlG=
S:0000000000000000
> [   14.045401] CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   14.045407] CR2: ffff8000007f5ea0 CR3: 0000000012f6a000 CR4: 000000000=
0000660
> [   14.045420] Call Trace:
> [   14.045431]  e1000e_set_interrupt_capability+0xbf/0xd0 [e1000e]
> [   14.045479]  e1000_probe+0x41f/0xdb0 [e1000e]

Otoh, from this it's pretty clear it's not a device Xen may have found
a need to access for its own purposes. If aforementioned address covers
(or is adjacent to) the MSI-X table of a device drive by this driver,
then it would also be helpful to know how many MSI-X entries the device
reports its table can have.

Jan

> [   14.045506]  local_pci_probe+0x42/0x80
> [   14.045515]  work_for_cpu_fn+0x16/0x20
> [   14.045522]  process_one_work+0x1ec/0x390
> [   14.045529]  worker_thread+0x53/0x3e0
> [   14.045534]  ? process_one_work+0x390/0x390
> [   14.045540]  kthread+0x127/0x150
> [   14.045548]  ? set_kthread_struct+0x40/0x40
> [   14.045554]  ret_from_fork+0x22/0x30
> [   14.045565] Modules linked in: e1000e(+) edac_mce_amd rfkill xen_pcifr=
ont pcspkr xt_REDIRECT ip6table_filter ip6table_mangle ip6table_raw ip6_tab=
les ipt_REJECT nf_reject_ipv4 xt_state xt_conntrack iptable_filter iptable_=
mangle iptable_raw xt_MASQUERADE iptable_nat nf_nat nf_conntrack nf_defrag_=
ipv6 nf_defrag_ipv4 xen_scsiback target_core_mod xen_netback xen_privcmd xe=
n_gntdev xen_gntalloc xen_blkback xen_evtchn fuse drm bpf_preload ip_tables=
 overlay xen_blkfront
> [   14.045620] CR2: ffffc9004069100c
> [   14.045627] ---[ end trace 307f5bb3bd9f30b4 ]---
> [   14.045632] RIP: e030:__pci_enable_msix_range.part.0+0x26b/0x5f0
> [   14.045640] Code: 2f 96 ff 48 89 44 24 28 48 89 c7 48 85 c0 0f 84 f6 0=
1 00 00 45 0f b7 f6 48 8d 40 0c ba 01 00 00 00 49 c1 e6 04 4a 8d 4c 37 1c <=
89> 10 48 83 c0 10 48 39 c1 75 f5 41 0f b6 44 24 6a 84 c0 0f 84 48
> [   14.045652] RSP: e02b:ffffc9004018bd50 EFLAGS: 00010212
> [   14.045657] RAX: ffffc9004069100c RBX: ffff88800ed412f8 RCX: ffffc9004=
069105c
> [   14.045663] RDX: 0000000000000001 RSI: 00000000000febd4 RDI: ffffc9004=
0691000
> [   14.045668] RBP: 0000000000000003 R08: 0000000000000000 R09: 00000000f=
ebd404f
> [   14.045674] R10: 0000000000007ff0 R11: ffff88800ee8ae40 R12: ffff88800=
ed41000
> [   14.045679] R13: 0000000000000000 R14: 0000000000000040 R15: 00000000f=
eba0000
> [   14.045698] FS:  0000000000000000(0000) GS:ffff888018400000(0000) knlG=
S:0000000000000000
> [   14.045706] CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   14.045711] CR2: ffff8000007f5ea0 CR3: 0000000012f6a000 CR4: 000000000=
0000660
> [   14.045718] Kernel panic - not syncing: Fatal exception
> [   14.045726] Kernel Offset: disabled
>=20
> I've bisected it down to this commit:
>=20
>     commit 7d5ec3d3612396dc6d4b76366d20ab9fc06f399f
>     Author: Thomas Gleixner <tglx@linutronix.de>
>     Date:   Thu Jul 29 23:51:41 2021 +0200
>=20
>         PCI/MSI: Mask all unused MSI-X entries
>=20
> I can reliably reproduce it on Xen 4.14 and Xen 4.8, so I don't think
> Xen version matters here.
>=20
> Any idea how to fix it?
>=20

