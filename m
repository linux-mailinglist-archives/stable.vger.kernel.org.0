Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFCC05A50CA
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 17:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiH2P4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 11:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiH2P4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 11:56:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9C7895F9
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 08:56:02 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27TFkYee020871;
        Mon, 29 Aug 2022 15:56:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=/plhqjySGXXbkXjgfnqGTCEDJfZchIkM3TyKVsEb9Qk=;
 b=If7Dx8qL/I2AOMqR14Yig1k15okjB7/Bitb9ZKhyGT/N5cCPGZBXSjQbe8Uv3B4VQXil
 XrfZVDWc+w+ZYulRgg2WV554V0/aTgRMXnZF9w4/T3gyCxdyysPihdD/3pn1WhErAXp3
 jG1y7+SaRehE5YLlHcOk2sD2YcB7ZvmW0qCiGUkte0DYCv2BG/Vh+amLLLoMTmo2m5aN
 IGFmEkPqf6ZS6VPDo7BjT6NxDaUjNs/M2/3hg2tjyVJDjO6epS0zVx6N4eSMG709BL78
 7q0ai1bJULnEDa8uKMrM9UWDu8LesbDmIqk7rj8HUE/xJVTvD8/z/Wyj9SZQORXzaIJK 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j90cu8kmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Aug 2022 15:56:01 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27TFlOom024070;
        Mon, 29 Aug 2022 15:56:00 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j90cu8khb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Aug 2022 15:56:00 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27TFqBAB005494;
        Mon, 29 Aug 2022 15:55:56 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3j7ahhsuga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Aug 2022 15:55:55 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27TFuEML41615688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 15:56:14 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CBB98A405B;
        Mon, 29 Aug 2022 15:55:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 965D9A4054;
        Mon, 29 Aug 2022 15:55:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Aug 2022 15:55:52 +0000 (GMT)
From:   Gerald Schaefer <gerald.schaefer@linux.ibm.com>
To:     gregkh@linuxfoundation.org
Cc:     david@redhat.com, gerald.schaefer@linux.ibm.com, gor@linux.ibm.com,
        hca@linux.ibm.com, stable@vger.kernel.org
Subject: [PATCH 5.4] s390/mm: do not trigger write fault when vma does not allow VM_WRITE
Date:   Mon, 29 Aug 2022 17:55:49 +0200
Message-Id: <20220829155549.3866458-1-gerald.schaefer@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <16617586615547@kroah.com>
References: <16617586615547@kroah.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: i2flHhBPKdqjyck8UbgdPecIrIecnhgZ
X-Proofpoint-ORIG-GUID: -ptmU5sga0D0cmsFqwhFDcMxcpdJoLvy
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-29_07,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 mlxscore=0 adultscore=0 impostorscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208290073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 41ac42f137080bc230b5882e3c88c392ab7f2d32 upstream.

For non-protection pXd_none() page faults in do_dat_exception(), we
call do_exception() with access == (VM_READ | VM_WRITE | VM_EXEC).
In do_exception(), vma->vm_flags is checked against that before
calling handle_mm_fault().

Since commit 92f842eac7ee3 ("[S390] store indication fault optimization"),
we call handle_mm_fault() with FAULT_FLAG_WRITE, when recognizing that
it was a write access. However, the vma flags check is still only
checking against (VM_READ | VM_WRITE | VM_EXEC), and therefore also
calling handle_mm_fault() with FAULT_FLAG_WRITE in cases where the vma
does not allow VM_WRITE.

Fix this by changing access check in do_exception() to VM_WRITE only,
when recognizing write access.

Link: https://lkml.kernel.org/r/20220811103435.188481-3-david@redhat.com
Fixes: 92f842eac7ee3 ("[S390] store indication fault optimization")
Cc: <stable@vger.kernel.org>
Reported-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
---
 arch/s390/mm/fault.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 7b0bb475c166..9770381776a6 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -432,7 +432,9 @@ static inline vm_fault_t do_exception(struct pt_regs *regs, int access)
 	flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
-	if (access == VM_WRITE || (trans_exc_code & store_indication) == 0x400)
+	if ((trans_exc_code & store_indication) == 0x400)
+		access = VM_WRITE;
+	if (access == VM_WRITE)
 		flags |= FAULT_FLAG_WRITE;
 	down_read(&mm->mmap_sem);
 
-- 
2.34.1

