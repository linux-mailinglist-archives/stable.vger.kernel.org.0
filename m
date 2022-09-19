Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2FF5BD60E
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 23:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiISVDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 17:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiISVDh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 17:03:37 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF474B48C
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 14:03:36 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28JKS8EB017279;
        Mon, 19 Sep 2022 21:03:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=KsFtA2qIWe1sfE2HXFuazsAi58lb+/W4s1nPPB3eLG8=;
 b=JF8HeLtAgXBQAezool68u6n+b3o7VyfFw9Gvaqi4P4M35r0+rmcSiz+cA6vybngIt+Fl
 ogVkolB+rqOlnaUdKRu25eVGjsAkfwkYUOflTqVGSbS+/+CCy5cUKtvjN+EoOJmlnPOe
 2zD5PY3KsM5OOBVl+8iP9rcPND0ErKZ8CenaSeFQUnH/Seogd7E+zkCA9Hw/9zv5pxO0
 U2uqg3j60X5XvG+BhCHTm1YqvEuV/l/+VnpIsjYamUBjbE1hhS4QBfsAKcqc7veqBgVe
 rlL8IfSDIzzA93NtFhuNb1F1zxpaQk9aNnrpvteEi1LOu1z1Bs5dNHx8Osakum9utOk6 8A== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3jn57a1yku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Sep 2022 21:03:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S97hvcxM9eghTF+JniuhO/VG21W03bG7ZdU0ilRi2Em8GX0c1U0evwVgAr09ZJR++xhjDxReRK/ua5y+LFdcb8dK48VPpj2/2quXCiQ4UzjHWB9kC4G/HdP2rP9hOjDw61Ft5FVXbfFj3F9F0M5FXGsIw0sw0RX6TEw4QI6Qz5TTuciu5LCUaAvFXnfb2Cn3Y3XGtmp/fjOVtc0dlWXfyKYAwg/Z2QulUjmWOTw3ydM/uDMoi77YDYxw8/DoMgOSXxtf6EfTIb9/gkn0T46ZUhaP/ENzUTFjJ81Hw9tajWv7kbK7N6z0Numgyw+rdYoYygjAPal6WB9z8kn7YTurrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KsFtA2qIWe1sfE2HXFuazsAi58lb+/W4s1nPPB3eLG8=;
 b=aUiQ8bVhVwLcalV5nlaTbeePY9MXgtHsw/OeqLvnVnw7eq/pzoCBFl4PG4sK2QwFevBWqekucHoee/AbYYG4WGh1YidbjZF1fdy2o348Q8KoT/m2xVQ+AFw+EOuz0AjqIxNI6tK0/PXTAcQOqR63MzRq6kGsLiNbQApMEi8pOdyP9L7U8U1O1jVm+s5nfUzZBAyTra7kAbTOaifWIspLjBtSkRWC51BeKgGcB8MTYGKR0FLh/zK9L6Nfr/sJ7hUq3MCIgjSNc2u5urkz2m/svZvEzVKt4Fb/YhvkfRUbsOmebiNUuS5bxAmtmBRTzjsX9zwz7v+xeOQ6QM+FBgU+QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by DM6PR11MB4515.namprd11.prod.outlook.com (2603:10b6:5:2a9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Mon, 19 Sep
 2022 21:03:29 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::b1f3:22ad:609f:35ea]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::b1f3:22ad:609f:35ea%9]) with mapi id 15.20.5632.021; Mon, 19 Sep 2022
 21:03:29 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>, Helge Deller <deller@gmx.de>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.10 1/1] video: fbdev: i740fb: Error out if 'pixclock' equals zero
Date:   Tue, 20 Sep 2022 00:03:02 +0300
Message-Id: <20220919210302.29792-1-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0023.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:15::10) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4989:EE_|DM6PR11MB4515:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cb987f1-0e40-4b7b-4b2e-08da9a8266f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cAv383TmVPizzyfKCZiPpR62EW3wlTCMZprNpA/Vhl2AFgdxoo4ZSc8l1htguCmDftsEs5C8PKzVhF2VGakPOaIhqu6AxPGKHeuQWhhN8ugdUX9hedVP7vgbWPhuFl+e0QL8mbKusczJClcSK/6ptXcEfEnZ9q8etJy4axp4ce2IilwEF10UGcLq7Xgp7vWFXfbvxcUnttQ89yK7etGo2sBLxggOLiaFCxPu1mzFdMibPv+R/1k01ofL7sTYBAwulDEs04UlyhLUSfrPIZiMcBpP9vmXKHi9V4JfLccxrYzWRJDPllYAP3wcy0AiVNmHAXcZMQCi3F/d0kgCH+wTg6tgmwGWT/XK/tCYyJgZ4vQWRHQt67+l6KZIZAjj5NeD/9v9iTf5PP7OpTyEPQa7EoJajkiMFfrLZ4lIXOd+Gah9rDdP+Xoerq06WtBrO1YFUd7MCMzmtnu/BBT4DK4RkqsxZ96/hqXaaMP/e7FgJoLFxd8Y540CCWvsHiQoAve3vL9SHpo9LX5i9vPe5xABYtofNk9E+/jH26qxBJB3QqOCEKjnpXWJ2W8N1MlQi3D8BdVTSUQ0UJyybcSQR3ULOGM6PVZgq4psvOFoDPJYKVcFxy5Jdu3gotkHZ4owkHcAFDM1rvqP96xkKxQWylMCTn2XP9fjzKR7S9sO+cywCdZr/odjeGP7tqFk+oe8gsOvWrkQmKdBeoZFijcgtscr8cYoLvgQ9FyGjxcZHoGzxss3z8TAUHB6ApIMO7de/60DgxaTrUQ5Xkzvs/7sbf/rQ6ZmPpqhLltAamhuHbyeykkOmKMtkZ1vqMKUvY/7dwya
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(396003)(39850400004)(136003)(366004)(451199015)(44832011)(36756003)(2906002)(316002)(38350700002)(38100700002)(8676002)(5660300002)(4326008)(66476007)(66556008)(66946007)(6916009)(54906003)(8936002)(86362001)(1076003)(186003)(478600001)(2616005)(6512007)(26005)(83380400001)(6506007)(6666004)(6486002)(41300700001)(52116002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?96BsWzSl7X3WvLYYSG6u3nlp7oF70RyesqTUyhvWdsajMM2/G3P+v7gY2HRd?=
 =?us-ascii?Q?lXrTnFSnvryr26te0RhisGKs3+9He3Cs62XhhX1sxu7YxA5c5FdJNTisMW8q?=
 =?us-ascii?Q?uNttXQ3ps1v+6D+/4HterGxuYk8rxEl6eUGHih0j49DHC6CP+lFhlFyNGlWh?=
 =?us-ascii?Q?h0/W2zZ8snWntGyRUb4Qd4EggI7oHb+StKugoBlOkIEn3xzKdsP/Rx6YrKXM?=
 =?us-ascii?Q?4Szz7vEG9Ln3I1RUVxBX5b6+wcse0AJguCbwqJeC2zk188oluzZdID/NliDh?=
 =?us-ascii?Q?ydNrgSEn+eNRWpXXU3/d5Xq6rTi2bO3jqACmj0Jmdvjqumps4vdSQgHDfRoY?=
 =?us-ascii?Q?cQWklf/66553k+u5SoyOGUHWaNLkoENwVio8hDLZ9Lu/bZ2xGUYH6UCOHvpa?=
 =?us-ascii?Q?3QdMyhkX1krc8JxPyLq6hGavQpPRhDMZD4NlqZWoT7mCEhLQ3wxtno7rtcSd?=
 =?us-ascii?Q?JDl1O7U568VbG2Y2V18r60vWVeFW7v/ZV3cRdZ9L958uuVS6xpo/sQy/vnVR?=
 =?us-ascii?Q?OlgYXYFR/m/B3/AxIFvFAnb6aGb4+tAgoy8QdVFdu6vSpTQGxmUxIlhdtcI7?=
 =?us-ascii?Q?whJnaLR54RtLuVxxnIGROGcnj2FHme/JxG6OLXzCeC/6otlwX893tSV8CnY3?=
 =?us-ascii?Q?kyFHlNTzS2eu9TdUnSvbPSRaXaXTuqPxiKDagPC95RMgrFmSzzTXJgW2JC6O?=
 =?us-ascii?Q?gNsUXMnConwVoiwsMwimy175OatCWqiYi95+Zai5TmG0dgpW2dTLybvD8f/o?=
 =?us-ascii?Q?6uE0TUJU00tEIt1xb6ZSFcWIkbWLkQz0MmJ7ABrcngBgkCC0sJzouTB9wD7+?=
 =?us-ascii?Q?rLQsGXf0Qp36eNVc1lAmGOCc1Aj45VYCKdMBO3RpSdNEx5gI5ogdXMVwZci+?=
 =?us-ascii?Q?VmKBbq5zfM+kkWn6uSXeXoZEzvwutoMzXAHsyCXu8Lmd7AxLjQv8iAXj8bkr?=
 =?us-ascii?Q?N+LJWN1GoXQm++zNt2X4C+kc4OHw7SfUnc25RhmnWht73/WDOnfo4htFbtLu?=
 =?us-ascii?Q?9kd2omsHug0JhHCHY8sxzVgHl82FB6OOBhjQtU0tpF90VInQbKuLtlWQG4nd?=
 =?us-ascii?Q?rsO0/1cpoagyowuuGGODVZy+6yisiZiZlreu6ygoJZgOLssihgcndRFdkxdI?=
 =?us-ascii?Q?4Hl3aW0DPzGoptWlYUMIcMGHsS7RmiHgOudNcO+BTCHbAv2Rngwhz3wvhr5W?=
 =?us-ascii?Q?F0GBYKow3jSCqAF1bbS1iYTEkfL1LswQBCkdB12GhwvP094yr5L9N+6lrnKQ?=
 =?us-ascii?Q?hFoVFExyhD0IBXqYYLBjXQsdbvfezz3nwi4pB1ZYcOlYprzTIaYzld4YP9Xe?=
 =?us-ascii?Q?luj73vc7KFDv0WlIRnsTnZhFF8rxfIUBHY1uFAzhr28r/6F6/8C8/FD0zrJ3?=
 =?us-ascii?Q?iZoMYll6bTShR5SaAqCdIkVmJkAGs8L3u68KYkr0+Ll0X7uFEeKA9xD812QX?=
 =?us-ascii?Q?keb2vIprQWJGo8Ib/jrIRFevInxNguG55uJPIiJ/tngs9nzwV8GP9/zsi3Cq?=
 =?us-ascii?Q?feyd5mwYr7lIfEKSr5kK6f//0VgntnY+lfGOnWu/Xtq8I6uzep4gLbGHyRe/?=
 =?us-ascii?Q?RQDRIIsC0aP9CeZwz5SHDFdpCTnC4Whib59XUmeSv3fMj4vyQ8omlXj5p5Z4?=
 =?us-ascii?Q?Ug=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cb987f1-0e40-4b7b-4b2e-08da9a8266f9
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2022 21:03:29.2104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ZBAkstCyClYPk7mN0huaPTOWMPvzKG94+OhHl6A8gOhMJbw1Tvph75DPxP0KCJGAo2Zj5NUEYv/CSIQM4vHvJ4z1GIolfoHYYj9Dq7rVlI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4515
X-Proofpoint-ORIG-GUID: _8eW6C8PqvjnJWWzAsmBYZfYypWhJ6WS
X-Proofpoint-GUID: _8eW6C8PqvjnJWWzAsmBYZfYypWhJ6WS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-19_05,2022-09-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501 phishscore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209190141
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

commit 15cf0b82271b1823fb02ab8c377badba614d95d5 upstream

The userspace program could pass any values to the driver through
ioctl() interface. If the driver doesn't check the value of 'pixclock',
it may cause divide error.

Fix this by checking whether 'pixclock' is zero in the function
i740fb_check_var().

The following log reveals it:

divide error: 0000 [#1] PREEMPT SMP KASAN PTI
RIP: 0010:i740fb_decode_var drivers/video/fbdev/i740fb.c:444 [inline]
RIP: 0010:i740fb_set_par+0x272f/0x3bb0 drivers/video/fbdev/i740fb.c:739
Call Trace:
    fb_set_var+0x604/0xeb0 drivers/video/fbdev/core/fbmem.c:1036
    do_fb_ioctl+0x234/0x670 drivers/video/fbdev/core/fbmem.c:1112
    fb_ioctl+0xdd/0x130 drivers/video/fbdev/core/fbmem.c:1191
    vfs_ioctl fs/ioctl.c:51 [inline]
    __do_sys_ioctl fs/ioctl.c:874 [inline]

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
---
 drivers/video/fbdev/i740fb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/fbdev/i740fb.c b/drivers/video/fbdev/i740fb.c
index ad5ced4ef972..8fb4e01e1943 100644
--- a/drivers/video/fbdev/i740fb.c
+++ b/drivers/video/fbdev/i740fb.c
@@ -662,6 +662,9 @@ static int i740fb_decode_var(const struct fb_var_screeninfo *var,
 
 static int i740fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
+	if (!var->pixclock)
+		return -EINVAL;
+
 	switch (var->bits_per_pixel) {
 	case 8:
 		var->red.offset	= var->green.offset = var->blue.offset = 0;
-- 
2.37.3

