Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDBD4EC48
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 17:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfFUPjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 11:39:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26418 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726118AbfFUPji (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 11:39:38 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5LFMFiB124916
        for <stable@vger.kernel.org>; Fri, 21 Jun 2019 11:39:38 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t8yb3yv2j-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 21 Jun 2019 11:39:37 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <iii@linux.ibm.com>;
        Fri, 21 Jun 2019 16:39:35 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 21 Jun 2019 16:39:34 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5LFdXDk41287780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 15:39:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E9F611C04A;
        Fri, 21 Jun 2019 15:39:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2CD411C058;
        Fri, 21 Jun 2019 15:39:32 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.152.98.53])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jun 2019 15:39:32 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Laura Abbott <labbott@redhat.com>
Cc:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        stable <stable@vger.kernel.org>,
        Major Hayden <mhayden@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH] s390/jump_label: Use "jdd" constraint on gcc9
Date:   Fri, 21 Jun 2019 17:39:12 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <99840513-9a7d-2c91-1e41-5355f88babcf@redhat.com>
References: <99840513-9a7d-2c91-1e41-5355f88babcf@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19062115-0008-0000-0000-000002F5E1CE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062115-0009-0000-0000-000022630749
Message-Id: <20190621153912.9528-1-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-21_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906210125
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Ah okay, I didn't realize there was more needed, I was just looking at
> the clean cherry-pick. I'm not sure how to do the backport, if you
> give me the patch I can verify.

Please find the cherry-picked 146448524bdd below.

I also had to cherry-pick 159491f3b509 to fix an unrelated compilation
error and make the build fully work.

Best regards,
Ilya

----

[heiko.carstens@de.ibm.com]:
-----
Laura Abbott reported that the kernel doesn't build anymore with gcc 9,
due to the "X" constraint. Ilya provided the gcc 9 patch "S/390:
Introduce jdd constraint" which introduces the new "jdd" constraint
which fixes this.
-----

The support for section anchors on S/390 introduced in gcc9 has changed
the behavior of "X" constraint, which can now produce register
references. Since existing constraints, in particular, "i", do not fit
the intended use case on S/390, the new machine-specific "jdd"
constraint was introduced. This patch makes jump labels use "jdd"
constraint when building with gcc9.

Reported-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/include/asm/jump_label.h | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/jump_label.h b/arch/s390/include/asm/jump_label.h
index 40f651292aa7..9c7dc970e966 100644
--- a/arch/s390/include/asm/jump_label.h
+++ b/arch/s390/include/asm/jump_label.h
@@ -10,6 +10,12 @@
 #define JUMP_LABEL_NOP_SIZE 6
 #define JUMP_LABEL_NOP_OFFSET 2
 
+#if __GNUC__ < 9
+#define JUMP_LABEL_STATIC_KEY_CONSTRAINT "X"
+#else
+#define JUMP_LABEL_STATIC_KEY_CONSTRAINT "jdd"
+#endif
+
 /*
  * We use a brcl 0,2 instruction for jump labels at compile time so it
  * can be easily distinguished from a hotpatch generated instruction.
@@ -19,9 +25,9 @@ static __always_inline bool arch_static_branch(struct static_key *key, bool bran
 	asm_volatile_goto("0:	brcl 0,"__stringify(JUMP_LABEL_NOP_OFFSET)"\n"
 		".pushsection __jump_table, \"aw\"\n"
 		".balign 8\n"
-		".quad 0b, %l[label], %0\n"
+		".quad 0b, %l[label], %0+%1\n"
 		".popsection\n"
-		: : "X" (&((char *)key)[branch]) : : label);
+		: : JUMP_LABEL_STATIC_KEY_CONSTRAINT (key), "i" (branch) : : label);
 
 	return false;
 label:
@@ -33,9 +39,9 @@ static __always_inline bool arch_static_branch_jump(struct static_key *key, bool
 	asm_volatile_goto("0:	brcl 15, %l[label]\n"
 		".pushsection __jump_table, \"aw\"\n"
 		".balign 8\n"
-		".quad 0b, %l[label], %0\n"
+		".quad 0b, %l[label], %0+%1\n"
 		".popsection\n"
-		: : "X" (&((char *)key)[branch]) : : label);
+		: : JUMP_LABEL_STATIC_KEY_CONSTRAINT (key), "i" (branch) : : label);
 
 	return false;
 label:
-- 
2.21.0

