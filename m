Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F62D45031B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 12:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237681AbhKOLJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 06:09:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58274 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237746AbhKOLIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 06:08:51 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AF8HcRO019648;
        Mon, 15 Nov 2021 11:05:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=rw8VBGcwKL65pvLfNCOPcvXjqxWYbXVshkapZP1Bm74=;
 b=R0RSO/Mze2iYf/XN5ZUQ58Vi1n07tgDdQECF6LhXN3/PY9l6gLwwSv6HNVjUV/m0eP6D
 DH4J6y8xE1H5WKbMB5argF6SoO0GzoFWCyjeyUSsODT6S06UwjItjNUaTJCL0o+yWhkr
 DPpG5KkG21vk6n2moP/llxRWW7p7wMA31iNAa22fafHkNLT2FmczcVMFvmRwkbT3Wzo/
 IZZxDV9O5TCLrxnbbix5GWySJIopSEkXyKh9qY4vL/pyc5A2NJuBJQ1htVsMZqunltnA
 uyRRsQOKnSmu6qNqwjgzEKiJj9hlXp23ocYvtnZsAiNvpWLvqWVyJP3/fQywyk+x8m2Y 2A== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cbkwq32vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:05:41 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AFB1bXv008140;
        Mon, 15 Nov 2021 11:05:40 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3ca509mj7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:05:39 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AFB5buj54001924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 11:05:37 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90FFDA406F;
        Mon, 15 Nov 2021 11:05:37 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5677FA4083;
        Mon, 15 Nov 2021 11:05:36 +0000 (GMT)
Received: from naverao1-tp.ibm.com (unknown [9.43.37.229])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Nov 2021 11:05:36 +0000 (GMT)
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     <stable@vger.kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.19 0/5] powerpc/bpf: Various fixes
Date:   Mon, 15 Nov 2021 16:35:27 +0530
Message-Id: <cover.1636968020.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ETgYMlj9N0lx7V1w707E2vRU0mnb5otp
X-Proofpoint-ORIG-GUID: ETgYMlj9N0lx7V1w707E2vRU0mnb5otp
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_10,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 phishscore=0 mlxlogscore=739 mlxscore=0 adultscore=0
 spamscore=0 malwarescore=0 clxscore=1015 bulkscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111150061
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a backport of the remaining patches from the below series:
https://lore.kernel.org/all/cover.1633464148.git.naveen.n.rao@linux.vnet.ibm.com/

Kindly apply to the longterm tree for v4.19

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
 arch/powerpc/net/bpf_jit_comp64.c            | 93 ++++++++++++++++----
 7 files changed, 118 insertions(+), 34 deletions(-)


base-commit: 3033e5726834e4c9c8c48cdb2273f33bd105f938
-- 
2.33.1

