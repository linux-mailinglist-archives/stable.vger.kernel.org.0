Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD9F3BD752
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 15:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbhGFNDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 09:03:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3742 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232185AbhGFNC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Jul 2021 09:02:58 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 166CY8U7097856;
        Tue, 6 Jul 2021 09:00:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=7Flkiv6ZDiTrTl0rmhz4VEYewiyuY42MGWW9H6Sixnc=;
 b=IdoweoKaQti0HZcSfOzb5zo2leV61dJDiC8dpneNAPflAW9uYztlkQoKLKjBa1TJwEq+
 c0DEv8OCmH42bDr8dFIqeoJWoaAAP9gk3J6DD2Vq8sO1hGFKM4wYkS626G+zlVvUaSce
 nC0j+05QXPsW1nM/KokoZZJbTLD/V3c/70Hac5VaT2rYeBOnZiMoCIhX6wkCRH4/lni0
 V8fWSItkyZn0VfJszSWFpg9jpht++/w6Tg+pPF5slMWN5q7C0seoPYCx+JINTuHBEvqb
 HPsiBP/5mZnRUZaSSlDEeSP6vKN3DKh49ejRrTL+EBhfv77k6B0HtnMo81l8UDS6koVN Hg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39mkpuq801-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 09:00:15 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 166CgnWY031733;
        Tue, 6 Jul 2021 13:00:13 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 39jf5h98uy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 13:00:13 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 166CwLQK35979656
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jul 2021 12:58:22 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 386D1AE072;
        Tue,  6 Jul 2021 13:00:10 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F04A6AE07D;
        Tue,  6 Jul 2021 13:00:09 +0000 (GMT)
Received: from osiris (unknown [9.145.176.98])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  6 Jul 2021 13:00:09 +0000 (GMT)
Date:   Tue, 6 Jul 2021 15:00:08 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     gregkh@linuxfoundation.org
Cc:     gor@linux.ibm.com, stable@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] s390/stack: fix possible register
 corruption with stack" failed to apply to 5.4-stable tree
Message-ID: <YORT2ADgY32NITmo@osiris>
References: <16248036362480@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16248036362480@kroah.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: A6_cJDKrZ6aqmu4fDYx2ddrq39VhwICX
X-Proofpoint-GUID: A6_cJDKrZ6aqmu4fDYx2ddrq39VhwICX
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_06:2021-07-02,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 impostorscore=0 phishscore=0
 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501 clxscore=1011
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060061
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 27, 2021 at 04:20:36PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

Please find below the backported patch which applies to 5.4-stable:

From 1a124d1b216ddf165ce0635ef77878c83731c3dc Mon Sep 17 00:00:00 2001
From: Heiko Carstens <hca@linux.ibm.com>
Date: Fri, 18 Jun 2021 16:58:47 +0200
Subject: [PATCH] s390/stack: fix possible register corruption with stack
 switch helper

[ Upstream commit 67147e96a332b56c7206238162771d82467f86c0 ]

The CALL_ON_STACK macro is used to call a C function from inline
assembly, and therefore must consider the C ABI, which says that only
registers 6-13, and 15 are non-volatile (restored by the called
function).

The inline assembly incorrectly marks all registers used to pass
parameters to the called function as read-only input operands, instead
of operands that are read and written to. This might result in
register corruption depending on usage, compiler, and compile options.

Fix this by marking all operands used to pass parameters as read/write
operands. To keep the code simple even register 6, if used, is marked
as read-write operand.

Fixes: ff340d2472ec ("s390: add stack switch helper")
Cc: <stable@kernel.org> # 4.20
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
---
 arch/s390/include/asm/stacktrace.h | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/stacktrace.h b/arch/s390/include/asm/stacktrace.h
index 3679d224fd3c..6836532f8d1a 100644
--- a/arch/s390/include/asm/stacktrace.h
+++ b/arch/s390/include/asm/stacktrace.h
@@ -79,12 +79,16 @@ struct stack_frame {
 	CALL_ARGS_4(arg1, arg2, arg3, arg4);				\
 	register unsigned long r4 asm("6") = (unsigned long)(arg5)
 
-#define CALL_FMT_0 "=&d" (r2) :
-#define CALL_FMT_1 "+&d" (r2) :
-#define CALL_FMT_2 CALL_FMT_1 "d" (r3),
-#define CALL_FMT_3 CALL_FMT_2 "d" (r4),
-#define CALL_FMT_4 CALL_FMT_3 "d" (r5),
-#define CALL_FMT_5 CALL_FMT_4 "d" (r6),
+/*
+ * To keep this simple mark register 2-6 as being changed (volatile)
+ * by the called function, even though register 6 is saved/nonvolatile.
+ */
+#define CALL_FMT_0 "=&d" (r2)
+#define CALL_FMT_1 "+&d" (r2)
+#define CALL_FMT_2 CALL_FMT_1, "+&d" (r3)
+#define CALL_FMT_3 CALL_FMT_2, "+&d" (r4)
+#define CALL_FMT_4 CALL_FMT_3, "+&d" (r5)
+#define CALL_FMT_5 CALL_FMT_4, "+&d" (r6)
 
 #define CALL_CLOBBER_5 "0", "1", "14", "cc", "memory"
 #define CALL_CLOBBER_4 CALL_CLOBBER_5
@@ -105,7 +109,7 @@ struct stack_frame {
 		"	brasl	14,%[_fn]\n"				\
 		"	la	15,0(%[_prev])\n"			\
 		: [_prev] "=&a" (prev), CALL_FMT_##nr			\
-		  [_stack] "a" (stack),					\
+		: [_stack] "a" (stack),					\
 		  [_bc] "i" (offsetof(struct stack_frame, back_chain)),	\
 		  [_fn] "X" (fn) : CALL_CLOBBER_##nr);			\
 	r2;								\
-- 
2.25.1

