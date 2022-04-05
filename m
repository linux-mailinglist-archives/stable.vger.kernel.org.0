Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D274F2B56
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbiDEI5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235764AbiDEIkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:40:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B76C03;
        Tue,  5 Apr 2022 01:33:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D773360FFC;
        Tue,  5 Apr 2022 08:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB528C385A0;
        Tue,  5 Apr 2022 08:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147619;
        bh=L+a2SzSVzn4E/4douuC9asR0dAPEwbbhzHSIRnZEM04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eqqXQgNcwlm6Ld13fvGGCwWqwrn+Fw6/rUeN3RRoGBpQw1cJDgxy4Wc2jBlVkKnjr
         qwYvadlm+hYhIUCcHa5hGxWvDCByu4lJQwAEvXZVsgIQkSrPy1aIin/lGfhwn/OeZu
         6Jg/7swm/iALAkAAlhqvmqV8W4EAQzmoRa0ukQLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 5.16 0060/1017] Documentation: add link to stable release candidate tree
Date:   Tue,  5 Apr 2022 09:16:13 +0200
Message-Id: <20220405070355.967089528@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

commit 587d39b260c4d090166314d64be70b1f6a26b0b5 upstream.

There is also stable release candidate tree. Mention it, however with a
warning that the tree is for testing purposes.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Link: https://lore.kernel.org/r/20220314113329.485372-5-bagasdotme@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/process/stable-kernel-rules.rst |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/Documentation/process/stable-kernel-rules.rst
+++ b/Documentation/process/stable-kernel-rules.rst
@@ -170,6 +170,15 @@ Trees
 
 	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
 
+ - The release candidate of all stable kernel versions can be found at:
+
+        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/
+
+   .. warning::
+      The -stable-rc tree is a snapshot in time of the stable-queue tree and
+      will change frequently, hence will be rebased often. It should only be
+      used for testing purposes (e.g. to be consumed by CI systems).
+
 
 Review committee
 ----------------


