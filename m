Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E23B60173D
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 21:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbiJQTUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 15:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbiJQTUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 15:20:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A4613E82;
        Mon, 17 Oct 2022 12:20:14 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29HITP1C022722;
        Mon, 17 Oct 2022 19:20:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=g+CQYC8sMTWhCuqgEiG08pesQ4UF94AC6C5ZFEepKos=;
 b=QsRvvNDJQyo0NYiDI/w3/PQew7uqZrLlduQc4XYTRYHEvBGrnYCVV094gTlcRwXN85rp
 aGQ8AGZHrBWOzRcrVvLJnTm2pmBabl6e82UQrNRTe3IdrQlhjO1It7VqtRDUbZ1f+9g2
 wmwEL5LRLubeO7ZmUTiuhXNF+GdOnhXlxKv6nADMkrRzDT8THx2W6tyjKE2TpjBefRtY
 DUtP0rgZX7O0OgGuAHJp3DrhZcvGbDbsUM7YX3YyJ7B2Hf+KuxDM5CG84MGNgk47PWw+
 U/O1ZrG/Bm7+4SlYqTrUihBy5tJA4JZQHE5qKTIVaiyPpWHhSZqA+BlFP0OzmR/uKCP/ xw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mtyvqtu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 19:20:13 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29HHgPbI036422;
        Mon, 17 Oct 2022 19:20:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8htf4acr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 19:20:12 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29HJKCYn007860;
        Mon, 17 Oct 2022 19:20:12 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.147.25.63])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3k8htf4abs-1;
        Mon, 17 Oct 2022 19:20:12 +0000
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        jason@zx2c4.com, saeed.mirzamohammadi@oracle.com
Subject: [PATCH stable 0/5] Fix missing patches in stable
Date:   Mon, 17 Oct 2022 12:20:01 -0700
Message-Id: <20221017192006.36398-1-saeed.mirzamohammadi@oracle.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_13,2022-10-17_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210170111
X-Proofpoint-ORIG-GUID: l07ZT0l-D0fwMcpsemtbLwdOahIw3I6R
X-Proofpoint-GUID: l07ZT0l-D0fwMcpsemtbLwdOahIw3I6R
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following patches has been applied to 6.0 but only patch#2 below
has been applied to stable. This caused regression with nfs tests in
all stable releases.

This patchset backports patches 1 and 3-6 to stable.

1. 868941b14441 fs: remove no_llseek
2. 97ef77c52b78 fs: check FMODE_LSEEK to control internal pipe splicing
3. 54ef7a47f67d vfio: do not set FMODE_LSEEK flag
4. c9eb2d427c1c dma-buf: remove useless FMODE_LSEEK flag
5. 4e3299eaddff fs: do not compare against ->llseek
6. e7478158e137 fs: clear or set FMODE_LSEEK based on llseek function

For 5.10.y and 5.4.y only, a revert of patch#2 is already included.
Please apply patch#2, for 5.4.y and 5.10.y as well.

Thanks,
Saeed

Jason A. Donenfeld (5):
  fs: clear or set FMODE_LSEEK based on llseek function
  fs: do not compare against ->llseek
  dma-buf: remove useless FMODE_LSEEK flag
  vfio: do not set FMODE_LSEEK flag
  fs: remove no_llseek

 Documentation/filesystems/porting.rst |  8 ++++++++
 drivers/dma-buf/dma-buf.c             |  1 -
 drivers/gpu/drm/drm_file.c            |  3 +--
 drivers/vfio/vfio.c                   |  2 +-
 fs/coredump.c                         |  4 ++--
 fs/file_table.c                       |  2 ++
 fs/open.c                             |  4 ++++
 fs/overlayfs/copy_up.c                |  3 +--
 fs/read_write.c                       | 17 +++--------------
 include/linux/fs.h                    |  2 +-
 kernel/bpf/bpf_iter.c                 |  3 +--
 11 files changed, 24 insertions(+), 25 deletions(-)

-- 
2.31.1

