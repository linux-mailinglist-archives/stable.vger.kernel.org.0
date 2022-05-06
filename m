Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76DC551D40C
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 11:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381989AbiEFJQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 05:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390356AbiEFJQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 05:16:22 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C5F6339A
        for <stable@vger.kernel.org>; Fri,  6 May 2022 02:12:39 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2468qdL7028605;
        Fri, 6 May 2022 02:12:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=9YAL0PWJu6Y2Ajp7wN+cqAlwA+3sCHexHMJZcBzkVvA=;
 b=gqPWagK3GPhZXY2v3VEfgf9H6tNifnybwOMkwh4IuCfgHWBp8tjZtrrwQzgBfjU/dDQE
 Q4bM4FhEUkhZFvU0RfKmYR3DWb30jORBbK5IAlrlO5aCv0ktQo51xrthv5loqDvM0lUb
 +OMCxwBG2lfekHZXfQbGbVYckRjkYPrNlbdWc60cn7T5BCx6pecNB6M94SrTPvhmYTVv
 0FDjPbWcUjZLGLQ+4DYzRgWlM/THrqgdmHEQvj1ASKqyxckJ1FJoFF6cCY7og3tkReiV
 eqPgopxamI+gd4Np/yWufd2eIOmsrrQmuz+G1Cgbt0FskajbpNUkdh9aVgyrZhQLk49v wA== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fs0d3cere-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 02:12:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dyCN3Q598wAJu4Tm4ubGrCrAGACuMYnQbC8JfTQ/I7tdyMfJL1/RyVgJEutLWqZeZcFYoCVzN2QS7q4oFzAzmdQeMi08OIY02tN4H6k0l6ZoighgKNWj9ihf5vlJ1V/SArhWkaGEhV/mYNQO7qf20tz6dxjE3t56Y9pTxa7e3++JWp2zKjtf3qzBH7xh39R4RO+LwNfebXrjhJc2jHRaOrymu+LlqtjsC344b6Woor+vtDelfKW+xTrUZPhmHF5UVPbALcL/J77gfzyYuANXfTRW9LdzPabHRkJIQzTb4P+A8uHY4Yj+2XSwIiUAwI8pki1sLZt5wbDGC2SsS1nkDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9YAL0PWJu6Y2Ajp7wN+cqAlwA+3sCHexHMJZcBzkVvA=;
 b=bUlwIAx4sicsAFl8EPE9BukcBSRZpAadr5e3XGRVcV/aRTkRJQTHsGY4qy2ExMUzkKobcvs8qCPXHWrcj2m9/ixgubpSdV+CgOWFHTsk4zP61TAAFO2A2Q9GMZ8oTElACf0DcNTCQLX0XKYQPKh0B5VRp9GNL44oK78CKEdTRujE9AgMR0YEJNH58PugUmA/OGK6oOsOLSqAbgsDHo9cp7cqEq31mBogRgdNy1QaMzDVvBjOTB5zEh6A6R8rlivLDrAWS+KUX5HiZjfh7IRCTRo7BrbWY5sfRVRv3ZBJ+0b8SXn9CEz1ZhiXYmP96dsMbAEylx9ed6Jp+XU85+9Sgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BN7PR11MB2660.namprd11.prod.outlook.com (2603:10b6:406:b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Fri, 6 May
 2022 09:12:26 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34%8]) with mapi id 15.20.5206.027; Fri, 6 May 2022
 09:12:26 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tiwai@suse.de, perex@perex.cz, kirin.say@gmail.com
Subject: [PATCH 5.4 5/5] ALSA: pcm: Fix potential AB/BA lock with buffer_mutex and mmap_lock
Date:   Fri,  6 May 2022 12:10:13 +0300
Message-Id: <20220506091013.1746159-6-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220506091013.1746159-1-ovidiu.panait@windriver.com>
References: <20220506091013.1746159-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0009.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::21) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c64e6c46-b51c-4cbd-0b46-08da2f408a02
X-MS-TrafficTypeDiagnostic: BN7PR11MB2660:EE_
X-Microsoft-Antispam-PRVS: <BN7PR11MB2660D038E0D8F249D89CF3C3FEC59@BN7PR11MB2660.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dj6MMx6DcwxPgBw27znlFqvAjcJwQwiUNZZZWxF77ZcrW1hLdjk91qndhIWGY7xfm1ntVIM9pvFa4cu18i1haTOAcM/V8Vfi53lTcaaQV5f9cg6nmfsotScsnkog6bKudm12TojZtmE2YrRPmbzwDzFi4pE23SP2XJ81P1UkHzdPCBR+H0iNRR58vOI0nfuzUrMKYGImlIWQOmUAAaK0Z75X/HZZjuTJ96ZZS2m4MlcRdfu4uHwU2k2T0KLdm+Iz5FUfrpMuFVohA2PeILL2noTiXQyvVJWeYa2FwfixJ0NyRbZ2J7KO1PXs6nzzn78P+FTlE72EIu81BCnQ+WUZHwZM0t18m8SnVcjsU3BBNzb2sKH+bDeURnNvvBSw8hDY9O+1fg+6wTOM7LYOPY5GYN1ulYK+kXr5YBiClTYT8pWz4lvLN2Ji2BfoTyp+Y8IaU/Hveml/3o+NjRAoSv4HDLgKr/AvX0HxZ/w7Ipl8uFR9W9K6fUKAsV49eZOSop6sIkGkGtY3n5WVcKSZwkGzSVHO8t0BN9S5yjMvMPIM+7TgLM/cqWQMzwSaoDaVOt3TqZkz++rnJyTKRew0YGlQMyzyOVXJ1vkSjCeYboDFFwV6kcfSh9KLEDkYACOsjggbniXVQ/Q6ewG3QEmfRlgnNn07ryz7MUgpKRwtfWmtnI8PiHUIo0d5lgRWHE8RC4PuubHTrR8pxZ35y7Y5hIVxF0yVX8HVtYW28J9Lh9WUbZPLnQNJFhOkNxLvs41X7+Lsh3c+NgtRohfmls0go0kOHQCyyzEW67y0V6YsyZu3FxPHE71RBRkHejYvpmc4c05wk152WxGlDb0TwSu4fuiOng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(508600001)(2906002)(6666004)(44832011)(36756003)(52116002)(5660300002)(8676002)(4326008)(86362001)(6512007)(66476007)(66946007)(66556008)(26005)(8936002)(38350700002)(6486002)(966005)(38100700002)(1076003)(186003)(316002)(2616005)(83380400001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AeLDyiqhCXhaiMLk8qQAfU1aKLBy7URL2RqlWAJuuzRzY+z0ScykHVvDX2Ue?=
 =?us-ascii?Q?w3xmmeg9HXZSo+rBsPKw5OaMaw1lF/EZtGfo7Bfp7f2Sm8eQUugXb6+z3WXI?=
 =?us-ascii?Q?KMwTeYD7xgZXWkWWE0jlZKJ6EOJ0cqVLVraLjkL9qDfcSlDtEMBIMfoO57hp?=
 =?us-ascii?Q?dsLeuhooX7K8BArjdPE6h8TMIF4qKsk5Ml5rBU450dNmLe8FeP4OFywNfOuu?=
 =?us-ascii?Q?snAWUweX+Ni4pgciQiC2DBkIBo//J2C8Dd8KKk2S3ctRSb8FAXqC4qKz5cBn?=
 =?us-ascii?Q?azGSfPoCx1m6jPTX9EhqNTWt871pDOhCYP0faW1Dd2v0xQkbe0MHRw2Ubpo7?=
 =?us-ascii?Q?DqkyYf++q42IVyW3Gf/lj1jT4xkiUSWA+h4h2kXXl0dIQbftkywRhiZQBFJS?=
 =?us-ascii?Q?Ltq6bn0dFOf47DIwun9STWCE7wazjXww1hMpJinXmSckFY64UdpeVOkqnezL?=
 =?us-ascii?Q?p9RFoxLtLUPkpVHH2ZK7HLhD15HbzNQAqO+v9s2YSmRzzml5NyBVJKT+/4OV?=
 =?us-ascii?Q?9lUXzegwGEQCH01HDxfnPHdb7WB2oCGUY0TD0/KD23VMvqEK72oLztgfHUaL?=
 =?us-ascii?Q?yjLZAxqNvgeWVdqD3GxtBa04ZSqN/VmGVKuk0V+onmWg4plu75CqHNA1Y8pw?=
 =?us-ascii?Q?bZ7GLxcJdbtzyVooGscis4D2k9cgqeKIHc6dUak38Ak5kimdMWodOJqiNOCI?=
 =?us-ascii?Q?Y7k45wx5kEYwVoqTTZpnqujn84gS8oxM15jrMMDm8SLqjSzPWySFZzF6++6s?=
 =?us-ascii?Q?7D45ur6AkYmZ1W3Xa5zen9oExpginCYjuQ8/2FW9IetJPV5aKKi1MC/Jl9Id?=
 =?us-ascii?Q?dl4wF1U+TBr3PR4p8hmmbz6K/2tF0uZl0B+8sOYn4jPlpHhF0IX03WHCFvfo?=
 =?us-ascii?Q?lPE/q2J8aOZsej2eXe4mOFBvDcwI/9zz3O3aYJ6HCk9Nu6WWtFKBrD2CgkyG?=
 =?us-ascii?Q?/s0S2XZlnYpW6Ac6Go38oQUTb6AiUxN10VL2IhwgtJJQCmJFrSXhKxZt4+8s?=
 =?us-ascii?Q?W50AIgWI50o5tpMqi3rlDlrCCoS6Y0gdTd87Yx8oUU5GqVcNSX070ijoal5I?=
 =?us-ascii?Q?L5XnncY7ti0CmG7TbD8SI+JdzAKRadJcNL3jVO+woyvB8af/KUQAcmqpHoIU?=
 =?us-ascii?Q?fmFSLhr3BvYtKaOUFtno6KiIGeMWp39XruwfL9sbcFulhrZk8npWg63UqyqT?=
 =?us-ascii?Q?NI4UXcUODj6uckk2TSyPgH3H6lywGwmHf1OsbdgWIu4swqWyqAs9rm924OIi?=
 =?us-ascii?Q?eDvLmBG3goCwAZiAPk2BJJ/0272K1QoTZUpc/YLUlW/ZQGdGHZYWt134YWZE?=
 =?us-ascii?Q?9YQftPraW9jQNpk7LfeWBcmg0VTDc+4m3LUr+D51GVVx8S6Jkfr93eiOK0dX?=
 =?us-ascii?Q?d1CLfab6jHxSOXeVqNml3KLdXqICQ8qvoZVS5KWuGLLMJ5uHkVb5Q0GEbgtt?=
 =?us-ascii?Q?6Eiobf6d8sUZj1pgnsu87jn38hP2plC2cygawfJluNd6ImQ5Q8/3nD2SP5up?=
 =?us-ascii?Q?tsjS89UaUPfIbKBqeiIT7bLmLeuiCN0ZtPJqnBaDbfofwNgOCOga5+WB7TCl?=
 =?us-ascii?Q?yHbxgnPJxL1r0f75hqy3w7ccecOtIXlaEgDSiLncFY7dU5oka/2pMQJzizHE?=
 =?us-ascii?Q?5y49KFh8ZFyi+k9PLXrawptl3Zqjg57SfLKFcrLoMQZWCHzGIBhBXuD8hnt6?=
 =?us-ascii?Q?CZYA9Y+ysa3GXC5gkszKG7lLmS6TYrqI7Wn4idcLzezoBCxvoDS17cewm6s0?=
 =?us-ascii?Q?uLLxh0Np7BOZh2L9DYpB3e9tKw/ie1Y=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c64e6c46-b51c-4cbd-0b46-08da2f408a02
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 09:12:26.7086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3QmHug58NHRVBJNmRTfmrurWzTboEuaz0uFlq7bpCqKGFvCjtKsWW/ZjrHzmmpD8fgnOKq7Kui7lO/s5coumWZYkaVZ76iCVcoVGc3DL/q4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2660
X-Proofpoint-GUID: mVNQ6Jf62Sc1YqwzG4LgauzrujnGrQd3
X-Proofpoint-ORIG-GUID: mVNQ6Jf62Sc1YqwzG4LgauzrujnGrQd3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_03,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 suspectscore=0 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205060051
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
[OP: backport to 5.4: adjusted context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 include/sound/pcm.h     |  1 +
 sound/core/pcm.c        |  1 +
 sound/core/pcm_lib.c    |  9 +++++----
 sound/core/pcm_native.c | 39 ++++++++++++++++++++++++++++++++-------
 4 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/include/sound/pcm.h b/include/sound/pcm.h
index 24273d0f770b..f0045f842a60 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -396,6 +396,7 @@ struct snd_pcm_runtime {
 	wait_queue_head_t tsleep;	/* transfer sleep */
 	struct fasync_struct *fasync;
 	struct mutex buffer_mutex;	/* protect for buffer changes */
+	atomic_t buffer_accessing;	/* >0: in r/w operation, <0: blocked */
 
 	/* -- private section -- */
 	void *private_data;
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index c9335d1d0e44..3561cdceaadc 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -970,6 +970,7 @@ int snd_pcm_attach_substream(struct snd_pcm *pcm, int stream,
 
 	runtime->status->state = SNDRV_PCM_STATE_OPEN;
 	mutex_init(&runtime->buffer_mutex);
+	atomic_set(&runtime->buffer_accessing, 0);
 
 	substream->runtime = runtime;
 	substream->private_data = pcm->private_data;
diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index fdb141e426ac..1bce55533519 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1861,11 +1861,9 @@ static int wait_for_avail(struct snd_pcm_substream *substream,
 		if (avail >= runtime->twake)
 			break;
 		snd_pcm_stream_unlock_irq(substream);
-		mutex_unlock(&runtime->buffer_mutex);
 
 		tout = schedule_timeout(wait_time);
 
-		mutex_lock(&runtime->buffer_mutex);
 		snd_pcm_stream_lock_irq(substream);
 		set_current_state(TASK_INTERRUPTIBLE);
 		switch (runtime->status->state) {
@@ -2159,7 +2157,6 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 
 	nonblock = !!(substream->f_flags & O_NONBLOCK);
 
-	mutex_lock(&runtime->buffer_mutex);
 	snd_pcm_stream_lock_irq(substream);
 	err = pcm_accessible_state(runtime);
 	if (err < 0)
@@ -2214,10 +2211,15 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 			err = -EINVAL;
 			goto _end_unlock;
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
@@ -2247,7 +2249,6 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 	if (xfer > 0 && err >= 0)
 		snd_pcm_update_state(substream, runtime);
 	snd_pcm_stream_unlock_irq(substream);
-	mutex_unlock(&runtime->buffer_mutex);
 	return xfer > 0 ? (snd_pcm_sframes_t)xfer : err;
 }
 EXPORT_SYMBOL(__snd_pcm_lib_xfer);
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 4f53e6103fd5..57a4991fa0f3 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -630,6 +630,24 @@ static int snd_pcm_hw_params_choose(struct snd_pcm_substream *pcm,
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
@@ -640,14 +658,16 @@ static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
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
@@ -752,7 +772,7 @@ static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 			substream->ops->hw_free(substream);
 	}
  unlock:
-	mutex_unlock(&runtime->buffer_mutex);
+	snd_pcm_buffer_access_unlock(runtime);
 	return err;
 }
 
@@ -785,7 +805,9 @@ static int snd_pcm_hw_free(struct snd_pcm_substream *substream)
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
@@ -805,7 +827,7 @@ static int snd_pcm_hw_free(struct snd_pcm_substream *substream)
 	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
 	pm_qos_remove_request(&substream->latency_pm_qos_req);
  unlock:
-	mutex_unlock(&runtime->buffer_mutex);
+	snd_pcm_buffer_access_unlock(runtime);
 	return result;
 }
 
@@ -1221,12 +1243,15 @@ static int snd_pcm_action_nonatomic(const struct action_ops *ops,
 
 	/* Guarantee the group members won't change during non-atomic action */
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

