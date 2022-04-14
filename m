Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365EB50123D
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245162AbiDNOHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347703AbiDNN7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:59:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC67EA7756;
        Thu, 14 Apr 2022 06:51:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68294B82910;
        Thu, 14 Apr 2022 13:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE25BC385A1;
        Thu, 14 Apr 2022 13:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944302;
        bh=wutGclBUfxGLLDAMDkOqd76TAwFxGfljFph8llK6Xs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WsTvs2NmnVYXpPawmLmyKbtAYFozlaBRRAcVs5MOTaY3tQ3bHF1CemMrpfKfG962Y
         azu5le45nCvZJHbf8RVXFXsLkuzpcC6frOBVDhIdXBLzaek4qJAVDx4Ga8Nk2gc5sx
         f3HvcdMiG3mkLqSF8H8iT6zjaMLfFO0SFn7iQIHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Colin Ian King <colin.king@canonical.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.4 465/475] drm/amdkfd: add missing void argument to function kgd2kfd_init
Date:   Thu, 14 Apr 2022 15:14:10 +0200
Message-Id: <20220414110908.067968065@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

From: Colin Ian King <colin.king@canonical.com>

commit 63617d8b125ed9f674133dd000b6df58d6b2965a upstream.

Function kgd2kfd_init is missing a void argument, add it
to clean up the non-ANSI function declaration.

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_module.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_module.c
@@ -82,7 +82,7 @@ static void kfd_exit(void)
 	kfd_chardev_exit();
 }
 
-int kgd2kfd_init()
+int kgd2kfd_init(void)
 {
 	return kfd_init();
 }


