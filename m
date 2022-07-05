Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530D2566B4B
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbiGEMFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbiGEMEf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:04:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0936418B1C;
        Tue,  5 Jul 2022 05:04:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5B4D7CE1B86;
        Tue,  5 Jul 2022 12:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5697DC341C7;
        Tue,  5 Jul 2022 12:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022656;
        bh=4r/lnZsmlmpO0BQfSAkzvfd7sMwi3ZNjPndOr1+bnlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ksiBslnzFAZs0qj8ETYlhcsomcdLlwjKvOY3QX7lSHcdsg+epPythc0aV4lmIu5QP
         8RbEnd3zk/P1J1GTCfEchRhzA66FagBY7unEKQyqM8Keuqyf5c9mfjS1ffIo0htKz6
         KJwtIEgPPTyyTkzzyxTL6CKFHxTtbbo3rznyBkQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 5.4 21/58] s390: remove unneeded select BUILD_BIN2C
Date:   Tue,  5 Jul 2022 13:57:57 +0200
Message-Id: <20220705115610.874402162@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115610.236040773@linuxfoundation.org>
References: <20220705115610.236040773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 25deecb21c18ee29e3be8ac6177b2a9504c33d2d upstream.

Since commit 4c0f032d4963 ("s390/purgatory: Omit use of bin2c"),
s390 builds the purgatory without using bin2c.

Remove 'select BUILD_BIN2C' to avoid the unneeded build of bin2c.

Fixes: 4c0f032d4963 ("s390/purgatory: Omit use of bin2c")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20220613170902.1775211-1-masahiroy@kernel.org
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -541,7 +541,6 @@ config KEXEC
 config KEXEC_FILE
 	bool "kexec file based system call"
 	select KEXEC_CORE
-	select BUILD_BIN2C
 	depends on CRYPTO
 	depends on CRYPTO_SHA256
 	depends on CRYPTO_SHA256_S390


