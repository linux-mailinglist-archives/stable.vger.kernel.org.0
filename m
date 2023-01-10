Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB0BB664A57
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234673AbjAJScc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239417AbjAJSbe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:31:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDC69748E
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:26:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 109596184D
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:26:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D0FC433EF;
        Tue, 10 Jan 2023 18:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375209;
        bh=a3SrtMPOpfa7g6GNQtdu1xyMFAj+xosFpM/Tc6gTXWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QddIrm7aQSRveZmICkwAsNsxMd7OHI2Gtz65JtVxiUKsYPN6RzoHkdSu8f3WR0RV3
         CH0Q6JMsBi6BJ+j5k7lg7LRPN+fH4ows/1nj+W7tiwz9Ohl0Gsxvx9MaCo7rOgNNJV
         fiQRYPZU5QAZ4JXw6CRame2Tzdgf9YG3Dpto5gAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Aditya Garg <gargaditya08@live.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.15 115/290] efi: Add iMac Pro 2017 to uefi skip cert quirk
Date:   Tue, 10 Jan 2023 19:03:27 +0100
Message-Id: <20230110180035.767137370@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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
 


