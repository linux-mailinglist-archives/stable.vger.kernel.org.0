Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A83E525CBD
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 10:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378001AbiEMIBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 04:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353020AbiEMIBA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 04:01:00 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECBC17054
        for <stable@vger.kernel.org>; Fri, 13 May 2022 01:00:58 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24D7kSO2030554;
        Fri, 13 May 2022 01:00:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=rs9lnBVcwYfyA1gJXC0lZK+MVjkvqdpjpU36AL421l8=;
 b=l8OuXYBuhMqTPnsWPN7HE/dLQ1SNCNH8l4+VTSnzY/TL6zPVehgN+6AUOtsfUrrAbOiX
 7VIRe7ivPwYf4G0G49gYvE65KSip9rgq0bvpWRWL90p0nvrQg5tQbXGhCR+aUxRUE3/Q
 SiIi3dmdU+9h9X5EFvY6ZGWEKcN1FNqHeUqvJUr1/CT+FAMB6wbAi3WeQYmGMd1Jk+c9
 dp3ZRsqdynRMy1Sp+a/aotw/9sk8f4LKZTxwZvq83Tze3M3ArJhR19ohizp1Zh3jQX+I
 LJCe49gbdwCj4nC0IO8CaENws9s3zE2HDDXJLuQy1z4CIpbHhvvTLdkW7BGUNSKkU3oe LA== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fxde5kx1k-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 01:00:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Brk1gS2wsBI4S6qPmtYHtVnSqPvvn+4b17U2d0m2sXdov1XtIZIM0q5Kfd6Hw16j4DalruDMoMmq7AsZWjtZa9Yzp0NP7mAAp0yA8Eve7PQipLKEnUAT7Xo0bckt5PsGMq/1AeydBe4bK8TrGNgQ5+/ubBGj5kYyKz2e5+j1A5xhKiGfMjNiNPsd0MShbI821Ogpfscn1uB9zJ520bsQd53TXKUhwywbMB26TPppI+qPFn+N0pRtI3PzrVapAfL0cFAgWI2hV1+dd7SbDhyk0naGjFQG/omeAEmmCLahqjJF1LhAv07xTHzqk6heYEO2lYo8F6vdQTZqNXq5ken+4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rs9lnBVcwYfyA1gJXC0lZK+MVjkvqdpjpU36AL421l8=;
 b=oHMjApR2bnsK0CyOPjd5UX99SDON87xrKL0XMsWZcE92tUVWlLQzYbjQd4RRrgrtz+bJIy6ORYbWAh7oROhYif2RqDQbP3A6ZfxEVDFD+1Sm/cjugswzb6xF/PtWt5iGNdVaU5SZfEXjMjt2WcyCI9mp+QjYdEe1SnUC6gbhNFoO8w6vA+Z4XJ1ZbxkgcknJRUXgzvcDN039ytL8m68ggfx5Ck8X+RlI1wQukn8xLFzKYPEPB5KvwAT9y09F+5Mo6XL4heDdlC9HPsyGzsVNsL3GsKpecJUcywK0h9aEPyi72ecsJLb1JZAa5JY0wMnN3Hp73iaaO18JuavEcvdJdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BYAPR11MB3175.namprd11.prod.outlook.com (2603:10b6:a03:7c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Fri, 13 May
 2022 08:00:40 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842%5]) with mapi id 15.20.5250.015; Fri, 13 May 2022
 08:00:40 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 2/5] ALSA: pcm: Fix races among concurrent read/write and buffer changes
Date:   Fri, 13 May 2022 11:00:15 +0300
Message-Id: <20220513080018.1302825-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220513080018.1302825-1-ovidiu.panait@windriver.com>
References: <20220513080018.1302825-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0104.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::33) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a3cc2f3-fe98-46cf-2c8a-08da34b6ac42
X-MS-TrafficTypeDiagnostic: BYAPR11MB3175:EE_
X-Microsoft-Antispam-PRVS: <BYAPR11MB3175509656FA7084A218F235FECA9@BYAPR11MB3175.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ysds9KHUzHwsZZrWUaeIS+7EKYPoqs35ItZ3oghM5es/bys0C7MS90gMbmgJHo7Z32KMrKnDW8ixOpyLi2z6YShA+VvqCBH6ImokZ8ISUg2MVWcZcw1BMW3gmubnR25PbJusZ+sow+f3QGIhsUDADc2LCdfV0HYb2sd7oCPdQhnGrUoOAqXDW9SzrraTmF20AkG+kM0Ws4Sat0ZenJinLMvE5GIs7RMe5P2TJ960Vd4XGNayW5DyoBSpOxKrbaQ5EmMqfuVUoZRQpm4JGdcxEbF4uJV8sk8Jl0hjDIUTAHyFulwNO0u8QORB0ij7UYM9KY68BsywPlFei0VcHZ16kEyZSq0P84UGX3l6IjO7lDHxGgeByxvQghYypJLZ/kWFqFveI5qknMOemmkVuoPk2l/g1ERQgP/m3hgSSCvWtGoK+R5UU7GSUWla784ry16FKFISb14wXkGglW/sfu+0HrLTAXXPkTzWdqEB3sGJ3yk8ikAPSYHgwQmqsB1T19VX806WUdY1suQvIJ4DcebaxkUhjw9b2vh5i2ApyhfJ4gmyFsOffDkDBtAkhy2haVzWp3UsTFaBPXqhcrITi6CrDP3atOMVxiXwdv7yCSyoRFPOBcZdcuyZc0UeJSxOj5w6vM7N1Lbl1MHhOQiDY6qRnITCOtMbVbo2XOanYFFme3sLgksIY9OlsQfogBI8mt5BosVrGbQVl+g8c6Q/w6Zb9inb3c3EhcysMOy5d5Ip97eK3jMBnCSmUvpOidcIaAO7w7T/tyCvXvgfis0mQFPGBfAmr3TtuwDyl2iXdNfwuJI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(54906003)(2906002)(4326008)(83380400001)(8936002)(44832011)(5660300002)(66476007)(6916009)(66556008)(8676002)(316002)(36756003)(26005)(6512007)(6506007)(86362001)(2616005)(6486002)(966005)(508600001)(107886003)(186003)(1076003)(52116002)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2y7vYXUFBjYYvQJEEs/0D49zcEd+AeyjE1LUZgPInN5m23T36GJ45XADI2FE?=
 =?us-ascii?Q?MCMp2uIkMYRi+2shVnHbDxzC/5krbmMNT77kmxJtBGC1mdIs3jsIA1WrT16K?=
 =?us-ascii?Q?1M8U3BOANaRoITcWOJqUIjZsb/T0tpX5seX8QOQZlyb6oYWLxa8QoSvtVULA?=
 =?us-ascii?Q?ckEl9uGy4hKBMgZS3NWKkntrkz89OT5DEq7fElDsatbceRGk7huffiOU9NZ2?=
 =?us-ascii?Q?vzR0aPzAkiqtr6cmWY9wPHG9/cfPcVi1ZOoGcUq7lN3ewybGW8mMSUlKJCYw?=
 =?us-ascii?Q?4+YixStNvfm2sPMNAvKxV9WuF1L6l5F95VWc6E7uLO02UYfiFYtRw4WW/5L4?=
 =?us-ascii?Q?8YKZIdUahtaBzTOPlRhSewTcGrZB6wweDAUb7wncscAOSBHWeiRpggnElzkf?=
 =?us-ascii?Q?27kzQqNryjJKuhQJzJdbRsBejWPgupjRF/IPiuYwyy4MkM7jVqJCj3zbf8et?=
 =?us-ascii?Q?7acGEynZpoRWaQrOkykmnFnHDTMZLpJTKvZ2DeTvGuGR1IMwK8TKDZRzxlas?=
 =?us-ascii?Q?eecZxWn3RUgg5BOCEEqAFQeP9irlEE6y9W1KD70L+T3kDv7YFtCtvvsshh8m?=
 =?us-ascii?Q?WNfMCNSFH0G58e+zSx9vGX8kH+R57MDBmAXO+bICZrKOurPiWwNs5snq3mFM?=
 =?us-ascii?Q?KcLbUPrjxKnM9fevv/eE6CrnQqqBlhQY4/a/WwHujrdZHujjxmlnI7SvsOcC?=
 =?us-ascii?Q?oedpRYGiABmgirOSISVwfp+E/uA/zpaQh3xnmsosWfgTPHJkzPy2Qn4UncII?=
 =?us-ascii?Q?DMDFJ6OhEpugkE58sJelhxKKLXAU6VOELU5CArMVNpa6I1br81oOCIMyhbM0?=
 =?us-ascii?Q?vHYgpow7tUNo+JsP8EXniOqbDigOlEyfJTns9wXfdof8KB1wCIxT+geaN/gN?=
 =?us-ascii?Q?kRMfG2XAKEtaSV60XHV2dTEP39oNr8tiQMOS5R0CD+H+Y1am8YLYYJL4bc8F?=
 =?us-ascii?Q?DRDb1pqN+CaGj7rvWKxVL65XDsO3zDxqrBt049Hn1T9zJAvBlhM/oaTrh87f?=
 =?us-ascii?Q?G2hAaShsyn+ZsIwZh4GJ2EBA9G7qnysx/YrBH42qZ9blE3aBG5jazU2J12Xr?=
 =?us-ascii?Q?3Wv07OUiDIMphem6GSU4ZehprmNQVDAoYndTbh3xdHOVUkmUuxkuE2RqFKJ+?=
 =?us-ascii?Q?EjNXuPn0XYFq9/4dJ18pDvQX7ZcXcbW/i3N2/caz9qw8S///ttb/oBNIRdd5?=
 =?us-ascii?Q?eF+R+oUVdliUyVHGImCZxlpxo40TihRUsmTNwS20Qtwkq8clmQsISgDieBcL?=
 =?us-ascii?Q?I9N5x8fkqgNy2lI0e9F0z005XbjkE7d6IySZRqpwjPUsGhZfcYWqrz8fAbTB?=
 =?us-ascii?Q?PzGq0ykXHfxM+reC5I8P2sIPLUoxDoBMeN5HfgksQVIB7n+BlZ+ffjHPOb8s?=
 =?us-ascii?Q?xmhiBDlNgaVsHAZN2zc5rWOSWJ2DANxDm0HXUGyEwJU9YtI0G9JuH3GvSVSM?=
 =?us-ascii?Q?YJpme/oHGCLh0cr+931/7EPkMVoBF0YZL3CtRvJcziSMicRcGUst+9BTOvqD?=
 =?us-ascii?Q?KcAKG3Y3qY3+ZUwsWq5ha75YmO2J0KUsOgeXFslxQxf8+4tlAlQpiSFdiXc6?=
 =?us-ascii?Q?X3STPkSa4duOneiDksjkU/vKlRkyo5hg6ZJm5Yik+kkPsfvMiUJX9ewnmMSB?=
 =?us-ascii?Q?JqjpHSTVXJwnEcHBBvigaOc7c1W8dHjgDzz2hLZWMgg8Vy02BNz65FAZkcz9?=
 =?us-ascii?Q?QGcSCAzNA/8tso6NxkawmSYtAdnIwNkWt693rYyqJt+ntRd2Ojc4Ics9S7F0?=
 =?us-ascii?Q?dWJ3af+gxBy+TjnMcwMOPdt4lP7l8e4=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a3cc2f3-fe98-46cf-2c8a-08da34b6ac42
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 08:00:40.6631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gfWpEr8YVS00JTb/aPBRYYnOn3w/eEaFZCxxHGxCBfQsyvdcfExljEC4V9bFUhqEAKnzBsX/XWmbPTmhIZEwroEqrFpXa98+AJc1JsDdatQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3175
X-Proofpoint-GUID: Nga9uRGHyi4EXgkyvUeJGNFOjW_WXPbf
X-Proofpoint-ORIG-GUID: Nga9uRGHyi4EXgkyvUeJGNFOjW_WXPbf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_03,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxscore=0 malwarescore=0 clxscore=1015 bulkscore=0
 mlxlogscore=948 suspectscore=0 adultscore=0 impostorscore=0 spamscore=0
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
index da454eeee5c9..552c642ee53a 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1876,9 +1876,11 @@ static int wait_for_avail(struct snd_pcm_substream *substream,
 		if (avail >= runtime->twake)
 			break;
 		snd_pcm_stream_unlock_irq(substream);
+		mutex_unlock(&runtime->buffer_mutex);
 
 		tout = schedule_timeout(wait_time);
 
+		mutex_lock(&runtime->buffer_mutex);
 		snd_pcm_stream_lock_irq(substream);
 		set_current_state(TASK_INTERRUPTIBLE);
 		switch (runtime->status->state) {
@@ -2172,6 +2174,7 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 
 	nonblock = !!(substream->f_flags & O_NONBLOCK);
 
+	mutex_lock(&runtime->buffer_mutex);
 	snd_pcm_stream_lock_irq(substream);
 	err = pcm_accessible_state(runtime);
 	if (err < 0)
@@ -2254,6 +2257,7 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 	if (xfer > 0 && err >= 0)
 		snd_pcm_update_state(substream, runtime);
 	snd_pcm_stream_unlock_irq(substream);
+	mutex_unlock(&runtime->buffer_mutex);
 	return xfer > 0 ? (snd_pcm_sframes_t)xfer : err;
 }
 EXPORT_SYMBOL(__snd_pcm_lib_xfer);
-- 
2.36.0

