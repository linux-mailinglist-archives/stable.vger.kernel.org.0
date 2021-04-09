Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7135359B0B
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhDIKHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:07:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234077AbhDIKE0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:04:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94F026128C;
        Fri,  9 Apr 2021 10:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962465;
        bh=remeRqQSZdAKtDQ5b6HvkjLjZMA0xfhMsjcWwvk6B7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zHNvXF9zNEXT6rX4vvRh9JdJfmPsiH1xGklAXWbhK6a04olCYsHFPjaHCszTKLyAF
         Ii/WiOQ0KergsyyR1PFJzoOgVrIe14yEM5EVmJnAB+c+aMgm9DoW0r4rEZTaF2vD/l
         c/PMdE/fwnJPU6PtsnwZn6ckK7Vr9mDN3xEMnUjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "David E. Box" <david.e.box@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 25/45] platform/x86: intel_pmt_class: Initial resource to 0
Date:   Fri,  9 Apr 2021 11:53:51 +0200
Message-Id: <20210409095306.223969623@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095305.397149021@linuxfoundation.org>
References: <20210409095305.397149021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David E. Box <david.e.box@linux.intel.com>

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
2.30.2



