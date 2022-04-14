Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB2F5011AF
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241632AbiDNNwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245116AbiDNNiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:38:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84C89AE7C;
        Thu, 14 Apr 2022 06:31:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50AA16190F;
        Thu, 14 Apr 2022 13:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA97C385A5;
        Thu, 14 Apr 2022 13:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943098;
        bh=PRvNGRbCxJO3uZqkoyIaJS5EUibIifK85wWIQr+TfZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=el7Yn3v+vcxQkpNvIZ2mUQ7HcnxZeothEisjybmwBDy00NobXLCY4VI1i0tIPJAXX
         KPUJ3yeOhhTQbJgbhOGp1LPZRa5WIFS1J4ye2ow5ibhnI7TGIMzuuN1M9+HOvuBlsp
         kT4g2t+Q491HWnFZ0tt4/LcjEjyesbgc1ooOcyiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 5.4 033/475] Documentation: update stable tree link
Date:   Thu, 14 Apr 2022 15:06:58 +0200
Message-Id: <20220414110856.082905736@linuxfoundation.org>
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

From: Bagas Sanjaya <bagasdotme@gmail.com>

commit 555d44932c67e617d89bc13c81c7efac5b51fcfa upstream.

The link to stable tree is redirected to
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git. Update
accordingly.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Link: https://lore.kernel.org/r/20220314113329.485372-6-bagasdotme@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/process/stable-kernel-rules.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/process/stable-kernel-rules.rst
+++ b/Documentation/process/stable-kernel-rules.rst
@@ -174,7 +174,7 @@ Trees
  - The finalized and tagged releases of all stable kernels can be found
    in separate branches per version at:
 
-	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
+	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
 
  - The release candidate of all stable kernel versions can be found at:
 


