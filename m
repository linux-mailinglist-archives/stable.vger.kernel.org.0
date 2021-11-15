Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8375245030E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 12:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhKOLIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 06:08:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6876 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231282AbhKOLI1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 06:08:27 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AF9E6x7006323;
        Mon, 15 Nov 2021 11:05:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=XUwii6mK56tGfQn0tsmykabaCGBUdlpuDjayEtjbZa8=;
 b=dYOsiekewmLjAkKpTbsQKrZ3KYvWs3qOKsVjwkeE57R94144952pVS2Z2Crt3eTwFdLk
 RaCElO5vOteOXWZXI7+aazRuy0tmPC8vZuc2FYNzlLDxvL7ToyoHounLgGAPQixtU311
 trUCsw5/V2dyfoCj7tBwt8K7vGnd80vUDZDJtw8gD+0M0nykvLytQiHKxaoUa527ZXOy
 oV4ubucuyzcnUhw/Edhdbwwincmw+mx2NbyL5AtNErwlFLuAIXtcRZtFl8hw8OLoNdQA
 keXujRfA5ZfLspf61yx5M+qw61ewBntT+3hdnFUxJOGJFnh4fnSBZ9mtAK/wSGDKn/U/ kQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cbmqwa2jf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:05:16 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AFB35fS002711;
        Mon, 15 Nov 2021 11:05:14 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3ca4mjcmsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:05:14 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AFB5CiR62587334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 11:05:12 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04FF5A4089;
        Mon, 15 Nov 2021 11:05:12 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9442A406B;
        Mon, 15 Nov 2021 11:05:10 +0000 (GMT)
Received: from naverao1-tp.ibm.com (unknown [9.43.37.229])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Nov 2021 11:05:10 +0000 (GMT)
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     <stable@vger.kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.14 0/3] powerpc/bpf: Various fixes
Date:   Mon, 15 Nov 2021 16:35:05 +0530
Message-Id: <cover.1636968906.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3i9hkVHSNk2lzUEoHju979SKF6shCWd1
X-Proofpoint-ORIG-GUID: 3i9hkVHSNk2lzUEoHju979SKF6shCWd1
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 11 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_09,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 malwarescore=0 adultscore=0 mlxlogscore=669 bulkscore=0 impostorscore=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111150061
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a backport of the remaining patches from the below series:
https://lore.kernel.org/all/cover.1633464148.git.naveen.n.rao@linux.vnet.ibm.com/

Kindly apply to the longterm tree for v4.14

Thanks,
Naveen


Naveen N. Rao (3):
  powerpc/lib: Add helper to check if offset is within conditional
    branch range
  powerpc/bpf: Validate branch ranges
  powerpc/bpf: Fix BPF_SUB when imm == 0x80000000

 arch/powerpc/include/asm/code-patching.h |  1 +
 arch/powerpc/lib/code-patching.c         |  7 ++++-
 arch/powerpc/net/bpf_jit.h               | 33 +++++++++++++--------
 arch/powerpc/net/bpf_jit_comp64.c        | 37 +++++++++++++++---------
 4 files changed, 52 insertions(+), 26 deletions(-)


base-commit: 0447aa205abe1c0c016b4f7fa9d7c08d920b5c8e
-- 
2.33.1

