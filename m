Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E034134CE
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 15:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbhIUNt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 09:49:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65530 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233428AbhIUNtx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 09:49:53 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18LDRCw5016875;
        Tue, 21 Sep 2021 09:48:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=SqvjPubLHu3KNaK7W4fiBVIRY7dIc0KmJSzZMlI/9XQ=;
 b=BJSR3o0ywsskBTD7pqQfXHnpni8POe/BnWxV3TtfXZJmSsv8fZVm8DvWm5TAwuE4x0HA
 ncTkwjKnpudnohp5b3iMhDMHHUDYjKHQh0Os2H4LpsBKgyn4hr/WsSkwvrEdVtFB1kPc
 aJp/GdD5Ex8M/UqJ1nh1jNEFl2/5QL+VNgVbYQPn4V+h30z4WxQF59htjnWDMc4oJVsj
 bTS/pLlfZ/oIbjUJTEoV9Oj1TswX0KMN7HJVWwHiRiiqX/ywick2EIeIbKhIy7IckupF
 ThRgE2wQU2k7+f9qU013Wpk/9BBJTEulQFO40IzgVXesO7pRyefW5I92HkPpf9743cv/ Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b7b7u15ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 09:48:24 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18LDWtef030148;
        Tue, 21 Sep 2021 09:48:24 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b7b7u15jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 09:48:24 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18LDhGFC029879;
        Tue, 21 Sep 2021 13:48:22 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3b57r9cn27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 13:48:22 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18LDmGKs56557870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 13:48:16 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80C5511C058;
        Tue, 21 Sep 2021 13:48:16 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7656F11C06C;
        Tue, 21 Sep 2021 13:48:16 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 21 Sep 2021 13:48:16 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 11939E07EE; Tue, 21 Sep 2021 15:48:16 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, KVM <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] [backport for 4.19/5.4 stable] KVM: remember position in kvm->vcpus array
Date:   Tue, 21 Sep 2021 15:48:15 +0200
Message-Id: <20210921134815.17615-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -3tHm8Y9-2rczQ5iTOgfj_3orM6YaSxR
X-Proofpoint-ORIG-GUID: TPsZ7XBaaKlxAjJfmxJqnu_jZzmh6rV8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-21_01,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=430
 lowpriorityscore=0 malwarescore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109210083
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Radim Krčmář <rkrcmar@redhat.com>

Fetching an index for any vcpu in kvm->vcpus array by traversing
the entire array everytime is costly.
This patch remembers the position of each vcpu in kvm->vcpus array
by storing it in vcpus_idx under kvm_vcpu structure.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[borntraeger@de.ibm.com]: backport to 4.19 (also fits for 5.4)
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 include/linux/kvm_host.h | 11 +++--------
 virt/kvm/kvm_main.c      |  5 +++--
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8dd4ebb58e97..827f70ce0b49 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -248,7 +248,8 @@ struct kvm_vcpu {
 	struct preempt_notifier preempt_notifier;
 #endif
 	int cpu;
-	int vcpu_id;
+	int vcpu_id; /* id given by userspace at creation */
+	int vcpu_idx; /* index in kvm->vcpus array */
 	int srcu_idx;
 	int mode;
 	u64 requests;
@@ -551,13 +552,7 @@ static inline struct kvm_vcpu *kvm_get_vcpu_by_id(struct kvm *kvm, int id)
 
 static inline int kvm_vcpu_get_idx(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *tmp;
-	int idx;
-
-	kvm_for_each_vcpu(idx, tmp, vcpu->kvm)
-		if (tmp == vcpu)
-			return idx;
-	BUG();
+	return vcpu->vcpu_idx;
 }
 
 #define kvm_for_each_memslot(memslot, slots)	\
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a3d82113ae1c..86ef740763b5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2751,7 +2751,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 		goto unlock_vcpu_destroy;
 	}
 
-	BUG_ON(kvm->vcpus[atomic_read(&kvm->online_vcpus)]);
+	vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
+	BUG_ON(kvm->vcpus[vcpu->vcpu_idx]);
 
 	/* Now it's all set up, let userspace reach it */
 	kvm_get_kvm(kvm);
@@ -2761,7 +2762,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 		goto unlock_vcpu_destroy;
 	}
 
-	kvm->vcpus[atomic_read(&kvm->online_vcpus)] = vcpu;
+	kvm->vcpus[vcpu->vcpu_idx] = vcpu;
 
 	/*
 	 * Pairs with smp_rmb() in kvm_get_vcpu.  Write kvm->vcpus
-- 
2.31.1

