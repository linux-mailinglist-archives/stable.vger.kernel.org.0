Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F7F549226
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350946AbiFMLGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350932AbiFMLFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:05:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656A410FD;
        Mon, 13 Jun 2022 03:34:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4143B80EAA;
        Mon, 13 Jun 2022 10:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35490C34114;
        Mon, 13 Jun 2022 10:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116494;
        bh=liqDYnBITC4aho+0gENp/8bVnL2kel+KNoF6yUOwYMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QcyA5DO187glUxep5+W6MjP7IzpcWM5xxPiBYbHAGucU0/3HCEShMEeGC1eXCFi0r
         EF27Qu/TLciZO5hkmEJNZTWHdA3S3NAKqF+fuzhI/ZuVyU6HKSaLoFxcTNTnNnu6aS
         LsXaaa1EScnFQmPybSn9pABCJTwvZr0MJFNC3cPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/411] efi: Add missing prototype for efi_capsule_setup_info
Date:   Mon, 13 Jun 2022 12:06:09 +0200
Message-Id: <20220613094931.560133489@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
index c82ef0eba4f8..f9b9f9a2fd4a 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -165,6 +165,8 @@ struct capsule_info {
 	size_t			page_bytes_remain;
 };
 
+int efi_capsule_setup_info(struct capsule_info *cap_info, void *kbuff,
+                           size_t hdr_bytes);
 int __efi_capsule_setup_info(struct capsule_info *cap_info);
 
 /*
-- 
2.35.1



