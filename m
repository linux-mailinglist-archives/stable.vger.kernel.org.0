Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852622DE3DA
	for <lists+stable@lfdr.de>; Fri, 18 Dec 2020 15:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgLROTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Dec 2020 09:19:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13754 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725908AbgLROTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Dec 2020 09:19:01 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BIE5qDO022031;
        Fri, 18 Dec 2020 09:18:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3iYoFMACVWQh4220baHiiCssGjisDx4QieQjyKEbMY0=;
 b=ksOWUHNkWdzmp9aMv2BiUwNzemMrQPy8E8LH4Lnu+8we6hYc1iq8cu9X4n6r8b9cILKk
 KCylKOf1V5Z0/ULANe8xpAG05ImSXpYFrMyWW1VTpqxUFrRGrYnRW+kc9PX/NJzH3HpN
 bb2gFtj5uEO+pLu1dOJ6A9AyusPGouVryQodG+qQxWnLcHa5TRo5PfvVV5Y7C3YLSZqX
 01GvBsT1eL1L089iozcUzElE+erGjAefcyHOYmvJncw9fQh6EjYUDQMmm4Djx1bbvXqO
 FD3mkgCKEcI1u7a084LQCiD2vwT/Dr2oC7LUaxhOmLZTbHfcFDaYcyNH+BUdHeuPFg9F 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35gw6ehqwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Dec 2020 09:18:19 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BIE7geK033629;
        Fri, 18 Dec 2020 09:18:19 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35gw6ehqvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Dec 2020 09:18:19 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BIEIGpm012367;
        Fri, 18 Dec 2020 14:18:17 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 35cng889nc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Dec 2020 14:18:17 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BIEIEnE43516186
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 14:18:14 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 012F5A405B;
        Fri, 18 Dec 2020 14:18:14 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9ABECA4064;
        Fri, 18 Dec 2020 14:18:13 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.12.102])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 18 Dec 2020 14:18:13 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v1 4/4] s390/kvm: VSIE: correctly handle MVPG when in VSIE
Date:   Fri, 18 Dec 2020 15:18:11 +0100
Message-Id: <20201218141811.310267-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201218141811.310267-1-imbrenda@linux.ibm.com>
References: <20201218141811.310267-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-18_09:2020-12-18,2020-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=899
 lowpriorityscore=0 malwarescore=0 clxscore=1015 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180099
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Correctly handle the MVPG instruction when issued by a VSIE guest.

Fixes: a3508fbe9dc6d ("KVM: s390: vsie: initial support for nested virtualization")
Cc: stable@vger.kernel.org
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 73 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index ada49583e530..6c3069868acd 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -977,6 +977,75 @@ static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	return 0;
 }
 
+static u64 vsie_get_register(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, u8 reg)
+{
+	reg &= 0xf;
+	switch (reg) {
+	case 15:
+		return vsie_page->scb_s.gg15;
+	case 14:
+		return vsie_page->scb_s.gg14;
+	default:
+		return vcpu->run->s.regs.gprs[reg];
+	}
+}
+
+static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
+{
+	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
+	unsigned long r1, r2, mask = PAGE_MASK;
+	int rc;
+
+	if (psw_bits(scb_s->gpsw).eaba == PSW_BITS_AMODE_24BIT)
+		mask = 0xfff000;
+	else if (psw_bits(scb_s->gpsw).eaba == PSW_BITS_AMODE_31BIT)
+		mask = 0x7ffff000;
+
+	r1 = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 20) & mask;
+	r2 = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 16) & mask;
+	rc = kvm_s390_vsie_mvpg_check(vcpu, r1, r2, &vsie_page->scb_o->mcic);
+
+	/*
+	 * Guest translation was not successful. The host needs to forward
+	 * the intercept to the guest and let the guest fix its page tables.
+	 * The guest needs then to retry the instruction.
+	 */
+	if (rc == -ENOENT)
+		return 1;
+
+	retry_vsie_icpt(vsie_page);
+
+	/*
+	 * Guest translation was not successful. The page tables of the guest
+	 * are broken. Try again and let the hardware deliver the fault.
+	 */
+	if (rc == -EFAULT)
+		return 0;
+
+	/*
+	 * Guest translation was successful. The host needs to fix up its
+	 * page tables and retry the instruction in the nested guest.
+	 * In case of failure, the instruction will intercept again, and
+	 * a different path will be taken.
+	 */
+	if (!rc) {
+		kvm_s390_shadow_fault(vcpu, vsie_page->gmap, r2);
+		kvm_s390_shadow_fault(vcpu, vsie_page->gmap, r1);
+		return 0;
+	}
+
+	/*
+	 * An exception happened during guest translation, it needs to be
+	 * delivered to the guest. This can happen if the host has EDAT1
+	 * enabled and the guest has not, or for other causes. The guest
+	 * needs to process the exception and return to the nested guest.
+	 */
+	if (rc > 0)
+		return kvm_s390_inject_prog_cond(vcpu, rc);
+
+	return 1;
+}
+
 /*
  * Run the vsie on a shadow scb and a shadow gmap, without any further
  * sanity checks, handling SIE faults.
@@ -1063,6 +1132,10 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		if ((scb_s->ipa & 0xf000) != 0xf000)
 			scb_s->ipa += 0x1000;
 		break;
+	case ICPT_PARTEXEC:
+		if (scb_s->ipa == 0xb254)
+			rc = vsie_handle_mvpg(vcpu, vsie_page);
+		break;
 	}
 	return rc;
 }
-- 
2.26.2

