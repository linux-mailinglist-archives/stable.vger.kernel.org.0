Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC36914FCC8
	for <lists+stable@lfdr.de>; Sun,  2 Feb 2020 12:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgBBLGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Feb 2020 06:06:15 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:31004 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgBBLGP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Feb 2020 06:06:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580641574; x=1612177574;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=XES2koAMzAn+jrNRN9pU7/oRTwoU1BNvGUcOReuP/RQ=;
  b=oQptLglo5IODDYAOI3XhbvnV9NVkJ099F5q7Pq+cGQZabxzF8zYDcjpa
   dLqe9v0zAy1RWw3q23NW7DAG6kQIsPFRc2nWXcoWPusoEHpWzPiNatMn2
   yM+mff8F+248cKpQjtEYe8++8hSfOFyB2SKX6CI5SIm9UpvWtY18zDPcl
   JUmPHza6MRUN85nIbpASVBplb5lQXEZDv0OrNCZTLM2p8qeMKTNcc+Wq6
   /PwHEW8OawJOInOPIGiv84w3oOFiOXDPUtnTwSkWjEX7wzmvBdVd8425s
   xA6t2bNDX8yhuzGWBn2kGoC4EJ0rBUL5i/zPkQIRYntVtYWdaaFkUNcve
   A==;
IronPort-SDR: nTaWWAEioI2uFmMN0+/5M1zKl6mugcztt5AwiBxqObfcHoMetYfV/3iBaio/XLKK3MkabgxRJf
 Pd6kql/LXOKpa+p3k7ZJE2qyG29mMr5KMG8Y5emsS5uR/v6kXwhYOOEo8fgPPfDIDKPxpsZyXW
 oSqHrR4GzGQi0/LCZvdv4t94mLy6IV+eSf9zGfhr9QsBXEISP5yzrcxjjsC69q/Vcwq/7INLgy
 skYgve6PLePfa/dvJoMsJcFGQDjd+gLeeOAL5l+Vqbx20dIRTmM5rsIfcK0mHvbINNRx74dIWU
 ulE=
X-IronPort-AV: E=Sophos;i="5.70,393,1574092800"; 
   d="scan'208";a="236870672"
Received: from mail-co1nam11lp2171.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.171])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2020 19:06:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ECVVHzXIaWeGkic2BekVjXfNTte3mogTccsISYkGqFCCh/odK/eDEdMdcEbrBsbQE29OMRF85uXT8M/ImBYNLqV8h6Y9lQM649W3VT5clTliXfe41XWTgcW3xu+28CPgKwNxw6rQNtRJrdzptr8+O4S0SNhq+IYCLvJuRyD7GA2y7110hoWCfJMTusTQs8uW6Y93DaAZ1EpKAE8htKv1njFBhz8VDs8N+hGGTMboJK4C1NUU6zryB/rZQjNJ34mtGkE0LnFEKMqztiQFIW0oQFv99L5fX3Woe+Yw4ImTbVITFkUftkG+MBGxec3zNGNXK3mkSZfN9AdsY2064inNag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bsq9FT9moFZoKzWfdtb5BpXHbdCsbs3tT1XCbncxR8o=;
 b=AYyoP8guh95kxaUDhUBYaxV7NM1xpOPV1UVProy8YwNjNyXdQ+BnaspVcLACX8uZBg6XdyyitHbOgnw6y35JrYYo1GUrhFYcOfD9V2KihP0YH5DDEAg7yAAQMgkuzDEXt0ddKVjzv/kot6x2lf4THqnACvkPTjsMm+xJLKqRg2Q/s7RwMq5/qy3PUcB41rlIeaQud37eUmAM61jzqqVPPuQWqWgeSQXQKfvCDi7/Ou28MghZDX9JFrx5+IjTCNC0o92Yds5sxNyo0y9ZICy6zRHaP/NiA2/3VeVKRnoAlKDvoBuVimn/ujrSTajc2yuZWSbIKSU4l//1fGs+YpJNUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bsq9FT9moFZoKzWfdtb5BpXHbdCsbs3tT1XCbncxR8o=;
 b=DAmbkNAwxMYC0DAPJD3aRYctHN1rkZTP5ZDUzC9+UihBTzv798OZHFHH1Rcz4DoDbtBjVWrhT6bBQSxyB/uX67r95/DzjRuQt2lZeQwMqa2jrg2vMwVEBLsxCNyetjYrf98gXRzH71RSPmbSAajjfSQgG172SvpbVXRGy0FtAKM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6333.namprd04.prod.outlook.com (52.132.169.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.26; Sun, 2 Feb 2020 11:06:11 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2686.031; Sun, 2 Feb 2020
 11:06:11 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>
Cc:     Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Anup Patel <anup@brainfault.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Anup Patel <anup.patel@wdc.com>, stable@vger.kernel.org
Subject: [PATCH] RISC-V: Don't enable all interrupts in trap_init()
Date:   Sun,  2 Feb 2020 16:32:02 +0530
Message-Id: <20200202110202.124048-1-anup.patel@wdc.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0015.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::25) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
MIME-Version: 1.0
Received: from wdc.com (151.216.142.133) by AM4PR0902CA0015.eurprd09.prod.outlook.com (2603:10a6:200:9b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.29 via Frontend Transport; Sun, 2 Feb 2020 11:06:08 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [151.216.142.133]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b47ccb09-222c-4ca0-3f6a-08d7a7cfe925
X-MS-TrafficTypeDiagnostic: MN2PR04MB6333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR04MB633331918D2C4D61E815AB768D010@MN2PR04MB6333.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 0301360BF5
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(366004)(376002)(136003)(39850400004)(396003)(189003)(199004)(8676002)(81166006)(81156014)(8936002)(66946007)(16526019)(186003)(7696005)(4326008)(66476007)(66556008)(26005)(478600001)(956004)(8886007)(52116002)(55016002)(6666004)(2616005)(1076003)(86362001)(36756003)(5660300002)(2906002)(110136005)(54906003)(316002)(44832011);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6333;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gw/8sQw5JnQ5RklLftya4FIy+3v94f+Spx31+hRNpnAUTWpPU9xTPQ5y/PkXyIUEigXJ//cUCm6OZuTMlF+kIKpX63EqzW4W6f1ERWlOW1J8RSmbGhNp1BHf/8m8VEIKanfBau4G/BjzXI6whVT6wGKjOSY5SgzDgCVxjlGCeyHJxHNzk84bJCiWBOIHDKO0dQ2X4DL2AIRuEz8dfsLho5OkBfkVF1ZPchjZ+D+vjos/Jz3/MSyChZKPuHqvgXs/iZnmTkajTbpm5x10p4rLg3mgNxDtcmj0TZ9TnLidsOdZlPTbIJ5Z2y3jBgaKMFQTpxunN2blcJkw8lI08XbtZnJtXPoD+JTKbU3gH3+kZQh8bcyDAfWQ8VNsJNq2QpWV+fphHMeEjWv1xWAfz0uAz6N7YqMTHF82ME+aIL6KE9WaB/J+rM0ulO1JuEj0FrNl
X-MS-Exchange-AntiSpam-MessageData: B1Q6WkUWIGAhYYBzPlJslz/T9erwgvDSof4CTVmJ/Z9M0+bdMnTVoiDrqfoDpGR9lndwNwk2Ak0PRKEfb43uXh2EttphSybke3oajA9x7Ilvipr+qnTYfyJZlSMEDdxWN4d78z5gJqyqbVye1hSVUw==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b47ccb09-222c-4ca0-3f6a-08d7a7cfe925
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2020 11:06:11.2103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g45Bk6FYNJnm3TEc3PRzLiLFEUekIFV5k18HftKvBKq4MHo0zgoCvKFr0tf6JwJ6/TfMZdO9bwj8CEpc5OMOLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6333
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Historically, we have been enabling all interrupts for each
HART in trap_init(). Ideally, we should only enable M-mode
interrupts for M-mode kernel and S-mode interrupts for S-mode
kernel in trap_init().

Currently, we get suprious S-mode interrupts on Kendryte K210
board running M-mode NO-MMU kernel because we are enabling all
interrupts in trap_init(). To fix this, we only enable software
and external interrupt in trap_init(). In future, trap_init()
will only enable software interrupt and PLIC driver will enable
external interrupt using CPU notifiers.

Cc: stable@vger.kernel.org
Fixes: 76d2a0493a17 ("RISC-V: Init and Halt Code)
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/kernel/traps.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index f4cad5163bf2..ffb3d94bf0cc 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -156,6 +156,6 @@ void __init trap_init(void)
 	csr_write(CSR_SCRATCH, 0);
 	/* Set the exception vector address */
 	csr_write(CSR_TVEC, &handle_exception);
-	/* Enable all interrupts */
-	csr_write(CSR_IE, -1);
+	/* Enable interrupts */
+	csr_write(CSR_IE, IE_SIE | IE_EIE);
 }
-- 
2.17.1

