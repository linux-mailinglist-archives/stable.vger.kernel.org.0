Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8C9342644
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 20:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhCSTeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 15:34:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43084 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230468AbhCSTeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 15:34:02 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12JJXPfb185144;
        Fri, 19 Mar 2021 15:34:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=BwR/PoVTo9a9RrveTk09NWZ9rzgYeR3qcNKMc+06fAc=;
 b=k6iyNW7lOx4jxjYV8wujKorWFBq6atDH1oGI6IkgT3fOmX0VrBGCy01hYcfnrudKzgDn
 +v5DImm9FqU9Me5dO7nS/AaQ9omJaLY2sFDsfeO1Vv7orWrOKLYobK9Y3Xkktah3sfgA
 azv44LkqxDetULBJfTMR7HpexdUnUTIugXOsvZ5tIdRYk/3ok56gNxWrMTwaJ6dbVtW5
 VEx8+NCh+0rP/PF5mvc9fCTsp1Mu7j41EG0CKKkcLDcVzB6EHMRcOCYtjYGPbAuC6EG7
 Q7W4dBvSXOw42CxhM4XAkCyhgKwvXgj0jG7zwjJr9XMzfRfFin2HF2gmf+H2uTTOXUxX hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37byr4pt0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 15:34:01 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12JJY1v3186300;
        Fri, 19 Mar 2021 15:34:01 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37byr4pt0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 15:34:01 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12JJWxGo013358;
        Fri, 19 Mar 2021 19:33:59 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 37crcrgevj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 19:33:59 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12JJXuRh42664376
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 19:33:56 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5032CA405F;
        Fri, 19 Mar 2021 19:33:56 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D49A5A405C;
        Fri, 19 Mar 2021 19:33:55 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.2.56])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Mar 2021 19:33:55 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v1 2/2] s390/kvm: VSIE: fix MVPG handling for prefixing and MSO
Date:   Fri, 19 Mar 2021 20:33:54 +0100
Message-Id: <20210319193354.399587-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210319193354.399587-1-imbrenda@linux.ibm.com>
References: <20210319193354.399587-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_10:2021-03-19,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 suspectscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190130
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Prefixing needs to be applied to the guest real address to translate it
into a guest absolute address.

The value of MSO needs to be added to a guest-absolute address in order to
obtain the host-virtual.

Fixes: 223ea46de9e79 ("s390/kvm: VSIE: correctly handle MVPG when in VSIE")
Cc: stable@vger.kernel.org
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 48aab6290a77..92864f9b3d84 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1002,7 +1002,7 @@ static u64 vsie_get_register(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
 static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 {
 	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
-	unsigned long pei_dest, pei_src, src, dest, mask;
+	unsigned long pei_dest, pei_src, r1, r2, src, dest, mask, mso, prefix;
 	u64 *pei_block = &vsie_page->scb_o->mcic;
 	int edat, rc_dest, rc_src;
 	union ctlreg0 cr0;
@@ -1010,9 +1010,13 @@ static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	cr0.val = vcpu->arch.sie_block->gcr[0];
 	edat = cr0.edat && test_kvm_facility(vcpu->kvm, 8);
 	mask = _kvm_s390_logical_to_effective(&scb_s->gpsw, PAGE_MASK);
+	mso = READ_ONCE(vsie_page->scb_o->mso) & ~(1UL << 20);
+	prefix = scb_s->prefix << GUEST_PREFIX_SHIFT;
 
-	dest = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 16) & mask;
-	src = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 20) & mask;
+	r1 = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 16);
+	r2 = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 20);
+	dest = _kvm_s390_real_to_abs(prefix, r1 & mask) + mso;
+	src = _kvm_s390_real_to_abs(prefix, r2 & mask) + mso;
 
 	rc_dest = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, dest, &pei_dest);
 	rc_src = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, src, &pei_src);
-- 
2.26.2

