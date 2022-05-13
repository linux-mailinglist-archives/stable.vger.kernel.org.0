Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1950525F24
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 12:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379083AbiEMJjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 05:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379096AbiEMJjO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 05:39:14 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFF92A7694
        for <stable@vger.kernel.org>; Fri, 13 May 2022 02:39:11 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24D995TY031470;
        Fri, 13 May 2022 09:39:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=Fl5jxP+4RcvMaN+oZc9wGpsBx4viLnvJHLkgU0mym8s=;
 b=XR0fydEP5L1ZUdrdLuFUCIslyXp3q09F3Mf4AE7UYpmHernmdbACsRYb3r+a1DklTzva
 gZVHVW3tIcGbkNyeGO0PcUWsCHjC1WFsCFR4R/LgKBFwdzdCQDvbJPB5cNllvAamJ/at
 anI1QVrRzaI+c4wSAfQvBHweeRz1JrXUHZmdrkB+rFh+pXr4GAdh8Cm3DBsUvNRlsIN0
 PeSTPkzvg1QBOShHrIru/WQ1tV2K5sMMoSiRI+Lt5wk3YokQFmtFbus/kHETqpHvGMm5
 8fsyftRLhOTj6aw81HofyvEMqyxpNOJNWiAMT8vrDh//a0XDYqvd16xPwgpjqR1zlgCt bg== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2042.outbound.protection.outlook.com [104.47.73.42])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fwdyyvq41-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 09:39:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOFSZGdUzeiNUDyeaMZmBtLWrb3dkgBpqzwbyPc4QVkmo/XCaUTMMNbdsBA/buD54PZ6Qbqg8YOjtSQxNPWUfp7Y/X1CQjwhKrN24UJi6VIQ6VNpgJOO+0PZ+yZjVBtYpuM62TJrAJSi7Ly1Gv3d83z1P2HvpclBJGXVhIHzlubDIpq53akagDnJIiYY/+t6SKFOrUIswrYaxj5L/HGtVmdE0j1uwF9FchxtqBqZca3kwe5S2m91Mdz4jxcySTtPsUIF1wJQmFrnA+lwzAhSs+BL3dTp/18Fetayp5zOcGKzXzSFtWnNyVV1qHDM2GQD9eG4hEeeIKb04tAduLhJeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fl5jxP+4RcvMaN+oZc9wGpsBx4viLnvJHLkgU0mym8s=;
 b=c/ZtVRaS/0l4lEG3COybR39r2nZ6Q3kiAxw18zzn6V5RC//g4AuDB24FoQU1Tz0KqxnD6y0M5M+7+d3cA60ZIaxkKvnqREOFujAB1wD5mlNdDER37mFN9FsaZo70MCr9LfYvkWXNFkRzj5JkADzQK+tl2TeVY6/vHgRc6u08yHbSKjuWxvu1Md3MAh8z6XmgH/sVnN84r+4dk5DumbU7qgf5KAoUAu/WjP6gVivPH8WquqQ84qOF9PYtih9jxXWBoRcEaIqGCp9Tt1vgsfeVl9MpLPsv7eRP0Tjz6Vnlw3jfXFkqQSKN+4/3dtE4GozkDsOBbW6w5qhZ1qI4XyGeYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA0PR11MB4527.namprd11.prod.outlook.com (2603:10b6:806:72::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Fri, 13 May
 2022 09:39:00 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842%5]) with mapi id 15.20.5250.015; Fri, 13 May 2022
 09:39:00 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 3/5] ALSA: pcm: Fix races among concurrent prepare and hw_params/hw_free calls
Date:   Fri, 13 May 2022 12:38:30 +0300
Message-Id: <20220513093832.1434697-3-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: dbcdae3d-8fe7-4e04-1151-08da34c468f2
X-MS-TrafficTypeDiagnostic: SA0PR11MB4527:EE_
X-Microsoft-Antispam-PRVS: <SA0PR11MB45279A9F8BA8CF3541A24244FECA9@SA0PR11MB4527.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HUy2+YzjnP5DSdtTnQi9swc84wx6NxE51Ngzi+ox8dzxZcywmI4n8CIYy2iJ09MF17UYn3H1zod7P5TkfjMKL23vucqXHMZLTEQP9TGw5yM8sTire9I0XqBqjcN6ljpcqY3xcnTJrWRbl+eEo/yzFIVoJHexDtKA+1n66T9qFQkcLlFzMbVUALjKOwCTb6nMDJe+P2S7Q81WCaNSIdi9qkXguV0gtSyy/icdpoJNfcd4XwIiwvlShnwJryjFmFa6PqZxgh967oCEKInf2nFchDj/oC4MDgifk/6QhmZ6nX9CBdjA5oOhKbqQbNGb3NiWEuga4HXcn4X4fiUPDgIzCnVtO+eJI8Zlr3STmJ7zm1IwvDusBInHf24X+HIW1AklytrwOc/+6DGacJkNWVew28aoC5JoocaBDmVtOw23ki30KC5IUbCHm3/JUnoWco2CBiIhfcfIW3UY+Z6jmIkO4NIS3ViS20LSP3oXriNEPcwyFdPL8/2KvOf/XqNATvRdgnO2sR4jRq6ek7iFdPXC3tSnzTkuxO8ut/9VU3Lof89vSh45/lH2Bo3KyLq965mKnNyBaH6OZn3mvaqnZce15Mk0Q7krM7m/ookEgRQ+BqVBZ4lGbocOjmkKeAp0gcDr/aI82PbdvfIbfa7ssJ5ljQ9o5nXbbo/L8B+UtskkmfRye7wYoTsny5eFEpz0abxzvW+PfTZ10nSCmweINoQ524PT9kL+dh0FfqXBu0u49lj0qYCqsooxpBnvPKX/p2KxlZk/rOJYe36WS03Fr/frYi8+cbY+UZ+dwdclxEqS9cY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(38350700002)(316002)(66476007)(8676002)(4326008)(54906003)(6916009)(8936002)(66946007)(6512007)(26005)(1076003)(2616005)(107886003)(6506007)(52116002)(6486002)(508600001)(6666004)(186003)(966005)(86362001)(38100700002)(36756003)(5660300002)(44832011)(2906002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lLt5D6jpGsyIJOkegVwiMeDvfpmr4HLMmYGtYKhjLkXVU3fHMN9fXAnJ2N1+?=
 =?us-ascii?Q?WMEjPJ+xmGpdG41pGPrPnD225JtXRNxoD97PoJZfs6/9FXtwFOZsi5xHRF0R?=
 =?us-ascii?Q?7FS1N7DLuvZXK5QygUf0vzOJzGPeiipXzAuUJ6ICq2XbTYJthaiLRfNJ1XtM?=
 =?us-ascii?Q?WuB6Nkrs5NMh1oKPy1MRtiixBQ5FSKJUq4UOYB4FXreyt8WyGEBhVWhHXRW2?=
 =?us-ascii?Q?dZt7ru4YKM7gXSkNz7KGUfXto17fcO77B/eVlroFiPurvdsOsoCT45V/vEm5?=
 =?us-ascii?Q?mt0VBYVIRKsRLOrjxynB0hP83nC3issWs7n+qm96+QkUGzlYCX5rShCU/9AG?=
 =?us-ascii?Q?98/txvXCM63krqiQvawY2ypNOcylmDHEyJmY0vhUBaDY/oN9f4at7MJqK6RR?=
 =?us-ascii?Q?7SuJ1O2Ejqk1M4wlsoXkKIYu5Hane2fouRvV5goFVKx9QbxyVUHHPbTW/zoj?=
 =?us-ascii?Q?eEo+kHuy2ZxbOTk1Us7fBoL6LTFz25un67nuH9UjJZceu7Z5FXZunchQYMa3?=
 =?us-ascii?Q?aFCLOOglD6Osv1Fs8Dpt1tmE29Ol3s1zSdsQU/XHZrnp5C/v4tdkMY0mp2wu?=
 =?us-ascii?Q?dQyZbpy7CITnIFoGQdy+a5AIiMtFd0rCyXLrh4rVrwi1wZJuMUEppOVdyAUv?=
 =?us-ascii?Q?v/E6MKXdG/+kf3LC9+/nPNPH6XZlTNA6H9hJBcljLwjayFAsP22te9/Z0Duj?=
 =?us-ascii?Q?Ual0Lzk11aZgysu5CRZ+wIRtsiPvzFGK0Hr7RCmjxXQLvnAqqWwoBHpyyD2S?=
 =?us-ascii?Q?ZliDdEDFsdMLAZGfTfU5IncYw/yTGhAG4DyHDu2XNYf3D6y5HEjuxb2lsqd3?=
 =?us-ascii?Q?1zLZ37AAVWuhLxmapddGXeeCS0VfzflYuJ6cz/viA/EqE4EC80kmGGIkTrIA?=
 =?us-ascii?Q?JUg3r1kbJEsi5hxmBz+JC9IQiN2S/C9OhrzCTaqLSmVk4gV8OXmCi5hSxtDK?=
 =?us-ascii?Q?KytiqUjblG3Som1CCjF9N7oGCm31hmoWTnvIhxB0s0CmrNyudyD4YGSfJybV?=
 =?us-ascii?Q?/cux62g0I+X4JlFFVgYx8iUBEugD75KBjaEn5+w9B64r1vkUEYaQ6/NkNDOd?=
 =?us-ascii?Q?Oaj+zDevq7o2zj48MAc4+OZU8b2x7X/bN0cNv11GYbWGIcqkHc80swVf1GwB?=
 =?us-ascii?Q?KUSSwy77EilUni50FZUqk9js8PWFMcCEwaj/lYI2AswgadA073tpsiJ5HDGk?=
 =?us-ascii?Q?fnuQUtuPYbV0o/l+guXwR6uLc8SBR+0nf12nqYQfgxhT6yU3KOdBxOZ3nlY6?=
 =?us-ascii?Q?bCQqOoCYyBwjy+z/y5514m9U3jOfHhBwVREG/qVngUuzthogzA+AO4nG+HtB?=
 =?us-ascii?Q?1Dg1DYcf9iv2rRdqTCGP1cDC5H8MGq/QXEi1iM9D4Sc0brWdlWu01sdt7PTK?=
 =?us-ascii?Q?mHCiqOVKGFOE0x/wZUBKN2aEnYwPoPe/9X8Sjsu8CJebJq/uRrp+AujNmrud?=
 =?us-ascii?Q?acrpOdOlI1LyoMrp+SoEsbqystrce0mH68aP1k9s2XNiphg8pfSBLVEcqqwr?=
 =?us-ascii?Q?OoR2HDWhOg9vsXoWGNsoLcW1dMNE01abGDrBFQlPanouoBbaDL+u1SJQB0wc?=
 =?us-ascii?Q?Gu5hK4+gH9CeHAeNEnc5gQQxY8vGTIQDLu40UYT0r7yShDxWEA8Tlob85bNM?=
 =?us-ascii?Q?n9ajEbV5aD93Vld6HTaVFaNfENtxTa91lf1bzGuX49yb5t7Iaxvr4zd+Zxjp?=
 =?us-ascii?Q?QRgh2F/9xyLAXCNZt5V44G/KegEEvpfnAO/7n0ACt6Orow08/+eAS924WkQ1?=
 =?us-ascii?Q?gOQUGoSeOUiThQbHsmlnosk0WiHSjzA=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbcdae3d-8fe7-4e04-1151-08da34c468f2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 09:39:00.6212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qy1BHD70YW5ShJDhvkIC+t/So0wuTXOSP6YIspk8fL0+ssNPuYGinN4b7omdIDw/zuontW9H0aNcJjyx4zXSX37WzIA4z2zWfTuat+qiVk0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4527
X-Proofpoint-GUID: DTxPE3eFHw7grRAReVoxVeOC4uE1guYO
X-Proofpoint-ORIG-GUID: DTxPE3eFHw7grRAReVoxVeOC4uE1guYO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_04,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=896 adultscore=0 priorityscore=1501 malwarescore=0
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

commit 3c3201f8c7bb77eb53b08a3ca8d9a4ddc500b4c0 upstream.

Like the previous fixes to hw_params and hw_free ioctl races, we need
to paper over the concurrent prepare ioctl calls against hw_params and
hw_free, too.

This patch implements the locking with the existing
runtime->buffer_mutex for prepare ioctls.  Unlike the previous case
for snd_pcm_hw_hw_params() and snd_pcm_hw_free(), snd_pcm_prepare() is
performed to the linked streams, hence the lock can't be applied
simply on the top.  For tracking the lock in each linked substream, we
modify snd_pcm_action_group() slightly and apply the buffer_mutex for
the case stream_lock=false (formerly there was no lock applied)
there.

Cc: <stable@vger.kernel.org>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20220322170720.3529-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[OP: backport to 4.14: adjusted context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 sound/core/pcm_native.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index b4ba16e31e5c..35613a52ce1f 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1046,15 +1046,17 @@ struct action_ops {
  */
 static int snd_pcm_action_group(const struct action_ops *ops,
 				struct snd_pcm_substream *substream,
-				int state, int do_lock)
+				int state, int stream_lock)
 {
 	struct snd_pcm_substream *s = NULL;
 	struct snd_pcm_substream *s1;
 	int res = 0, depth = 1;
 
 	snd_pcm_group_for_each_entry(s, substream) {
-		if (do_lock && s != substream) {
-			if (s->pcm->nonatomic)
+		if (s != substream) {
+			if (!stream_lock)
+				mutex_lock_nested(&s->runtime->buffer_mutex, depth);
+			else if (s->pcm->nonatomic)
 				mutex_lock_nested(&s->self_group.mutex, depth);
 			else
 				spin_lock_nested(&s->self_group.lock, depth);
@@ -1082,18 +1084,18 @@ static int snd_pcm_action_group(const struct action_ops *ops,
 		ops->post_action(s, state);
 	}
  _unlock:
-	if (do_lock) {
-		/* unlock streams */
-		snd_pcm_group_for_each_entry(s1, substream) {
-			if (s1 != substream) {
-				if (s1->pcm->nonatomic)
-					mutex_unlock(&s1->self_group.mutex);
-				else
-					spin_unlock(&s1->self_group.lock);
-			}
-			if (s1 == s)	/* end */
-				break;
+	/* unlock streams */
+	snd_pcm_group_for_each_entry(s1, substream) {
+		if (s1 != substream) {
+			if (!stream_lock)
+				mutex_unlock(&s1->runtime->buffer_mutex);
+			else if (s1->pcm->nonatomic)
+				mutex_unlock(&s1->self_group.mutex);
+			else
+				spin_unlock(&s1->self_group.lock);
 		}
+		if (s1 == s)	/* end */
+			break;
 	}
 	return res;
 }
@@ -1174,10 +1176,12 @@ static int snd_pcm_action_nonatomic(const struct action_ops *ops,
 	int res;
 
 	down_read(&snd_pcm_link_rwsem);
+	mutex_lock(&substream->runtime->buffer_mutex);
 	if (snd_pcm_stream_linked(substream))
 		res = snd_pcm_action_group(ops, substream, state, 0);
 	else
 		res = snd_pcm_action_single(ops, substream, state);
+	mutex_unlock(&substream->runtime->buffer_mutex);
 	up_read(&snd_pcm_link_rwsem);
 	return res;
 }
-- 
2.36.0

