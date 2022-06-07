Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38545409D2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350087AbiFGSON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350179AbiFGSMy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:12:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A671157F4;
        Tue,  7 Jun 2022 10:48:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00D0C61732;
        Tue,  7 Jun 2022 17:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE45C385A5;
        Tue,  7 Jun 2022 17:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624131;
        bh=xMtGMO50ZU85bygJVmbfUVWw3rhEmqYRx2viIrB+LOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+6j5vuiqnrUbKWIAg7IXvOMytK23PUysWJUbqnmjGqGbSC9m1x8uJmG9HzaWpjB2
         oV6go+FHzI1hIYkzC6w/ci/YPHRtD1z9Xn1jSW+tQ6oVFcA7ShMHqpnrqF3AL2oNsv
         X54oeTVLK4KsQHUH6xC45//9rC7zmbypvWDMsMKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 214/667] efi: Add missing prototype for efi_capsule_setup_info
Date:   Tue,  7 Jun 2022 18:57:59 +0200
Message-Id: <20220607164941.213312356@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

[ Upstream commit aa480379d8bdb33920d68acfd90f823c8af32578 ]

Fixes "no previous declaration for 'efi_capsule_setup_info'" warnings
under W=1.

Fixes: 2959c95d510c ("efi/capsule: Add support for Quark security header")
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Link: https://lore.kernel.org/r/c28d3f86-dd72-27d1-e2c2-40971b8da6bd@siemens.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/efi.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 3d8ddc5eca8c..d34e8a7ed4d5 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -167,6 +167,8 @@ struct capsule_info {
 	size_t			page_bytes_remain;
 };
 
+int efi_capsule_setup_info(struct capsule_info *cap_info, void *kbuff,
+                           size_t hdr_bytes);
 int __efi_capsule_setup_info(struct capsule_info *cap_info);
 
 /*
-- 
2.35.1



