Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E485D6C7323
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 23:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjCWWeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 18:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjCWWeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 18:34:00 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0226594;
        Thu, 23 Mar 2023 15:33:58 -0700 (PDT)
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32NM93cO001022;
        Thu, 23 Mar 2023 22:33:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=qcppdkim1;
 bh=Iknq7DbmCPa6NBoymiUBH+ykN+AAfltzX0txCoit3Hs=;
 b=R44Kt7Her+aC5tByGhPDZAHE17tYb+7o0ZepTTVVgS+VXFmFl5r+rloqKq+KPXMij38e
 1xsrhxjhjeLlJ//GHLJMsZjlIJFvFNVXKGmKbI9X0vc0nzcqBc6vEa2xFPJFVYeCzFad
 qD1Zki6Z5BffdC127VF365Y2WRYZeADYoVxC/qLTGFJ3xQEyjyRebabUc65dLEYqfMeY
 AzObSH0Md21TolzR7vdB8VTn7aMDjwN46TRm1loM5KOOQkrw+sSeOlCzPqXC8kvEYkAa
 /veCPm+tT0NWU/kjbljy4RIzIR0YipNURuzHgpa/qoIDC++fWxFcUNu7/nft9IlCRCFo bg== 
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3pgxrur3a0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 22:33:49 +0000
Received: from nalasex01c.na.qualcomm.com (nalasex01c.na.qualcomm.com [10.47.97.35])
        by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 32NMXm0I005301
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 22:33:48 GMT
Received: from hu-bjorande-lv.qualcomm.com (10.49.16.6) by
 nalasex01c.na.qualcomm.com (10.47.97.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Thu, 23 Mar 2023 15:33:48 -0700
From:   Bjorn Andersson <quic_bjorande@quicinc.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Xuewen Yan <xuewen.yan@unisoc.com>
CC:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH] cpufreq: qcom-cpufreq-hw: Revert adding cpufreq qos
Date:   Thu, 23 Mar 2023 15:33:43 -0700
Message-ID: <20230323223343.587210-1-quic_bjorande@quicinc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01c.na.qualcomm.com (10.47.97.35)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: vy4OtcRPJPGg9At0hUZb5oJirT1hd6f3
X-Proofpoint-GUID: vy4OtcRPJPGg9At0hUZb5oJirT1hd6f3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-23_13,2023-03-23_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 clxscore=1011 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303230162
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The OSM/EPSS hardware controls the frequency of each CPU cluster based
on requests from the OS and various throttling events in the system.
While throttling is in effect the related dcvs interrupt will be kept
high. The purpose of the code handling this interrupt is to
continuously report the thermal pressure based on the throttled
frequency.

The reasoning for adding QoS control to this mechanism is not entirely
clear, but the introduction of commit 'c4c0efb06f17 ("cpufreq:
qcom-cpufreq-hw: Add cpufreq qos for LMh")' causes the
scaling_max_frequncy to be set to the throttled frequency. On the next
iteration of polling, the throttled frequency is above or equal to the
newly requested frequency, so the polling is stopped.

With cpufreq limiting the max frequency, the hardware no longer report a
throttling state and no further updates to thermal pressure or qos
state are made.

The result of this is that scaling_max_frequency can only go down, and
the system becomes slower and slower every time a thermal throttling
event is reported by the hardware.

Even if the logic could be improved, there is no reason for software to
limit the max freqency in response to the hardware limiting the max
frequency. At best software will follow the reported hardware state, but
typically it will cause slower backoff of the throttling.

This reverts commit c4c0efb06f17fa4a37ad99e7752b18a5405c76dc.

Fixes: c4c0efb06f17 ("cpufreq: qcom-cpufreq-hw: Add cpufreq qos for LMh")
Cc: stable@vger.kernel.org
Reported-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index 575a4461c25a..1503d315fa7e 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -14,7 +14,6 @@
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/pm_opp.h>
-#include <linux/pm_qos.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/units.h>
@@ -60,8 +59,6 @@ struct qcom_cpufreq_data {
 	struct clk_hw cpu_clk;
 
 	bool per_core_dcvs;
-
-	struct freq_qos_request throttle_freq_req;
 };
 
 static struct {
@@ -351,8 +348,6 @@ static void qcom_lmh_dcvs_notify(struct qcom_cpufreq_data *data)
 
 	throttled_freq = freq_hz / HZ_PER_KHZ;
 
-	freq_qos_update_request(&data->throttle_freq_req, throttled_freq);
-
 	/* Update thermal pressure (the boost frequencies are accepted) */
 	arch_update_thermal_pressure(policy->related_cpus, throttled_freq);
 
@@ -445,14 +440,6 @@ static int qcom_cpufreq_hw_lmh_init(struct cpufreq_policy *policy, int index)
 	if (data->throttle_irq < 0)
 		return data->throttle_irq;
 
-	ret = freq_qos_add_request(&policy->constraints,
-				   &data->throttle_freq_req, FREQ_QOS_MAX,
-				   FREQ_QOS_MAX_DEFAULT_VALUE);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "Failed to add freq constraint (%d)\n", ret);
-		return ret;
-	}
-
 	data->cancel_throttle = false;
 	data->policy = policy;
 
@@ -519,7 +506,6 @@ static void qcom_cpufreq_hw_lmh_exit(struct qcom_cpufreq_data *data)
 	if (data->throttle_irq <= 0)
 		return;
 
-	freq_qos_remove_request(&data->throttle_freq_req);
 	free_irq(data->throttle_irq, data);
 }
 
-- 
2.25.1

