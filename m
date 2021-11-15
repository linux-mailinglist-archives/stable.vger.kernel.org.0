Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFDF450301
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 12:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhKOLEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 06:04:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9090 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237737AbhKOLD7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 06:03:59 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AF8HaHH019572;
        Mon, 15 Nov 2021 11:00:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=PKzxVWVUV6MatKAyb47OjnPyhJuQHrgGrp/z1yPrmrs=;
 b=bRXXVO5G0BLHsqF9DKmA2miKweQwNaTnoh1JPrIj5+NPJw+LoKZ5GAD27AFDXaAweZlU
 a1RBQpn70dLYkTehtLRecdRXcMfTWpUjLgWSNE6LkjaSAPwMlI8NfaC+dDbJcJmFBxVq
 WNe1mbhQatMiXAzZrnxyP/1FLQV9MX5tvC4b990IN+d8J/dP83a0gXSumC0izEgUkRwY
 5wsF21HbwDNF1qAPs77eTnL7/ms0E3PKg0Ipr6vJ0SEnxNqjPJsGuAf9amBvVKTOa8tB
 LTQzcIEKVuJIz3s51RjykvsDW68aM7eMWymc8YfeezRlEW0IcrXDKH5GuCoUYimuuTWk VA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cbkwq2ya1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:00:46 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AFAwv6p024105;
        Mon, 15 Nov 2021 11:00:45 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3ca4mjkwhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:00:45 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AFArnvn46072152
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 10:53:49 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3EC65206D;
        Mon, 15 Nov 2021 11:00:42 +0000 (GMT)
Received: from naverao1-tp.ibm.com (unknown [9.43.37.229])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 761C252054;
        Mon, 15 Nov 2021 11:00:41 +0000 (GMT)
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     <stable@vger.kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.9 0/2] powerpc/bpf: Various fixes
Date:   Mon, 15 Nov 2021 16:30:35 +0530
Message-Id: <cover.1636969865.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PcZ3I9xDBwSlaCUyAxO2TTKeRwsuEuw1
X-Proofpoint-ORIG-GUID: PcZ3I9xDBwSlaCUyAxO2TTKeRwsuEuw1
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_10,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 phishscore=0 mlxlogscore=733 mlxscore=0 adultscore=0
 spamscore=0 malwarescore=0 clxscore=1011 bulkscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111150057
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a backport of the remaining patches from the below series:
https://lore.kernel.org/all/cover.1633464148.git.naveen.n.rao@linux.vnet.ibm.com/

Kindly apply to the longterm tree for v4.9

Thanks,
Naveen


Naveen N. Rao (2):
  powerpc/bpf: Validate branch ranges
  powerpc/bpf: Fix BPF_SUB when imm == 0x80000000

 arch/powerpc/net/bpf_jit.h        | 25 ++++++++++++++++-----
 arch/powerpc/net/bpf_jit_comp64.c | 37 ++++++++++++++++++++-----------
 2 files changed, 43 insertions(+), 19 deletions(-)


base-commit: 59d4178b517472a1f023886baded2191458a76b5
-- 
2.33.1

