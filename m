Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A6D4706D6
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 18:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236597AbhLJRUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 12:20:19 -0500
Received: from mail-eopbgr40093.outbound.protection.outlook.com ([40.107.4.93]:53377
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236247AbhLJRUT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Dec 2021 12:20:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OyzZzQsSsHIp4IEciogSMjhlxZqEtNh2eySjqWYv8bxZmPTmiHbEgm6QlGNG39zeQB1bMDFELzuyqUrbvtZYbQca8FrOd2Of5/jid/xQn8nEINDwdudDkMTLaqaOJCA0VurcFcjkBYj3zbk5Qcfl3uXqVFMS98egJ4Fh2RtK17K6lZHAWWszHBNE3HfVKO3tN1Acqpt9SS37HEFmtdsYOrOJfNJsfIG710O0JriT0FMn4YpOz5LwhmaaoAvraSaTO6bM8eryMlzTkKVB51QsmiboBpdyLCftFAiLabEQmB5qR0sINTYm2RWDJrc+X77CRZt0bJHH9jOZW/VFjMsS8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VbB4eRreBOG2Tt2F/BvRuXwLvvFxsfeuoFzZbPTy4KE=;
 b=JfkNz6lds2/mF/c+u9JCB5o9os0IeFVWwXdkAF9YnXPToMAVGvRgaD/POn2YA7D4EJ9/0Ht5zPeCt7ndXe72cyfKS3nSRFcKSjsp/ZFc7ee9fxIttoTuAP3aJtXn1N+a8Rnq8LUr19EgLp/RG7J6pAnzAhUl1W4ijOVpr7N1o6YgWLJqYFPlx7VPr8XBXGFfpyIuCSPP3XAwfM4gyTvIGlhjGoxRNGdr1gWEYiWFY4UjeIhLjWbTp4Gq+L72gvhs/gYQi8a+p1E3HLE9wBECaDnq6BJuP7RqC0GCbh/se9zr58axizM6L9if2fQHL5SqiT8U+997scf/UdO1xWA+XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eho.link; dmarc=pass action=none header.from=eho.link;
 dkim=pass header.d=eho.link; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eho.link; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbB4eRreBOG2Tt2F/BvRuXwLvvFxsfeuoFzZbPTy4KE=;
 b=X6pv/VFE2BqByTmNwIR8iJEsqzWVnSQtNr4LiM1vcqOVxeZg2oIRYe1489FqPSfr90Uc39CIjapkwCQTxksjWrGfgkp6YOl3nhzWLRHLIhH9cNSs9w30gjnhkRouuwxpgDF5P4AYW1YH5IoDckCqXV3v/+FPCxPLLkKBYNQf32G1xnJwSsnZnpQWITc93Qj7StPEDILDhocC32RDL1lQbGrvSh01SqCAYzUyzhdFpiR3scRHlSUEd1/fe4Ac+XaKKUEcGUzVtRITzeO2maL7YBn8wf79OVzr3ZoYN/gDXZp5cgdl5hKrjzx0yjGMVxELQqemisWueOMeSzBsGLNfNA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=eho.link;
Received: from PAXPR06MB7517.eurprd06.prod.outlook.com (2603:10a6:102:12e::18)
 by PR3PR06MB6779.eurprd06.prod.outlook.com (2603:10a6:102:60::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14; Fri, 10 Dec
 2021 17:16:41 +0000
Received: from PAXPR06MB7517.eurprd06.prod.outlook.com
 ([fe80::42c:a94b:d533:ca15]) by PAXPR06MB7517.eurprd06.prod.outlook.com
 ([fe80::42c:a94b:d533:ca15%2]) with mapi id 15.20.4755.022; Fri, 10 Dec 2021
 17:16:41 +0000
From:   Louis Amas <louis.amas@eho.link>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, kuba@kernel.org,
        Louis Amas <louis.amas@eho.link>,
        Emmanuel Deloget <emmanuel.deloget@eho.link>,
        Marcin Wojtas <mw@semihalf.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH v5 net 1/1] net: mvpp2: fix XDP rx queues registering
Date:   Fri, 10 Dec 2021 18:16:20 +0100
Message-Id: <20211210171620.679625-1-louis.amas@eho.link>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0262.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100::34)
 To PAXPR06MB7517.eurprd06.prod.outlook.com (2603:10a6:102:12e::18)
MIME-Version: 1.0
Received: from las.office.fr.ehocorp.admin (2a10:d780:2:104:72de:bd96:8c96:f1d5) by PR0P264CA0262.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100::34) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Fri, 10 Dec 2021 17:16:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66733f56-3b40-4eaf-2f21-08d9bc00d4c5
X-MS-TrafficTypeDiagnostic: PR3PR06MB6779:EE_
X-Microsoft-Antispam-PRVS: <PR3PR06MB677976DE7D0A1661B66D698DEA719@PR3PR06MB6779.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OE8BsYqF5xQ6yTWIq5Okujee2uiMQQ6Bf5gN8qPd2zgsZY8rdFm2RqksyWLw0mIVKJjAzIEawHM10crGAYEc8h0fcvN6EBETdSUACqyRBTxRBAgw77slPdpLyxQZo8qgCHXf2ZFWDp8LuBYiz5WGuVixj1L2GfoWGjBjmWVoaxZ13uxnMJsd3LBDqgCczutiYEK4fYb2kc52P5ub4a9SI36+ObC4qMed3bR66bWWlC7EiQE771l9lgN7pNBqzAngt1e1+1XT6nfsbA1njbFXoFhltQRfQ/oU86ZF70js+0VYkRWVhouFKUsokryfU3frho/NKawgzMWQw2y3rnZv6JF0l4QqjJ+OzIfkAeW5BeJehuPkw9VlSoESsGuTphc0osKsOYHHw4Y0KsUNMDY9Ci+FerPF5KxB0+aiv7LcHdZ8TxVuRypuaaZS+RzRWEeqBEWVe9L2JVG1Cs3vhQGbKouXnAYsdphy0jUQ5SoQJuZm6GHJa+wfT3FXFQqyNjAxZKw5x1neISHdAiRRgzo6gZi6cqhO/8hXi+OcevvUywjPpBSEif2/c/BwMOA0O0MT7mEHWqe67UKyNqcSFynnxWHQcy80WbbPCiCbQJCjuZ/fsWq9LA3efTnoyyihuTEgVsfTyrKcXGR2/57OSAoWyqrYe+8I3BKxLuvRNj+/qsXctjkJNPWzxY0flqce+3oeFHp6h0q1JKOUtVjjGxp1fcTUZIC9yT3MTrkj4UtSMyA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR06MB7517.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(39830400003)(376002)(966005)(83380400001)(6486002)(52116002)(6506007)(8936002)(6666004)(508600001)(5660300002)(1076003)(2616005)(66476007)(66946007)(44832011)(4326008)(8676002)(186003)(86362001)(66556008)(36756003)(54906003)(6916009)(38100700002)(2906002)(316002)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hya1cMIUAgEUPWAa6U9vHsR4vicXrsKs8Bi+ipnwMZTdcJBCxKoSOadBpizu?=
 =?us-ascii?Q?Dz6XkKPWT2AHIhk1nsycIPH+aZWISLrTTNOdib/GAeqpB7IjNgkBVbJ/PlIg?=
 =?us-ascii?Q?HJHArZBzaC+YQges06VQpBSY8WU+zAyY/25KjfrDJhoUQsYHXLHuEKI1gVQ2?=
 =?us-ascii?Q?2MDh0mrCz2pQO4VDNPjQE4PIHYjTEWcBR2rA3q4mfZQ39ml4yPf7sYD7X3Qw?=
 =?us-ascii?Q?GAWh8LGJw8Lg7qsBchIRdHVtNaOvpysM+Y6T7vYfAbkHcg/TMZnKjfPNMH5N?=
 =?us-ascii?Q?EfcItkb3eVXCR2q+x2k3SiuqwVXhVi6IK9HjTLii5q7aq6RxwY+TiAlMis3j?=
 =?us-ascii?Q?M8BLxqBDyA2l/ILHjsMSUPHnAjiXcWaX5Go6YKrNOiwx5lXLm1+9VpZeUhCa?=
 =?us-ascii?Q?6dX7aIJj+Ph08HUOyqGFPpouiQjv3ycz4bOQt1WUzEMOvItS7Gafyxt2nZgS?=
 =?us-ascii?Q?0rSw6BUH5yW/5eU0qKtPu8oFo08O/Cv4NypGfLysgBJA6ijhfSuxys4I4MoB?=
 =?us-ascii?Q?iZcL9fbb3doB1X4F7dSHbyaQBXcFvncL32TSdShrqigvNqdRVFlHb79lkae5?=
 =?us-ascii?Q?FIOxdN/FcHGhXETOK9U21KeM867igb5aXxIkFgFhCvEypQvRAtsQXV56gHSH?=
 =?us-ascii?Q?ipblyiUV6S7Mjwfcap8LQu/S1Lel5vuo3HvVf7mQeHlVlngx7mfzy2Qjn9FK?=
 =?us-ascii?Q?rbeT728N4UxdTVQriOMrgcl2XkSVrnUrq7DRvxMmcwwdFSoSWGSP3YWHEDJa?=
 =?us-ascii?Q?PWDOWfct2qodV8zRIF+fqs4e4d/lzFepZuh3EzMpYKulo9IQFJlhjvoMfcjo?=
 =?us-ascii?Q?cHAi2lOLgnGUyDLWIE9XkHsMCqkZdOltRxExI72l/bBfSr+p6KerJO3B5kj5?=
 =?us-ascii?Q?MXDnJIItAcvTsipoNyl3GexLFZvqJFpKOGctgwxPcFLRcAsxrDFo36zHjonJ?=
 =?us-ascii?Q?w8jKeF2MaQAJ1QigDltA7IZtVvcbbGZeDeOcgEvdePiCGn2l19a/Hmv5J/2x?=
 =?us-ascii?Q?JSlD2fpMDoRgOKHKWbGzeBKj5IFcUTjsr3/JrGOJNQqOn0z5sFnaA2IMFRJm?=
 =?us-ascii?Q?xzdmeEByRLWWrjxlyftQ7Zb7GcZf5ecXzX7XeUg6ZKNdvurhHHeX0luxdVQ3?=
 =?us-ascii?Q?cs9qd+EA18t/qmJt63Hc50H5itI4fdEi2KIfdwlivXx7Esgc46ULT5iRdu+Q?=
 =?us-ascii?Q?Xp2C3pugqdXG8iM0sq3omZcTHPYwMl7U4+i2YSJE4RCWIfMZfkzKIc00HKvI?=
 =?us-ascii?Q?3vT0CRaAJeU1VKL52Tpc7WLVggiUjYuBymFcxYhysS2Mgsig5kA4eSRz33rC?=
 =?us-ascii?Q?areZz7bcMMLk1Npo01uEtmdL5Q0rqPfdQ/b+IeW/edRTQTtacmTtmI0tuVlq?=
 =?us-ascii?Q?FjvvK9nW/6ai6VFUH+vl5eDV5I39Z2xB/7Z367JLWEPju6hggVLg9Lnw9aTm?=
 =?us-ascii?Q?TIFuSKBs8E4JemvKRkAQ3raUaF91aJIHBnBVSPcxro/ZHpv0V+Wiul1Oj/me?=
 =?us-ascii?Q?Gc33LgkDNW2Gcad8GNNyEtbK4CtWCXKX5k3lgw+rzZn25XmOdQrTxl7huFFs?=
 =?us-ascii?Q?TG0tCdJFl87HZRYy76sO548bdBQNvhOBPkJA/sIv+GpHR0U3c+Ly5KA1uSrn?=
 =?us-ascii?Q?Vzh1Bzn+F6cGV5RS3mohuQr/lOfyvaiONshq5sp7Ho8aNTp2VO0DdAfr3/Ow?=
 =?us-ascii?Q?mCeqms+iYc85LnK5nXqwtOk97nQ=3D?=
X-OriginatorOrg: eho.link
X-MS-Exchange-CrossTenant-Network-Message-Id: 66733f56-3b40-4eaf-2f21-08d9bc00d4c5
X-MS-Exchange-CrossTenant-AuthSource: PAXPR06MB7517.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 17:16:40.8197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 924d502f-ff7e-4272-8fa5-f920518a3f4c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4MLEisJxqnem4ASpb+bFA8YBk+0RitJlE4/OFsHEpQEy/75e/34Afp73klcmSDqYF+fEpknYb8VAGcubes+M7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR06MB6779
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a50e659b2a1be14784e80f8492aab177e67c53a2 upstream

The registration of XDP queue information is incorrect because the
RX queue id we use is invalid. When port->id == 0 it appears to works
as expected yet it's no longer the case when port->id != 0.

The problem arised while using a recent kernel version on the
MACCHIATOBin. This board has several ports:
 * eth0 and eth1 are 10Gbps interfaces ; both ports has port->id == 0;
 * eth2 is a 1Gbps interface with port->id != 0.

Code from xdp-tutorial (more specifically advanced03-AF_XDP) was used
to test packet capture and injection on all these interfaces. The XDP
kernel was simplified to:

	SEC("xdp_sock")
	int xdp_sock_prog(struct xdp_md *ctx)
	{
		int index = ctx->rx_queue_index;

		/* A set entry here means that the correspnding queue_id
		* has an active AF_XDP socket bound to it. */
		if (bpf_map_lookup_elem(&xsks_map, &index))
			return bpf_redirect_map(&xsks_map, index, 0);

		return XDP_PASS;
	}

Starting the program using:

	./af_xdp_user -d DEV

Gives the following result:

 * eth0 : ok
 * eth1 : ok
 * eth2 : no capture, no injection

Investigating the issue shows that XDP rx queues for eth2 are wrong:
XDP expects their id to be in the range [0..3] but we found them to be
in the range [32..35].

Trying to force rx queue ids using:

	./af_xdp_user -d eth2 -Q 32

fails as expected (we shall not have more than 4 queues).

When we register the XDP rx queue information (using
xdp_rxq_info_reg() in function mvpp2_rxq_init()) we tell it to use
rxq->id as the queue id. This value is computed as:

	rxq->id = port->id * max_rxq_count + queue_id

where max_rxq_count depends on the device version. In the MACCHIATOBin
case, this value is 32, meaning that rx queues on eth2 are numbered
from 32 to 35 - there are four of them.

Clearly, this is not the per-port queue id that XDP is expecting:
it wants a value in the range [0..3]. It shall directly use queue_id
which is stored in rxq->logic_rxq -- so let's use that value instead.

rxq->id is left untouched ; its value is indeed valid but it should
not be used in this context.

This is consistent with the remaining part of the code in
mvpp2_rxq_init().

With this change, packet capture is working as expected on all the
MACCHIATOBin ports.

Fixes: b27db2274ba8 ("mvpp2: use page_pool allocator")
Signed-off-by: Louis Amas <louis.amas@eho.link>
Signed-off-by: Emmanuel Deloget <emmanuel.deloget@eho.link>
Reviewed-by: Marcin Wojtas <mw@semihalf.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
---

Patch history

v1 : original submission [1]
v2 : commit message rework (no change in the patch) [2]
v3 : commit message rework (no change in the patch) + added Acked-by [3]
v4 : fix mail corruption by malevolent SMTP + rebase on net/master
v5 : (this version) add tags back

[1] https://lore.kernel.org/bpf/20211109103101.92382-1-louis.amas@eho.link/
[2] https://lore.kernel.org/bpf/20211110144104.241589-1-louis.amas@eho.link/
[3] https://lore.kernel.org/bpf/20211206172220.602024-1-louis.amas@eho.link/

 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 6480696c979b..6da8a595026b 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2960,11 +2960,11 @@ static int mvpp2_rxq_init(struct mvpp2_port *port,
 	mvpp2_rxq_status_update(port, rxq->id, 0, rxq->size);
 
 	if (priv->percpu_pools) {
-		err = xdp_rxq_info_reg(&rxq->xdp_rxq_short, port->dev, rxq->id);
+		err = xdp_rxq_info_reg(&rxq->xdp_rxq_short, port->dev, rxq->logic_rxq);
 		if (err < 0)
 			goto err_free_dma;
 
-		err = xdp_rxq_info_reg(&rxq->xdp_rxq_long, port->dev, rxq->id);
+		err = xdp_rxq_info_reg(&rxq->xdp_rxq_long, port->dev, rxq->logic_rxq);
 		if (err < 0)
 			goto err_unregister_rxq_short;
 
-- 
2.25.1

