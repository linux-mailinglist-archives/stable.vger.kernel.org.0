Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A2B65B950
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 03:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236508AbjACCW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 21:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236553AbjACCW5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 21:22:57 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3151B7CC;
        Mon,  2 Jan 2023 18:22:54 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NmGgs1fk8z16LyW;
        Tue,  3 Jan 2023 10:21:29 +0800 (CST)
Received: from huawei.com (10.67.175.31) by dggpemm500024.china.huawei.com
 (7.185.36.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 3 Jan
 2023 10:22:52 +0800
From:   GUO Zihua <guozihua@huawei.com>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <zohar@linux.ibm.com>
CC:     <paul@paul-moore.com>, <linux-integrity@vger.kernel.org>,
        <luhuaxin1@huawei.com>
Subject: [PATCH v2 0/2] ima: Fix IMA mishandling of LSM based rule during
Date:   Tue, 3 Jan 2023 10:20:09 +0800
Message-ID: <20230103022011.15741-1-guozihua@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.31]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backports the following two patches to fix the issue of IMA mishandling
LSM based rule during LSM policy update, causing a file to match an
unexpected rule.

Some changes were made to these patches, which was stated in the commit
message of corresponding patch.

GUO Zihua (1):
  ima: Handle -ESTALE returned by ima_filter_rule_match()

Janne Karhunen (1):
  ima: use the lsm policy update notifier

 security/integrity/ima/ima.h        |   2 +
 security/integrity/ima/ima_main.c   |   8 ++
 security/integrity/ima/ima_policy.c | 153 +++++++++++++++++++++++-----
 3 files changed, 137 insertions(+), 26 deletions(-)

-- 
2.17.1

