Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3463C657AC0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbiL1POo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233117AbiL1PO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:14:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C5213EBB
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:14:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4A0A6155F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52C5C433D2;
        Wed, 28 Dec 2022 15:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240465;
        bh=NJFNp4F21/1fDeKzHeY4xY5wc0AAoHfUqzNFDzZmiX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uP88o9d9ElOL55xsTZ8rzBGnPIt7ENgadaOj7/jJOAl4cv4oY25YAUt69n5xUBxVq
         HfK66A15ccnh+TSHubA2oxLJbgK6vIepbWnRpGlXWpc8G76BuM+ZFhqkOGB8SKa8jw
         o+4QFbaoPClVhML9fGUyMbWLdEE6KW45xYtjR5wM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0122/1146] ACPI: irq: Fix some kernel-doc issues
Date:   Wed, 28 Dec 2022 15:27:41 +0100
Message-Id: <20221228144333.470034820@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index 1cc4647f78b8..c2c786eb95ab 100644
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
@@ -297,8 +298,8 @@ EXPORT_SYMBOL_GPL(acpi_irq_get);
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



