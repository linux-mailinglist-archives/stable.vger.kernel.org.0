Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5098F5B62B5
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 23:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiILV2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 17:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiILV2D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 17:28:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF42327FD2;
        Mon, 12 Sep 2022 14:28:01 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CLOjca010559;
        Mon, 12 Sep 2022 21:27:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=u5fSgoIS0Se5af6rSATppQ+YdUQ3Cgf9O2CC3cx3vDs=;
 b=mTJHi3M8v6yc04hLNWCAtAGO5n1zOICFpXL5AQwrk9xq9shddTOtRLL7Eg7aKhcKtYoX
 ZAUAIStq1n3KFXfRjZ3VeJIbXDAkWTZs05FaGEv3hhVaStgWgn2hVcjZkYa0hk7C/QI9
 cPWvslxY1Y9QLeTFe94n2x9t2tReyUyOixzLiaAS9XTOhQRCm6LEODgLxlOKhlqGLorr
 GDHeQNis/aJuDsdQfDV8z0FgRRfdsH6DYEEfL2vo9BukNIZBzkmxq+xnLvHw1cmgtvqv
 xtzYPYchqjczmVREplFeLiTCKuuhvsjwkeoJXAcmivxMHlpKF/SxNQ7Km4HbzvzUtRpx ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jjcnn81ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 21:27:46 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28CLPDBX012485;
        Mon, 12 Sep 2022 21:27:45 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jjcnn81an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 21:27:45 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28CLM1dw029570;
        Mon, 12 Sep 2022 21:27:44 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04wdc.us.ibm.com with ESMTP id 3jgj797xte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 21:27:44 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28CLRiJp28180790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 21:27:44 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F5B0AE067;
        Mon, 12 Sep 2022 21:27:44 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85D24AE05C;
        Mon, 12 Sep 2022 21:27:43 +0000 (GMT)
Received: from slate16.aus.stglabs.ibm.com (unknown [9.77.129.206])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 12 Sep 2022 21:27:43 +0000 (GMT)
From:   Eddie James <eajames@linux.ibm.com>
To:     jic23@kernel.org
Cc:     lars@metafoo.de, linux-iio@vger.kernel.org, joel@jms.id.au,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        stable@vger.kernel.org, eajames@linux.ibm.com
Subject: [PATCH v7 0/2] iio: pressure: dps310: Reset chip if MEAS_CFG is corrupt
Date:   Mon, 12 Sep 2022 16:27:41 -0500
Message-Id: <20220912212743.37365-1-eajames@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mpjS81g_jvE9hrYZbWbKL6FKLbChYcch
X-Proofpoint-ORIG-GUID: raad5OAIQXdIDTagCCx40opY2czv_EFA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_14,2022-09-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209120071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The DPS310 chip has been observed to get "stuck" such that pressure
and temperature measurements are never indicated as "ready" in the
MEAS_CFG register. The only solution is to reset the device and try
again. In order to avoid continual failures, use a boolean flag to
only try the reset after timeout once if errors persist. Include a
patch to move the startup procedure into a function.

Changes since v6:
 - Use helper instead of the lengthy regmap_read_poll_timeout twice
 - Just return dps310_startup in dps310_reset_reinit

Changes since v5:
 - Completely rework the second patch to reset and reinit in any
   timeout condition, if there haven't been previous timeouts that
   failed to recover the chip.

Changes since v4:
 - Just check for rc rather than rc < 0 in some cases
 - Split declaration and init of rc

Changes since v3:
 - Don't check regmap* return codes for < 0
 - Fix comment spelling

Changes since v2:
 - Add some comments
 - Fix the clunky control flow

Changes since v1:
 - Separate into two patches
 - Rename 'dps310_verify_meas_cfg' to 'dps310_check_reset_meas_cfg'

Eddie James (2):
  iio: pressure: dps310: Refactor startup procedure
  iio: pressure: dps310: Reset chip after timeout

 drivers/iio/pressure/dps310.c | 266 +++++++++++++++++++++-------------
 1 file changed, 167 insertions(+), 99 deletions(-)

-- 
2.31.1

