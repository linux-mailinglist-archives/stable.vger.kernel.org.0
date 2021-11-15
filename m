Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07BDC45031D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 12:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237758AbhKOLJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 06:09:37 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58230 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237712AbhKOLJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 06:09:24 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AFAxUoj022822;
        Mon, 15 Nov 2021 11:06:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=cql9u6bIllhR3CN0f1xLpeRmVluAvB2XaEboEN7m1oQ=;
 b=e4okCo+m9WDixdxQqmMt1/ogdaLbsnqfNxbEQ/fo0iNgBW74pSMuSw/kaxgxE6bfALlU
 ZpjgL675JqCMOsD306JLL3HMgyVLtp8IY0cNpNNTXTwvun7Ma4mluf0Hs7rr4HxPsMJv
 ihCRpfbi7cTvN4i2pADpQRcheYQ7rDHxNxq+uRRYRVHcpyrtltKv6mtkAC9Cx4u/qpfI
 nu+pqfibWKgyGrRYcR2DkWjKSILKM6+pOm3kSzMQ/A+5MrHHmefFW2KfYapzoyUSuIHe
 DnQsKNx4sMKz9j1OeUbb45fQcdMFnV0ZT1KIc/XOch/geonz9avtEpBTmzu0bUO/H+r2 jA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cbcw1b23q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:06:14 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AFB38rw014125;
        Mon, 15 Nov 2021 11:06:11 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3ca50amhdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:06:11 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AFAxF7n60686842
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 10:59:16 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED4AFA407C;
        Mon, 15 Nov 2021 11:06:08 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9547A4091;
        Mon, 15 Nov 2021 11:06:07 +0000 (GMT)
Received: from naverao1-tp.ibm.com (unknown [9.43.37.229])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Nov 2021 11:06:07 +0000 (GMT)
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     <stable@vger.kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.4 0/5] powerpc/bpf: Various fixes
Date:   Mon, 15 Nov 2021 16:35:59 +0530
Message-Id: <cover.1636963359.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: I2v8G8PZVOF7LPDvRFJHmPERZaHXbzFT
X-Proofpoint-ORIG-GUID: I2v8G8PZVOF7LPDvRFJHmPERZaHXbzFT
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_10,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=751
 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111150061
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a backport of the remaining patches from the below series:
https://lore.kernel.org/all/cover.1633464148.git.naveen.n.rao@linux.vnet.ibm.com/

Kindly apply to the longterm tree for v5.4

Thanks,
Naveen


Naveen N. Rao (5):
  powerpc/lib: Add helper to check if offset is within conditional
    branch range
  powerpc/bpf: Validate branch ranges
  powerpc/bpf: Fix BPF_SUB when imm == 0x80000000
  powerpc/security: Add a helper to query stf_barrier type
  powerpc/bpf: Emit stf barrier instruction sequences for BPF_NOSPEC

 arch/powerpc/include/asm/code-patching.h     |  1 +
 arch/powerpc/include/asm/security_features.h |  5 ++
 arch/powerpc/kernel/security.c               |  5 ++
 arch/powerpc/lib/code-patching.c             |  7 +-
 arch/powerpc/net/bpf_jit.h                   | 33 ++++---
 arch/powerpc/net/bpf_jit64.h                 |  8 +-
 arch/powerpc/net/bpf_jit_comp64.c            | 91 ++++++++++++++++----
 7 files changed, 117 insertions(+), 33 deletions(-)


base-commit: c65356f0f7268b1260dd64415c2145e73640872e
-- 
2.33.1

