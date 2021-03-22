Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99A934431C
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhCVMsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:48:45 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:35241 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231853AbhCVMpc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 08:45:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1616417130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IDfIYUuvg3l13s4UiUIIDqNyJd88FZ4pD4D02Wxq0sA=;
        b=kMkUgnhbfr8ZzmPrcJZ+SBecj1pHHmOHNg+CGiAGdFQ78+e4wUS8JK7sucmoJYrF6/h2hN
        FK8nacPGyJgrzaKr08itsOcX+W7TOC2j4arM1X4S/yiaDWpSxYcvaV42moTbQnISRnYQih
        yMoobfu1CSCTDFUT/k3vmuvAIKNnzVw=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2112.outbound.protection.outlook.com [104.47.17.112])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-34-dZ3FEb5uN6WgRAACyMTLsA-1; Mon, 22 Mar 2021 13:45:28 +0100
X-MC-Unique: dZ3FEb5uN6WgRAACyMTLsA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lKAZPOPnoeJPvs6Z09eqCxxsS2i8Wlv515Cya8zAeRBhzVMYNTamLdfhHetrUmQe2qxeAaNOd02WfmdeXH/oqR61Kf8lpm/lwbVuoPPY+Ok8Snocz7OW+C3Y2R3SF1MGGy/vkBKVFQ8V5Gz3wY6UeTIDWnFp8XDCC6EfUbZfuywM2x7cul6RMPiVty7jcXjnHzgXQPx+JW+MCNu5Dv9XA2w5rrragJHmDQ3pROXK72bFCoqQySsMyd4LKtu/FYjiy9GBheGxf+36MBZk0i0eR0Sz4zZUl9CD6S97I+tyuiMseimVUlXFsh4+noEvWVdu+UoaxlzKl4uQ0+R5d5bBBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IDfIYUuvg3l13s4UiUIIDqNyJd88FZ4pD4D02Wxq0sA=;
 b=VhZczyTxkj8UnNJo5OBKkUTSbixt5LsH1rhWH1JqqSfzX3DaY0wHsVyMf1WUiRJrPERfQdAGEAF+hN9/Ao19WRVzmnQrtWimH1uYA3rvu3Vcx8tyS4/k3orZqf8zC9NuUxjbOxYPwcaPlExkIVGpsyKkHcy/IyilBSmVFG13sQwEi7/NMhMFFL8ILdzjCxzx/jPAUxQ8lt3690K5sMBJfUmoUH5QAlo3zAORWW32w42wjhsCDfJZBWafUnX1rPFj6zmk7UeSv9a3N9E+nuQymLFdwaZ9ffBw3E0dEY8mwf+EVtCXlsErUFhayvgOZLyFNiebvJsT3YtpvS582fsn4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB5215.eurprd04.prod.outlook.com (2603:10a6:803:59::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 12:45:26 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.3933.032; Mon, 22 Mar 2021
 12:45:26 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     gregkh@linuxfoundation.org, vincent.whitchurch@axis.com,
        stable@vger.kernel.org, stfrench@microsoft.com
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] cifs: Fix preauth hash corruption"
 failed to apply to 4.19-stable tree
In-Reply-To: <1616328256183102@kroah.com>
References: <1616328256183102@kroah.com>
Date:   Mon, 22 Mar 2021 13:45:24 +0100
Message-ID: <871rc7s6fv.fsf@suse.com>
Content-Type: multipart/mixed; boundary="=-=-="
X-Originating-IP: [2003:fa:700:2815:b96b:85ea:1f90:5f2c]
X-ClientProxiedBy: ZR0P278CA0060.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::11) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:700:2815:b96b:85ea:1f90:5f2c) by ZR0P278CA0060.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 12:45:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ac6c9ce-ed9b-414d-c09b-08d8ed305dbb
X-MS-TrafficTypeDiagnostic: VI1PR04MB5215:
X-Microsoft-Antispam-PRVS: <VI1PR04MB521561018151E8CC3F17862FA8659@VI1PR04MB5215.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PgG8B0HlYpyG6oiqSiPho1txmFyV7ZlZGnveUGQFGSPe5CmhAqwxg/Qsyc/10XEqfpYSX9+yllG8qNJy3IwLj3WwFluz8qev9k3fY6izcrWvszDgsPeQ9hL+OYbaR0VZHStVOa/22dWL/XPSNmeWT5m+kC3rC0cC6OSsWJigbRzXIc2iaq4oudiitzCqasVIgAs2EkKfj7SAp8ipaiUkbpDk8pFHybi8yWDlDP3riRFMiTwtn9LK63rrJVQlHoHGpc/ycPbXriO59Tub1YUahOZUFUK0F/LQCeWNf3r5ikWmIFHq+/m9OrxC7SEm7uLe4RwE9B3q8/ECsZpt/D0jSrBhhMm421vAKpuKE9/Sj4kjPmuGZvBQdmtjOB7f32kxbu6pGlNb7Zv8KfoBg08bKSohgIwIXbGbUHtZtCw1KP3ZadMo5ZxF0qcslx2ITCcGEt4AVCOUIi8Hi6Sux5H0nnVqdaEgHC7iQsmmNz4vKlp+v1TieTkuIYUyQEoYg6jY32wG3JyAxmxWGhGpC9g3IEC/rda5z6fOHQIPQFv5tLD7GLjFn/Fcvgk0ku6YfA3EG11acUXNMkS/2WaWpzNMqXRdJd3/XuZAKJWJe4ySG2xvCTGUFt8bee89fvsJ7mCiF2yhSJlDjFFbPU+WzV33kg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(376002)(366004)(396003)(33964004)(316002)(478600001)(235185007)(6486002)(38100700001)(86362001)(5660300002)(6496006)(52116002)(66576008)(2906002)(36756003)(8936002)(16526019)(186003)(8676002)(4326008)(66946007)(66556008)(66476007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9M2ESNFh/4jhpexZBdd5ngPIDPYd4jp5mFwOCmyVfaqiHNJ89IVKdUulzAIO?=
 =?us-ascii?Q?gxosXIaWQVjZMsR0dvTy2P8qbCPThLJ6EOFIXq6HcZ2S5GM+ruLKMhuG8Bxx?=
 =?us-ascii?Q?qEebhzjCTgUqm5aYxCeo2G/yk+8OiM34BCw79QPq2POOciG+woBOyqrazE/P?=
 =?us-ascii?Q?kwunPBM0XpcIest/U60dqDQ7mXMCt2pGKvhJSfuAthAeMhFX9XtSOx2Tygf1?=
 =?us-ascii?Q?5AtlifH3p6F35R3b77Boioh/twkJEvy8vaRbr4PXq1NspGkdjsi3tbxJaBkw?=
 =?us-ascii?Q?AzySJIDza9/QT21y1LU4nKlTbDjRrOtE6cuOKiZ5ZYZZAzsogPZQuUGiw0/m?=
 =?us-ascii?Q?bRdN8UvKuX18AGb3sUbLtKTP3TevotACbtSExQQ5J42Ln8sLWkHm34gfXUQa?=
 =?us-ascii?Q?pwosrE1ICGj3Yx7vcYH/coIYyMRSpcTt43lJRNZoiC9sKysSkHKQRTLuAiwr?=
 =?us-ascii?Q?A6ZvAMoGFOI1aHS/G42pxx6VGSPbMopE+nh+Sr6lui91hU5do2nG+g1WLvsu?=
 =?us-ascii?Q?/sU2B4SKDzNcXXxX8S+zgYDZ6wC/xySBOKaLWTB9s06tmAp3MB1+6lZS/4EC?=
 =?us-ascii?Q?DuQb3wIj34cJ3DTkd5W4bFw1CBH3fyuMo03FWWxJk0eYiUKQe7syFwiNDTag?=
 =?us-ascii?Q?V0g4VMfgoDoAPvj1WIu4E/0ceTvs18/mpwofvgWwAORROy+m7sWYQs7zmuCI?=
 =?us-ascii?Q?tUA9objxQaFcL1CFMThcWIhQJn1QuoO3W+pneoLPxH4AnPlDjZzi41ZkjRSM?=
 =?us-ascii?Q?xh3g3wJwIKmHp2PdfNjSbvV8e+9PPh/VVs2MgPpxBxSGsbPBKBtmW7K++TU7?=
 =?us-ascii?Q?M2AmXUVAy7AaDkOQShKqlPDrI3P5wjwsDQ2LsfjMrZj0uNuDGPgmh85mmc0x?=
 =?us-ascii?Q?5xCGC29Nse+zoosOyABrBJ5ZKBJREQwylHZ/Bws46xUpqucxjLFaL0RNzCiv?=
 =?us-ascii?Q?zPzyz/Gogfw48LYep+B7+TOaCpJ8Rflx0B0sFbCBjgKEbN6A6J+jB6NA9Ifs?=
 =?us-ascii?Q?qq0JQ1LxiZsBIqEKiaBhDXmp2L05wnT72vLXQbpZsy6IJT1iSaHtP0OSW+xo?=
 =?us-ascii?Q?2Ou/BqpI5LesYU9ismZmWidYfX6tGw4O2UU9Uhm2BjJ7cIFgSjhfotfLBYhV?=
 =?us-ascii?Q?2NEbTFKQgN21/YN1VfPFGGNRcPZ1owM4aJ22F8O2ZkeSM5rBV8Ca7JyDaJNu?=
 =?us-ascii?Q?DuTaSYlHG7oDm0mfnzkqoiVBLliCwyF6P7s5NC7HIrgtG8b65mWXk1PdcLJ2?=
 =?us-ascii?Q?+WzOjdT3cGhsqcOZ3BVLqhMDOGs/uCrbXBCu6WCnzxMyf3ZgUts3ABVeacDc?=
 =?us-ascii?Q?gXbMVPPCCfjHnU62WArV5k/cJS+Sr5rM8FfFqsX8W1brPSGc35DpFOGymUHp?=
 =?us-ascii?Q?i0TSUH8uv7lRPPRWWU8r2FupUnLj?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ac6c9ce-ed9b-414d-c09b-08d8ed305dbb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 12:45:26.0843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u50gHIKHGgL1RDaCdy4tGVhgv/7Npw5LJkXRZih/945zFDW7mPxVUNmKKsz0iyvK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5215
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Greg,

<gregkh@linuxfoundation.org> writes:
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

This should apply for 4.19.

For 4.14 you can drop the patch, it predates preauth hash implementation.

> From 05946d4b7a7349ae58bfa2d51ae832e64a394c2d Mon Sep 17 00:00:00 2001


--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment;
 filename=4.19-0001-cifs-Fix-preauth-hash-corruption.patch

From a844f9f9a55fb6a100aee7c517f87c116c5866d8 Mon Sep 17 00:00:00 2001
From: Vincent Whitchurch <vincent.whitchurch@axis.com>
Date: Wed, 10 Mar 2021 13:20:40 +0100
Subject: [PATCH] cifs: Fix preauth hash corruption

smb311_update_preauth_hash() uses the shash in server->secmech without
appropriate locking, and this can lead to sessions corrupting each
other's preauth hashes.

The following script can easily trigger the problem:

	#!/bin/sh -e

	NMOUNTS=10
	for i in $(seq $NMOUNTS);
		mkdir -p /tmp/mnt$i
		umount /tmp/mnt$i 2>/dev/null || :
	done
	while :; do
		for i in $(seq $NMOUNTS); do
			mount -t cifs //192.168.0.1/test /tmp/mnt$i -o ... &
		done
		wait
		for i in $(seq $NMOUNTS); do
			umount /tmp/mnt$i
		done
	done

Usually within seconds this leads to one or more of the mounts failing
with the following errors, and a "Bad SMB2 signature for message" is
seen in the server logs:

 CIFS: VFS: \\192.168.0.1 failed to connect to IPC (rc=-13)
 CIFS: VFS: cifs_mount failed w/return code = -13

Fix it by holding the server mutex just like in the other places where
the shashes are used.

Fixes: 8bd68c6e47abff34e4 ("CIFS: implement v3.11 preauth integrity")
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
CC: <stable@vger.kernel.org>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>

[aaptel: backport to kernel without CIFS_SESS_OP and multichannel]
Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/transport.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 70412944b267..59643acb6d67 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -891,9 +891,12 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	/*
 	 * Compounding is never used during session establish.
 	 */
-	if ((ses->status == CifsNew) || (optype & CIFS_NEG_OP))
+	if ((ses->status == CifsNew) || (optype & CIFS_NEG_OP)) {
+		mutex_lock(&ses->server->srv_mutex);
 		smb311_update_preauth_hash(ses, rqst[0].rq_iov,
 					   rqst[0].rq_nvec);
+		mutex_unlock(&ses->server->srv_mutex);
+	}
 
 	if (timeout == CIFS_ASYNC_OP)
 		goto out;
@@ -964,7 +967,9 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 			.iov_base = resp_iov[0].iov_base,
 			.iov_len = resp_iov[0].iov_len
 		};
+		mutex_lock(&ses->server->srv_mutex);
 		smb311_update_preauth_hash(ses, &iov, 1);
+		mutex_unlock(&ses->server->srv_mutex);
 	}
 
 out:
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

