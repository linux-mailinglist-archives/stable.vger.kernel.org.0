Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1174399E97
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 12:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhFCKQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 06:16:15 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40466 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229661AbhFCKQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 06:16:15 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 153AAgt5011070;
        Thu, 3 Jun 2021 03:14:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=yLL+Xxqcqnev5qwWZwQffjXIrrGZo6EP3JJ8wzOvzOM=;
 b=CCtNKeC1cba6wil1pBrKexpkLPDJG22lxF/Cyvf6AT8YEzZCWUlXGaJHaN76mgGZIHMt
 zg2brx0C/1IDViIJeTfpht2IEPb1B0w1xGMbQP67/3vaDmrGHXTHLq4ABOh6NG3WG6B/
 +dPhGvIYY8v3m7D9/VeUojMbCglBAdWZGmngyyPd9Oy6/zZY3iaTBB/mEJXI54Ne0O3P
 Xu9ElpjV5/6U/7jIqcknJ/2BbKxRgNB+Rue/2al7/szJNLbMFBE58/mkxdBDppdXP/ki
 xVUvGUI+rcEwY+0oUWOo3qoNmsTvTJRgTYE++9mnj4DsTihZPi3ne1ovKOi3FKw5Qkeq XA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 38xhym26ay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 03 Jun 2021 03:14:30 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 03:14:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 03:14:28 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C04D73F7040;
        Thu,  3 Jun 2021 03:14:28 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 153AESTX007877;
        Thu, 3 Jun 2021 03:14:28 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 153AESLm007875;
        Thu, 3 Jun 2021 03:14:28 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>,
        <stable@vger.kernel.org>
Subject: [PATCH V2 0/2] scsi: FDMI Fixes
Date:   Thu, 3 Jun 2021 03:14:02 -0700
Message-ID: <20210603101404.7841-1-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: teg2965i0HXL7e9qETJ3vyVSaDrTOImY
X-Proofpoint-GUID: teg2965i0HXL7e9qETJ3vyVSaDrTOImY
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-03_06:2021-06-02,2021-06-03 signatures=0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series has two fixes for FDMI.
Attributes length corrected for RHBA.
Fixed the wrong condition check in fc_ct_ms_fill_attr().

Kindly apply this series to scsi-queue at your earliest convenience.

Javed Hasan (2):
  scsi: fc: Corrected RHBA attributes length
  libfc: Corrected the condition check and invalid argument passed

 drivers/scsi/libfc/fc_encode.h | 8 +++++---
 include/scsi/fc/fc_ms.h        | 4 ++--
 2 files changed, 7 insertions(+), 5 deletions(-)

-- 
2.26.2

