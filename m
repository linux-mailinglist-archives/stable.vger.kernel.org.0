Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063EA34DA5E
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhC2WWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:22:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231962AbhC2WWI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:22:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08B6D6198F;
        Mon, 29 Mar 2021 22:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056527;
        bh=tQJoCxpovS4upu8UjYSn8Ty5bw8x9UQbHWn+lFOYW7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J5AhQ3n0veD19VksB1sV0pfnOZX2qiknGVGF2auOG9tRHhQfQWouoAwz7LQSlzBcx
         uHBYNSNQUD+dAYcc34TUZLhZtv0v/HiduO6FbXYwkuhOtXAKinQz6CGz0PR/cFjzqd
         DBcnVBMcSSPRFrOTlE66vXkDXoV3SHm5M1OyZqyft0SsgSVNh+TVyYaK7CbPen5bv/
         5KW9rZJ4/IDSapqYNGuN7LOz2MmGViJs0aJTfmvwZoCTC1VErJY+WaMIdc1IpHktVv
         BzBFzJIXx9fouo0trtgriM49S7o7Y0OYNygFYldmaoX144DaUi8JPJBeUhb9QzmF9A
         IPJNkJqbj9sHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "David E. Box" <david.e.box@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 27/38] platform/x86: intel_pmt_class: Initial resource to 0
Date:   Mon, 29 Mar 2021 18:21:22 -0400
Message-Id: <20210329222133.2382393-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222133.2382393-1-sashal@kernel.org>
References: <20210329222133.2382393-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "David E. Box" <david.e.box@linux.intel.com>

[ Upstream commit 7547deff8a221e6bf1e563cf1b636844a8e5378a ]

Initialize the struct resource in intel_pmt_dev_register to zero to avoid a
fault should the char *name field be non-zero.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: https://lore.kernel.org/r/20210317024455.3071477-1-david.e.box@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_pmt_class.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel_pmt_class.c b/drivers/platform/x86/intel_pmt_class.c
index c8939fba4509..ee2b3bbeb83d 100644
--- a/drivers/platform/x86/intel_pmt_class.c
+++ b/drivers/platform/x86/intel_pmt_class.c
@@ -173,7 +173,7 @@ static int intel_pmt_dev_register(struct intel_pmt_entry *entry,
 				  struct intel_pmt_namespace *ns,
 				  struct device *parent)
 {
-	struct resource res;
+	struct resource res = {0};
 	struct device *dev;
 	int ret;
 
-- 
2.30.1

