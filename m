Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB16F338F5E
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 15:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhCLOET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 09:04:19 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:31306 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231519AbhCLOEI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 09:04:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1615557847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fSU36SIaOIAn1ltPAjHWIp3Fcu6CdTw1fZJB5aGWbVc=;
        b=EhIkoz2S6KqZ/fgsg5HMcsZhXwglWfID02+yZeO1oa8lLRSJgvVE4UQuN2sRhu2eCcjsQf
        1/3qE1IjopI0qn5rpbcswHxBJYBihwqJ3tc0+MxzK6zmnFOh9SXs7dVVxo4OXhgFaobafR
        w4JiIRk0o0lmAFIKxdWQHkisUNZCfJ4=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2054.outbound.protection.outlook.com [104.47.9.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-2-gMwBwQ3FPzu-hE9KpcquJg-1;
 Fri, 12 Mar 2021 15:03:00 +0100
X-MC-Unique: gMwBwQ3FPzu-hE9KpcquJg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VbOgq3eU8n9ppZYCCyn3Pu7qoLA4w+VCK5PVCaEbv8RDKdi/euFzK96DdTddFKo/vUF/h0/RaEo4Ty6SfsRTPp8eT3JQVhp1GuO3KMKR/ifcP4tfdks4zM2EjmUCjGJpumRD8DvkD+T4fOOEo2/jdXrVhHhFImrNiKi2NADY4AJgtWSPY592xHfDqvkZr7O5OTdZl/83pa/Gthjmb2lHKs19MJwlAYehh6hTjuRI1YPYi/JKZvcNnu+QVRzWiEoUbEG9Ey9Mk1eccdv9lT2JSRK8te4IGeRdfFIBkS1NISI9Kq3erDDdCAPm6+Hj4zISyo/hlq3zlC4jvGzxEYV2Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSU36SIaOIAn1ltPAjHWIp3Fcu6CdTw1fZJB5aGWbVc=;
 b=DUX20LwiZXwnJebQBs2SlVMQ8wjaEGNMzN8haraIwYtIlcgA2bblmNLSkIzgGVRLDMVuBpPeu6fql/wgJ8T/BvOnqiLRP6vEuL4MTZXNhTr1JCDWo7MJxYL2uBlmG1N7jX0PfFAGhMFQmBnPN72p8z09Ly8k/B3WhQVy42mqBixB1lxpdUdWmcq/EN7CdwGGjW+jZuLvyjr/S8vfosVe13qi613BxMP8kCOxx9VZFIp2Qh3MU9UeVrGeyBZy6Hn5hbB1EwBvjV73DyjMU0kobUToA8awNC9GGj7gNUx2cDmIyfXXdJlgp3zYrVP9yvikFhtqomHnFFE0d9X0kijRlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0401MB2382.eurprd04.prod.outlook.com (2603:10a6:800:23::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Fri, 12 Mar
 2021 14:02:58 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3912.030; Fri, 12 Mar 2021
 14:02:58 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     gregkh@linuxfoundation.org, sprasad@microsoft.com,
        stable@vger.kernel.org, stfrench@microsoft.com
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] cifs: fix credit accounting for extra
 channel" failed to apply to 5.10-stable tree
In-Reply-To: <161554344221530@kroah.com>
References: <161554344221530@kroah.com>
Date:   Fri, 12 Mar 2021 15:02:55 +0100
Message-ID: <87y2essc4w.fsf@suse.com>
Content-Type: multipart/mixed; boundary="=-=-="
X-Originating-IP: [2003:fa:70b:4a74:5e00:fecb:7ed8:3a23]
X-ClientProxiedBy: ZR0P278CA0019.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::6) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:70b:4a74:5e00:fecb:7ed8:3a23) by ZR0P278CA0019.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 12 Mar 2021 14:02:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd932900-7d31-4f2f-6489-08d8e55f8a05
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2382:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2382FC5D3D472E993C8E3EA0A86F9@VI1PR0401MB2382.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cRnpmN32IQNVBqqKvRM+2r+sMbpP3N9ztBg0ZcnhYu7sng5O+k4CGSgQ2j7ACx92lEAGdipYdaW7gMjAGqH9YNL6qeA5JCdaEdDT64cBEnLhtYdoRUchGWU6RfrM8CVkD+G1hzvhOcF+QcrdFe7CFAappVQF51OciXyUQ9b8JlztPjFjjRpcnW/llnk1VG2JBuBNqItgmq9p7znWQ416HO19F3mcApxoQqb17wcp9mr2ImfsQyp5d0mM0jiWEsHWyVAjfxagVIwQ5KVivrUQ5jUmc5PE1Uu013e8rNf6e4U3JJfS4A2jYP8AUviZla9u7AuzsM0nrMEqYixTtyIS94SMv9cWculpagimR6isfz6LPars5eX+SiD/FNxWl3yokk7fWDkCTY8oTl6dWS/i75gI3AFpNVOKO1s1Da/N8AKl48w6Z0bj4XuFZC6QpP49xRD0Lnq9SFD2n7BcNW7uw7l/K8j89WOj4EGv1OVUg4aQzB7f2kg/jZmrqdm6FRU6M9wrahpdJtXImCb23YLiIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(366004)(136003)(376002)(15650500001)(4326008)(52116002)(478600001)(8936002)(66476007)(66556008)(83380400001)(66576008)(6496006)(86362001)(33964004)(8676002)(2616005)(5660300002)(6486002)(16526019)(186003)(2906002)(235185007)(36756003)(316002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Tt5u3iMdl4N52oFKyXEkFj7Dlqfk8KbFRQi8TkNEWv9XXV83MfR3OpxVy1LR?=
 =?us-ascii?Q?zSJA5XVdwS6J2RoSD89v2N3aK6oFuF3AkjahUXRPVCgGiUWRlIzLLHhcRFhv?=
 =?us-ascii?Q?NM1tXeIyNfpT6AFOak8oismq6kLIk0pncSemV+Lq0Qw0jY4pKmsnxLKEpEOR?=
 =?us-ascii?Q?83wA2/Eq9B+pX8SBfUQqnJz8DTvHGuKy+mwVzllTs8YMVVB+9lb+mnqKXOyl?=
 =?us-ascii?Q?zllfnwHXINkWxTqTovgJau2k4tUNWV/ltj1duUv+nBdDuFTNtxoeYHI6kOzt?=
 =?us-ascii?Q?ZWCZejHGcAwT2HeheEpRPy0E+P0HsxrcyJv/MBO6VLIDIHuHu4UMhz/dkiNd?=
 =?us-ascii?Q?w8MZi0fPA+rXA3dGoKJcTRIkLjhTtFRhDPyeN6ttKU+X+4PQR9pIwA+5bBev?=
 =?us-ascii?Q?bWvmR8t5nJ3w4aYEgpFnpB0D1Huw0nx+ApAeVfztbhyE0PQ4aROVltxTrJ8k?=
 =?us-ascii?Q?AwffYCJTllHpiCA8RfTWc2alBBN/Dgv3GY1zZ38bDepOwvoMiyIXpoK1ag0m?=
 =?us-ascii?Q?KxszOB5fGzVX0+/brzsGp2xUeuZEaDcShGkgU4RnVdDfb+iitSfQ2m6cFSIv?=
 =?us-ascii?Q?8vPo8DTc4PqgtQT4BwrIioPCuoDdqBpPd4mYjwvY7cq9bfSK11ToW3b4PI6s?=
 =?us-ascii?Q?TxhgXCDSwCP1FK9T8IM/P7MMtsJIW/nIbKVnpgw9UOILeB3Y7GlLJ+Arc4Lv?=
 =?us-ascii?Q?2SHmSMQmiP37serunwaLDxlVETzHltbe9kfu07hTJazKvdECCF27MLStDqKr?=
 =?us-ascii?Q?wpzKzrDLYAMQwgp26mDBZXmGtd672XniBcNmX7jGnRyVAOIS4MpyX7bdL/sM?=
 =?us-ascii?Q?MLUReAPtC8SSWG2eNMq3tN3FLi2ZY85WDmGX8XCeQ++YTrs7/1GaX6qVllnv?=
 =?us-ascii?Q?J07yu15Zi5JY2jbJKpIJE/oH114vc2/kz1wt+NuYrPiwqxDD753javP7n6Dc?=
 =?us-ascii?Q?yAYzKhKY4Gm2YzcXqdnaOpBaSoQ2hHWuTDdPCZ/NJD61HdIJMhbcmhs5pNcU?=
 =?us-ascii?Q?k1Jt0D70gWZX4xwYMubw41lCpTioiZanqT4YImpgckoTRu9B4JzAWXQ9yJ79?=
 =?us-ascii?Q?n9vLEMGZCAU8x5LKFmEq7dTQHGQgv1qpcA/ESLI5ijKe7P+8p1GuWp73PrZF?=
 =?us-ascii?Q?v349euNhsfW7mgcZ64+5YMOe3bJ/fkXGfmFn45Otx6khSiWBVNuEr8EgfdbL?=
 =?us-ascii?Q?uBhZBfIAsJRvDe5fc4vF2FwpjpvHeoCKucoPTqudxI1zJg5IbG1z6U5q0OrP?=
 =?us-ascii?Q?hl3pRKzjYFq0Iw3UIBBF7VUeRbpXoT/pKR6Cgraa7KbNOI9EWqiRg0XB7uqO?=
 =?us-ascii?Q?culTeiXDe3P6175Oyf5n+I4y8SgyjzrYwle284IfOd0vysndmWjgg8sPy/3j?=
 =?us-ascii?Q?F+um2bocAlQDg1Urg5zpY6cTTWCo?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd932900-7d31-4f2f-6489-08d8e55f8a05
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 14:02:58.2263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4RFs0Frh/QxAzoKnI8V3VzO0zzVOKqIwvNQZyNjNmlhjorvvC8A5BtIYEuhO3YhT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2382
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Greg,

I've attached the backport for

 a249cc8bc2e2fed680047 ("cifs: fix credit accounting for extra channel")

for linux-5.10.y


--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment;
 filename=0001-cifs-fix-credit-accounting-for-extra-channel.patch

From 7ff12ff16af1dbb74afd689354809879760e7a90 Mon Sep 17 00:00:00 2001
From: Aurelien Aptel <aaptel@suse.com>
Date: Thu, 4 Mar 2021 17:42:21 +0000
Subject: [PATCH] cifs: fix credit accounting for extra channel

With multichannel, operations like the queries
from "ls -lR" can cause all credits to be used and
errors to be returned since max_credits was not
being set correctly on the secondary channels and
thus the client was requesting 0 credits incorrectly
in some cases (which can lead to not having
enough credits to perform any operation on that
channel).

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
CC: <stable@vger.kernel.org> # v5.8+
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/connect.c | 10 +++++-----
 fs/cifs/sess.c    |  1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ad3ecda1314d..fa359f473e3d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2629,6 +2629,11 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	tcp_ses->min_offload = volume_info->min_offload;
 	tcp_ses->tcpStatus = CifsNeedNegotiate;
 
+	if ((volume_info->max_credits < 20) || (volume_info->max_credits > 60000))
+		tcp_ses->max_credits = SMB2_MAX_CREDITS_AVAILABLE;
+	else
+		tcp_ses->max_credits = volume_info->max_credits;
+
 	tcp_ses->nr_targets = 1;
 	tcp_ses->ignore_signature = volume_info->ignore_signature;
 	/* thread spawned, put it on the list */
@@ -4077,11 +4082,6 @@ static int mount_get_conns(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
 
 	*nserver = server;
 
-	if ((vol->max_credits < 20) || (vol->max_credits > 60000))
-		server->max_credits = SMB2_MAX_CREDITS_AVAILABLE;
-	else
-		server->max_credits = vol->max_credits;
-
 	/* get a reference to a SMB session */
 	ses = cifs_get_smb_ses(server, vol);
 	if (IS_ERR(ses)) {
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index de564368a887..c2fe85ca2ded 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -224,6 +224,7 @@ cifs_ses_add_channel(struct cifs_ses *ses, struct cifs_server_iface *iface)
 	vol.noautotune = ses->server->noautotune;
 	vol.sockopt_tcp_nodelay = ses->server->tcp_nodelay;
 	vol.echo_interval = ses->server->echo_interval / HZ;
+	vol.max_credits = ses->server->max_credits;
 
 	/*
 	 * This will be used for encoding/decoding user/domain/pw
-- 
2.30.0


--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

--=-=-=--

