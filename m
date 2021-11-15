Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04393450329
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 12:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237663AbhKOLKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 06:10:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59682 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231502AbhKOLJr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 06:09:47 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AFA5C1X019509;
        Mon, 15 Nov 2021 11:06:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=jktOavGF740NMbTzUVQA/3yWJh+Q7ho1B5I03794+Tg=;
 b=kR69mQ4KZ17kZQzZSboxsg9erFmhOQp4hnke2hR35o2YTRiaK9XXeDBCpQ0oYJsFYrDy
 52Hw81RMzHLqg8AfbBaanKO8aYloQ5UYpq8OjKiih/lyxT6cHCm/5LDM90kDveJopzCA
 Q9Q++o9RErIxUw6DiC3RtgSgUAUnHJ+AIiA5IJgXc/9lh5oCucx3+CqPiGq8mMgN83KF
 uczujLQJjpHyzTV8jKl0/j7AVfX73wD05LXHx9v81FZECzczI+Gm1impr9x0Qg+Uz4nU
 DeYOx7AUi3gALSfkWTt7YAz4+c8lQq9hycl5784bo6oBelpzV8gRK+wsDd0kGOhnR428 Yg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cbf32s0g4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:06:39 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AFB1brb008153;
        Mon, 15 Nov 2021 11:06:37 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3ca509mjdu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:06:37 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AFB6Zt36423122
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 11:06:35 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 082B8A407C;
        Mon, 15 Nov 2021 11:06:35 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C131FA4081;
        Mon, 15 Nov 2021 11:06:33 +0000 (GMT)
Received: from naverao1-tp.ibm.com (unknown [9.43.37.229])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Nov 2021 11:06:33 +0000 (GMT)
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     <stable@vger.kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.10 0/4] powerpc/bpf: Various fixes
Date:   Mon, 15 Nov 2021 16:36:26 +0530
Message-Id: <cover.1636963563.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 72xLV3ftVF_ijLCKCzd_PPudvb5J9Drj
X-Proofpoint-ORIG-GUID: 72xLV3ftVF_ijLCKCzd_PPudvb5J9Drj
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_10,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=705 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111150061
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a backport of the remaining patches from the below series:
https://lore.kernel.org/all/cover.1633464148.git.naveen.n.rao@linux.vnet.ibm.com/

Kindly apply to the longterm tree for v5.10

Thanks,
Naveen


Naveen N. Rao (4):
  powerpc/lib: Add helper to check if offset is within conditional
    branch range
  powerpc/bpf: Validate branch ranges
  powerpc/security: Add a helper to query stf_barrier type
  powerpc/bpf: Emit stf barrier instruction sequences for BPF_NOSPEC

 arch/powerpc/include/asm/code-patching.h     |  1 +
 arch/powerpc/include/asm/security_features.h |  5 ++
 arch/powerpc/kernel/security.c               |  5 ++
 arch/powerpc/lib/code-patching.c             |  7 ++-
 arch/powerpc/net/bpf_jit.h                   | 33 ++++++----
 arch/powerpc/net/bpf_jit64.h                 |  8 +--
 arch/powerpc/net/bpf_jit_comp64.c            | 64 ++++++++++++++++++--
 7 files changed, 100 insertions(+), 23 deletions(-)


base-commit: 5040520482a594e92d4f69141229a6dd26173511
-- 
2.33.1

