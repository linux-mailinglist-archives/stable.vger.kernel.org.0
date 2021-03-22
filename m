Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8CC34434A
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhCVMt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:49:29 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:21673 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232600AbhCVMrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 08:47:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1616417274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lRJ/8usvqJD5Wtpigf+PhvzuPWodKUAbA2okNFhQPBI=;
        b=M+yXj8RGKkqmSRJPpWT5DexvvVlyTQBTZQ2DBY34MvUVo3d97RObW4P5IwwLmWOhUiG25k
        2U32bFm4QjZsGP2TecnnPSC1b9uwVehkDskiDUukEzE0ZmgSCnIDodV1va5RSNAzagiy80
        f7e04ERrh/O1WUCR7GE20xUxpnu9zF8=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2056.outbound.protection.outlook.com [104.47.12.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-14-FgaQSCA0M62U4SjkxNXyxQ-1; Mon, 22 Mar 2021 13:47:52 +0100
X-MC-Unique: FgaQSCA0M62U4SjkxNXyxQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bpwwD7KwiWpgtHrL3dU5jds28bJFVs3jAE92+Vzv7yG1tVWZfDmj4QEZenj/Ta4HWKrQUqlpojCWghIXhiS4W+yKLn0CgFFxX2wwAbobbW/oQyCQJsKSlVWr4rMDSuskmkdc4EjouGJNhuoQ9kVztHZJEOoMHhBGMlaVdY11ym/c82LAU8CafJH50YYiIgu4idoot9syDb1hoO4Eab/L2+boBV2a35egYm5x01KWSV4JhJqtOP+MCxu05OYRay+d+q3lWyssQtalmVzrfo/swDJX3RgwKYLN6cckV9csuBxWU0qJvDfrxIJbQRlyVmvO13VGIpZhnaK2q/39KJN7DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRJ/8usvqJD5Wtpigf+PhvzuPWodKUAbA2okNFhQPBI=;
 b=nLFhvcUkONZBdqcIxQk8BBgn2mO8sj7GLjm1JIk0Zw4ZCioOZaYcR+VYGpl+z/T7LOBHc/GMYOUfSk50qSPsdlb3N2egQ08TrjijOeY2lMXoZ0LzjYZNDNYWO5w9elkzvvW1E+0bxnVFSXjPjljZ8v3Cb4iHjnhCHtX3vp+LCPOJqt8/33vCcxuPPrJzb3PKG2wUs8JKE8uHI/shI8z01y2CvQccOVwsrEUqj9h2i7b2pUR4CARrNiDApiycxjs6Sz44BEaeIQxVT1PxWipPmHQGnNncIC+EWUtqT3iVMhXUUD1zJTwDfxpaF6f9q9vJHDSzMDxfDTlo8kNTTpCYYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VE1PR04MB7456.eurprd04.prod.outlook.com (2603:10a6:800:1ac::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 12:47:50 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.3933.032; Mon, 22 Mar 2021
 12:47:50 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     gregkh@linuxfoundation.org, vincent.whitchurch@axis.com,
        stable@vger.kernel.org, stfrench@microsoft.com
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] cifs: Fix preauth hash corruption"
 failed to apply to 5.11-stable tree
In-Reply-To: <1616328254225233@kroah.com>
References: <1616328254225233@kroah.com>
Date:   Mon, 22 Mar 2021 13:47:48 +0100
Message-ID: <87y2efqrrf.fsf@suse.com>
Content-Type: multipart/mixed; boundary="=-=-="
X-Originating-IP: [2003:fa:700:2815:b96b:85ea:1f90:5f2c]
X-ClientProxiedBy: ZR0P278CA0138.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::17) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:700:2815:b96b:85ea:1f90:5f2c) by ZR0P278CA0138.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 12:47:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9d7535b-6e78-4dcd-c9b4-08d8ed30b3ed
X-MS-TrafficTypeDiagnostic: VE1PR04MB7456:
X-Microsoft-Antispam-PRVS: <VE1PR04MB74565A01B2B416DA8ADA5868A8659@VE1PR04MB7456.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 855R0X7GTsWcQxecprHWSo25BSrwbRjXYD29WQ2FSo2wOEJcI/U4CO44BYF3gsTeWlp2OjNp0EvWY254SCeoDGckDYaq4X/lzyAVtUiKpwXRmMmpofxTNoZU9fo2rJDNUPEJ9Y90XipWSTRsXKxxtKIghf+hqfyt5Rh5h2r0mamr1C3fFfgY80STwYOvDOYRl0xmBBgTRz6wa0viiIg4ncPbFhbcXrEJ+q6IStF1v/gMg56mTD0X0TDP0h8y6NNDPIc0pdWcZC3NC6ev7LwXuxqaSNPsvznyW86DskHjKAW6PPm53g9oDHdnJtzOJwUpdKOp3LWSDHzvGvjWCgy88NcquUGPLMbBLqp/Xnc7ANyAv+nfQGQLRpbKUl8lxMWJ3NSOTVSvRpn5Ki2k41w4bM5VLrUmj9dvB5Gojp1uoWPthKuPLuFgzYB4+s7fasjgYjNC7FVHdieqvorOtTOFUYil9IBzYVQ1Xu/IckdfyF59/Og+vUzH9dStvZfYDPS+tMg3uKnKLHMoBmLnC7wuQNMPJDjjGgLe+PB+UUZmNtWp6DAeD2mD4+M1Ir2Q+EBU2B3j58/6PUxl+N6QfV8bnupp2sYa3GP5tDaK1Tj9CHjYOcewpGPG+ol1yM+stZn3LVQbSHDoK8hyGR6dNvLyHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(39860400002)(366004)(346002)(66556008)(66476007)(16526019)(186003)(66946007)(316002)(66576008)(8676002)(2616005)(2906002)(86362001)(4326008)(478600001)(33964004)(36756003)(5660300002)(8936002)(235185007)(6496006)(38100700001)(52116002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dyPIJIUZ2OTTInbQniMSOCPyGvazwZGJixZo51AH1MEo1sVJfuXIydAwn2z4?=
 =?us-ascii?Q?KzLFetvE1VIsvlvpCP+ttPx0oHBvi557lgID9DgIZE6aVtEJjiYozkh9qpel?=
 =?us-ascii?Q?uqRAVQhWKcWi8IK2KUFLajk6A/Q6HEMsLcl2sYHWFaoCc8u5rNI9PifBtRA+?=
 =?us-ascii?Q?/+m/MurrRCl+Z1+nagwUNMtMZxlZWuvIuFHMbLZnDB92AgEzV5mjEdQ6f4al?=
 =?us-ascii?Q?cq8w5s5bT/A04BZWJFjnuT9xyuuAu9Aiy/lSbubdMiXchn6M49kW93azDs7s?=
 =?us-ascii?Q?3xcCwFSRn8CHgHtbrIP/k0lmyA8qqq7OoywzL5OiLSn1eXZoSu8UuUFdMZ9V?=
 =?us-ascii?Q?hT8LvvUWQJP8s9WM7EYkY9uEJ3F8p1n0wNNcNo6vS0UPN92fB7mNboq8p1/9?=
 =?us-ascii?Q?kdC+KQ77f4AUmTSButpyVbZZPNWYvuo/T7FBu3yjLnHt3FQG8j9pFi4qOMaq?=
 =?us-ascii?Q?TRUqkAD+hGd3iUu0bVPqcamfsMxQEvCcM80y2TvPxWGL21JeX6TZj441mIGx?=
 =?us-ascii?Q?WiX4rhjdNTr5AP3GJf9pn7F8tUr6hPcAFSmBRvZ5uttIfvaRiPKMCssoJdKl?=
 =?us-ascii?Q?lP1m1hjfNA7xPQ8znMx9cr4nf6GzjEF318SSg+jnb4DgQzbkvunCVscfsM50?=
 =?us-ascii?Q?DOzURoonYcUxttpTu+AMRbjLdGRhI6UF3Fz5ZPJXJ8meBR1T0kfKZX4iEQIc?=
 =?us-ascii?Q?fZrKB9UaH/CcinGEJ9tA2p6gR+KW+kvQZq5gNoFNTS7b5M0S5mEJFF4JIC81?=
 =?us-ascii?Q?D+QAlP9Pqx+7cXOpx+2hbOqLT0FI1yCICCBZTD0UAttzHMzwHXTTzi2s/Sl/?=
 =?us-ascii?Q?6O9DwyG654qaOY75LYdnB5qTb2fnQlL31pWBPy0J+Fi3qygAorN7XMSdtmnS?=
 =?us-ascii?Q?6PYy7QKGrL2WDfRt9rB+cLRAg/L/qrCimTnaEgBc3IByNrLsuRgbpfG7suNO?=
 =?us-ascii?Q?lPohEAWOxaxewoY98xGfhY3K+bT/VWmywjmR2syd59UXhfWv6d0HV0MHQnBs?=
 =?us-ascii?Q?R0pvTTBYIqgvW94/CyxloM/Zote8jC8eyBa+HB/Na/o1GNWLplcdDIsAo6Kr?=
 =?us-ascii?Q?VavzluWhINYemDPCyIM0vYVhNNg49ylGdomWjsskOloQLJIHQ/OwBFvdZbKm?=
 =?us-ascii?Q?0Tvl2xmdST0/1+PG4/SENEjNRCJ1dcJDt3z3vlWQ2WIol3AW19pr12uKN2w2?=
 =?us-ascii?Q?V+2aENhLw2xs9HtJA0QUqzpYVA5fmUbI1qr8Nv84RGomKuGF4kVIJku23MNU?=
 =?us-ascii?Q?VpjzCdVvS0iDC7O9ljY1xph6KTRJNYejHmHzbXpGsdDmUIQuHe+gB1GbVBk4?=
 =?us-ascii?Q?z68vovR6cWYXl2MCi8WBnAc9LGTnMLSbeoqSbw2Gf1SebRAf+FNv/lxC950g?=
 =?us-ascii?Q?++DfPt+DK7+X2Y4F60BnZGuY9qfT?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9d7535b-6e78-4dcd-c9b4-08d8ed30b3ed
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 12:47:50.6972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yPnyAI2pbHWC0CBxyPURJE3hL2GpcTrUlxOhRTkjJCFhTVIGSthOLa4278sCkwj7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7456
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Greg,

<gregkh@linuxfoundation.org> writes:
> The patch below does not apply to the 5.11-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

This should apply to 5.11, 5.10 and 5.4. 

> From 05946d4b7a7349ae58bfa2d51ae832e64a394c2d Mon Sep 17 00:00:00 2001


--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment;
 filename=5.11-0001-cifs-Fix-preauth-hash-corruption.patch

From 1d225f77208b58f6a81d6038964caad2dd637443 Mon Sep 17 00:00:00 2001
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

[aaptel: backport to kernel without CIFS_SESS_OP]
Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/transport.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 14ecf1a9f11a..64fccb8809ec 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -1171,9 +1171,12 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	/*
 	 * Compounding is never used during session establish.
 	 */
-	if ((ses->status == CifsNew) || (optype & CIFS_NEG_OP))
+	if ((ses->status == CifsNew) || (optype & CIFS_NEG_OP)) {
+		mutex_lock(&server->srv_mutex);
 		smb311_update_preauth_hash(ses, rqst[0].rq_iov,
 					   rqst[0].rq_nvec);
+		mutex_unlock(&server->srv_mutex);
+	}
 
 	for (i = 0; i < num_rqst; i++) {
 		rc = wait_for_response(server, midQ[i]);
@@ -1241,7 +1244,9 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 			.iov_base = resp_iov[0].iov_base,
 			.iov_len = resp_iov[0].iov_len
 		};
+		mutex_lock(&server->srv_mutex);
 		smb311_update_preauth_hash(ses, &iov, 1);
+		mutex_unlock(&server->srv_mutex);
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

