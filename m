Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C07A8525CBF
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 10:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356176AbiEMIBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 04:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378012AbiEMIB1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 04:01:27 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA9621820
        for <stable@vger.kernel.org>; Fri, 13 May 2022 01:01:26 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24D7kSO1030554;
        Fri, 13 May 2022 01:00:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=Bqy9Nu1LIJo0MzQSUNg1hMgounrAcf/WsFd5kmV4B78=;
 b=ZTDMpkRW7zsbPiWEzqniwOzjLwLJok5azCghME/+ddjBzfIdkqOa8hFuQmLvQUrunbCH
 ugb+xjswGwU6erSFNjfm9P+mCkVB3H0b6zPWgkdR+DmxyaransMDw347X6UbkLbkEyA5
 FKG61a95XCBlAm9Tl+51oCIHQfHZ6wnQjwJrNu9efywfAjWujHP2h3X8zta1nWFxTwJX
 qg3IJHY0ipvRjrJEgqfxA9/ZoDXGFFja+qz6r6cJe51duOX0n/MwuX38ouFb2YkyZyXZ
 AhtZssM9VFKvGG3hWibolxNrMyEZ63ZszBak7e8Hvmq72s4bzxuta2yokH3fGaPH8+oE qQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fxde5kx1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 01:00:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aWmIirr9NQZMkC59ReHGOU9nGEhlJrR/jwSqj2gQab7HmBnN10NaX8dO3xoEr1/WsSz1E9TvpNMQv1v2R9x7CEQpwBwXPxL30p29Nn/qF1U9wPnERhbf7kXwEeDRQ5OiVU9qvhupSQbYrafisdGtK7/oNLAzLrYi2UCu76OkFGNhKEcM+l+WFr75UODt6hNoTEvimzTqwRoRkkOwJXMTu6WS5E+uvnkDroZlNuVtzNva2H7e819CnJbSYm0QJaAjboIuyozHRI4r4lbTO60dm7+0EpDsK8CWG8yaI5U7dMoEJNW7QwySmSTym6uLdCC6hDH8HUPDTNuypodHZhdjTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bqy9Nu1LIJo0MzQSUNg1hMgounrAcf/WsFd5kmV4B78=;
 b=Jygj+WsY4SXnUZGScbk4RZXhdm9+oip71g9eloV/Ycs0t9cziduLMba5Rn8OFvorBck3JCry9zo0d5jd0T4zIFsMPzE/lMBxfw9seqUeZnuIKNZtAwQyHwnJIJnDfp4vckE1BkFiZnkGVEGMIk0THDz4VMqdwCRUBsdpXpTtClybCrLXig90dWXMQYbdlS3Uou6rTy7JmpF5sOC8IPgOEjXBQMVA3O+MiZvXIL/Cg9pZCxfHdzAEHeSqiTytYnyxiSIaFF16hhRnLmiCJqxvewqpSG/A9u0CVccY2uKuqlekG+6Ft+pKg8vQS0o/QDDHHWmHnrmdkIvZj35oZNmOGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BYAPR11MB3175.namprd11.prod.outlook.com (2603:10b6:a03:7c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Fri, 13 May
 2022 08:00:39 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842%5]) with mapi id 15.20.5250.015; Fri, 13 May 2022
 08:00:39 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Hu Jiahui <kirin.say@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 1/5] ALSA: pcm: Fix races among concurrent hw_params and hw_free calls
Date:   Fri, 13 May 2022 11:00:14 +0300
Message-Id: <20220513080018.1302825-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0104.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::33) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5db2352e-4de8-42f5-67be-08da34b6ab70
X-MS-TrafficTypeDiagnostic: BYAPR11MB3175:EE_
X-Microsoft-Antispam-PRVS: <BYAPR11MB3175676A1D238318B56ED5EAFECA9@BYAPR11MB3175.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VHJD30/UVFvHrolqGsY3nnT5tppLLn2FgLkqUngnTlkLjog3E2yQ1X2PqJBBaO15Q3laoQxI/TXs05nJ+Gh00l9lNro95tnrFbXievdjbHuhem57uHqY2u9Kg9/bBTBRvrZkDf1G7/El1I1EdJ7fAUk/YecavRREPRTYNrr1BM5/e7lwNYTG+5V9nsLhjFvNAdKVZ6CH+IFjQm1+J0fnpL+VMtOhpUpAwOuqUIp8QzLLlIjW5+NuzqXlOZ6AqblooPyx+MUgXUDnBuqDVKgVCOWda5ogqOWqaYMC0P7ifBoa53fJDcxIQ40z4xOFJJrvyUg/Opmb0OcCO1XZuvA/+WGiTRkZWSO5pRGZir5QyrHx/ZW5zebN12c5UORPYyiSm2wbdaaFYu7s0fhpf1eqHgUqyCGxaJ76YmhzO/4Gf7RgnU/T6vGg4KG8Kc481xwjy9UWbpeoBWzSt+n8wwj1JAimK/v5GwTkcJnqzNmSRTEXwKw1rQNWvIJFaMgU0RFzl9UAsdNVGb8MXzuwKn2BhiPhPZlY8IfHDBEzfAe4PcoNAoYh7PpfSaFgSGsdCEOv+Q7M3yCK5Zm/ej4pHglxOqX9zBvvkNipa9rVNzxZJneitAEC1ubqKO6b41S/fkzTne/qLnEqdIOkm08Igi5d1Vnc01iwY0Yhud+lx08R1rWecLDa2DRR4bSSa6YSeM9bTD6SWz1Xj8ebgDucZBsSoHOfhYBbf2gZWHj7ey4jI9TJQEaDwT5YlKc0wFmUtR9lcfkNH6cXjtEUUnJLdi1wEngVxFy0hz0kc0nDnFThJ2U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(54906003)(2906002)(4326008)(83380400001)(8936002)(44832011)(5660300002)(66476007)(6916009)(66556008)(8676002)(316002)(36756003)(26005)(6512007)(6506007)(86362001)(2616005)(6486002)(966005)(508600001)(107886003)(186003)(1076003)(52116002)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m57Rv6i+8mvPQ+OC98BCcZ1OmP35Wb8ZZjOwzqHzUxzEdYCnF3J6CyVuYnGq?=
 =?us-ascii?Q?ApMZiMl9LMu49q74+24bQ/ChpUSS9RRoJNS3VpbdaONxNNbggHksqRWWCqZP?=
 =?us-ascii?Q?U1KfytqBwPYZ5H4ZM7d+Kgd3qpPtXoSM1/Kr2lcMONOrPobuerjhZv39XR+a?=
 =?us-ascii?Q?x41ZTsGljWoBHKjZ8pZg7LF4ubitPcg3Nf/jbDZpb+wFusdQJFIOgR9+JdOM?=
 =?us-ascii?Q?fAPhMtBjDuRCZv6wH2ElcYy5Uo7bzuwQpAcAfVNWk/VESy0kia/J5t5Xyyys?=
 =?us-ascii?Q?kX/2gUF+oVM8TEv7Bcx+CxWB/lP7ad23VxeMTTb49+eivYhF2DKBKJWS5vlI?=
 =?us-ascii?Q?z2WXfqj81G0NowTTjIH5ChJsjA0KNT21mcK1lILAOAbjEj5yN5gbHbaHngGA?=
 =?us-ascii?Q?Ftuzmaxt/cFdI/3ztI6FnATjSZf8LINy6PkBYqMigPe2r6VeK3eOtp3fl6dk?=
 =?us-ascii?Q?yexB3REhIdkaaa/Ds5TfcrE768PjOmZuePL09nGM/hXTVRUE/Pymq4GhfROb?=
 =?us-ascii?Q?odASjf1SKunkR/ltGsZfiTx4HecjOiUqGvk7LKLQmD+YY1NIm8KqctJmejlG?=
 =?us-ascii?Q?bT4m/tuCduacjhYYs2qF8HYT/Rg0Sn43o6YbyHv9eVK+nBeKM9tjDmkWns1z?=
 =?us-ascii?Q?4VaVRWDAmdLJT1s5crYQ8ETbRFOsyICx/FW4MNpOgZY3gsUY4gY4SUBiwyVV?=
 =?us-ascii?Q?Xhq4e26AVFFo4yXGVxVDQv/GjbhlRLjlHxk5UrTVSbwNBd0fgVTqYy29vScc?=
 =?us-ascii?Q?vVgt15zLdcYKeWCJD/oopE23Ebl2aBnUweb4r4EUTFK8U9M7NqkYonBJfl7J?=
 =?us-ascii?Q?mJ0lt+i9MMYl/oZzOQ2H/mHCkPv97yNcwkUDLYLRQ3oun9TFT3d8rvwv5g0L?=
 =?us-ascii?Q?PspeVD7IIguACNFnbSDQuJJ5uaQWBhXx/mgvcvCeTBsSxk0iKbrv4kv10bcW?=
 =?us-ascii?Q?vocwvx51URiviXQ0nsZ++8GOjyGdxGv9Dmy0YjjlX9NA0eJfahLuRk9Ruw7f?=
 =?us-ascii?Q?Nlg/7eADgSuO6htcKN8GmNgQKvt0pjee2HDcZCJLQnGuJu9z7qn+hpYo61JA?=
 =?us-ascii?Q?wqzzl9u8QeNXtHEADzr/D6SHbhEjHFQWq+343EaxN1msToJIP95SEbt11/l5?=
 =?us-ascii?Q?CBWhJPn5Nppu+GqqtEtL0835gSyNjSbh255sch/6rIcVIjgAhkhEysP1WIoE?=
 =?us-ascii?Q?6TxYo2XKAryHBf0VsdM29QuRheQBGf6lCaRD2JcBT8X4DkhxP03m6ZucnKP9?=
 =?us-ascii?Q?5ASimsvLyPNk6IhsAcjfGpQWgnPPeHTPtJ9DF5xUg0ATr9Wl3A/J1Fba74k+?=
 =?us-ascii?Q?sv36cUqiFhm6SPsOn+hc9UEbE43Nl3Z/+4xjHwSBM9U5eceEum8Jdzga+f14?=
 =?us-ascii?Q?AgDSTbNYkAZ40nvJkKv1KLnGq9yXJbNcJDSa19ZrQIboaVksH7+Wbm+SN0rB?=
 =?us-ascii?Q?2+aJ5MbFh+sP33X8QdQ4OzYt10pTzi3j0vPzYuxdcDrd1h0iKWF+jPhlWj/6?=
 =?us-ascii?Q?FraA8+Zdvv1MeLwM32p4bEl/3SJmHM5SG81ktEE5k8vItq3MZACPDLjCt0IH?=
 =?us-ascii?Q?NKZrioW4TkTgMj0CSkoclmoU2uTiKhZ88DADvBfl8gPfKTRIMxnmwDBR9ddS?=
 =?us-ascii?Q?KkSIim3+RHnf05V0eL4SzsgaqJBRsVq1ec12q+0rf808UHCJaHHp+GmOP+N4?=
 =?us-ascii?Q?P5pn+Z90dT0adIK6g80IX/d9Ufz2hX2N5qUXmD5WZpmyq60w1BFOwt/clnjB?=
 =?us-ascii?Q?1OyGYWyyB4iyvwhm/3ZhqvV68PWYegM=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5db2352e-4de8-42f5-67be-08da34b6ab70
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 08:00:39.3340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QFPcOw9bRXjxYSBGU90uofPu3V3pvoFv9+G3OhJjDUefro81tPeeMHDcivmZX5pP650tnJOcm05Vc/mWYnCaym2bnEqusJcc1m7M/10t2I0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3175
X-Proofpoint-GUID: Ssv4lmxW3OtzHLbGfe0pQqBleOZT0_JA
X-Proofpoint-ORIG-GUID: Ssv4lmxW3OtzHLbGfe0pQqBleOZT0_JA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_03,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxscore=0 malwarescore=0 clxscore=1015 bulkscore=0
 mlxlogscore=911 suspectscore=0 adultscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130034
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

commit 92ee3c60ec9fe64404dc035e7c41277d74aa26cb upstream.

Currently we have neither proper check nor protection against the
concurrent calls of PCM hw_params and hw_free ioctls, which may result
in a UAF.  Since the existing PCM stream lock can't be used for
protecting the whole ioctl operations, we need a new mutex to protect
those racy calls.

This patch introduced a new mutex, runtime->buffer_mutex, and applies
it to both hw_params and hw_free ioctl code paths.  Along with it, the
both functions are slightly modified (the mmap_count check is moved
into the state-check block) for code simplicity.

Reported-by: Hu Jiahui <kirin.say@gmail.com>
Cc: <stable@vger.kernel.org>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20220322170720.3529-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[OP: backport to 4.19: adjusted context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 include/sound/pcm.h     |  1 +
 sound/core/pcm.c        |  2 ++
 sound/core/pcm_native.c | 55 +++++++++++++++++++++++++++--------------
 3 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/include/sound/pcm.h b/include/sound/pcm.h
index d6bd3caf6878..0871e16cd04b 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -404,6 +404,7 @@ struct snd_pcm_runtime {
 	wait_queue_head_t sleep;	/* poll sleep */
 	wait_queue_head_t tsleep;	/* transfer sleep */
 	struct fasync_struct *fasync;
+	struct mutex buffer_mutex;	/* protect for buffer changes */
 
 	/* -- private section -- */
 	void *private_data;
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index b6ed38dec435..a11365dc5349 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -1031,6 +1031,7 @@ int snd_pcm_attach_substream(struct snd_pcm *pcm, int stream,
 	init_waitqueue_head(&runtime->tsleep);
 
 	runtime->status->state = SNDRV_PCM_STATE_OPEN;
+	mutex_init(&runtime->buffer_mutex);
 
 	substream->runtime = runtime;
 	substream->private_data = pcm->private_data;
@@ -1062,6 +1063,7 @@ void snd_pcm_detach_substream(struct snd_pcm_substream *substream)
 	substream->runtime = NULL;
 	if (substream->timer)
 		spin_unlock_irq(&substream->timer->lock);
+	mutex_destroy(&runtime->buffer_mutex);
 	kfree(runtime);
 	put_pid(substream->pid);
 	substream->pid = NULL;
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index c92eca627840..2b46a2ebefe0 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -666,33 +666,40 @@ static int snd_pcm_hw_params_choose(struct snd_pcm_substream *pcm,
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_SND_PCM_OSS)
+#define is_oss_stream(substream)	((substream)->oss.oss)
+#else
+#define is_oss_stream(substream)	false
+#endif
+
 static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 			     struct snd_pcm_hw_params *params)
 {
 	struct snd_pcm_runtime *runtime;
-	int err, usecs;
+	int err = 0, usecs;
 	unsigned int bits;
 	snd_pcm_uframes_t frames;
 
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
+	mutex_lock(&runtime->buffer_mutex);
 	snd_pcm_stream_lock_irq(substream);
 	switch (runtime->status->state) {
 	case SNDRV_PCM_STATE_OPEN:
 	case SNDRV_PCM_STATE_SETUP:
 	case SNDRV_PCM_STATE_PREPARED:
+		if (!is_oss_stream(substream) &&
+		    atomic_read(&substream->mmap_count))
+			err = -EBADFD;
 		break;
 	default:
-		snd_pcm_stream_unlock_irq(substream);
-		return -EBADFD;
+		err = -EBADFD;
+		break;
 	}
 	snd_pcm_stream_unlock_irq(substream);
-#if IS_ENABLED(CONFIG_SND_PCM_OSS)
-	if (!substream->oss.oss)
-#endif
-		if (atomic_read(&substream->mmap_count))
-			return -EBADFD;
+	if (err)
+		goto unlock;
 
 	params->rmask = ~0U;
 	err = snd_pcm_hw_refine(substream, params);
@@ -769,14 +776,19 @@ static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 	if ((usecs = period_to_usecs(runtime)) >= 0)
 		pm_qos_add_request(&substream->latency_pm_qos_req,
 				   PM_QOS_CPU_DMA_LATENCY, usecs);
-	return 0;
+	err = 0;
  _error:
-	/* hardware might be unusable from this time,
-	   so we force application to retry to set
-	   the correct hardware parameter settings */
-	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
-	if (substream->ops->hw_free != NULL)
-		substream->ops->hw_free(substream);
+	if (err) {
+		/* hardware might be unusable from this time,
+		 * so we force application to retry to set
+		 * the correct hardware parameter settings
+		 */
+		snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
+		if (substream->ops->hw_free != NULL)
+			substream->ops->hw_free(substream);
+	}
+ unlock:
+	mutex_unlock(&runtime->buffer_mutex);
 	return err;
 }
 
@@ -809,22 +821,27 @@ static int snd_pcm_hw_free(struct snd_pcm_substream *substream)
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
+	mutex_lock(&runtime->buffer_mutex);
 	snd_pcm_stream_lock_irq(substream);
 	switch (runtime->status->state) {
 	case SNDRV_PCM_STATE_SETUP:
 	case SNDRV_PCM_STATE_PREPARED:
+		if (atomic_read(&substream->mmap_count))
+			result = -EBADFD;
 		break;
 	default:
-		snd_pcm_stream_unlock_irq(substream);
-		return -EBADFD;
+		result = -EBADFD;
+		break;
 	}
 	snd_pcm_stream_unlock_irq(substream);
-	if (atomic_read(&substream->mmap_count))
-		return -EBADFD;
+	if (result)
+		goto unlock;
 	if (substream->ops->hw_free)
 		result = substream->ops->hw_free(substream);
 	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
 	pm_qos_remove_request(&substream->latency_pm_qos_req);
+ unlock:
+	mutex_unlock(&runtime->buffer_mutex);
 	return result;
 }
 
-- 
2.36.0

