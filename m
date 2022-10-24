Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEBA460A4C2
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbiJXMPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbiJXMOs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:14:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732147739A;
        Mon, 24 Oct 2022 04:55:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 918116126B;
        Mon, 24 Oct 2022 11:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3571C433C1;
        Mon, 24 Oct 2022 11:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612513;
        bh=7a+WTDLovQeSm3K4+3q8ZCqpy2ODJ1EzuBZHDte6j3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MURE368QAnM1DEWIYCfn/kr14lRU6c5Ee+u/90UutcbrBDbL/EOU24NMQI1Fl/stu
         SfvKYzho2VkFuYIKfQJ1xd+6Yuc92BeiT3nwg6TkGRDQuDVIq1qVuh3hQs8O5n3J9/
         nCiwYNZGzxpRBB94quEeF3YPA7EzbIcvL6xXFGHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 4.19 002/229] docs: update mediator information in CoC docs
Date:   Mon, 24 Oct 2022 13:28:41 +0200
Message-Id: <20221024112959.182109794@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

commit 8bfdfa0d6b929ede7b6189e0e546ceb6a124d05d upstream.

Update mediator information in the CoC interpretation document.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20220901212319.56644-1-skhan@linuxfoundation.org
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
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
-reach out to our conflict mediator, Mishi Choudhary <mishi@linux.com>.
+reach out to our conflict mediator, Joanna Lee <joanna.lee@gesmer.com>.
 
 In the end, "be kind to each other" is really what the end goal is for
 everybody.  We know everyone is human and we all fail at times, but the


