Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5F25FD4C9
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 08:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiJMG1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 02:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiJMG1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 02:27:13 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2076.outbound.protection.outlook.com [40.107.215.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8507D78B
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 23:27:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHPHeXxvN7l6tdTpt5N7uSNwTxcybHM5g5m3NDKduGUh+MAmcs+WO4+QBi78Dpyrw0m6FkQ8GFLaA54W2U/iFwCXe4bykKOAkHIe/C6CdGlBqdqrngCBEpboKFC/Bz8opSFBBYbHjyGkDX7Vsxv8m9IVkt7vp3Vi7XgRd0r1dzyTzlkxqc2aAnCwSIMDvomwEsyFoNl96JFJvXCxOcVZFLnO81fwf+6VnS3md27YFGmP6Rcojf2pyyGSzUzpwfEAUTY3T0HqK3d7eZDaepf2Nh/GPy3RefKqllHb612DKDMiJhSTksLVX+r8PPIJTZrNIMhUNZNS+HFguo18kAw9bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jWcVckSpl96miq62husfgjocEE10RFRaoC3fvY2CCS8=;
 b=mRJ6CYxH9MsEQg5TBEBd588+3M/wJ5XKmgcMed0IgoJJm1FuzKzrrjGWSa8GyUBB+tmr5oJFSIkIRXHgaUPgprA3vKupLEiI+hVa+Zvj2bGkAf1ORS5jBJOno5QINd1mlZWOgjPdtlKYLCV4kJESFQ3F5Uio+xp+UhlMOGyPLtec7yx0HyY6kiNQaTtezwWt7dxsU0dQgfe58jHc/pzcg6t2D9YtpEOLndgI/qNqVoomQOXNimxK1Y76r03RaAGLUp/LtHCN5QnDXhFFIQJn0q/iuSQr0pzMFvymRYqKp759YKSmEzYetDmCx8OQwAlhIglkct5KBQ1HlPBwyei/VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jWcVckSpl96miq62husfgjocEE10RFRaoC3fvY2CCS8=;
 b=GGgZKAKcvQ4W1n/9ePGYUvf/z+/79Djl1dQEJs0vK6n+QSIhWG5hH9UL/AQXBNgSfYDjUfG/gKavFsZGICBGqEsDWWWmfW93PtQpTP3ZsEpAR77DIQeX0zzAXSiQzKQXc4p8YWcwSZaaxVZjOkaDuXqkl6FAQJVlyKSe/ROFlZA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB6007.apcprd02.prod.outlook.com (2603:1096:101:7e::10)
 by KL1PR02MB4530.apcprd02.prod.outlook.com (2603:1096:820:41::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.22; Thu, 13 Oct
 2022 06:27:06 +0000
Received: from SEZPR02MB6007.apcprd02.prod.outlook.com
 ([fe80::3402:acf8:13e7:9741]) by SEZPR02MB6007.apcprd02.prod.outlook.com
 ([fe80::3402:acf8:13e7:9741%7]) with mapi id 15.20.5709.015; Thu, 13 Oct 2022
 06:27:06 +0000
From:   lvgaofei <lvgaofei@oppo.com>
To:     stable@vger.kernel.org
Cc:     gregkh@google.com, jaegeuk@kernel.org, chao@kernel.org,
        drosen@google.com, linux-f2fs-devel@lists.sourceforge.net,
        lvgaofei <lvgaofei@oppo.com>,
        Hyeong-Jun Kim <hj514.kim@samsung.com>
Subject: [f2fs-dev][PATCH 5.10 5.15]f2fs: invalidate META_MAPPING before IPU/DIO write
Date:   Thu, 13 Oct 2022 14:26:40 +0800
Message-Id: <1665642400-410526-1-git-send-email-lvgaofei@oppo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: SG2PR02CA0026.apcprd02.prod.outlook.com
 (2603:1096:3:18::14) To SEZPR02MB6007.apcprd02.prod.outlook.com
 (2603:1096:101:7e::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB6007:EE_|KL1PR02MB4530:EE_
X-MS-Office365-Filtering-Correlation-Id: 517053fa-913a-407c-af71-08daace3f33c
Content-Transfer-Encoding: quoted-printable
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PNrEHaARehvkLO3oDEfXR3AltyAu2M93wIyUM/upijW5ljPT38aKZfKkIQkt0xuZAYcismu0z+0nt6TgY/Wae+eA+PJBc1w6XOXKojzsfJ6sj5X800dLhGr3Ppk8EkPtexc5x18ld+ktBi8n+RMEF5ww7YT3MK7WhFAztAwiRyFoHVMONjfKCy+XueKw0P8CB+pxApfOkBG5RhWmVqRlhlgM2MeahzqZ/IyLuo93KMRHQbMAHT4R8hNoBOvCf2lsdj0nNC1U/PQy9RsijCBvJ2UfmE+Dv7koIgC1yEOiC/kuiQXzbcqWAjAs74Lo10LDPiRdFWDIN7T0j2PJGA5sbbTuCgqBl9UtJXRInUgqhGlmMzFZS9H6dIzV6jHlLrXuV+oO03RMfws7FC81RcsSrOhF2DmIYr7vnIV3hXzcq2kPArwLklVajIJGpWdIP3xt1Q2oq4Z/JGDWVqf3MkIEpnaBEcfxlAllGXn+DfnPkVgsxQK5u4lxcvWOYuJjudmOvGv6qHxEXe1mGIOU1Hslez1+jbEWuhCcNdiTP1FQ10PkssnqOK8ayU8vMEUsTfSSvkueyFqHkLh2Py41Zd4UyE2d2B2rcxCMxeWNV+rhc1jxrLuKsaqVaBBVQt3/I1FEnGZu152k9ZfM+FhFVNlTNIaOvSaJgTaLHQtnqRAd3+W0993ZRv/0A6XddAA1fHceBss5u6wwqDGnhyJdvLDNAmi6AiYTTk1H8DUQFzCGIZm3E8RotfSy9LEvu2OttZrQ+BO3KQmJ6NqF+tzewn0MYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB6007.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199015)(86362001)(2906002)(36756003)(6666004)(8936002)(5660300002)(2616005)(83380400001)(186003)(6916009)(54906003)(478600001)(6486002)(6512007)(26005)(66946007)(6506007)(52116002)(4326008)(66476007)(66556008)(8676002)(38100700002)(38350700002)(41300700001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXE0R3FJaWdBblhtV2Myb01xSjMzdVgzdlRON0pZV3NsdTkwTTJ5YjB6U1RK?=
 =?utf-8?B?Z01lRitNbEIzdlQyZ1pWV3BDVnFQYW1MY0Y1dkNTN0U0TnhvMzZWK2lYQXcy?=
 =?utf-8?B?ZG5EZ2poL3dtb0tyMmw4VkJTTHBKaGZsb3lxSzB5c1pwNDM5YTZwbkk2NTY5?=
 =?utf-8?B?a0IwNWdUcklBdThXaDlleDV4Z2U2Tjg5WWNjQ0wza1FKZUZaMUFNZ1F6bzho?=
 =?utf-8?B?MDBZa3ZJUTlWNlBSeFdKaHVaZUcraWxYdEYyRnM2b2NLSUF1NlhyMTJrcjlW?=
 =?utf-8?B?VUFIQ3I1blhKTTVOd1lvWFBNamVJRXVhL0tXQXlrSGlOK0VHY05IakRXN0tn?=
 =?utf-8?B?bU5Fd2lBY25SdElnMkU3MGVTSENmMlZQUmJmQXI4Vkd2VG9lWWRJU215cUFm?=
 =?utf-8?B?YUpnNFFJVWdVUzUxaDl5MER2VmZYRnZLS0lTKzhBTTF2Q2ZWWkVSU2VoamFu?=
 =?utf-8?B?Z3ZPMjFwYjBrTmRnNFZDZjEyT2kyS3FRUitGUnNNd3Jja1dSVHErRGc0ZGxT?=
 =?utf-8?B?dXBDVERoUGthRXhGemZzOExuVVlBQnVoYldodUVaUDdod3FhOS9WSHN5bE5p?=
 =?utf-8?B?cjdnTzhCMW9NZHpENGVpK0l6SVVlcXZacUFUREkzMTlNWmhkZGtHWURnYkdE?=
 =?utf-8?B?bTZnV2FqV3NJLzBqcDBlU3M5MjB3ejUwVlAreEdJZ3VYSXdMYnY2ckdnZ2NW?=
 =?utf-8?B?OWxnSFFlMGYrcStsc0J0NGpHZVBMSFUxeEtNUlZhaU1ydkg1RjNVMmRjUXNI?=
 =?utf-8?B?ZFN1RktmZkExd0hCcytFMFErd3lPZFJHQk1wcnVRd3N1OTBBRURxaUsvdjJP?=
 =?utf-8?B?V1I2V1I5Y2wvK25mSzE1OGFtclRrN0c0anVFWnJPWTBoVGRKRUJ6TW9SVkVk?=
 =?utf-8?B?TWRJc2dPUm5HbGZua29qaC94ekg0RVQ4TGkxaW1YbEduYXJubVJHTHpzSzBo?=
 =?utf-8?B?M0FvWnZxM0R2b0paTEVMQzVjTUJLciszU0taMk1UME9QYkJHTDAwS2dGcldF?=
 =?utf-8?B?ckNKTHpCS3cwWHBTa2EvclJGYnNveUVndkwzSExjTlRXTlNOQ3czcGtxdWRP?=
 =?utf-8?B?ZEhPczNzWjF6cEtoazg0elV3ODljK2cvb3IvaEZHSGpvbG5ZbzFDN0ZXdmQ1?=
 =?utf-8?B?Qkt1VDN3ZFZXeDRyTkFNNGpFYklWc0tlV3g1TnJZZVdYMVFoamc5SzRxL0Jy?=
 =?utf-8?B?OHZ4OTIvc0EwYVNFVDA2NG1wUXZsWXBYakVLYUwxNW9hQyticmVmdXNFNUtn?=
 =?utf-8?B?R0cvRFJvaFowYU9iRG5vcFBxUXR2ejE0VC90ejh4NjZtY2VzeGw4TXpVQVc4?=
 =?utf-8?B?YXVYb1Z0Qk9nZkxXR1NsVUcydmlHVUR5eDNnMDIxQXlnUFhxRlJoOTloaTV0?=
 =?utf-8?B?eVl2a2diOFVUeDdoY081TzdlNVhlS241QndibkpoYVpNOGRxRTBNNk4zWm84?=
 =?utf-8?B?Sm50T2E1MFB4YmNnWlZGWllhSFdBYUxMdGxha3lBeUZScFBBZyt3NkhmTXNk?=
 =?utf-8?B?L1BONVdYRWVXd2l2SXFvQjNteERMNlFzUDRjZEEvWC8vMnRvNXVjRDF1eHE1?=
 =?utf-8?B?QXNNRWxGZWxSNTJPMTlJTnoyZUp2UlAzeDN5YWlEaEc2YUhac3pTTENRS1lZ?=
 =?utf-8?B?ZWUzNVk4azRRUTk4NGluMjN0U2JIY2haWXJKa2R2TkVaLzV1QnJBWDR0Z2Y0?=
 =?utf-8?B?YjhSdXVFRW5LOU4yY0kvbjdlWER0NnhqNm1JY1dIa3lnNHNNQW5qMTZlN2hn?=
 =?utf-8?B?c1VHU3pRUldXZWh0TC9zdU56VXhYbENhUHNiV0wrbmphYkliMVcyQ0Zxb3Iw?=
 =?utf-8?B?L3E2ejdBV3l6NHFicmFpRjhxUXFZN1lWd1pnTllMTlNrMjdYUXYwUVBFL0Fh?=
 =?utf-8?B?eG9qenZKSlN5QlRGanE1Vjh0UittVUJzUTA3ei83VFV1dnRna0RsenFwSlhE?=
 =?utf-8?B?bVoyYlZ6ZEt1Z1RtUEtINUh3SzBDRHg3OHk4aHhHd0doc2xLa2wwdGYvblJX?=
 =?utf-8?B?YkVGaFhadlBsSnR1L05CK0dHN0M1WlBTQU50bGdUVmZZY2ZVeUdkZXNSRGlN?=
 =?utf-8?B?TVdQQ0puOEdnV1p2alFON1dzUXIrbWhCR1NpZjJCUWlIeFVaelVPS2RualJC?=
 =?utf-8?Q?MjJiuMAUejrCqVjYnYBcR2ny0?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 517053fa-913a-407c-af71-08daace3f33c
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB6007.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 06:27:06.5834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qBiFzmsNvsjgrtuTIwDFzafSQLxRxIl32GIPEcIKhzLD/hdLarhsB6BelHsvQlzeHHtLYq1Wv3QhS6b+lW/JBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR02MB4530
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

cherry picked from commit e3b49ea36802053f312013fd4ccb6e59920a9f76
[Please apply to 5.10-stable and 5.15-stable.]

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
Cc: stable@vger.kernel.org
Signed-off-by: Hyeong-Jun Kim <hj514.kim@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Chao Yu <chao@kernel.org>
(cherry picked from commit e3b49ea36802053f312013fd4ccb6e59920a9f76)

Signed-off-by: lvgaofei <lvgaofei@oppo.com>
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
