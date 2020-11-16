Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC682B43D3
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 13:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgKPMfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 07:35:48 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16638 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728329AbgKPMfs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 07:35:48 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AGCUkUA019905;
        Mon, 16 Nov 2020 04:35:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=ngni3SWmVIoitinPiqX1KU7bliY6xD7wcZKtSL8tWDc=;
 b=UqmaZpe/iZap6WSGo5v94itcvAUP9tVbvcDgRAPscanqfOTryQwONnjwptERIPHu2oRL
 +59e57VdoB27cB4PYblGrD5xNX9yT53T6H8M1dIV6LCPsUpc/9wKeCO0i9b/jP9elUVs
 fDCpqlSfAjUo3RKEnPoQ6Qj7HO+jPTH96S72CVjgK5Ik07yANR4p3hotDA/X0FzYDcRT
 hnVMkcWzTXxqXGgZV2EgvOw+yKGxW7lMnH5KF78CGtEspvLlBO7JGWVWYX56tYDiDeaa
 dBWf1mAVVe6ehg5VJJYjgUSnZWErrzEWUrlowu6rzYkYJmoXl35A9gmiQaNEY5SCzCN8 Aw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 34tdftw95d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 04:35:35 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 16 Nov
 2020 04:35:35 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 16 Nov
 2020 04:35:34 -0800
Received: from virtx40.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 16 Nov 2020 04:35:31 -0800
From:   Linu Cherian <lcherian@marvell.com>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC:     <mathieu.poirier@linaro.org>, <suzuki.poulose@arm.com>,
        <mike.leach@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <coresight@lists.linaro.org>, <linuc.decode@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH stable-5.9 1/2] coresight: etm: perf: Sink selection using sysfs is deprecated
Date:   Mon, 16 Nov 2020 18:05:09 +0530
Message-ID: <20201116123510.28980-1-lcherian@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_05:2020-11-13,2020-11-16 signatures=0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit bb1860efc817c18fce4112f25f51043e44346d1b upstream.

When commit 6d578258b955 ("coresight: Make sysfs functional on
topologies with per core sink") 
was merged to stable, this patch was a pre-requisite and got
missed out leading to build breakages.

When using the perf interface, sink selection using sysfs is
deprecated.

Signed-off-by: Linu Cherian <lcherian@marvell.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200916191737.4001561-14-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reported-by: kernel test robot <lkp@intel.com>
---
 drivers/hwtracing/coresight/coresight-etm-perf.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm-perf.c b/drivers/hwtracing/coresight/coresight-etm-perf.c
index be591b557df9..75379184f391 100644
--- a/drivers/hwtracing/coresight/coresight-etm-perf.c
+++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
@@ -222,8 +222,6 @@ static void *etm_setup_aux(struct perf_event *event, void **pages,
 	if (event->attr.config2) {
 		id = (u32)event->attr.config2;
 		sink = coresight_get_sink_by_id(id);
-	} else {
-		sink = coresight_get_enabled_sink(true);
 	}
 
 	mask = &event_data->mask;
-- 
2.25.1

