Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54EED667787
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239795AbjALOpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239858AbjALOoK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:44:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DCD63399
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:32:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30F0E60A69
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C98CC433EF;
        Thu, 12 Jan 2023 14:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533965;
        bh=a3SrtMPOpfa7g6GNQtdu1xyMFAj+xosFpM/Tc6gTXWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JoTBKlc3qzXG7vNzoV8F99JUcTn7TDvga18BnCe+1lGWv5aRNSNUDqYbMd0ZaulA5
         XkRA2sXqTPMwPD8fzxmH3uR1Q9E7TeQAG6IaVZmjEAmt3N8pjBTtA5JxNhsN1S30c0
         kiyccjT4cc5qKLl1qqrFLjEG95vO+RVE3fqXBqco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Aditya Garg <gargaditya08@live.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.10 650/783] efi: Add iMac Pro 2017 to uefi skip cert quirk
Date:   Thu, 12 Jan 2023 14:56:06 +0100
Message-Id: <20230112135554.457471261@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Aditya Garg <gargaditya08@live.com>

commit 0be56a116220f9e5731a6609e66a11accfe8d8e2 upstream.

The iMac Pro 2017 is also a T2 Mac. Thus add it to the list of uefi skip
cert.

Cc: stable@vger.kernel.org
Fixes: 155ca952c7ca ("efi: Do not import certificates from UEFI Secure Boot for T2 Macs")
Link: https://lore.kernel.org/linux-integrity/9D46D92F-1381-4F10-989C-1A12CD2FFDD8@live.com/
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/platform_certs/load_uefi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/security/integrity/platform_certs/load_uefi.c
+++ b/security/integrity/platform_certs/load_uefi.c
@@ -34,6 +34,7 @@ static const struct dmi_system_id uefi_s
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacPro7,1") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,1") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,2") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMacPro1,1") },
 	{ }
 };
 


