Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E00B657A10
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbiL1PH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233591AbiL1PH0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:07:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1E413D7C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:07:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D8D161553
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D47BC433D2;
        Wed, 28 Dec 2022 15:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240044;
        bh=5mTxK/RncLcU3rrenc/5jESFvzS91oTeb9pVSlhc/ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eder/KgTNFY1azEwZDU4AITR9TtafKEa/xsWJwRTZJfVjZDIH5uUwy+XYXL88LCVb
         WBvVmEinpXJ17/E8isDcO6KCkN3k+w8hBQ5PGNuy65Rkyj6PLGXZucJ1Fl+9kxZ3OO
         NCKND/S+c9i0FqxbsVtBpiNdaXgthg/wrtdw2Hdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0111/1073] ACPI: irq: Fix some kernel-doc issues
Date:   Wed, 28 Dec 2022 15:28:19 +0100
Message-Id: <20221228144331.057375208@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit ebb92d58b90753e658059f5d8590d9048395491a ]

The following commit change the second parameter of acpi_set_irq_model()
but forgot to update the function description. Let's fix it.

  commit 7327b16f5f56 ("APCI: irq: Add support for multiple GSI domains")

Also add description of parameter 'gsi' for
acpi_get_irq_source_fwhandle() to avoid the following build W=1 warning.

  drivers/acpi/irq.c:108: warning: Function parameter or member 'gsi' not described in 'acpi_get_irq_source_fwhandle'

Fixes: 7327b16f5f56 ("APCI: irq: Add support for multiple GSI domains")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/irq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/irq.c b/drivers/acpi/irq.c
index dabe45eba055..0d9a17fdd83e 100644
--- a/drivers/acpi/irq.c
+++ b/drivers/acpi/irq.c
@@ -94,6 +94,7 @@ EXPORT_SYMBOL_GPL(acpi_unregister_gsi);
 /**
  * acpi_get_irq_source_fwhandle() - Retrieve fwhandle from IRQ resource source.
  * @source: acpi_resource_source to use for the lookup.
+ * @gsi: GSI IRQ number
  *
  * Description:
  * Retrieve the fwhandle of the device referenced by the given IRQ resource
@@ -295,8 +296,8 @@ EXPORT_SYMBOL_GPL(acpi_irq_get);
 /**
  * acpi_set_irq_model - Setup the GSI irqdomain information
  * @model: the value assigned to acpi_irq_model
- * @fwnode: the irq_domain identifier for mapping and looking up
- *          GSI interrupts
+ * @fn: a dispatcher function that will return the domain fwnode
+ *	for a given GSI
  */
 void __init acpi_set_irq_model(enum acpi_irq_model_id model,
 			       struct fwnode_handle *(*fn)(u32))
-- 
2.35.1



