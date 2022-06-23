Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BECE65580C5
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233692AbiFWQx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbiFWQwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:52:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D261BC70;
        Thu, 23 Jun 2022 09:52:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6ACD861F90;
        Thu, 23 Jun 2022 16:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E58DC3411B;
        Thu, 23 Jun 2022 16:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003143;
        bh=EfjHEXngIHb1NkNDfPiBcIIYBBCupQ5bhVJ1+ujLLhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pAVaFw3siPbdXJilJnXm5cVHZxYeQ/JxHu//hE56WA+pkE3pSvo+vAEGxd0TLOTsx
         rop7wVIUj6J3Cw5agEWX9ONyJmGs/9ToWS+W3TCD7OIJP+QS8tMBKXkSZlYzUr4lAW
         h38VgWLCHxIeQ4wSR4Cba8Ck/Irp0Zjo9nQQ8G2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 145/264] hwrng: core - do not use multiple blank lines
Date:   Thu, 23 Jun 2022 18:42:18 +0200
Message-Id: <20220623164348.168438952@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin LABBE <clabbe.montjoie@gmail.com>

commit 6bc17d90e62d16828d1a2113b54cfa4e04582fb6 upstream.

This patch fix the checkpatch warning "Please don't use multiple blank lines"

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/core.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -30,7 +30,6 @@
 
  */
 
-
 #include <linux/device.h>
 #include <linux/hw_random.h>
 #include <linux/module.h>
@@ -45,12 +44,10 @@
 #include <linux/err.h>
 #include <asm/uaccess.h>
 
-
 #define RNG_MODULE_NAME		"hw_random"
 #define PFX			RNG_MODULE_NAME ": "
 #define RNG_MISCDEV_MINOR	183 /* official */
 
-
 static struct hwrng *current_rng;
 static struct task_struct *hwrng_fill;
 static LIST_HEAD(rng_list);
@@ -296,7 +293,6 @@ out_put:
 	goto out;
 }
 
-
 static const struct file_operations rng_chrdev_ops = {
 	.owner		= THIS_MODULE,
 	.open		= rng_dev_open,
@@ -314,7 +310,6 @@ static struct miscdevice rng_miscdev = {
 	.groups		= rng_dev_groups,
 };
 
-
 static ssize_t hwrng_attr_current_store(struct device *dev,
 					struct device_attribute *attr,
 					const char *buf, size_t len)


