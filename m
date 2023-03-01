Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33DFC6A69DC
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 10:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCAJfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 04:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCAJfC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 04:35:02 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9FD436FD6
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 01:35:01 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31SNDk31001607;
        Wed, 1 Mar 2023 09:35:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=kl8h3ERAUYAQNsYDw8cJ/XkLym5Dkae0LN1Ttz8L4+U=;
 b=fA2hQR92QQSRPMQkVAwefM02u+qvc5CK6i6GV1xBEpFmW9z0+E51ff3PfxSuQgUFwwAy
 I+pwm47abS+FZWEHCAqtj9Hp0+AyyFMJSUTc+ge2S70EWde+GFSR0KbeuABnOOWZ1pOU
 4br7BUy+8nW5gN/SVQ1prfBZm8xIHnmBnJdFjR0aswiFjKyfIhldI/j755QCgnmT7WF1
 wMA02GaJUdm8obndUs9wBlRBhyr1VmRFRqNTtBT8uy7PCGNN121zDUmA9tsY+KRNSpvP
 ojj5htxNnGgXsCzv3my0Rhb5kLP64/3SEI8yrSPU6Re71S03naUfmbdoZ/F3nTVuCqU7 eA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyba28m1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Mar 2023 09:35:00 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3219Qref015877;
        Wed, 1 Mar 2023 09:34:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8s8g6n5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Mar 2023 09:34:59 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3219YxES011607;
        Wed, 1 Mar 2023 09:34:59 GMT
Received: from t460.home (dhcp-10-175-15-169.vpn.oracle.com [10.175.15.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3ny8s8g6kk-1;
        Wed, 01 Mar 2023 09:34:59 +0000
From:   Vegard Nossum <vegard.nossum@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH stable-queue.git] scripts/bad_stable: include instructions to fix and resubmit
Date:   Wed,  1 Mar 2023 10:34:49 +0100
Message-Id: <20230301093449.16560-1-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.35.1.46.g38062e73e0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_04,2023-02-28_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303010079
X-Proofpoint-GUID: JisaxtTfudeTn9pRuFUA_3N60Iw2Vb9M
X-Proofpoint-ORIG-GUID: JisaxtTfudeTn9pRuFUA_3N60Iw2Vb9M
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This basically implements the suggestion from
<https://lore.kernel.org/stable/46577540-6ed7-0ff5-11d5-2982cd29e92b@oracle.com/>.

Sample output:

  To reproduce the conflict and resubmit, you may use the following commands:

  git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
  git checkout FETCH_HEAD
  git cherry-pick -x 9f46c187e2e680ecd9de7983e4d081c3391acc76
  # <resolve conflicts, build, test, etc.>
  git commit -s
  git send-email --to '<stable@vger.kernel.org>' --in-reply-to '<165314153515625@kroah.com>' --subject-prefix 'PATCH 5.15.y' HEAD^..

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 scripts/bad_stable | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/scripts/bad_stable b/scripts/bad_stable
index 03165f8212..0cd0319fb3 100755
--- a/scripts/bad_stable
+++ b/scripts/bad_stable
@@ -136,6 +136,15 @@ reply()
 		echo "tree, then please email the backport, including the original git commit"
 		echo "id to <stable@vger.kernel.org>."
 		echo
+		echo "To reproduce the conflict and resubmit, you may use the following commands:"
+		echo
+		echo "git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-$STABLE_VERSION.y"
+		echo "git checkout FETCH_HEAD"
+		echo "git cherry-pick -x $git_id"
+		echo "# <resolve conflicts, build, test, etc.>"
+		echo "git commit -s"
+		echo "git send-email --to '$STABLE' --in-reply-to '$ID' --subject-prefix 'PATCH $STABLE_VERSION.y' HEAD^.."
+		echo
 		echo "Possible dependencies:"
 		echo
 		echo "$(curl --fail --silent https://git.kernel.org/pub/scm/linux/kernel/git/sashal/deps.git/plain/v$STABLE_VERSION/$git_id)"
-- 
2.35.1.46.g38062e73e0

