Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1795635569
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237392AbiKWJST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237395AbiKWJR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:17:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695F2D114
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:17:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 042EA61B10
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB78FC433C1;
        Wed, 23 Nov 2022 09:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195062;
        bh=yyRLcOZkVFdF4LGAYIWZzTY3gJNCP7TaUXIpFbcdzNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hDqg10avqSWkdMwNCgP0oVhiU0+p9gy+QyAKn7Nh2qyrfHL7eQ5Ru6zN6++jeqDFv
         jN+FBxcY52BIqA0LTjopzUxrcsHm80xPdKhyiR1Et0bUiJbym+IUw+uHRHjMoHUWVs
         F6oRw9zTDkEeXXqcJ2YPpY+tE4z/lpEbx+oIec6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.4 137/156] docs: update mediator contact information in CoC doc
Date:   Wed, 23 Nov 2022 09:51:34 +0100
Message-Id: <20221123084602.861820450@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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

From: Shuah Khan <skhan@linuxfoundation.org>

commit 5fddf8962b429b8303c4a654291ecb6e61a7d747 upstream.

Update mediator contact information in CoC interpretation document.

Cc: <stable@vger.kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20221011171417.34286-1-skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/process/code-of-conduct-interpretation.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/process/code-of-conduct-interpretation.rst
+++ b/Documentation/process/code-of-conduct-interpretation.rst
@@ -51,7 +51,7 @@ the Technical Advisory Board (TAB) or ot
 uncertain how to handle situations that come up.  It will not be
 considered a violation report unless you want it to be.  If you are
 uncertain about approaching the TAB or any other maintainers, please
-reach out to our conflict mediator, Joanna Lee <joanna.lee@gesmer.com>.
+reach out to our conflict mediator, Joanna Lee <jlee@linuxfoundation.org>.
 
 In the end, "be kind to each other" is really what the end goal is for
 everybody.  We know everyone is human and we all fail at times, but the


