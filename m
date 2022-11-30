Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1166E63DD46
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiK3S0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiK3SZy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:25:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31C8CC1
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:25:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 456A8B81C9A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7F3C433D6;
        Wed, 30 Nov 2022 18:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669832751;
        bh=tcP/3rZBDihPO2WK1ana31KjdfofLbh/3e2EEQwsl/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISZdoqk9/N9qiDOzpHg2wrlY+oz3ZTsuKgAcccggmixOvRBLqzUcgQC3BHlh0GwlY
         ap0+hslwiwxLRcBvrBGQbZjP59uq5eBB9EUgydF1QUuNluVNhNU5DzQqv7/hheED7y
         c6CCBCuuGGZvHSVCxDoX6kuptVn1ZLTyxqZMXwGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?=C4=90o=C3=A0n=20Tr=E1=BA=A7n=20C=C3=B4ng=20Danh?= 
        <congdanhqx@gmail.com>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        stable <stable@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/162] speakup: replace utils u_char with unsigned char
Date:   Wed, 30 Nov 2022 19:21:31 +0100
Message-Id: <20221130180528.772325383@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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

From: Đoàn Trần Công Danh <congdanhqx@gmail.com>

[ Upstream commit 92ca969ff8815f3feef2645199bd39bf594e5eeb ]

drivers/accessibility/speakup/utils.h will be used to compile host tool
to generate metadata.

"u_char" is a non-standard type, which is defined to "unsigned char"
on glibc but not defined by some libc, e.g. musl.

Let's replace "u_char" with "unsigned char"

Signed-off-by: Đoàn Trần Công Danh <congdanhqx@gmail.com>
Reviewed-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/b75743026aaee2d81efe3d7f2e8fa47f7d0b8ea7.1665736571.git.congdanhqx@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accessibility/speakup/utils.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accessibility/speakup/utils.h b/drivers/accessibility/speakup/utils.h
index 4bf2ee8ac246..4ce9a12f7664 100644
--- a/drivers/accessibility/speakup/utils.h
+++ b/drivers/accessibility/speakup/utils.h
@@ -54,7 +54,7 @@ static inline int oops(const char *msg, const char *info)
 
 static inline struct st_key *hash_name(char *name)
 {
-	u_char *pn = (u_char *)name;
+	unsigned char *pn = (unsigned char *)name;
 	int hash = 0;
 
 	while (*pn) {
-- 
2.35.1



