Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F489566D96
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237526AbiGEMZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237709AbiGEMXv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:23:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306C41F2E0;
        Tue,  5 Jul 2022 05:16:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6DE6B817D6;
        Tue,  5 Jul 2022 12:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBDFC341C7;
        Tue,  5 Jul 2022 12:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023416;
        bh=L6W946gDPDBiH7ixPIjiusMUY8nSzKlUbNgjnc8rI0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQq0Tg2kRvE3+lAEapMyzXUhCszhcwyKIX+XILfGQV5JGxqPTDjaggOfk6Q27Gq+B
         V3kfjulNWbEcz8FrRW3gvk7iV6K53qg29GQMN8DWuQ8CtzrCkaVbf/Udl11Pzrvk5m
         CPt/jGzHOsQbnbatQyvSB8WCev4vZKwFInwNKXs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 5.18 053/102] s390: remove unneeded select BUILD_BIN2C
Date:   Tue,  5 Jul 2022 13:58:19 +0200
Message-Id: <20220705115619.912823850@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
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
@@ -487,7 +487,6 @@ config KEXEC
 config KEXEC_FILE
 	bool "kexec file based system call"
 	select KEXEC_CORE
-	select BUILD_BIN2C
 	depends on CRYPTO
 	depends on CRYPTO_SHA256
 	depends on CRYPTO_SHA256_S390


