Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2DFB57D121
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 18:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbiGUQOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 12:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233586AbiGUQOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 12:14:00 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00D987369;
        Thu, 21 Jul 2022 09:13:54 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LFruqj005986;
        Thu, 21 Jul 2022 16:13:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=PCu9IdbsFrkiZhW55Gv/bdjhUSLiyOkHJrTzG3SPqtQ=;
 b=bFNwyXF2NcRrtWiwC8STdSBdGZ4oPNLKkIwQRIb3+uxT3j92m85s1qVQkqywZET8mm1+
 8Fyq/7Z27Ro+AyRUGHNDEiQcb1AkjOJlVEHdbNEc62XbKsdJiu4vu2252CVj7CysP+5m
 lPdOJoBD6AaHEcSWfQD3Y4YlGyGKqDXCSObyRvdrkGbb5HzWPHA3iQX7Vn/lq2Iqvd7d
 EVDvz6ejrr/fp5a+p5ynA0kAEDWLnNEvx0QKJi0tntQsDQ+jyBCHxvj3EgffwdEWjmJt
 bQCqPMAQZe47BfixsDhMijSVTwsujka+sH9NSZUocQyQxUeUDH+P8yQTGt92zwBhnmVb bA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9um8fj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:33 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LG0YML011431;
        Thu, 21 Jul 2022 16:13:33 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9um8fhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:33 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LG6k6c000977;
        Thu, 21 Jul 2022 16:13:31 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3hbmkht0ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:31 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGDStp23724480
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:13:28 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C6DDA405F;
        Thu, 21 Jul 2022 16:13:28 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97A8AA405B;
        Thu, 21 Jul 2022 16:13:27 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:27 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, Nico Boehr <nrb@linux.ibm.com>,
        stable@vger.kernel.org
Subject: [GIT PULL 39/42] KVM: s390: pv: don't present the ecall interrupt twice
Date:   Thu, 21 Jul 2022 18:12:59 +0200
Message-Id: <20220721161302.156182-40-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: twPCKVc02FyJecA1QRammBdKkBmIIZg1
X-Proofpoint-GUID: xCMRhmPftKDZ3CKPQ1U8lDU65sAX6A-f
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxlogscore=782 clxscore=1011
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

When the SIGP interpretation facility is present and a VCPU sends an
ecall to another VCPU in enabled wait, the sending VCPU receives a 56
intercept (partial execution), so KVM can wake up the receiving CPU.
Note that the SIGP interpretation facility will take care of the
interrupt delivery and KVM's only job is to wake the receiving VCPU.

For PV, the sending VCPU will receive a 108 intercept (pv notify) and
should continue like in the non-PV case, i.e. wake the receiving VCPU.

For PV and non-PV guests the interrupt delivery will occur through the
SIGP interpretation facility on SIE entry when SIE finds the X bit in
the status field set.

However, in handle_pv_notification(), there was no special handling for
SIGP, which leads to interrupt injection being requested by KVM for the
next SIE entry. This results in the interrupt being delivered twice:
once by the SIGP interpretation facility and once by KVM through the
IICTL.

Add the necessary special handling in handle_pv_notification(), similar
to handle_partial_execution(), which simply wakes the receiving VCPU and
leave interrupt delivery to the SIGP interpretation facility.

In contrast to external calls, emergency calls are not interpreted but
also cause a 108 intercept, which is why we still need to call
handle_instruction() for SIGP orders other than ecall.

Since kvm_s390_handle_sigp_pei() is now called for all SIGP orders which
cause a 108 intercept - even if they are actually handled by
handle_instruction() - move the tracepoint in kvm_s390_handle_sigp_pei()
to avoid possibly confusing trace messages.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Cc: <stable@vger.kernel.org> # 5.7
Fixes: da24a0cc58ed ("KVM: s390: protvirt: Instruction emulation")
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Link: https://lore.kernel.org/r/20220718130434.73302-1-nrb@linux.ibm.com
Message-Id: <20220718130434.73302-1-nrb@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/intercept.c | 15 +++++++++++++++
 arch/s390/kvm/sigp.c      |  4 ++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 8bd42a20d924..88112065d941 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -528,12 +528,27 @@ static int handle_pv_uvc(struct kvm_vcpu *vcpu)
 
 static int handle_pv_notification(struct kvm_vcpu *vcpu)
 {
+	int ret;
+
 	if (vcpu->arch.sie_block->ipa == 0xb210)
 		return handle_pv_spx(vcpu);
 	if (vcpu->arch.sie_block->ipa == 0xb220)
 		return handle_pv_sclp(vcpu);
 	if (vcpu->arch.sie_block->ipa == 0xb9a4)
 		return handle_pv_uvc(vcpu);
+	if (vcpu->arch.sie_block->ipa >> 8 == 0xae) {
+		/*
+		 * Besides external call, other SIGP orders also cause a
+		 * 108 (pv notify) intercept. In contrast to external call,
+		 * these orders need to be emulated and hence the appropriate
+		 * place to handle them is in handle_instruction().
+		 * So first try kvm_s390_handle_sigp_pei() and if that isn't
+		 * successful, go on with handle_instruction().
+		 */
+		ret = kvm_s390_handle_sigp_pei(vcpu);
+		if (!ret)
+			return ret;
+	}
 
 	return handle_instruction(vcpu);
 }
diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index 8aaee2892ec3..cb747bf6c798 100644
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -480,9 +480,9 @@ int kvm_s390_handle_sigp_pei(struct kvm_vcpu *vcpu)
 	struct kvm_vcpu *dest_vcpu;
 	u8 order_code = kvm_s390_get_base_disp_rs(vcpu, NULL);
 
-	trace_kvm_s390_handle_sigp_pei(vcpu, order_code, cpu_addr);
-
 	if (order_code == SIGP_EXTERNAL_CALL) {
+		trace_kvm_s390_handle_sigp_pei(vcpu, order_code, cpu_addr);
+
 		dest_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, cpu_addr);
 		BUG_ON(dest_vcpu == NULL);
 
-- 
2.36.1

