Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3A45FD34D
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 04:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiJMCkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 22:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiJMCkD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 22:40:03 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2089.outbound.protection.outlook.com [40.107.117.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360B4422ED
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 19:40:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rp4fVp1WoMEoPWSh6hvlwxDoztVl/jFxsSVnk9pYSDUXvVyVRCqTBC4yE/0BDPjm4jAHD8FkP75yCi34ejKuP7hj8SvcxuIrD9iyEsGaKQIhbDu8KpEYh+Mcord89p3FpnsbwwpFYkEdhouHT1RvsnGOIbqFtKRgswXkqMwt9ESbYuX9bKkvt2T3CoEXP4tXi/wujcw9FXCgCiVEjbdVL3zCGn78+ojacNNMuUfP3yPfVOvsH7AhmGVv1ood2jjPcqoH6yEcQjiHZPVZFX6tUVGfSEx/3BETf9m5pkP6F7/V3gGtjWpGjRJEZPE9QvRSmM1rneVPRpe8gVrDUestcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=in+tJ8rNMtUiYGluPT0OsnNtdHjVYrllAZkSj62XMOg=;
 b=EwG9xAYrO5DX6u5bXCUn1WT7LX69R72H7TTNX4Ei4N5xvUMpHJ6N6SelL+B4/R7S3yfphE56vksgpPZV7fRU36qEw/Mf3uz/VIjQO5Ndr2vPUPiFCapd89G+l9G+Vp6QK0gYCm8x8d2RWilsq7PBQ7hvVnNfR4dylUqHzW6cjN4hDlU6GdDe+RAu6mSE3c2IPZ8BAUAeoRJn0pUyNUBw5wV4NHcQQN9rpE01sg62ICYH/jLqsOw10EVsVmGA7iZz2hDSVz0YmqhJ3iY19BpMr5l2+DXjmBtlAk9IjaN/yQfbIxierURo6S6siF684G3+LKHiOUMrzzgNqP07aZps4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=in+tJ8rNMtUiYGluPT0OsnNtdHjVYrllAZkSj62XMOg=;
 b=PCsCRk4Rj2EeH9VNcDOtrLE436kicxPfQPoZ4k3/nZ7xiVNhx5RrV/Y3Go4hGfvtCYXIjddNR2FjezozsSp07tqB02AuHY8iLa3M16ROizWBr+fRwwDjDHKyvongMnT+YTEJ1skzxA/XK7aMSIM+avdptERBSukgCxBrFYmrZtk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB6007.apcprd02.prod.outlook.com (2603:1096:101:7e::10)
 by TY0PR02MB5527.apcprd02.prod.outlook.com (2603:1096:400:1bd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.34; Thu, 13 Oct
 2022 02:39:59 +0000
Received: from SEZPR02MB6007.apcprd02.prod.outlook.com
 ([fe80::3402:acf8:13e7:9741]) by SEZPR02MB6007.apcprd02.prod.outlook.com
 ([fe80::3402:acf8:13e7:9741%7]) with mapi id 15.20.5709.015; Thu, 13 Oct 2022
 02:39:59 +0000
From:   lvgaofei <lvgaofei@oppo.com>
To:     stable@vger.kernel.org
Cc:     gregkh@google.com, jaegeuk@kernel.org, chao@kernel.org,
        drosen@google.com, linux-f2fs-devel@lists.sourceforge.net,
        lvgaofei <lvgaofei@oppo.com>,
        Hyeong-Jun Kim <hj514.kim@samsung.com>
Subject: [PATCH] Cherry picked from commit e3b49ea36802053f312013fd4ccb6e59920a9f76 [Please apply to 5.10-stable and 5.15-stable.]
Date:   Thu, 13 Oct 2022 10:39:34 +0800
Message-Id: <1665628774-388896-1-git-send-email-lvgaofei@oppo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: SI2PR02CA0026.apcprd02.prod.outlook.com
 (2603:1096:4:195::19) To SEZPR02MB6007.apcprd02.prod.outlook.com
 (2603:1096:101:7e::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB6007:EE_|TY0PR02MB5527:EE_
X-MS-Office365-Filtering-Correlation-Id: b3734058-fc71-46d3-4cd2-08daacc4387c
Content-Transfer-Encoding: quoted-printable
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tis22jC6wRfC7/g+Cn2S+EpY+a7geYT609+BeE64aPzp8q4SanpjB3R2FcQwNoLaTfMc+AVS+YKQe5kFW2DKMkBwyXq+mHhuqrL54x394DlzzOs6jTtTBVKgb6dBSsUi09i1+IbgO4fFj5JEcMKckqpnmNU5uubce7TmMY9I532EStsbp+9aegYozwvOHiNeDC/3JbD/acsMt/D/jYVczONo6zozK9F8eocMvIf5nV2FKmqj9mZchN/WN57Dph+YuZLtosY3mxZD5p+CAUdmXmyLj29/pcRa488KfmLpms/p2KhOaJalCmuhmJvi61N74VRH+osMQoN1l+r/8uPRsHukD62lU+8TNJBrt5qofi70cw1ujsTmzlFHJPCnSUTd6lGiDnbm+vWrdfZh7r5PYc+N3/bVS3W8wssoj0uvodpLLSCmj9eRV0mGmVBRBCLKE1nMTb1ySNb7hf+rpX1Q7j1sB320s9znQo2wRW2Oe1n7VhxtvtPqvU41OMtACKT4Go7bwU0m56no8K1kjkMxmkl8T6Tj2BrhHxH+3Xp7Hb2DzroqU+e9+90zn1/mSXV2K/z/JOei8iE1c5KUxZTjmix1wsHPg7mPG9eayZ4TaT2IPenBE6+BNi4oNNreb+/ZGhettXLU7WNN3SxMBnZ9Y35m1HPZXybKlFycvcpS7qGZW4+maNpWRvXxPMrLN47B2FxXeajIJQdtQ6faQUm05kiqhzdcAR3xeXM32e3Z6L9oOIkqYrxj7ej7xDiIr7qt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB6007.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(451199015)(6916009)(316002)(2906002)(8936002)(54906003)(478600001)(6486002)(2616005)(36756003)(86362001)(38350700002)(38100700002)(8676002)(66556008)(83380400001)(4326008)(5660300002)(41300700001)(66476007)(66946007)(52116002)(6666004)(6512007)(6506007)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXRGRGx4blBFbThOQ2FmRW1tWUFRZE5PaFFLc0J6a2xZV2xWa1BiOTRWZXc0?=
 =?utf-8?B?SjdXVEJyVU9XSVhoM0hJNG9TR2YvK2tkOEZvTU82eUpqZFlsV09HaXZQdmFi?=
 =?utf-8?B?Y2VNdmRFN1dWckVFRFVWVG1xekMrRjAwTy9KL0RTYUY2SWRKc3NTa2lWK0Z6?=
 =?utf-8?B?V3grWmMwN0dmYU5nZDVMVmtxL0xDamRaMDN1MGdtT3lYU3ovbG1MUUsxSXV0?=
 =?utf-8?B?M0E0ZXVlMDd1TVpNc0x0a3EzU3ozM2I3YzNVdlNtQ1d3cFhNMDlIbnFFZkNP?=
 =?utf-8?B?S0E5dXFldk02WVVxSkpqZUhoK0thcWV5NlpuN1RrM3B6ekk5b1RnclB1dzhP?=
 =?utf-8?B?aXFNWFlaSEtvRmNaQlpNb21oYmdZSjBocFlWR21BejBXUjV1cFNoVkRsMUd5?=
 =?utf-8?B?NTNSdmVTZWtDb1hYSkhIb3AwWnhIQ25CUUJ2dGdZSXBhMC82N242bWkzbkUr?=
 =?utf-8?B?ejh0aVRZYllZb3NpN2F1ZG1uQWwvdEYvck5pdnA4aFZUenpoeU1tSEF6VU14?=
 =?utf-8?B?L1BuMmRtaGJuS0V5ZHg3Qm8zZmNGQU5oWVdFRVQxTytqYzlKVnVzcE9Sb0U4?=
 =?utf-8?B?RkR6TkltaTl2UjhaMFBQVjF1NDN4akdMNStxOS93VFI0V1NscnczN0RHemRC?=
 =?utf-8?B?RmE4dFdCOHVUdTJ3eXdrK2QySXFFTUcvZDhhTTZzYjNvRnZ5S28rZVliRExs?=
 =?utf-8?B?c05IN3R1S0hrVEZFR3lHeWNkV2xFV1h1T3k0VHJVbDd1NU9aNW5ZbGM0T0sw?=
 =?utf-8?B?Tm9tMFZlSkpwblJFVUsveFlsYlVTRmJCRVk0RUZiQ0JwK0pPTFAyRDF1ZHZB?=
 =?utf-8?B?ekpsRk1wTWVGTjJZc1o5R29pblJ3eWlIVk5LYTNkTDVTNUQvVkUzY2xINXJI?=
 =?utf-8?B?U2ZHVk41RXBxc3M1QUdaTFZwdmp2ZFFtcm0zcG50WERraVVFdjgwajZZRzZM?=
 =?utf-8?B?SjVvMzF3WlZnZ3dqTDQ1aE00cXVPNS9ZWXBZNkJlZmM5MnlZQUFNcDR3cnhW?=
 =?utf-8?B?Q00vVmVqMmo4VkZZczU5QTJNdnY4bjZ5ckhJY3IwWnNHMVJsTzl0RVUzaDMx?=
 =?utf-8?B?RFRxclJqb0c5NWF0b20vVHBsK1R4bXdFZXR4RldLV0tsdmNRTmhHOVBEV0s5?=
 =?utf-8?B?WkRFN2UzRDBPZVR5ZVU0Smx3NlRrRko0S3ErQ2JkVmNZdmxKK0JUWHNiQldw?=
 =?utf-8?B?dnNsYmM5aDBnVlNMRWc5T1V4ak15QVVGYWpOekZ1N2NQbzJQU2xmQVl4V1Ar?=
 =?utf-8?B?L1o4TWNFbzdhS2dXc3REWjhqNFB1eldpbE0xQzV6eHp5RXpjZG80a1owRnpj?=
 =?utf-8?B?Q3pZbjRpUjdFaWE3bUptWEFyZm9rUjFvbXdnRnlkRDNNTjJwTFY4dXZrUkxp?=
 =?utf-8?B?TDdZNUYxaTIyZnNlcEFEaW0rSDNMNGl3K3pYektWa29MZkE5VStxN2pzRmho?=
 =?utf-8?B?TDVJYjV3WmRnenlQU0FRVmFhcXprTm9sRFdGT0lhMVlkd0RxUkJHS3BxK2Y5?=
 =?utf-8?B?SnJQVlVNdExCa3pKcGJDV0RCbjFGVERqWmhVZXkwaE5YOGpsR0VIOTdrVHBz?=
 =?utf-8?B?ZzJja0RGWUxHNnM4MUhuZFA2RGZNVDB5UWgxYWUyV2xYbzE5SmxjdUtwK05n?=
 =?utf-8?B?VkFUbFBmUkVHaklTMUhoYnJKRjFRcFhWUm12MEJ2TU9oOEt4RUlkN2ZhbmtC?=
 =?utf-8?B?M0lzNkF0elpLa2ZkTTE5cjdPSUw0WFROWHFEaXk0TlJMQlQ3R1hKM3BHeUh5?=
 =?utf-8?B?SVZvUS9FeU5LOWZjSXdsTWx3K1loLzgrV3U4b2VzRlhKbmtKVDYxaFlNK2U5?=
 =?utf-8?B?UTdjTkJrTDRHYm02L3VKZHhYbjhsbU5RU0xrYW1JMFU5RXoyNktBR0x1dmJw?=
 =?utf-8?B?WWFDYloyQk9BajJXcUVXcUw4bm5hd3B1aGhpOGsxY2NySkcyVUdhOTZTdVhI?=
 =?utf-8?B?MTRhUXM4UTVKdzJJUE1Fa1VndWh3UWFQQmVhTXpnVk1oMVB0RHMyejNvWER6?=
 =?utf-8?B?VHZrVEU3QTRmeFhQTlB0VDl1aWxFaFZRMzloSWVMY1pxNGRzMUhsUmpkS0Zz?=
 =?utf-8?B?TFRtdDVGdG05TzlPUDN3bFFZblIwVHpxVkxTWDBqZG1MOG9NbmxGUVpDUkta?=
 =?utf-8?Q?Mxd9zUDdkR2bDAHhbrPHE1fXt?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3734058-fc71-46d3-4cd2-08daacc4387c
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB6007.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 02:39:59.0396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jH5ZQmBk9r8Sydbhdyq+9xqOlZLPf/ofDGrfPK3SW6PhjEe3O1xJEgGnUtARyp/YC4QI2JEqukZT4Sd1oQojNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR02MB5527
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

BACKPORT: f2fs: invalidate META_MAPPING before IPU/DIO write

Encrypted pages during GC are read and cached in META_MAPPING.
However, due to cached pages in META_MAPPING, there is an issue where
newly written pages are lost by IPU or DIO writes.

Thread A - f2fs_gc()            Thread B
/* phase 3 */
down_write(i_gc_rwsem)
ra_data_block()       ---- (a)
up_write(i_gc_rwsem)
                                f2fs_direct_IO() :
                                 - down_read(i_gc_rwsem)
                                 - __blockdev_direct_io()
                                 - get_data_block_dio_write()
                                 - f2fs_dio_submit_bio()  ---- (b)
                                 - up_read(i_gc_rwsem)
/* phase 4 */
down_write(i_gc_rwsem)
move_data_block()     ---- (c)
up_write(i_gc_rwsem)

(a) In phase 3 of f2fs_gc(), up-to-date page is read from storage and
    cached in META_MAPPING.
(b) In thread B, writing new data by IPU or DIO write on same blkaddr as
    read in (a). cached page in META_MAPPING become out-dated.
(c) In phase 4 of f2fs_gc(), out-dated page in META_MAPPING is copied to
    new blkaddr. In conclusion, the newly written data in (b) is lost.

To address this issue, invalidating pages in META_MAPPING before IPU or
DIO write.

Fixes: 6aa58d8ad20a ("f2fs: readahead encrypted block during GC")
Signed-off-by: Hyeong-Jun Kim <hj514.kim@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: lvgaofei <lvgaofei@oppo.com>
(cherry picked from commit e3b49ea36802053f312013fd4ccb6e59920a9f76)
---
 fs/f2fs/data.c    | 5 ++++-
 fs/f2fs/segment.c | 3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index b2016fd..994a09e 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1713,9 +1713,12 @@ int f2fs_map_blocks(struct inode *inode, struct f2fs=
_map_blocks *map,
 sync_out:

        /* for hardware encryption, but to avoid potential issue in future =
*/
-       if (flag =3D=3D F2FS_GET_BLOCK_DIO && map->m_flags & F2FS_MAP_MAPPE=
D)
+       if (flag =3D=3D F2FS_GET_BLOCK_DIO && map->m_flags & F2FS_MAP_MAPPE=
D) {
                f2fs_wait_on_block_writeback_range(inode,
                                                map->m_pblk, map->m_len);
+               invalidate_mapping_pages(META_MAPPING(sbi),
+                                               map->m_pblk, map->m_pblk);
+       }

        if (flag =3D=3D F2FS_GET_BLOCK_PRECACHE) {
                if (map->m_flags & F2FS_MAP_MAPPED) {
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 19224e7..8549332 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3547,6 +3547,9 @@ int f2fs_inplace_write_data(struct f2fs_io_info *fio)
                return -EFSCORRUPTED;
        }

+       invalidate_mapping_pages(META_MAPPING(sbi),
+                               fio->new_blkaddr, fio->new_blkaddr);
+
        stat_inc_inplace_blocks(fio->sbi);

        if (fio->bio && !(SM_I(sbi)->ipu_policy & (1 << F2FS_IPU_NOCACHE)))
--
2.7.4

________________________________
OPPO

=E6=9C=AC=E7=94=B5=E5=AD=90=E9=82=AE=E4=BB=B6=E5=8F=8A=E5=85=B6=E9=99=84=E4=
=BB=B6=E5=90=AB=E6=9C=89OPPO=E5=85=AC=E5=8F=B8=E7=9A=84=E4=BF=9D=E5=AF=86=
=E4=BF=A1=E6=81=AF=EF=BC=8C=E4=BB=85=E9=99=90=E4=BA=8E=E9=82=AE=E4=BB=B6=E6=
=8C=87=E6=98=8E=E7=9A=84=E6=94=B6=E4=BB=B6=E4=BA=BA=E4=BD=BF=E7=94=A8=EF=BC=
=88=E5=8C=85=E5=90=AB=E4=B8=AA=E4=BA=BA=E5=8F=8A=E7=BE=A4=E7=BB=84=EF=BC=89=
=E3=80=82=E7=A6=81=E6=AD=A2=E4=BB=BB=E4=BD=95=E4=BA=BA=E5=9C=A8=E6=9C=AA=E7=
=BB=8F=E6=8E=88=E6=9D=83=E7=9A=84=E6=83=85=E5=86=B5=E4=B8=8B=E4=BB=A5=E4=BB=
=BB=E4=BD=95=E5=BD=A2=E5=BC=8F=E4=BD=BF=E7=94=A8=E3=80=82=E5=A6=82=E6=9E=9C=
=E6=82=A8=E9=94=99=E6=94=B6=E4=BA=86=E6=9C=AC=E9=82=AE=E4=BB=B6=EF=BC=8C=E8=
=AF=B7=E7=AB=8B=E5=8D=B3=E4=BB=A5=E7=94=B5=E5=AD=90=E9=82=AE=E4=BB=B6=E9=80=
=9A=E7=9F=A5=E5=8F=91=E4=BB=B6=E4=BA=BA=E5=B9=B6=E5=88=A0=E9=99=A4=E6=9C=AC=
=E9=82=AE=E4=BB=B6=E5=8F=8A=E5=85=B6=E9=99=84=E4=BB=B6=E3=80=82

This e-mail and its attachments contain confidential information from OPPO,=
 which is intended only for the person or entity whose address is listed ab=
ove. Any use of the information contained herein in any way (including, but=
 not limited to, total or partial disclosure, reproduction, or disseminatio=
n) by persons other than the intended recipient(s) is prohibited. If you re=
ceive this e-mail in error, please notify the sender by phone or email imme=
diately and delete it!
