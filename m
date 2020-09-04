Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D3A25D4CE
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 11:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbgIDJ1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 05:27:40 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2755 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729835AbgIDJ1W (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 05:27:22 -0400
Received: from lhreml742-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 47177DE6EC3476AF8C45;
        Fri,  4 Sep 2020 10:27:21 +0100 (IST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 lhreml742-chm.china.huawei.com (10.201.108.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Fri, 4 Sep 2020 10:27:21 +0100
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.160)
 by fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1913.5; Fri, 4 Sep 2020 11:27:20 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 02/12] ima: Remove semicolon at the end of ima_get_binary_runtime_size()
Date:   Fri, 4 Sep 2020 11:23:29 +0200
Message-ID: <20200904092339.19598-3-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.27.GIT
In-Reply-To: <20200904092339.19598-1-roberto.sassu@huawei.com>
References: <20200904092339.19598-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.65.160]
X-ClientProxiedBy: lhreml709-chm.china.huawei.com (10.201.108.58) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch removes the unnecessary semicolon at the end of
ima_get_binary_runtime_size().

Cc: stable@vger.kernel.org
Fixes: d158847ae89a2 ("ima: maintain memory size needed for serializing the measurement list")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/ima/ima_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
index fb4ec270f620..c096ef8945c7 100644
--- a/security/integrity/ima/ima_queue.c
+++ b/security/integrity/ima/ima_queue.c
@@ -133,7 +133,7 @@ unsigned long ima_get_binary_runtime_size(void)
 		return ULONG_MAX;
 	else
 		return binary_runtime_size + sizeof(struct ima_kexec_hdr);
-};
+}
 
 static int ima_pcr_extend(struct tpm_digest *digests_arg, int pcr)
 {
-- 
2.27.GIT

