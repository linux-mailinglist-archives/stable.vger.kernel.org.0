Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA19F541314
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357814AbiFGTzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358663AbiFGTwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:52:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4ED750036;
        Tue,  7 Jun 2022 11:22:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66087B8233E;
        Tue,  7 Jun 2022 18:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50FFC385A2;
        Tue,  7 Jun 2022 18:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626118;
        bh=LLYvGfGjXZ9QmB2lx9GE2qO8i4mMoaFQ3OO4wiSra9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CV3Yo7TKk53yKOT/Blfo3m0n1goHE70iKWO1rYC1Bm35TgYn0epOr0k36DY6xnLVP
         S/D+sFVH359/LuQLqpxtTTptDCevv6eoEi6bzrSb3LCboM6nOIIIHdSoYuBk1IXtVk
         2tJJVj8SMqv0RlFhVC6L7tIo2SYmDOJT1tsKFW/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 265/772] efi: Add missing prototype for efi_capsule_setup_info
Date:   Tue,  7 Jun 2022 18:57:37 +0200
Message-Id: <20220607164956.833192623@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
index ccd4d3f91c98..cc6d2be2ffd5 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -213,6 +213,8 @@ struct capsule_info {
 	size_t			page_bytes_remain;
 };
 
+int efi_capsule_setup_info(struct capsule_info *cap_info, void *kbuff,
+                           size_t hdr_bytes);
 int __efi_capsule_setup_info(struct capsule_info *cap_info);
 
 /*
-- 
2.35.1



