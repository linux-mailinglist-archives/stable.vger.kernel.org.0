Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83F1D566BC3
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbiGEMJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234957AbiGEMIN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:08:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A50186F1;
        Tue,  5 Jul 2022 05:07:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A406F61968;
        Tue,  5 Jul 2022 12:07:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B304BC341CB;
        Tue,  5 Jul 2022 12:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022841;
        bh=9WUR7wsYVs6fTDwuVts3+ftYZs+EiI8bnRN5ph2z1TU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SY7aRqgxpF5BOEKV6cXhdHsRF6Ctlv//66p7knvgdovh8dpyMDBCoCM8/nweDBDUZ
         Lm8i3Jj0QEuO6nYh7nvWSt0bu4ub9fsV/rf37Jak/w6qLR9XQQGbjx8pSkXq3Nepaj
         JkuK5EJ5usYHzDLJh9JbEYBx84M+Hk2LDJ3Luf4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 5.10 29/84] s390: remove unneeded select BUILD_BIN2C
Date:   Tue,  5 Jul 2022 13:57:52 +0200
Message-Id: <20220705115616.175548908@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
References: <20220705115615.323395630@linuxfoundation.org>
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
@@ -507,7 +507,6 @@ config KEXEC
 config KEXEC_FILE
 	bool "kexec file based system call"
 	select KEXEC_CORE
-	select BUILD_BIN2C
 	depends on CRYPTO
 	depends on CRYPTO_SHA256
 	depends on CRYPTO_SHA256_S390


