Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323CD525F05
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 12:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379071AbiEMJjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 05:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353324AbiEMJjk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 05:39:40 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E283F291CDC
        for <stable@vger.kernel.org>; Fri, 13 May 2022 02:39:39 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24D995TW031470;
        Fri, 13 May 2022 09:39:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=kdrKI17HIpBtIJjKWY0f6q/o7sWErb2cowe9LGu9AeU=;
 b=YSS0th4WA2qMCVvkseBbnreWpTbBgng81jrBf0Vhc1N9CprAGy8ERfu6eYDnmk6VlQ/N
 7Gp7uQm0zDZeFpZ1Ggb/ZHcjBlenUTpKyPSG9Utlu1SrBRIfo5l9qUHV+7w7KYeWDi/k
 oFn2hNh69ls+GbyNhy45xiRzFr3Kdt/38OuQjkYSQ4AjTSgI3Pj2FOjur5tRrVs8zPYk
 U8B1dn9AoO3d1JvPRhtJjS8EtXZGfVUc0299nZ+XD7IgVZHUFkTl72qPrNWWp3CchO15
 XkpFePLVxcCjNy8lv3Bt85JW8AiCXF7oCNGm0fYoJvIuLJ58CMz5OJxWImexafTBSPBF 6A== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2042.outbound.protection.outlook.com [104.47.73.42])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fwdyyvq41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 09:39:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hcg6AhukSuBXHUlEzydjtJoc01rLvhbQpBFlQtaTXraE67qUEJMntlHCK7mCFl7hsO8ejdJlvq01b2268I6vXjbuvlbQTjl7aqOo6TYOPKWIhWLTLsAflvJ9pbPhZwW9m1+6kBekq5z1ta4UnIDp0JtddWzKky/xrMfCTHqCT46SiYhA9C/80B6ocmplFlvDoPI9y4Nu/X5BNn5vW3X129AUyTG2nbDOoy2eCLHQG9wKgjSF3WZWaseOfBH2N9XEhq03UyObzWEewbnzGOptKovPHm4ezus8v5FR2ZxCxUCFn1NukEoilv3QqvHb3oNKPx/y11/I6tDXSs+yc0v7bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kdrKI17HIpBtIJjKWY0f6q/o7sWErb2cowe9LGu9AeU=;
 b=WzbrARfOtNNJ118edmMIKiMrJeB7hc6u7yKwvOmrtxt566uhUi4fvQRZUohwwcPih2iqR5oz1UVyDAaOO5SCBhBghJxKY790bdepbYY5Sl2Ig1Jvpq4TQmxkk9jtP7P4rL8dJsf+5EAgqjWA9sGJFhRehQKPrxqMMbGsXvqJGd/nBzkN+lGrkjlvAnYbC1QX4GH7oZjj9zW8zrMhbhjT/e7PjktkT4CD2cO5o2w1Kq65mPCJDrAxVeqhyPcm0gP/nZkVZFVH89ULc0X5aSOECOD6kn07ogfg141MxHx/9rgm/b5tFnw7qlSr0flYprmCjU5b6VIbm5edMyno1gre2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA0PR11MB4527.namprd11.prod.outlook.com (2603:10b6:806:72::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Fri, 13 May
 2022 09:38:59 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842%5]) with mapi id 15.20.5250.015; Fri, 13 May 2022
 09:38:59 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 2/5] ALSA: pcm: Fix races among concurrent read/write and buffer changes
Date:   Fri, 13 May 2022 12:38:29 +0300
Message-Id: <20220513093832.1434697-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220513093832.1434697-1-ovidiu.panait@windriver.com>
References: <20220513093832.1434697-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR02CA0047.eurprd02.prod.outlook.com
 (2603:10a6:802:14::18) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29f54305-c4c0-4b7c-f1fe-08da34c46837
X-MS-TrafficTypeDiagnostic: SA0PR11MB4527:EE_
X-Microsoft-Antispam-PRVS: <SA0PR11MB4527CA09963EDF08E030EA95FECA9@SA0PR11MB4527.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g6ICp52GF09e+8W5yUAt3hYA8oUo7FAh62PtR0Hp4ETNWS05RRZMMs5jNq5txuKATBrtiqzU8MCTXsahzwRQQ0Yw69edrGjiMkS4jQrkHiTY8DBIy9AWjPj4yML4DJ11PdIAnTfKqYRRNgINwR+v+x5dmZlepV5VFCjTa/Vq+ZXWqQ93JVJdX5z+KFv1yvPIMArnYBdt6VCHjr8dFtLtMV9+HUsa38/egl2762Lk18edWdpKNUN7yfYtafkhcfVtXERj2Y9QL/uJ8bqBorJ7RKf+/Hg5dm7EviKYeuxm0unieprY1li3FGf4i87GYuxPiz9DJTo5xJ87bC2nItSuK0+SRkjVIMdNGkt30Gld0Qq/yQSVmDo1nDVrj/8/EY9xB4xs7D7Ji6UBQBfGuM0fGeEscgYoLzIyjp/XiaU1xdiKhWOMk83emqUOFbNgvZeouR5Ig5HPSJAqx9/OqznQV3MkbpHahxdh6sZIr76Dl4qRbzV3ujqb5ymYoADxAfJZIxeVApD3NV+0CidT57okOOov56TWLJBFwO/FVKqWabWKxQqmmqdEpdzPy7mUfQ7bjQ1+qlWtbAzU+veDbyS+U5Om6xxCR453XC5H3fak81IeijYrJ9yOgchZlLV8xB6zpIjyVYfVI+eAIhqP7BgtzOCQ9jaK0bNUwBhgaFFxlettoc5lFkJt94r96489jsfBmb/8Q2xTheUOfNKbjdoNMqlOfJ8gY28zy25vuq14KFyqHWkx9xRXt8/u3jQZyDIctYtapV+FhWPi04ld6VFMFiyz+vGcGS7o/2n9jrioAM0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(38350700002)(316002)(66476007)(8676002)(4326008)(54906003)(6916009)(8936002)(66946007)(6512007)(26005)(1076003)(2616005)(107886003)(6506007)(52116002)(6486002)(508600001)(6666004)(186003)(966005)(86362001)(38100700002)(36756003)(5660300002)(44832011)(2906002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g68Lb5/YEiqhBg5YGYSGdIHzRgn41JjqIlZwHULu5msBAhTiKQOjr/ebiGPs?=
 =?us-ascii?Q?N9EuIfjNzibL6btBO7VHvXdYqkLXws05ZSWdLOnUe9iot3iYiimyHnThw3y7?=
 =?us-ascii?Q?9FPY+RccvSftpzf9kv6Ezy+9QIME1ZWBdtuO3N4w3UIjvvJEu1HsISQJoZFt?=
 =?us-ascii?Q?soMQoIMGtbNLnWjW6po52OS6dtfht6DB3gkEnQpJ1UdAub4wMJCN0QsXnJED?=
 =?us-ascii?Q?VYdrSPX0YmoOqyt6frH2KdpuUDbSEXjKOhdHDCT0xca01nnPFeKJ/tXjGT1D?=
 =?us-ascii?Q?O6qHfWi4SqP5p/mqyylhSQFdlEwEVhiu6Fb44GX0SpbyUTZS5L2QLrCUfORE?=
 =?us-ascii?Q?dhAry+Emw6O1AdWni4eSqRE8or2ryyL7ngGQNsHBMOy2NCe7+ZMUvddWadeC?=
 =?us-ascii?Q?qdbTxxNwJqniZ/XBJtnedi/hK8WTYptMYbBevXhWssgnZd9kl/NoBVUIa84D?=
 =?us-ascii?Q?B6prbOSicZaQy7xc5VFhnblCiUd13vwFDsmR16jBJQKUUi6XrPEMf4ZWS+Hp?=
 =?us-ascii?Q?LvGVHZZtU+vu89TIWRqv1a1IXvKMcUIaDyapbaEVqMjGP3tjOzHIXJq0Qmtz?=
 =?us-ascii?Q?ySx5/+MxwXbQbnVrkuQCczKAq9mTEp0hE+rCuWBxR9L1u6EDorqnrKu2F0tf?=
 =?us-ascii?Q?RgwiMX7ivDKbX0UqzRyDkv6BtIv67IbvtnzjJV2c1R4bO+WeFH9GChwFiwPm?=
 =?us-ascii?Q?yx4C2OQ+HKNWc8BTHHR9Ffr6/3on6NXdJHp1dH5Y2z3It0/ZB8a6n/enwS8M?=
 =?us-ascii?Q?oElSHLJk7gRDy9xkUVSNAGX9fxPh5CkpFEm+55CBvfDjvWCnWxfVtGyd1Mc0?=
 =?us-ascii?Q?udLEO1IEI0Xx2d8LXdzOyH9sd/zNmPjYgXOwA0Ci4nYe72avIrapIcVE6GFU?=
 =?us-ascii?Q?mWoxSkl6Je2a3YoKzGgDgki1xAiaWyUcFjFMMmphN+OMCZbIVVaOB3QoVNzm?=
 =?us-ascii?Q?I1u/vRUgebs9AdY2j7LO8RJIWGAOxzQcWfBOXbG5Mxy+z0tXabGQbaWh4fwC?=
 =?us-ascii?Q?9HBvBG5trHhgpNxsOwM3dPn9NxtMvD9OfZNyFnnNPqx1vqhf/UB3khp4xz+z?=
 =?us-ascii?Q?QzPA4bNMSLi5F8PQCQEp15oS/W3rTRVs8Yi6/GnTVQrQzryWNlWnd/pNltBT?=
 =?us-ascii?Q?P4dVb8vyCveIsasLVF55Ca6YlY4NJQyve7xc06+1wULk9cyAuM8ID8e/5GzH?=
 =?us-ascii?Q?BFR6mQzoqEjazXfelcqWLW3B46omd0niLP5FaLyqOVh9MvRc4OLPa/LbEO4Y?=
 =?us-ascii?Q?6mPuEL80P+7RuOlqBfwZEkzE1qTTYEzszK+vOru2TD8uP+fSseFx04QK7BK/?=
 =?us-ascii?Q?9W5FkXZGwThQ+1/qf2UJ7hxhYhv2f/DJ+TAiFDpCAx+7HChSeU5blCWvxtXj?=
 =?us-ascii?Q?MJEdY8+i8elnkJAuBCY1KGxMdGwGjHcWsJYjrJlnanyixi5TakY7ccoBjNdC?=
 =?us-ascii?Q?ZRS5xtJVmOMyQ8yLclSc5LZOIX/kOldUuRB3nVJNeObF9TD4A9M1Jllmsnh6?=
 =?us-ascii?Q?Bonp2yS7MJOHxWkAEySbZRFSQXasRADyy9mdz0Rq1NOOf3Z976jt/lZfzKEW?=
 =?us-ascii?Q?1EYiQnxh6dhV+J7PS5LSVIT8IVKgUaho5GYRLsfdw58kz+1yxiSKT7JAHssC?=
 =?us-ascii?Q?xVvk/dYKRu6XFOIQKZZcxgWdHLMcg21SgIipeff4x4d0SjfO2phcP/7IF9Dj?=
 =?us-ascii?Q?RlWJUg1HlWv/jT6ShA/qEmzaSxRxvNcepD6drHUXeSgk2KXOOyprRTxB30sn?=
 =?us-ascii?Q?lr4eMVL4WtVPDt8REvN3abAePO3eSkU=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29f54305-c4c0-4b7c-f1fe-08da34c46837
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 09:38:59.3858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6sgiCZ46ULhdEMUk6yMRq0sxPYcVq1h3AEkwMc3ckItLYb+idj35dXUKmHcusekamb+mJUqvF/2Riwv04LF7PlNW7RDNAoR+4huY6hDwe4Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4527
X-Proofpoint-GUID: onw0EU9sLFGjeIE9-guAy9i980rQt6Gg
X-Proofpoint-ORIG-GUID: onw0EU9sLFGjeIE9-guAy9i980rQt6Gg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_04,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=948 adultscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130041
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit dca947d4d26dbf925a64a6cfb2ddbc035e831a3d upstream.

In the current PCM design, the read/write syscalls (as well as the
equivalent ioctls) are allowed before the PCM stream is running, that
is, at PCM PREPARED state.  Meanwhile, we also allow to re-issue
hw_params and hw_free ioctl calls at the PREPARED state that may
change or free the buffers, too.  The problem is that there is no
protection against those mix-ups.

This patch applies the previously introduced runtime->buffer_mutex to
the read/write operations so that the concurrent hw_params or hw_free
call can no longer interfere during the operation.  The mutex is
unlocked before scheduling, so we don't take it too long.

Cc: <stable@vger.kernel.org>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20220322170720.3529-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 sound/core/pcm_lib.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 82a7387ba9d2..9eacad3e2f1b 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1878,9 +1878,11 @@ static int wait_for_avail(struct snd_pcm_substream *substream,
 		if (avail >= runtime->twake)
 			break;
 		snd_pcm_stream_unlock_irq(substream);
+		mutex_unlock(&runtime->buffer_mutex);
 
 		tout = schedule_timeout(wait_time);
 
+		mutex_lock(&runtime->buffer_mutex);
 		snd_pcm_stream_lock_irq(substream);
 		set_current_state(TASK_INTERRUPTIBLE);
 		switch (runtime->status->state) {
@@ -2174,6 +2176,7 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 
 	nonblock = !!(substream->f_flags & O_NONBLOCK);
 
+	mutex_lock(&runtime->buffer_mutex);
 	snd_pcm_stream_lock_irq(substream);
 	err = pcm_accessible_state(runtime);
 	if (err < 0)
@@ -2259,6 +2262,7 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 	if (xfer > 0 && err >= 0)
 		snd_pcm_update_state(substream, runtime);
 	snd_pcm_stream_unlock_irq(substream);
+	mutex_unlock(&runtime->buffer_mutex);
 	return xfer > 0 ? (snd_pcm_sframes_t)xfer : err;
 }
 EXPORT_SYMBOL(__snd_pcm_lib_xfer);
-- 
2.36.0

