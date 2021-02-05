Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D9B311270
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 21:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbhBESoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 13:44:23 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:52392 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233113AbhBEPIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 10:08:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1612543500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rgupklA/N/qZiMWgrCLOLW6WPqAkKi0PXjJqk+lQ4Tk=;
        b=YfjC/6XHpJhTOYUJS8aqHAFlyTfhsZ+S3ziHozA1zWzK2qWIbL6s+WxSxCGHPelRtA3Nv+
        oqV6hUxMULrWyMmbNXO7mhFKKiuTolMZydBZfpKuAl7kw9Q23iHRucFN7p+ltjMcF6MbBp
        kR2aWxZbmyo5bAUtJbJuKh0kw17vbgw=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2057.outbound.protection.outlook.com [104.47.14.57]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-25-zOoVJ1neMESVM9LfKacYTw-1; Fri, 05 Feb 2021 15:42:51 +0100
X-MC-Unique: zOoVJ1neMESVM9LfKacYTw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J85Qn8gkC8xgMHYJn7uXYkwbaHCLQY+WCPYVD8CyqPc/AdhIr+nqo7Jd1JOT/2bNwhvwgBpwaNqzcO9iGyOYkc78VXhzhyh86Kzm5NLfysz2S0313JPdbZqxka/uPc9p3htmeOBPUaUAFk4gznJC5F1Ce7+b8CwiEFUT3cKnQk0RJwfOOxx0r5FH7n7EN67ASMtFpRbUub2ZTWpRpK3tAuG3nck5psDDiBZXtnfFRxVN47XRJh9zGJYKoogF8LKQGgfkBZVAwOdDy0hc99C/5nk/DOglLpe0JI1QcO2V6jh4yKuZmLzMX7OTkPR5Xsz+leQjHZc1/GljHCDPRgR18w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y2AIpfP7T441A4UjIT+WDO+L5sKTgxQU44W5w9HaJgQ=;
 b=dd80KLjYWwYt0CUdysCxp4hWeVwwqXfLxRilBKfbNonl5A2/iZ2U7HXsm4ajthAImIYcjDYzTdWTv0yYRWjKPUXfTGCRR5ENJbuIvhPJFBWZHg6PbBL/sVFTxYyddC7s7vTPO+c84gZ+wovCieSHb/lDi8AmrNMDaRWe3Ea7ElE01jQWN/MPyT7I5b6QxFDoQtKa2pKOEHpeRZuBHsXDQ2qAos6fAFxgbI05doMfZDOU8H789ossqbFo5juqa+8jfKbuqJ2o3AT2EMnV4QT7krP/u3XL9DaEZQjs24cgkq75eBTv5mgSiXXqyNMxblJeBR2At9GJP/uHRdRffs+yWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB5759.eurprd04.prod.outlook.com (2603:10a6:803:de::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.21; Fri, 5 Feb
 2021 14:42:51 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3805.022; Fri, 5 Feb 2021
 14:42:51 +0000
From:   =?UTF-8?q?Aur=C3=A9lien=20Aptel?= <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org
CC:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v4] cifs: report error instead of invalid when revalidating a dentry fails
Date:   Fri,  5 Feb 2021 15:42:48 +0100
Message-ID: <20210205144248.13508-1-aaptel@suse.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <CANT5p=o4b9RfQ5omd911pLH3WFbiC1-ghF43kRZ5-4SV+PeS=g@mail.gmail.com>
References: <CANT5p=o4b9RfQ5omd911pLH3WFbiC1-ghF43kRZ5-4SV+PeS=g@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [2003:fa:705:9b44:810e:ca92:a80d:a39f]
X-ClientProxiedBy: ZRAP278CA0005.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::15) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:9b44:810e:ca92:a80d:a39f) by ZRAP278CA0005.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Fri, 5 Feb 2021 14:42:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74ed2f6e-b4cd-46e6-05ba-08d8c9e45031
X-MS-TrafficTypeDiagnostic: VI1PR04MB5759:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5759792763B0B41A73B3BD86A8B29@VI1PR04MB5759.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T4OyyWD6VU/W96Zpb6DVjfBD8bEnCRXsf7NLJEoSiF61820Kmcwf77Etg0ZTX79EB8XeH/HMxkzwMUSSazzQPuSIcDKioeWJTfX62x2jp6fnSZqSQ4lxsftmUYU053vdNrLvwuJhLj5dffpIu4T6taCbsc6VuAUnbWnKL9raeuuskVeBDRuY25/7lovKcLLcccuQpwiqFian3gq/O6Dmps7iSey+RNvlHTG2ySxxPlsH4J6UyEfYo+rUsiaRXK6gcDpiyBv+hGpgWRssIX9+vSaEBqpdbZsutvu1ZhSkCpLt8v0fW9lfl/pmbY6T0uGAft6HaWS6Tj+tlRp3I3mTtfmqDmW4OCvhmSH0GIBWw4sYZzVZ6UGTJDITiQbG3xwy67L3j82ixEOKNf+BesxctKCWRwemjDwjvxR4a6px/VDqZe9ZDdWFVY/jczq4VOj4vP3Sk+sJIRnR2jNC59RbqFiUe39Cw9AlIqezyyc8LfDj7rjQJn8QrvTOaee+FWSrhDc4o6uXH+2F8T3I8K6ngEDchOPh7apjRjfDKfZkV9R3yxiCWElqG9+MBkToupvIdzjkRUL7QUmy12ixGrBn5WMt209OA/VHYfVuIxTWE/JrK8fvQnrb0VAl77RJFub2ny5T6Mn0tBK2hZInAd7AR/QcIvSdfwlmJbokzYXBGo64v6K6hBaW12IcoBW49EBq3RcSdDhLqpjoz5/mxkdMwVs0yw4Kzp+nDg9ok9OKzVVQUON4CYpHUb6TsX5ui3tTtaIt99eG1bOvzTJONxqXP1ABKgqgE5CfzSbYuB7M9raMHEc06IcT8BF863OUIAdhhunNeNogi8nC3JAHTO9QZNZkgtJC3c8ol2SGPqzpUiY+u1xHHWtyXWt4nIfKYn9w1WbM5DfQw9oettRx12GAqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:OSPM;SFS:(136003)(366004)(346002)(39860400002)(396003)(376002)(478600001)(2616005)(36756003)(86362001)(4326008)(66476007)(8936002)(316002)(54906003)(186003)(2906002)(66946007)(66556008)(83380400001)(5660300002)(52116002)(1076003)(16526019)(6496006)(6486002)(8676002)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zA2H1AQnQeUFejyPbCV/99vLj1caj/QHfuUJzuNOiz0fll5S9DpvBW9Incys?=
 =?us-ascii?Q?cliAtv+6IAfGcZCIxdMRffHmZUN3s/v3ZRMy1sQqfRrZAnivxAAOIuv2ISfN?=
 =?us-ascii?Q?9xsfKZ6fgwmpJtqK5WAbjb+nbLONC2tqDiI0ASQI/hbPCVDmhKT4Fq9GEodV?=
 =?us-ascii?Q?uaB79KglV9fTskPqFDoMhO8Zk8jpubk9hDFHaFaIrhTgfcrRCKzJcNSwE83H?=
 =?us-ascii?Q?MocjJz4aal+aMr67aV8bmK5jxBf2aLlQAOiTCM4eR2ME5EQo3IlGtg7FOuHc?=
 =?us-ascii?Q?rN4YhN5WozU+44UdcW8icNw/4lnzHrx1Mf3vyc0jXietCd2PnUQyqHS6/mlj?=
 =?us-ascii?Q?C/b78XH5RAXbkyGD9BCsBU6zdcHrfcuuYmbKO+iXEGfPWqJVRUl6tvjoTnmN?=
 =?us-ascii?Q?4CL8ga0ZOCocr1t58ukYq7VWqHmob0nVWG81/j7iYV3K1QtXgDcwFs1Epw4l?=
 =?us-ascii?Q?H/bEG3rXxOyzqb/ff/nS739kNCaRDMITRXFRxjP1UvE/qM+iTmMnB2Zn0OlZ?=
 =?us-ascii?Q?2w0UaFdOwC1+Pq+mgcZ0rXqX2/4ljpkPRFEfwDj3nltfwQhM8r8Yp3FBLixl?=
 =?us-ascii?Q?+q0Pm3ihMCG4AYejONAECuyLLf+wRnMn6drCIztvW9SuAoc0diZrQRxzeU8+?=
 =?us-ascii?Q?RcFyiK/srapWcuVvs/b8h4LEi57e63M/PwJQWMFeyy0RVNZYGtEe0pMlunXl?=
 =?us-ascii?Q?YkSKYh/X4tHgSzESoPbqoerleFhLQps6Z78OL4rcjEQVhfmIVVw4VmRmTzGT?=
 =?us-ascii?Q?76gAQ09JNmbMU/C+z+C5iTdojI0mSx2oTBptX2i+mpSp2w4GsEQYZrfl6v08?=
 =?us-ascii?Q?RT7CQ4mv1rPa6IlYWHWDyZZCBbwkb5j6I1/3W5RufDdDtaBntxe9GNRY1jog?=
 =?us-ascii?Q?GZDEv6nyc4rjoiZLVwENhkeJN5OVVZKba4L4JTaf+mc2Gy6KweHCP5sfnPGl?=
 =?us-ascii?Q?1+jxDGr99aos9jCQJuDxJYQAUk/5kY1Z76A6jZXegdxYXnlaE/SLWwE0sKUm?=
 =?us-ascii?Q?6qbN6mX4h0/FkpJIeh69j7D3UQdKzfBiXMqANXIbabZH9Eso0RjdidPng598?=
 =?us-ascii?Q?MwaxmBgBS7Pyfv9RypQq6PJnOgwfAqf//AE0DiQ91x3h7MsZUo567EHEvITR?=
 =?us-ascii?Q?wJtfCbQTnkEcCWDitXRnriy6OUvLqWrCyCR3WdRsmRSHAJ78ULzyimfpBq0X?=
 =?us-ascii?Q?Xnsm5u9dQCtzchr8kJnHntOh1n6rMaln0gncqCqrG1Ay/nKoXWKV98tHuSyW?=
 =?us-ascii?Q?1yZISrHC2dad3QULdbO6vwMDJxersUZP6oo4zbVVJgigZRxKVGHqlQUnIWXb?=
 =?us-ascii?Q?wSIWvh2v8FaMFlH+uFfPRYO+VWT0Yiu9f2eOar3ixMX3plLKO4Ra6mnjqS0R?=
 =?us-ascii?Q?6Ma3V9tPdCR5SdHeuo3qVZWcONl6?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74ed2f6e-b4cd-46e6-05ba-08d8c9e45031
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 14:42:50.9570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5sVOplhie2UZ2J6xWp9xn87BBVAeZy3LCLFJk/znHquuvYpvWzQMQAC778zwE+6h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5759
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurelien Aptel <aaptel@suse.com>

Assuming
- //HOST/a is mounted on /mnt
- //HOST/b is mounted on /mnt/b

On a slow connection, running 'df' and killing it while it's
processing /mnt/b can make cifs_get_inode_info() returns -ERESTARTSYS.

This triggers the following chain of events:
=3D> the dentry revalidation fail
=3D> dentry is put and released
=3D> superblock associated with the dentry is put
=3D> /mnt/b is unmounted

This patch makes cifs_d_revalidate() return the error instead of 0
(invalid) when cifs_revalidate_dentry() fails, except for ENOENT (file
deleted) and ESTALE (file recreated).

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
Suggested-by: Shyam Prasad N <nspmangalore@gmail.com>
CC: stable@vger.kernel.org

---
 fs/cifs/dir.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 68900f1629bff..97ac363b5df16 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -737,6 +737,7 @@ static int
 cifs_d_revalidate(struct dentry *direntry, unsigned int flags)
 {
 	struct inode *inode;
+	int rc;
=20
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
@@ -746,8 +747,25 @@ cifs_d_revalidate(struct dentry *direntry, unsigned in=
t flags)
 		if ((flags & LOOKUP_REVAL) && !CIFS_CACHE_READ(CIFS_I(inode)))
 			CIFS_I(inode)->time =3D 0; /* force reval */
=20
-		if (cifs_revalidate_dentry(direntry))
-			return 0;
+		rc =3D cifs_revalidate_dentry(direntry);
+		if (rc) {
+			cifs_dbg(FYI, "cifs_revalidate_dentry failed with rc=3D%d", rc);
+			switch (rc) {
+			case -ENOENT:
+			case -ESTALE:
+				/*
+				 * Those errors mean the dentry is invalid
+				 * (file was deleted or recreated)
+				 */
+				return 0;
+			default:
+				/*
+				 * Otherwise some unexpected error happened
+				 * report it as-is to VFS layer
+				 */
+				return rc;
+			}
+		}
 		else {
 			/*
 			 * If the inode wasn't known to be a dfs entry when
--=20
2.29.2

