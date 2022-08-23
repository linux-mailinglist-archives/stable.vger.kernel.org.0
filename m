Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C8359D4E7
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243269AbiHWIc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243031AbiHWI3J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:29:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DE07392F;
        Tue, 23 Aug 2022 01:15:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 487EE61338;
        Tue, 23 Aug 2022 08:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33756C433D6;
        Tue, 23 Aug 2022 08:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242465;
        bh=sZA4j3WfRODB02016YMFjVMHgF4nnVisj24HWC5yEA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nP1YcKdQk2xQYYczAAbp2FngtkMlrN1+yy/Q6t8pSgeAqHdHoxnAnKBYQ6NlNEBWe
         7zzH7UELKKK9jy8mxtD3F7tLDW/S0745cLdLpLLxa+Ka9usPFafYKHTp3E57ffltOf
         7vbojNkjIt9Mtz1jB9fPFCdXxP1UImhMGNtwAPD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.19 119/365] ACPI: property: Return type of acpi_add_nondev_subnodes() should be bool
Date:   Tue, 23 Aug 2022 10:00:20 +0200
Message-Id: <20220823080123.173129219@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 85140ef275f577f64e8a2c5789447222dfc14fc4 upstream.

The value acpi_add_nondev_subnodes() returns is bool so change the return
type of the function to match that.

Fixes: 445b0eb058f5 ("ACPI / property: Add support for data-only subnodes")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/property.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -155,10 +155,10 @@ static bool acpi_nondev_subnode_ok(acpi_
 	return acpi_nondev_subnode_data_ok(handle, link, list, parent);
 }
 
-static int acpi_add_nondev_subnodes(acpi_handle scope,
-				    const union acpi_object *links,
-				    struct list_head *list,
-				    struct fwnode_handle *parent)
+static bool acpi_add_nondev_subnodes(acpi_handle scope,
+				     const union acpi_object *links,
+				     struct list_head *list,
+				     struct fwnode_handle *parent)
 {
 	bool ret = false;
 	int i;


