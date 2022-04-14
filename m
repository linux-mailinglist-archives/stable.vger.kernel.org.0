Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0E33500EE4
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243998AbiDNNWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237997AbiDNNVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:21:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398AB97286;
        Thu, 14 Apr 2022 06:17:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1028610A6;
        Thu, 14 Apr 2022 13:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB67FC385A9;
        Thu, 14 Apr 2022 13:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942244;
        bh=PRvNGRbCxJO3uZqkoyIaJS5EUibIifK85wWIQr+TfZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6ceOBQ7PqyihgpSoa0RMojFlqhA7v6Thu9d1u9Bop53bf/7BWD/xL2xKrkttV2tM
         3a9HV24q+09khFpA3KCS3oOK9BMV+GqdC3uUyP85bQUtyYJOyPmx0Ua9ZdKSeWCE8b
         J/b6sv/hFV/SKbFxwxDYTNAytMVcAR7BD62sE604=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 4.19 026/338] Documentation: update stable tree link
Date:   Thu, 14 Apr 2022 15:08:49 +0200
Message-Id: <20220414110839.636910023@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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
 


