Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 045E2603C88
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbiJSIsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbiJSIsG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:48:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F070A14003;
        Wed, 19 Oct 2022 01:46:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 107FEB822DE;
        Wed, 19 Oct 2022 08:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBB5C433C1;
        Wed, 19 Oct 2022 08:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168929;
        bh=qab0Rnt+T/tqzgVYqDfBj7DaAjjs/8A7KfmD14WqWuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UvAAavH7mSafJB4pIj6FAcuAh7BHWaLSoJ1Ux3uSMpI/zRkyRwRPLrADTUz7ERZsb
         m17vWpthamZkcQZ3MISS6GBOIMzM0xABIom9uT3aM64oqwhE3lbcJkX5WD2OV9MyIN
         xR0Om9/w9gJtt2j6iEpbVM40gUGtWB/D8cac3ecw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jae Hoon Kim <kimjae@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.0 100/862] LoadPin: Fix Kconfig doc about format of file with verity digests
Date:   Wed, 19 Oct 2022 10:23:07 +0200
Message-Id: <20221019083254.328176929@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Kaehlcke <mka@chromium.org>

commit aafc203bbad4bf6cf394a34ea698c2b0b8affae0 upstream.

The doc for CONFIG_SECURITY_LOADPIN_VERITY says that the file with verity
digests must contain a comma separated list of digests. That was the case
at some stage of the development, but was changed during the review
process to one digest per line. Update the Kconfig doc accordingly.

Reported-by: Jae Hoon Kim <kimjae@chromium.org>
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Fixes: 3f805f8cc23b ("LoadPin: Enable loading from trusted dm-verity devices")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220829174557.1.I5d202d1344212a3800d9828f936df6511eb2d0d1@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/loadpin/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/loadpin/Kconfig
+++ b/security/loadpin/Kconfig
@@ -33,4 +33,4 @@ config SECURITY_LOADPIN_VERITY
 	  on the LoadPin securityfs entry 'dm-verity'. The ioctl
 	  expects a file descriptor of a file with verity digests as
 	  parameter. The file must be located on the pinned root and
-	  contain a comma separated list of digests.
+	  contain one digest per line.


