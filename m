Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A5C5BA1A9
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 21:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiIOT5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 15:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiIOT5i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 15:57:38 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C1295AF2;
        Thu, 15 Sep 2022 12:57:36 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28FIuWvw026876;
        Thu, 15 Sep 2022 19:57:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=lvOej1TBFIRacZ5ySZE663i6gClm+IF+DVjQHVjivh4=;
 b=DfPO3WnOKGhwy3K3iGL7VvWgyK8mHp9fgCE1xVLMgvH9ZsNdL/DnoPUwOFzGdVOl1Oeo
 dcq87AeM07FaaBK5kSKXqx/tsL+Tl7KwFZc1v408sG5/rNEKoaFijXdweoEEne28shKC
 iPFAXWM0Mkn81Tc3Y3pANgmqbhm61p1eWNfPbpdfQX6lNaDimCbKdPnS35eOlisMsPEL
 +H/rtDZ9cQOfqblnICHCkq1I1O7vjNPH5j7TFPJc5ZIONECLE25RY1NWztPUYCNwT4hA
 kPBFR7zlSTGzCzvFZ1zy6Azl+/THjCcE9aJ6j+fgK5WHLHsOC2b9bu3tmcfT+njQuhux Og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jm9s5sskh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 19:57:23 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28FJfJB2020103;
        Thu, 15 Sep 2022 19:57:22 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jm9s5ssk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 19:57:22 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28FJoKAF008696;
        Thu, 15 Sep 2022 19:57:21 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03wdc.us.ibm.com with ESMTP id 3jm91w0ga6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 19:57:21 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28FJvKDq9437798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Sep 2022 19:57:20 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D242AC605B;
        Thu, 15 Sep 2022 19:57:19 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3494C6057;
        Thu, 15 Sep 2022 19:57:18 +0000 (GMT)
Received: from slate16.aus.stglabs.ibm.com (unknown [9.65.211.128])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 15 Sep 2022 19:57:18 +0000 (GMT)
From:   Eddie James <eajames@linux.ibm.com>
To:     jic23@kernel.org
Cc:     lars@metafoo.de, linux-iio@vger.kernel.org, joel@jms.id.au,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        stable@vger.kernel.org, eajames@linux.ibm.com
Subject: [PATCH v8 0/2] iio: pressure: dps310: Reset chip if MEAS_CFG is corrupt
Date:   Thu, 15 Sep 2022 14:57:17 -0500
Message-Id: <20220915195719.136812-1-eajames@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tgMdImoW7eIeHHYOKkQQk21VrU-rgEGl
X-Proofpoint-ORIG-GUID: XCWKlWb9110-Ss2aVFqaHtzLt25y7bDu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_10,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209150119
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

Changes since v7:
 - Condense the code a bit by dropping rc2

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

 drivers/iio/pressure/dps310.c | 262 +++++++++++++++++++++-------------
 1 file changed, 163 insertions(+), 99 deletions(-)

-- 
2.31.1

