Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8398C38CF62
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 22:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhEUUzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 16:55:12 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52720 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229455AbhEUUzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 16:55:12 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14LKfmS2022923;
        Fri, 21 May 2021 20:53:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=/IMNQnzKUfPs3Ryq4n2hm7JpJ1waqXTSB9/b4lfyxVs=;
 b=Oqwv752bAQ13Ny63Y/Mb8tE3KRczYY4uh+tz9HwHukAhhODN5E+IRRHTidByUNm6lcJq
 9T16c3LerzdrIImFQZUl+xXWrlii/YOGbO8BV57WfqQVvZlVg/mYTHOyHNGhdbfr5sOr
 51em0wez7DupKPoa4ZO7ZNY7wOyhS7Z1+gQ2j/pRWNkEaxTMt+8M6oeSTarMgzSKTUlX
 3tCDhUJmo5OkQrzkBc8+oG0Y8Des8PKOULETz/rPiaoPvoDKYGKVbwZ9dieo44tG0xTj
 JL+6i2trx8d0RZP2bRz5RcbZ+pkOYNr2JOP4n1ah3BkqM4qusRUuyBqys4vYgULnKND7 Vg== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 38n3dg13n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 20:53:42 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14LKrgkY061285;
        Fri, 21 May 2021 20:53:42 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46])
        by aserp3020.oracle.com with ESMTP id 38nry3sys8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 20:53:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i/Bfl9zk9z8wsfw80cyTNDvwQABHzQw6T1jvVoqaKtUpEA0teIZPXxn+zW7iEJp/LxmTtQp1gVih9SjmDNO5Vnwdl42dbyyZlGzAWZdVR6tsRpzMb9cS9CNGIq4soXNUZnDWxwQ01UzPAVSWlkN7EmQXqJKkFnzm2XJHKgegU8zaMjKzovox3aMOBK1P04TIotSX6w85fR5dGWpufyestRASx7Sq4NKIjMoeaMIVdiWdp16GhCcw5acEHmWBp0lQi5P0VcZdVN3ZYx4hxt9IhOvIIFM0HCvPDXjG0E8C4TH7hGdQ5HvdMQ0xCQhAq7tX/O9CQ1V3+7BCW/72zKB2eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IMNQnzKUfPs3Ryq4n2hm7JpJ1waqXTSB9/b4lfyxVs=;
 b=L/IiWuoF1dzuqm6UkZ+SPh/g0I5aOkrrH8f4Ul/UAb9kRHj8/g7modE+eRCeF/uJTZBIwiVi6NeWXURBTRSRi0supztIgfnESPknKa3G/ifbVISbY5je0D9Qcxwco5DgPENmDGO4QSTe+YRhhvCDQ7iKtJPdvKKOXkhmKrAbCdJsgVit7yraSObC/lU9FuUci+eXNKbmo0x7HFznKEYeQ35sicshPQuOzMLaVuU3g5yU8rv8ER32f5P3ZGA0SFTpuxRpXQS0Ej1d9kH+FnFoEtXOZNXSD4Z8p8AZeVjyvG5nSH72iml5b/SOck3LcBM+2C5SbThSYgfaER8TSQARlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IMNQnzKUfPs3Ryq4n2hm7JpJ1waqXTSB9/b4lfyxVs=;
 b=BhH5vAXouvbMYkm/8CAXHQcnKsLYdviet3yzD4wfJRhID9uE1Y1B3+KhCaOG8p/sKyWy3jkupu+jp+0CRYBFz7iHKBFHPmTXxAjOwt5XfY5nDqBcicEN0C/fm5ksI/4Mi839rhEvp4NXPptd+0uoplmzBEOZpV0mezJv1cKBTyQ=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from DM6PR10MB3851.namprd10.prod.outlook.com (2603:10b6:5:1fb::17)
 by DM6PR10MB4364.namprd10.prod.outlook.com (2603:10b6:5:223::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Fri, 21 May
 2021 20:53:40 +0000
Received: from DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6]) by DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6%7]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 20:53:40 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     george.kennedy@oracle.com, stable@vger.kernel.org, daniel@ffwll.ch,
        airlied@linux.ie, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, robdclark@gmail.com, sean@poorly.run,
        tomi.valkeinen@ti.com, vegard.nossum@oracle.com,
        dhaval.giani@oracle.com, dan.carpenter@oracle.com,
        dvyukov@google.com
Subject: [PATCH 5.4.y 2/2] drm/atomic-helper: reset vblank on crtc reset
Date:   Fri, 21 May 2021 15:53:20 -0500
Message-Id: <1621630400-22972-3-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1621630400-22972-1-git-send-email-george.kennedy@oracle.com>
References: <1621630400-22972-1-git-send-email-george.kennedy@oracle.com>
Content-Type: text/plain
X-Originating-IP: [209.17.40.39]
X-ClientProxiedBy: BYAPR07CA0078.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::19) To DM6PR10MB3851.namprd10.prod.outlook.com
 (2603:10b6:5:1fb::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-152-13-169.usdhcp.oraclecorp.com.com (209.17.40.39) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Fri, 21 May 2021 20:53:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b969c3b-2f5d-4dc4-015a-08d91c9a832a
X-MS-TrafficTypeDiagnostic: DM6PR10MB4364:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB436454907548AB03BCCD3FDAE6299@DM6PR10MB4364.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ilYbWR6inqHMW0lfHlY0C/5qDazSFtB6xgiFvSCAOtYGoP9A1BO7sta73UsXDgaqcA6m+md7/ItywB9GNabEqWphvFhernWB+HH6/A17H3zwu40HG/7ALYQw3BoXbAcvZopPMdNzqKvjsso7lhAvG5jPCYNyVNxZwh9CukakNrVUvXGhGo4tNt82wbQy93n/P2tKRZPoEs5cBzEfx8v5SU4gZTF/DsqniXiYovwwEgeuDEGrcXLJ4dMIxHFqqeG6Y5BW17ctpjqTgGAI5yrm82T4eHA1am3x/MEvhPbTrMBLcWOTUglDrHuN/ES0VAXtCKlfbk5LJF+/zvm/mVMo5Nt5F4x001GeyQ8owI4U3Y6yv8gRdVFffxjhXzh9Rw4ggcLiVdSdhMBngX6HB6Z0jWhdMPZeNcqaoFwRW7aBUUSus5/OUn5fvCktyBEP0iuQbBVxHaKi/CpYHGTFrlVCqBbY0AgE3ePA4iJvoPQ+8i+EOg1pU8QsNBK3gUJELEBwIFb8/ZN1FbQXAtBlO1KrIkkKxW7U2B8i2eDPTRSs2kSqNaa+ip5vd8n5n/qAWnaV3c75iUZ6fLk5lVkENemUXH46+/bCfXeZvsE8ZnRSgaxnjFx9i5JO+x7fPqebJTOgqPHj1moGX7UVp8TGElZ8wq+vUlSydaNm+vfnn/gdAwlpXKlIPEFneK3aefZzzNjDWXC8z4ytyUrOwEiBlAC/xeIrUd5lehWv7LTJGZ/82o55AkPgp59+MrBzu0PKAxdEELsYf9j3sVV63eJ4O1P/ZkvM7k+3TMdnyKIp97cUezs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3851.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(39860400002)(366004)(376002)(38350700002)(7416002)(6486002)(38100700002)(6512007)(6916009)(6506007)(83380400001)(36756003)(316002)(4326008)(44832011)(186003)(30864003)(6666004)(66556008)(66946007)(66476007)(2616005)(2906002)(16526019)(8676002)(966005)(8936002)(956004)(52116002)(5660300002)(86362001)(478600001)(26005)(99710200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?iX2JaVqq7uALoiGFo4Ys2Kw+hQw7bQvNJ/mtw0OcGpi3iSSbinlgw7MVzScF?=
 =?us-ascii?Q?drRXGhvsWsFZx7e2cjvt2OBvwawfkPOS/PTRdXwLGr3Qmi7J0aSNN1HjB5qk?=
 =?us-ascii?Q?Qls40pMs6B7vo0qpcQetawrfmsaRSsVI1n5hufvrT2DPBDdfZvnUSqCkRueF?=
 =?us-ascii?Q?VZ4GZCIr7mTZPjd6Whh4vzyiM6vOee8uT0RSWBt8dYIf/iZACUvM81G7+qAB?=
 =?us-ascii?Q?dni3Suih0xrCIhS8Ly3g0obgfPcDdxfddRemHqYVteyedhD2dSkLnBf3wFUA?=
 =?us-ascii?Q?36YkoitZsE1CtbAcszm7nBI/3+24E+YziL1S16MhDUzdX3NpBE96exUgtZrO?=
 =?us-ascii?Q?UgDR7fG6Wosb+PbtMTHsPrpsRzB4LzuR0vff5tNA5SHhabRsKJnSsIMJZgAD?=
 =?us-ascii?Q?C2yxsNtkhvE79LiYWnoHCHEZ9bqvbj0BIdPAek/2aZT/ehUUro9P0kyRyl6i?=
 =?us-ascii?Q?eXTMOPT1kD5nF2oMmUsF+/nr54juMwtWMwAH7M7CuizVWbav6oRNRc0EUKh6?=
 =?us-ascii?Q?ZUYIbiJVF0VZN1OngCHHBbmiA9ClQtH2q0jC56CXefFZa/dib/Ya4UkAnul6?=
 =?us-ascii?Q?haXyGxjMk5ceYTyaVAFEDf2uWGdljcfLOB2RwbGoosfggukWCmVytZ0pGiyi?=
 =?us-ascii?Q?Q9EXYSeuGrZXkUeOvI/0GxXD9B3hycxJFXu1P9yJc8EggsWEEaOzi7gYlhW9?=
 =?us-ascii?Q?Xv9FnopxGH+zUuFAniv4Lj4dBXuBv/WFDtwLulsqRUTjgXQ40TYkqAt4ebld?=
 =?us-ascii?Q?fBs/RtOxYsIdPvoF0+ieFZTvBkKdpo/KXP5FQxaMV7Cla4CT9wKn1YjrTiYV?=
 =?us-ascii?Q?3jTpUh3T0198tPweR7nLamE1N9bqDFE5BGOgPO6aEMi3S5WtIJHz53lciUOW?=
 =?us-ascii?Q?/caO9lCNKBeJhOGA2VdSdCcaGKuC6U73vw26LH16LluRy7EuqK6anO5twp9w?=
 =?us-ascii?Q?kPyfJZUjLChG2wqSAtMahrKNMFwFsNUIeyTtovbwz+9EnQnVfcgLNAdt+LNf?=
 =?us-ascii?Q?t0T0MXHoflAwOdZi2/UlmQGQ3BKGvhSvW5Bc6B1+6MFWVQ70LIlv5vSVrNkR?=
 =?us-ascii?Q?zcYoALUy3UZlOcJFtTXZec7CTzkPkrri2CxVghRsaiEOEsXlnbpLJr7zUrNC?=
 =?us-ascii?Q?iVWl5TZ0EintboVdkF/7AApwXlO0n1fqmUKOqAIY8/65k6tQl6oO8e9pB+ji?=
 =?us-ascii?Q?NwK2NAhS4E/+AwhgBRT3ibu7qtpMMTTOz7xZceeb7FHxVdln7+LhyHXFsM2l?=
 =?us-ascii?Q?dyliYf7YFPa2YRoHDNtHPZNC+FCDP9r45zUmCiE/LirUKiDjwQHyDl9rnV3+?=
 =?us-ascii?Q?LRcAkPebKd34Kg+blbSK8TuS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b969c3b-2f5d-4dc4-015a-08d91c9a832a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3851.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 20:53:40.1744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V69nKAB48tcyxf/doEnHPO/zx2K2c9C0YMRwRULXcDhsRaaq2KfIOR1nKt0yb3Jsg877x4gIi5ayoQ9IoxjPyrdxfyqc/GxCeEzzVZBiP8s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4364
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210113
X-Proofpoint-ORIG-GUID: VCdv8o_D8oQBuUvyKLEI_TaoUSdfdPnK
X-Proofpoint-GUID: VCdv8o_D8oQBuUvyKLEI_TaoUSdfdPnK
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

Only when vblanks are supported ofc.

Some drivers do this already, but most unfortunately missed it. This
opens up bugs after driver load, before the crtc is enabled for the
first time. syzbot spotted this when loading vkms as a secondary
output. Given how many drivers are buggy it's best to solve this once
and for all in shared helper code.

Aside from moving the few existing calls to drm_crtc_vblank_reset into
helpers (i915 doesn't use helpers, so keeps its own) I think the
regression risk is minimal: atomic helpers already rely on drivers
calling drm_crtc_vblank_on/off correctly in their hooks when they
support vblanks. And driver that's failing to handle vblanks after
this is missing those calls already, and vblanks could only work by
accident when enabling a CRTC for the first time right after boot.

Big thanks to Tetsuo for helping track down what's going wrong here.

There's only a few drivers which already had the necessary call and
needed some updating:
- komeda, atmel and tidss also needed to be changed to call
  __drm_atomic_helper_crtc_reset() intead of open coding it
- tegra and msm even had it in the same place already, just code
  motion, and malidp already uses __drm_atomic_helper_crtc_reset().
- Laurent noticed that rcar-du and omap open-code their crtc reset and
  hence would actually be broken by this patch now. So fix them up by
  reusing the helpers, which brings the drm_crtc_vblank_reset() back.

Only call left is in i915, which doesn't use drm_mode_config_reset,
but has its own fastboot infrastructure. So that's the only case where
we actually want this in the driver still.

I've also reviewed all other drivers which set up vblank support with
drm_vblank_init. After the previous patch fixing mxsfb all atomic
drivers do call drm_crtc_vblank_on/off as they should, the remaining
drivers are either legacy kms or legacy dri1 drivers, so not affected
by this change to atomic helpers.

v2: Use the drm_dev_has_vblank() helper.

v3: Laurent pointed out that omap and rcar-du used drm_crtc_vblank_off
instead of drm_crtc_vblank_reset. Adjust them too.

v4: Laurent noticed that rcar-du and omap open-code their crtc reset
and hence would actually be broken by this patch now. So fix them up
by reusing the helpers, which brings the drm_crtc_vblank_reset() back.

v5: also mention rcar-du and ompadrm in the proper commit message
above (Laurent).

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Maxime Ripard <mripard@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://syzkaller.appspot.com/bug?id=0ba17d70d062b2595e1f061231474800f076c7cb
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: syzbot+0871b14ca2e2fb64f6e3@syzkaller.appspotmail.com
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: "James (Qian) Wang" <james.qian.wang@arm.com>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Mihail Atanassov <mihail.atanassov@arm.com>
Cc: Brian Starkey <brian.starkey@arm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Boris Brezillon <bbrezillon@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Jonathan Hunter <jonathanh@nvidia.com>
Cc: Jyri Sarha <jsarha@ti.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Brian Masney <masneyb@onstation.org>
Cc: Emil Velikov <emil.velikov@collabora.com>
Cc: zhengbin <zhengbin13@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-tegra@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-renesas-soc@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200612160056.2082681-1-daniel.vetter@ffwll.ch
(cherry picked from commit 51f644b40b4b794b28b982fdd5d0dd8ee63f9272)
Signed-off-by: George Kennedy <george.kennedy@oracle.com>

Conflicts:
	drivers/gpu/drm/tidss/tidss_crtc.c
	drivers/gpu/drm/tidss/tidss_kms.c
---
 drivers/gpu/drm/arm/display/komeda/komeda_crtc.c | 7 ++-----
 drivers/gpu/drm/arm/malidp_drv.c                 | 1 -
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c   | 7 ++-----
 drivers/gpu/drm/drm_atomic_state_helper.c        | 4 ++++
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c        | 2 --
 drivers/gpu/drm/omapdrm/omap_crtc.c              | 8 +++++---
 drivers/gpu/drm/omapdrm/omap_drv.c               | 4 ----
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c           | 6 +-----
 drivers/gpu/drm/tegra/dc.c                       | 1 -
 9 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c b/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c
index 52c4256..d301e55 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c
@@ -440,10 +440,8 @@ static void komeda_crtc_reset(struct drm_crtc *crtc)
 	crtc->state = NULL;
 
 	state = kzalloc(sizeof(*state), GFP_KERNEL);
-	if (state) {
-		crtc->state = &state->base;
-		crtc->state->crtc = crtc;
-	}
+	if (state)
+		__drm_atomic_helper_crtc_reset(crtc, &state->base);
 }
 
 static struct drm_crtc_state *
@@ -564,7 +562,6 @@ static int komeda_crtc_add(struct komeda_kms_dev *kms,
 		return err;
 
 	drm_crtc_helper_add(crtc, &komeda_crtc_helper_funcs);
-	drm_crtc_vblank_reset(crtc);
 
 	crtc->port = kcrtc->master->of_output_port;
 
diff --git a/drivers/gpu/drm/arm/malidp_drv.c b/drivers/gpu/drm/arm/malidp_drv.c
index 333b88a..566b183 100644
--- a/drivers/gpu/drm/arm/malidp_drv.c
+++ b/drivers/gpu/drm/arm/malidp_drv.c
@@ -865,7 +865,6 @@ static int malidp_bind(struct device *dev)
 	drm->irq_enabled = true;
 
 	ret = drm_vblank_init(drm, drm->mode_config.num_crtc);
-	drm_crtc_vblank_reset(&malidp->crtc);
 	if (ret < 0) {
 		DRM_ERROR("failed to initialise vblank\n");
 		goto vblank_fail;
diff --git a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
index 1098513..ce246b9 100644
--- a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
@@ -411,10 +411,8 @@ static void atmel_hlcdc_crtc_reset(struct drm_crtc *crtc)
 	}
 
 	state = kzalloc(sizeof(*state), GFP_KERNEL);
-	if (state) {
-		crtc->state = &state->base;
-		crtc->state->crtc = crtc;
-	}
+	if (state)
+		__drm_atomic_helper_crtc_reset(crtc, &state->base);
 }
 
 static struct drm_crtc_state *
@@ -528,7 +526,6 @@ int atmel_hlcdc_crtc_create(struct drm_device *dev)
 	}
 
 	drm_crtc_helper_add(&crtc->base, &lcdc_crtc_helper_funcs);
-	drm_crtc_vblank_reset(&crtc->base);
 
 	drm_mode_crtc_set_gamma_size(&crtc->base, ATMEL_HLCDC_CLUT_SIZE);
 	drm_crtc_enable_color_mgmt(&crtc->base, 0, false,
diff --git a/drivers/gpu/drm/drm_atomic_state_helper.c b/drivers/gpu/drm/drm_atomic_state_helper.c
index d0a937f..9c16936 100644
--- a/drivers/gpu/drm/drm_atomic_state_helper.c
+++ b/drivers/gpu/drm/drm_atomic_state_helper.c
@@ -31,6 +31,7 @@
 #include <drm/drm_device.h>
 #include <drm/drm_plane.h>
 #include <drm/drm_print.h>
+#include <drm/drm_vblank.h>
 #include <drm/drm_writeback.h>
 
 #include <linux/slab.h>
@@ -76,6 +77,9 @@
 	if (crtc_state)
 		crtc_state->crtc = crtc;
 
+	if (drm_dev_has_vblank(crtc->dev))
+		drm_crtc_vblank_reset(crtc);
+
 	crtc->state = crtc_state;
 }
 EXPORT_SYMBOL(__drm_atomic_helper_crtc_reset);
diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
index 3951468..dbfd113 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
@@ -1043,8 +1043,6 @@ static void mdp5_crtc_reset(struct drm_crtc *crtc)
 		mdp5_crtc_destroy_state(crtc, crtc->state);
 
 	__drm_atomic_helper_crtc_reset(crtc, &mdp5_cstate->base);
-
-	drm_crtc_vblank_reset(crtc);
 }
 
 static const struct drm_crtc_funcs mdp5_crtc_funcs = {
diff --git a/drivers/gpu/drm/omapdrm/omap_crtc.c b/drivers/gpu/drm/omapdrm/omap_crtc.c
index f5e1880..cfeb424 100644
--- a/drivers/gpu/drm/omapdrm/omap_crtc.c
+++ b/drivers/gpu/drm/omapdrm/omap_crtc.c
@@ -698,14 +698,16 @@ static int omap_crtc_atomic_get_property(struct drm_crtc *crtc,
 
 static void omap_crtc_reset(struct drm_crtc *crtc)
 {
+	struct omap_crtc_state *state;
+
 	if (crtc->state)
 		__drm_atomic_helper_crtc_destroy_state(crtc->state);
 
 	kfree(crtc->state);
-	crtc->state = kzalloc(sizeof(struct omap_crtc_state), GFP_KERNEL);
 
-	if (crtc->state)
-		crtc->state->crtc = crtc;
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (state)
+		__drm_atomic_helper_crtc_reset(crtc, &state->base);
 }
 
 static struct drm_crtc_state *
diff --git a/drivers/gpu/drm/omapdrm/omap_drv.c b/drivers/gpu/drm/omapdrm/omap_drv.c
index 2983c00..672b0d3 100644
--- a/drivers/gpu/drm/omapdrm/omap_drv.c
+++ b/drivers/gpu/drm/omapdrm/omap_drv.c
@@ -557,7 +557,6 @@ static int omapdrm_init(struct omap_drm_private *priv, struct device *dev)
 {
 	const struct soc_device_attribute *soc;
 	struct drm_device *ddev;
-	unsigned int i;
 	int ret;
 
 	DBG("%s", dev_name(dev));
@@ -604,9 +603,6 @@ static int omapdrm_init(struct omap_drm_private *priv, struct device *dev)
 		goto err_cleanup_modeset;
 	}
 
-	for (i = 0; i < priv->num_pipes; i++)
-		drm_crtc_vblank_off(priv->pipes[i].crtc);
-
 	omap_fbdev_init(ddev);
 
 	drm_kms_helper_poll_init(ddev);
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index 2da46e3..6d0280c 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -910,8 +910,7 @@ static void rcar_du_crtc_reset(struct drm_crtc *crtc)
 	state->crc.source = VSP1_DU_CRC_NONE;
 	state->crc.index = 0;
 
-	crtc->state = &state->state;
-	crtc->state->crtc = crtc;
+	__drm_atomic_helper_crtc_reset(crtc, &state->state);
 }
 
 static int rcar_du_crtc_enable_vblank(struct drm_crtc *crtc)
@@ -1196,9 +1195,6 @@ int rcar_du_crtc_create(struct rcar_du_group *rgrp, unsigned int swindex,
 
 	drm_crtc_helper_add(crtc, &crtc_helper_funcs);
 
-	/* Start with vertical blanking interrupt reporting disabled. */
-	drm_crtc_vblank_off(crtc);
-
 	/* Register the interrupt handler. */
 	if (rcar_du_has(rcdu, RCAR_DU_FEATURE_CRTC_IRQ_CLOCK)) {
 		/* The IRQ's are associated with the CRTC (sw)index. */
diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 617cbe4..75c7068 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -1166,7 +1166,6 @@ static void tegra_crtc_reset(struct drm_crtc *crtc)
 		tegra_crtc_atomic_destroy_state(crtc, crtc->state);
 
 	__drm_atomic_helper_crtc_reset(crtc, &state->base);
-	drm_crtc_vblank_reset(crtc);
 }
 
 static struct drm_crtc_state *
-- 
1.8.3.1

