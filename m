Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A632B287305
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 13:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgJHLCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 07:02:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60436 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgJHLCL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Oct 2020 07:02:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098B01vT010200;
        Thu, 8 Oct 2020 11:02:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=sPmJETHBunmpRScxm8sJMxiMJ51jiawemlZJrir9uKA=;
 b=nwzpTy6rtOH23douZqDmlgGSKU2ABvNDwFaesqljZ6q+c0q/+5gFYywSjvQjLWkzvVZk
 2/57lANUF2/+d49WxGEO2ms8dp3NFo2gCo+FIlGFhV5m8NmRGgZHpbiDlUp/rgplXnD7
 knfMyGsw3aAxaekplPhQUMaFxAIPuPPuB+dxevy8pYVijSVGrWlo4Mf/Ik0hcp3EQXiv
 3tci2lzJtCln/o8a0bCpAwaZ0sOicc3S2HRnGfA7iF0bDap4w8+OzUz0C2ACFdveSBIr
 ViaudlJyKGJlSmOFtpmm8gL7E5F+oDV6BUTCwbU7X1VO/FVNZItJCeWMILt58e8Hxcmm iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33ym34v41r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 11:02:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098AtFK0033473;
        Thu, 8 Oct 2020 11:00:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 341xnbgpen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 11:00:04 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 098B03Kf020028;
        Thu, 8 Oct 2020 11:00:03 GMT
Received: from ltp.sg.oracle.com (/10.191.35.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 04:00:03 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     wqu@suse.com, fdmanana@suse.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH stable-5.4 0/6] backport fixes for xfstests btrfs/199,200,203,204
Date:   Thu,  8 Oct 2020 18:59:48 +0800
Message-Id: <cover.1599750901.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=783 spamscore=0
 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010080081
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=805 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080081
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series backports fixes for the xfstests test cases btrfs/199
btrfs/200 btrfs/203 and btrfs/204.

patch 1 is fix for btrfs/200
patch 2 fixes regression in patch 1 and is fix for btrfs/203 
patch 3 helps to fix conflicts in patch 4
patch 4 is fix for btrfs/199
patch 5 helps to avoid conflicts in patch6
patch 6 is fix for btrfs/204

patch1 Btrfs: send, allow clone operations within the same file
patch2 Btrfs: send, fix emission of invalid clone operations within the same file
patch3 btrfs: volumes: Use more straightforward way to calculate map length
patch4 btrfs: Ensure we trim ranges across block group boundary
patch5 btrfs: fix RWF_NOWAIT write not failling when we need to cow
patch6 btrfs: allow btrfs_truncate_block() to fallback to nocow for data space reservation

Filipe Manana (3):
  Btrfs: send, allow clone operations within the same file
  Btrfs: send, fix emission of invalid clone operations within the same
    file
  btrfs: fix RWF_NOWAIT write not failling when we need to cow

Qu Wenruo (3):
  btrfs: volumes: Use more straightforward way to calculate map length
  btrfs: Ensure we trim ranges across block group boundary
  btrfs: allow btrfs_truncate_block() to fallback to nocow for data
    space reservation

 fs/btrfs/ctree.h       |  2 ++
 fs/btrfs/extent-tree.c | 41 +++++++++++++++++++++++++++++----------
 fs/btrfs/file.c        | 23 ++++++++++++++++++----
 fs/btrfs/inode.c       | 44 +++++++++++++++++++++++++++++++++++-------
 fs/btrfs/send.c        | 19 +++++++++++++-----
 fs/btrfs/volumes.c     |  8 +++++---
 6 files changed, 108 insertions(+), 29 deletions(-)

-- 
2.25.1

