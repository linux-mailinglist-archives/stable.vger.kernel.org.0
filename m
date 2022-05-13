Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36830525F65
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 12:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379090AbiEMJjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 05:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379108AbiEMJjO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 05:39:14 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CCB2A76AC
        for <stable@vger.kernel.org>; Fri, 13 May 2022 02:39:12 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24D9Uv0L016177;
        Fri, 13 May 2022 09:39:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=TzPDLTM/WdrZ51fxAxIpZIxs3MABjmnavIxOPklJNX8=;
 b=buLnk2ZXtcv+N0rafOlIj1EZx0AkZnVEdBpz4BboaGolJG4FBO5VN5qFH9VOnzl8qA9M
 ETMJa1e1AWC3/ubNn9/AEyOr0pKq2IJPCbOIY7e84mIt84n2CGPKA2VmjewX3PqlSziL
 w45pjjeQt/amrNlFf0wcPRPqHePnud7wsiAbfBVCsXk1oS68IumxSvbZS/pS8aKMpnN+
 ATc+YTo5RGQ+oNT6SvNF/EqloIQzkd32EaRr8Am3bZmmQYpXUTb0j5OTHDH6hsl+PMQP
 uc59Ibk/4ksyCkGVQs8r5WPGmCp7oFO40GiYjKcyrRCiz/f9EQ6rD/hCqgTr4CjiCA0x tA== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2048.outbound.protection.outlook.com [104.47.73.48])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fwdyyvq43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 09:39:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X2a1Dax+1ZV5GESi0f295rezPKnFbzRhJH/2J5nYzw0mkaFFtoHIMOgfGlCWSaP7DJCCOcznZ2Rd5cpsnbmeNLMtgrLx4rck9Yh7f4At18zNvloQXSiReCrpydQ5YBHbf5xR4zdiViWdBcMQZeKIzPYcNZiECxKUG7a4pE+BISJfbi2jWxjuySsuA1kSj0UI5uIyZ8nNfHuKTACfRxJM+G7H22t8fw7fLx94brqOvszI4c/77RZlGLi18kptWCYFKYTZ42xAxUDZJnV0RxPWAa/k/KgBL1UQWevQGNXiCHv7IRkBNCnJ8UKYf37LNVuIClPtZfI6AKIavfVFhZk2AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TzPDLTM/WdrZ51fxAxIpZIxs3MABjmnavIxOPklJNX8=;
 b=ZqkMfAz3nsk0wwKOzPUlbvA0gGsX4hOW/F82hhWnHNOCEIhks5PkDd79+SaG+7LWI3/UVq04W3e2u1kD0ZdZqCJoTJGPDXAn11V9suWwo7f7CwdoZQlyQPnbjiVoFAoBEv5BU26xsq/GRSgAa227cYk6qMqbl6+AHsCw/O+3wbSTLw2Kw9Bt5XR7GehS9rQZN2BjUON3zZzMM0z5SX/Zc7VbCQi2fE5n977kht+sP14Ilr+eMg3OhpHowIuM/e5UI/+4htQ8uxpEy4TvbluFhusJqIImKTZ2olGBavF41BnJfiAlUGwsH7n0sAdlQnqMhN0bG65/kZdTj9oSzZJLnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA0PR11MB4527.namprd11.prod.outlook.com (2603:10b6:806:72::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Fri, 13 May
 2022 09:39:03 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842%5]) with mapi id 15.20.5250.015; Fri, 13 May 2022
 09:39:03 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        syzbot+6e5c88838328e99c7e1c@syzkaller.appspotmail.com,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 5/5] ALSA: pcm: Fix potential AB/BA lock with buffer_mutex and mmap_lock
Date:   Fri, 13 May 2022 12:38:32 +0300
Message-Id: <20220513093832.1434697-5-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3c5e0d4e-2091-4cb8-e936-08da34c46a6a
X-MS-TrafficTypeDiagnostic: SA0PR11MB4527:EE_
X-Microsoft-Antispam-PRVS: <SA0PR11MB45279A86948A09DBE22E8820FECA9@SA0PR11MB4527.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JiQrzj5TbVYsMX8U/Ms13+DM+csFPj7oGYzLuT0sNgLDGMJFSTv1zSSL3BuPH151MusicayKp9Em/C7sRx0b9XMR/iAa0yee+ktBV2BH4clJob7t7Wp0v/XoaFeJMaEbltgThSzGUlzQ9R8E+bYC+pzdh9+mqQnwjXJW04JZk0M4/+yB0fRni2wUFhIb+7euvJpX/9wbRQTyLKYlT+oFpIwdFBB4Em8kFFCBsC/nFOJjU78D26tbvgI5YGCi+eY0XbIgo92tIF98G5M5Vj6cRqz/cdV0V534u+juDmA4bOS4fJZskjEoovyVVe4OyWuwsgPCSLCicNmuwni9QZZBpWbvc2Nuy+bP0rv4TTZaiLs+4+2DAs+lP1B2alFUvJkL6uhyaGQEYtX7Oz5HkIm8JCOqDgylc/O30ehnWmtZCDVWoYkA8fRJrXH8a4Lgdfw9mjkCCDbX45gtNPt/vNdBOUYU5sCXyKzNjg7wbJsyxwEN/TKTCbGAP3ZV1OzJhoyQ1c3Nn1DEkwXaYvD7ROryFG4Ljg9mmu79EwmcrAL66mF6Z2QM9Im7hO5+b+ROauHTgcnBUD0HlB3m9x8rp/62UiWWk25Ti4W6gCTF+tm2o8r+Eyjgg2zzi14++aIYGQsH57tzSlup4vBZCCuqkoZscjYGuuXrxUy8VyI+hITVo7jjZ9u4RLQGP6p8uKoWmP49XGswAJzRf+fxjTwJcooB7SUbqyqE91XKFqysIg2z8EksK4/vv+GwV1s2evVofZE0dQwT17TRAzny7f8vzSLqr98+9p6yN8T1JoDQ9AsPebyWF0VHc44RRVdZCvAqmaoLDGsUCNUjFNDbE9daxoBdhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(38350700002)(316002)(66476007)(8676002)(4326008)(54906003)(6916009)(8936002)(66946007)(6512007)(26005)(1076003)(2616005)(107886003)(6506007)(52116002)(6486002)(508600001)(6666004)(186003)(966005)(86362001)(38100700002)(36756003)(5660300002)(44832011)(2906002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8BpH95v8T1dkJ+1SmjE2/wNZjPEJUf7EjwAhsXTTYVIGGD88ubgPtnGQEcEh?=
 =?us-ascii?Q?NB3XclibS7x9ZGfhxKs4aAiEcRmQNRw3tj8wofn+IL6yg1UvhcelICEse30z?=
 =?us-ascii?Q?w+BiGfe03hByxibSFwcdC/0buY/XJrBW0cSqpISCje8HkU8iwcvxlWT7SImv?=
 =?us-ascii?Q?50AjgP9JaYK6Vw4TDLCImpJYcSeAv769puymdTV36XxEqZUyc8SOz+jxASkg?=
 =?us-ascii?Q?PZh+8jcD6VDYg7NIkNqHimRnrOGaD6U8gG+7KiT0odrO6N4nCX1OiZNCYKaW?=
 =?us-ascii?Q?ojC6eDgx/fQ8e0iMThCymlvZicoM066hnWOiFKtKK1QzdOagobXcpKNt9lXL?=
 =?us-ascii?Q?xyiQC5tFlEvwQiHk7wDWqX9rFzoPxlCKDc2MTN9tjRR/v7Nbg9r1QrdAVS9k?=
 =?us-ascii?Q?AwtI1MPZ6WvIoHDfpxehX+x4VYnzZpnV4ldaO1aXDps/FF/9c6I6CNeJaFQK?=
 =?us-ascii?Q?LG9X6oTZsvA5QCuPjLMx4WPRbuAWEiG4tqR7SulkD51Vv313tLOzIhIkxc+1?=
 =?us-ascii?Q?lpoHaqRqIcOnyTKbI1hl4SPYq51Xje8foCHnrmGpqL4NE+BHO4KQppj+dT8x?=
 =?us-ascii?Q?KyeI7+QpOlssJhaJOXUu28r6JYqcflyZb1xqtd2XH+9S5U5DTRSCJTcejgUb?=
 =?us-ascii?Q?wAHl0zh66S+ZpGLL1bUahmdykWS+Ojd5ksFf+hz3WNZrisCChsiXaSk5Hwm2?=
 =?us-ascii?Q?FZbYQKOFGdI2Rf6+BGTXw+eUQVF48tLlSxdKaB30wnSm9qW7b1KKUuCCMnkN?=
 =?us-ascii?Q?m8o501qWDRs28Xm8NXefhW1Sd0riHl98YSA/sGZrJUcDKHri+EQaQ+ZlWuf8?=
 =?us-ascii?Q?x4VwkPwOOE5/llrxPquRX6DqXq1UY/1WgUULni3aRdvrgQ3yBm9Yj7WY4CMV?=
 =?us-ascii?Q?uTkCFFY9p3744MX+2g31NaDAsKk4DYzbJsZMNvtdyU4y/fEzy5n8dCMqrqTU?=
 =?us-ascii?Q?0bQffOtQzCkkshrjSPK5aT4TdNUzGOQSJHCXody8fWYcO+4trA/5+W4lnDi2?=
 =?us-ascii?Q?xNVptYhxZnXCUI/CzcHvucdcMci+qLaJKH5YcIpgmJstSMoocko0qdO3xA8Y?=
 =?us-ascii?Q?2HaHhTm3Gy19sXPpZC0FnxD2pp4tp69b8p9WfJ5xzx4ziiGdKuPPsilntxHG?=
 =?us-ascii?Q?2o0bUh8wea6y1ck7SF0BRSnyLTp1ToTdU/jSNeLA52D+hcc6U91MlYD7Z7Vo?=
 =?us-ascii?Q?afbVKU0jXvUAAy/DTwTjFW0e7Up65UOFnmMEaNWZXSxYDWjxkhKzs9b1Sdu0?=
 =?us-ascii?Q?yAEXE2oOTTT9yWauSX1iBYHihR26368OwDlw9Yma2TsLOV9hZ6Jap6L9Zhrc?=
 =?us-ascii?Q?g6NAz12eck863cLOhPuqFFlCRaxJRr8GsPw6PZbbzxLlxakfVQ9VTj78aKK0?=
 =?us-ascii?Q?YBtryk+4bapvF5fXF24C5moMU1zu+nLBkygyr8G1KotecdWeg+2L6L7beZ4y?=
 =?us-ascii?Q?Fzyhm2+mT8rl6Ec4J2F+Sp6K6u0uTRyWQbzsY5djw9R9kjCkl2gMkO1ZVxrW?=
 =?us-ascii?Q?XKzMk4jhDzJM1Wvl+CWrBmhQHDrTPS3fQEyC+ThkCXY9guCTpREdvwmYJiLo?=
 =?us-ascii?Q?VBIsA3hBTGdqa+OFTdDbnTZN/O+/PtB2/cAl4toCVky5lFpGtLDEQZqhIPlq?=
 =?us-ascii?Q?hCdaiRwRUzfwWcZLTP8COSOGPwlbA7vN9ZN7N7f3cCN/qmQuIE0Q5TnsFLwJ?=
 =?us-ascii?Q?sDJQaLu62kcpoxjiaXPtvbgHTqxxZn6htOZ5BKH7BpbU9vpjz60kMks9Vua0?=
 =?us-ascii?Q?bWwgP142Pff4QuRbt09UOfd23t0Z/zA=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c5e0d4e-2091-4cb8-e936-08da34c46a6a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 09:39:03.0909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hOATS5A+3m89hjRPXZWopflIbOtJbsGoQhi7jDKu1vvIAZPUsA7fG8nHBRM4+kjCR7FAi4Y1kr87cKV028OdQoV+5JIYpH4on6C1hO+lfqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4527
X-Proofpoint-GUID: FFE7MJE9sKAuFG0q10VTObGWDWUw6bHe
X-Proofpoint-ORIG-GUID: FFE7MJE9sKAuFG0q10VTObGWDWUw6bHe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_04,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=999 adultscore=0 priorityscore=1501 malwarescore=0
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

commit bc55cfd5718c7c23e5524582e9fa70b4d10f2433 upstream.

syzbot caught a potential deadlock between the PCM
runtime->buffer_mutex and the mm->mmap_lock.  It was brought by the
recent fix to cover the racy read/write and other ioctls, and in that
commit, I overlooked a (hopefully only) corner case that may take the
revert lock, namely, the OSS mmap.  The OSS mmap operation
exceptionally allows to re-configure the parameters inside the OSS
mmap syscall, where mm->mmap_mutex is already held.  Meanwhile, the
copy_from/to_user calls at read/write operations also take the
mm->mmap_lock internally, hence it may lead to a AB/BA deadlock.

A similar problem was already seen in the past and we fixed it with a
refcount (in commit b248371628aa).  The former fix covered only the
call paths with OSS read/write and OSS ioctls, while we need to cover
the concurrent access via both ALSA and OSS APIs now.

This patch addresses the problem above by replacing the buffer_mutex
lock in the read/write operations with a refcount similar as we've
used for OSS.  The new field, runtime->buffer_accessing, keeps the
number of concurrent read/write operations.  Unlike the former
buffer_mutex protection, this protects only around the
copy_from/to_user() calls; the other codes are basically protected by
the PCM stream lock.  The refcount can be a negative, meaning blocked
by the ioctls.  If a negative value is seen, the read/write aborts
with -EBUSY.  In the ioctl side, OTOH, they check this refcount, too,
and set to a negative value for blocking unless it's already being
accessed.

Reported-by: syzbot+6e5c88838328e99c7e1c@syzkaller.appspotmail.com
Fixes: dca947d4d26d ("ALSA: pcm: Fix races among concurrent read/write and buffer changes")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/000000000000381a0d05db622a81@google.com
Link: https://lore.kernel.org/r/20220330120903.4738-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[OP: backport to 4.14: adjusted context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 include/sound/pcm.h     |  1 +
 sound/core/pcm.c        |  1 +
 sound/core/pcm_lib.c    |  9 +++++----
 sound/core/pcm_native.c | 39 ++++++++++++++++++++++++++++++++-------
 4 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/include/sound/pcm.h b/include/sound/pcm.h
index aff851485b4a..0a4770cc3691 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -397,6 +397,7 @@ struct snd_pcm_runtime {
 	wait_queue_head_t tsleep;	/* transfer sleep */
 	struct fasync_struct *fasync;
 	struct mutex buffer_mutex;	/* protect for buffer changes */
+	atomic_t buffer_accessing;	/* >0: in r/w operation, <0: blocked */
 
 	/* -- private section -- */
 	void *private_data;
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index c62240d0f5b7..de48803f2be2 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -1033,6 +1033,7 @@ int snd_pcm_attach_substream(struct snd_pcm *pcm, int stream,
 
 	runtime->status->state = SNDRV_PCM_STATE_OPEN;
 	mutex_init(&runtime->buffer_mutex);
+	atomic_set(&runtime->buffer_accessing, 0);
 
 	substream->runtime = runtime;
 	substream->private_data = pcm->private_data;
diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 9eacad3e2f1b..82d4b72dcb64 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1878,11 +1878,9 @@ static int wait_for_avail(struct snd_pcm_substream *substream,
 		if (avail >= runtime->twake)
 			break;
 		snd_pcm_stream_unlock_irq(substream);
-		mutex_unlock(&runtime->buffer_mutex);
 
 		tout = schedule_timeout(wait_time);
 
-		mutex_lock(&runtime->buffer_mutex);
 		snd_pcm_stream_lock_irq(substream);
 		set_current_state(TASK_INTERRUPTIBLE);
 		switch (runtime->status->state) {
@@ -2176,7 +2174,6 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 
 	nonblock = !!(substream->f_flags & O_NONBLOCK);
 
-	mutex_lock(&runtime->buffer_mutex);
 	snd_pcm_stream_lock_irq(substream);
 	err = pcm_accessible_state(runtime);
 	if (err < 0)
@@ -2229,10 +2226,15 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 			snd_pcm_stream_unlock_irq(substream);
 			return -EINVAL;
 		}
+		if (!atomic_inc_unless_negative(&runtime->buffer_accessing)) {
+			err = -EBUSY;
+			goto _end_unlock;
+		}
 		snd_pcm_stream_unlock_irq(substream);
 		err = writer(substream, appl_ofs, data, offset, frames,
 			     transfer);
 		snd_pcm_stream_lock_irq(substream);
+		atomic_dec(&runtime->buffer_accessing);
 		if (err < 0)
 			goto _end_unlock;
 		err = pcm_accessible_state(runtime);
@@ -2262,7 +2264,6 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 	if (xfer > 0 && err >= 0)
 		snd_pcm_update_state(substream, runtime);
 	snd_pcm_stream_unlock_irq(substream);
-	mutex_unlock(&runtime->buffer_mutex);
 	return xfer > 0 ? (snd_pcm_sframes_t)xfer : err;
 }
 EXPORT_SYMBOL(__snd_pcm_lib_xfer);
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 35613a52ce1f..c57d82402220 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -634,6 +634,24 @@ static int snd_pcm_hw_params_choose(struct snd_pcm_substream *pcm,
 	return 0;
 }
 
+/* acquire buffer_mutex; if it's in r/w operation, return -EBUSY, otherwise
+ * block the further r/w operations
+ */
+static int snd_pcm_buffer_access_lock(struct snd_pcm_runtime *runtime)
+{
+	if (!atomic_dec_unless_positive(&runtime->buffer_accessing))
+		return -EBUSY;
+	mutex_lock(&runtime->buffer_mutex);
+	return 0; /* keep buffer_mutex, unlocked by below */
+}
+
+/* release buffer_mutex and clear r/w access flag */
+static void snd_pcm_buffer_access_unlock(struct snd_pcm_runtime *runtime)
+{
+	mutex_unlock(&runtime->buffer_mutex);
+	atomic_inc(&runtime->buffer_accessing);
+}
+
 #if IS_ENABLED(CONFIG_SND_PCM_OSS)
 #define is_oss_stream(substream)	((substream)->oss.oss)
 #else
@@ -644,14 +662,16 @@ static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 			     struct snd_pcm_hw_params *params)
 {
 	struct snd_pcm_runtime *runtime;
-	int err = 0, usecs;
+	int err, usecs;
 	unsigned int bits;
 	snd_pcm_uframes_t frames;
 
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
-	mutex_lock(&runtime->buffer_mutex);
+	err = snd_pcm_buffer_access_lock(runtime);
+	if (err < 0)
+		return err;
 	snd_pcm_stream_lock_irq(substream);
 	switch (runtime->status->state) {
 	case SNDRV_PCM_STATE_OPEN:
@@ -756,7 +776,7 @@ static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 			substream->ops->hw_free(substream);
 	}
  unlock:
-	mutex_unlock(&runtime->buffer_mutex);
+	snd_pcm_buffer_access_unlock(runtime);
 	return err;
 }
 
@@ -789,7 +809,9 @@ static int snd_pcm_hw_free(struct snd_pcm_substream *substream)
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
-	mutex_lock(&runtime->buffer_mutex);
+	result = snd_pcm_buffer_access_lock(runtime);
+	if (result < 0)
+		return result;
 	snd_pcm_stream_lock_irq(substream);
 	switch (runtime->status->state) {
 	case SNDRV_PCM_STATE_SETUP:
@@ -809,7 +831,7 @@ static int snd_pcm_hw_free(struct snd_pcm_substream *substream)
 	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
 	pm_qos_remove_request(&substream->latency_pm_qos_req);
  unlock:
-	mutex_unlock(&runtime->buffer_mutex);
+	snd_pcm_buffer_access_unlock(runtime);
 	return result;
 }
 
@@ -1176,12 +1198,15 @@ static int snd_pcm_action_nonatomic(const struct action_ops *ops,
 	int res;
 
 	down_read(&snd_pcm_link_rwsem);
-	mutex_lock(&substream->runtime->buffer_mutex);
+	res = snd_pcm_buffer_access_lock(substream->runtime);
+	if (res < 0)
+		goto unlock;
 	if (snd_pcm_stream_linked(substream))
 		res = snd_pcm_action_group(ops, substream, state, 0);
 	else
 		res = snd_pcm_action_single(ops, substream, state);
-	mutex_unlock(&substream->runtime->buffer_mutex);
+	snd_pcm_buffer_access_unlock(substream->runtime);
+ unlock:
 	up_read(&snd_pcm_link_rwsem);
 	return res;
 }
-- 
2.36.0

