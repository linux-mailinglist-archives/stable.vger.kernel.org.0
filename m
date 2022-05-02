Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE4E516FD3
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 14:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbiEBM5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 08:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234995AbiEBM5q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 08:57:46 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2744AE0E5
        for <stable@vger.kernel.org>; Mon,  2 May 2022 05:54:17 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242CajNE004620;
        Mon, 2 May 2022 05:53:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=m/WtGlh1106Wf+ptOAlCL64gNxHuAD1FLfayxc26CRk=;
 b=BUZ+gohXId4S9rdFJc7vftmnfCECX4fIs4D/EKJiIIrplLsHkz+gLHV2khzB1qWl+9NR
 V6yv9tcUZYbYT7oAAHtoD0JkhPSYuX4eSRBXklHe21CdCr/nqXx1I604tJPtyS22rBPW
 PgytEPLBLwV7aDzZkKwtGk1hWuj1SJpleWeqf8qbI+Z9CghEgQFnB19XKddPizE+E75o
 hwg411wfwWY1PokJc3l7VDP3HkwscbUKO+x46gom3Dw2XEXnmWFihhYNbILc6B/uxFIz
 RfKQzUCLDXfZfFk0Xi/1Qpf4zrtlWdTwL1AcrqvRrfoEx5s6NAKx+6WyxO6Hm6ammRWq 2g== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fs0d399pv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 05:53:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNwSGTyzo1KIE1YvNl6Xb0t1NGBtmLRkx2BhbBthrRJ98AyF0vD1Ygi0B1hgN5avdzfPpMKhUvhSYTSC1W+SnDWH7jaQUw3dYAqkluEXDTejDubB3XIRLeY7aSYarWSp5ZWdAEJyfmnEd9rpZMOtRMJJVtuMHpXrh0UzFxeLUA0iHb1rRZbi8SFvWXw3jFAC3NkioOvAHstTtkRbgrU9vA43M1zAes+g7WqNGenovqGncyY7q8oJlGsWeXuse57nvI2ppfm4ogcaAF8hxp0CGgnqdm6wHdgr8Hb2eSjqvRwoNb1SHGQSjViQaqNOpHbXotJWXU9Qd+RHJZBaE1nf1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m/WtGlh1106Wf+ptOAlCL64gNxHuAD1FLfayxc26CRk=;
 b=ksiEhJUlUIjcc/y0+2jFmmaY0/nunofcki2kAtWzaeOvZOxsmLo7OSCc4dcUEf1DZJ1BXti5fBPeiV2E1bK6Grha/sM07yOrKewcLQGWqOqGX1LdCIxYqaiokurGX2gaqYvD7O2Bb1h6TOgjfKvUR9ibcTnQ4gfL+coZ2s+pNRRHtgnD7DjcJcgjqu+qwbU4nz3wQmHGCaLAG/Vx39u0+M9GsKiSQPkYXDDWm3sFqRqherhYVnbTSKW2mF75ypM0XgRGZ31b8l+2t6Qh8YznwbrER53j6duSyLDcokCU4MZnt0Qgl870J/47Tp6rk7hFkOwhbKAeK3zv7rQ7J05NwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB4548.namprd11.prod.outlook.com (2603:10b6:5:2ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14; Mon, 2 May
 2022 12:53:48 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34%7]) with mapi id 15.20.5186.028; Mon, 2 May 2022
 12:53:48 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Hillf Danton <hdanton@sina.com>,
        syzbot+0dc4444774d419e916c8@syzkaller.appspotmail.com,
        Emil Velikov <emil.velikov@collabora.com>,
        Sean Paul <seanpaul@chromium.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Eric Anholt <eric@anholt.net>, Sam Ravnborg <sam@ravnborg.org>,
        Rob Clark <robdclark@chromium.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 1/1] drm/vgem: Close use-after-free race in vgem_gem_create
Date:   Mon,  2 May 2022 15:53:04 +0300
Message-Id: <20220502125304.2285620-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0007.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::20) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33f9b9d8-75d5-4e99-56e2-08da2c3acc99
X-MS-TrafficTypeDiagnostic: DM6PR11MB4548:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB4548C0A7F22D9C759CE88667FEC19@DM6PR11MB4548.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aAAdw6c293jJOtd79dAP3AuToXMvGMzsGe5+PHirWOtuzpKDC4ju6UOY1x//79Ga3QoUrkk3zjTqRSSgHn3Epd6420N4WUz2/98pWVlfHg6l3gNOc8u2SyEtQOmM66ZZq61FS1+NSsbNx+jm/fEHM1yIag5TxuylpxeFafUgCUkvlEqGbk3DWwZAiGxBUjRHgHRnzG89RaLPuFzdIBu3Pdj2x8Gyo7EkGMi2lxyr34rHU/F1izcMm70V2Ap4wgbsRQh2R4/GwyrI7McADVCU8ZgtL8WjhbHXuC1Vkf8puMjaCxkH5AGnhhX6h/YBdxIUjIVn4kJ4iz0GJIA93RneOuoxoBFUS/vrhC3aYfzw+4PXeUXdYCTiobcWpjNXEEZwtPIzz10w/YXUfeN7tpPXFh07TMvWjeSJ4KK96i7qFvh2Lg8UtGb2vW/QGrWKgXGU9+WRYBhgBzyecGPS77oEgc8fNIo/KbzoxzAzk3uXlBUQazlqEoeKCoLmH3tr36cLcvUOvCt0HOSxu/vVJ2VnTdUXjm/f/mUGZ/v1MiPp5JZPrLT2wQIv/1sSW2DLIYgjEerHdxJWhkwsVN8jAtLLWl4oPvX1HQowSqgGZVEZudnryxMUNcD55FK9YfP9K4hEaaPRuzjwqOz7mLmcg477SxapCjvjUP/SDsdUqMc6rbG9hep7+97ugu4gFwOtaBT4EICn0pIcpqhpl4sR37Gb+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(66946007)(66556008)(8936002)(83380400001)(8676002)(6486002)(1076003)(26005)(186003)(6512007)(86362001)(2616005)(107886003)(966005)(44832011)(5660300002)(2906002)(7416002)(52116002)(6666004)(6506007)(38100700002)(38350700002)(316002)(36756003)(6916009)(54906003)(66476007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fnNS1Cy6OTrAHUNtvitRwoGARft7GNvo9vwNa0wRz4e5Yq+nCmWHdXaBGFUz?=
 =?us-ascii?Q?/49dXiuYUIqEB9XS8XkgxZr/3pdFTbQxtpE3tYEaXy3m6cGEsCc6AnBKXT6G?=
 =?us-ascii?Q?qoVXD3WqxJfQP9AzH9HLenPJ+IqQOJQjiLAH19FZyOmxDESqgCwTVcIIr0n0?=
 =?us-ascii?Q?vyjT/nXMCNRybPXN4aWxQpJbvmYNtjrB9v0ehgbPNTRY5FAnlQmd72H1WGjG?=
 =?us-ascii?Q?8KihlxOu9Vwu5kASG7AJgumzbNCEMupojJXED0EBfLfSB0VCt1vv7nCxdd17?=
 =?us-ascii?Q?M9ujAn6Q1CnD7pZXEDdbjieaux9tQQ3lmcyGMvl8ZHabOZixVXhUKSPmko0K?=
 =?us-ascii?Q?D2fci4CtrM+7+jnhG8CbfK9pDMsvuZwXfBQd2ivDHXv8i7nuJ6KDcTBNgqGs?=
 =?us-ascii?Q?nXR0gP1SPfXSern+gtYsaq7Hk/t149Y8+7maO3QyDtN1x4yjEI62LW48Q6a7?=
 =?us-ascii?Q?FNDsuQe2k0ib/kkUR5JXVXd9fRkW0SC3iPov1iGonjhkKIJSsNZ/RtgN9IGp?=
 =?us-ascii?Q?/4nAIN4UsMRl5XK7RQZ4GGnJ6BqbeosYXaNFt6CS0wTs7zoqPCtXHX6pI1Go?=
 =?us-ascii?Q?NOsfq6yF4g4lB1ct56J73de04zLwlE4Aj0MXpv/EqCkcE5IcMkN5CUrThtnR?=
 =?us-ascii?Q?pEp6tzbw0e4B0wq+sxBRf5zf2OcTTk9zEdovQ5ToDJijbYoWuzj0I7k+xt55?=
 =?us-ascii?Q?NxtVgu4MEedx55wwPm0VowEF/H7DLtBoJQglkegrKTFW9z9dTYh9xbe7Ipvg?=
 =?us-ascii?Q?wtI1/6zyd/qp8yAD5dls38Xn+aETKUV2U8k7Vil0/bOxMqHMqN/6GqP8SLu7?=
 =?us-ascii?Q?yH9S85WI4sdLj9Nu2/+IlkAe+QfjSoIaNDBV8PiBnbVF4BdX2Vz6ZfL3cKyL?=
 =?us-ascii?Q?DvWKpnWGpcTp3buOpX+8M3dsmSGpAWz1Q7Rxk8kBJf3C0J2XuNVcDupOics2?=
 =?us-ascii?Q?up16snq/LY1k5R7A8H7NAF7vvsdpw5/5a0/Y0al0RTlSaLAoEJyc2a1OUtnw?=
 =?us-ascii?Q?TP6Yn5BtgnuXQofEbKtJpY7WO7YcfYZsV1sqe1Mz+I04Iqkhcg1HER0mmTWl?=
 =?us-ascii?Q?vbTmsbdG4cOD559SBgK37sxqtW/KkdiQaDuj97yWlk9+CL7orTOGg2Sm/Snh?=
 =?us-ascii?Q?e+7ZXU/BXQE8PVcFW6pbBUnBWkg5FobjoiDqzPBp0OSfg5b6lQbQPcdqCrpL?=
 =?us-ascii?Q?t/2fSDxwyMKNjGjvXwIt4XC+RMkW3YotOU+AyOsEbtm6bsvC0Eyzx0NwiX91?=
 =?us-ascii?Q?9HDxvchkp5NgUfU3MjKIxRFkIgBDm/U23bNv9UV/rCaXnkAxDxddX5SEHAUB?=
 =?us-ascii?Q?TMD2EzMb3Dq/3OV0P8DHU9LQzAuHK8HAKJqKWxALTLwl0XYnOO8bxzi1fmPB?=
 =?us-ascii?Q?CSqugL7poP+xPKDJr1JZMBmsPT3gGdds4NvWeJp/p2tOrWCfdk2SMLeGxJXU?=
 =?us-ascii?Q?GsXDkOSEI229OewMS7WlKcANQmp1G2f8vmQKdCb3I+fuXNQvWsx3sY2TDWG+?=
 =?us-ascii?Q?Nfq/qnThYG7Q/KhKow2oXXZFQlmgNzPwsYG80i0QJOv+gpXzCXla1vUbmJvd?=
 =?us-ascii?Q?/zVB0V54GilwrcBeY8RF0a8GBDjpW4EvC3Z+XyizlG3vHrbi4jIdAwcw471r?=
 =?us-ascii?Q?ulAa4zHuVfn0anVlaeDaVc2sZDgNMy89H8U/xTrlrQiE5H3/sYW/Kh7uXlsG?=
 =?us-ascii?Q?2hZ3ynzCzwfJFvfktI5lxVkTqPzpkyMVWfMiFXkJi4QuE/cJuNywZSwg7OA0?=
 =?us-ascii?Q?IrGz5zjbTfrfSMd4557lAVJvD4F3140=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33f9b9d8-75d5-4e99-56e2-08da2c3acc99
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 12:53:48.0079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ayGXUEUub+6D7AQW3oCm9XT9rJrUxewM2/HvRTry3eUsTCtql3HZQEv2HOH5msaBIX3MrYA/c4yYZS8VDw7+YFQtT8NqNB3phVqmXPEAO5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4548
X-Proofpoint-GUID: 8BF8dojUjNNDfd-WyD2mU88EYcVW0Y6v
X-Proofpoint-ORIG-GUID: 8BF8dojUjNNDfd-WyD2mU88EYcVW0Y6v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_04,2022-05-02_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 suspectscore=0 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205020101
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 4b848f20eda5974020f043ca14bacf7a7e634fc8 upstream.

There's two references floating around here (for the object reference,
not the handle_count reference, that's a different thing):

- The temporary reference held by vgem_gem_create, acquired by
  creating the object and released by calling
  drm_gem_object_put_unlocked.

- The reference held by the object handle, created by
  drm_gem_handle_create. This one generally outlives the function,
  except if a 2nd thread races with a GEM_CLOSE ioctl call.

So usually everything is correct, except in that race case, where the
access to gem_object->size could be looking at freed data already.
Which again isn't a real problem (userspace shot its feet off already
with the race, we could return garbage), but maybe someone can exploit
this as an information leak.

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Hillf Danton <hdanton@sina.com>
Reported-by: syzbot+0dc4444774d419e916c8@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Cc: Emil Velikov <emil.velikov@collabora.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Eric Anholt <eric@anholt.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Rob Clark <robdclark@chromium.org>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200202132133.1891846-1-daniel.vetter@ffwll.ch
[OP: backport to 4.14: adjusted DRM_DEBUG() -> DRM_DEBUG_DRIVER()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/gpu/drm/vgem/vgem_drv.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/vgem/vgem_drv.c b/drivers/gpu/drm/vgem/vgem_drv.c
index 67037eb9a80e..a1f976270a89 100644
--- a/drivers/gpu/drm/vgem/vgem_drv.c
+++ b/drivers/gpu/drm/vgem/vgem_drv.c
@@ -190,9 +190,10 @@ static struct drm_gem_object *vgem_gem_create(struct drm_device *dev,
 		return ERR_CAST(obj);
 
 	ret = drm_gem_handle_create(file, &obj->base, handle);
-	drm_gem_object_put_unlocked(&obj->base);
-	if (ret)
+	if (ret) {
+		drm_gem_object_put_unlocked(&obj->base);
 		return ERR_PTR(ret);
+	}
 
 	return &obj->base;
 }
@@ -215,7 +216,9 @@ static int vgem_gem_dumb_create(struct drm_file *file, struct drm_device *dev,
 	args->size = gem_object->size;
 	args->pitch = pitch;
 
-	DRM_DEBUG_DRIVER("Created object of size %lld\n", size);
+	drm_gem_object_put_unlocked(gem_object);
+
+	DRM_DEBUG_DRIVER("Created object of size %llu\n", args->size);
 
 	return 0;
 }
-- 
2.36.0

