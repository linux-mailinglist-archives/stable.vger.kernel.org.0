Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6165054E1
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241626AbiDRNPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241689AbiDRNI3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:08:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7599C2B27B;
        Mon, 18 Apr 2022 05:47:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AF3CB80E4B;
        Mon, 18 Apr 2022 12:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D422C385A7;
        Mon, 18 Apr 2022 12:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286072;
        bh=hSjoxYGD0LqCdflEGlp2q8yQwCPWJI2u6IK7aPgXHWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yJ/wv0bQ3n6SvaqqklvFdwF9JqaBmbyQUrGe6/3yDT3nDx38BVAXHwLtO8kPxtsaK
         cdzYt/ZI/DHi0tJxL9oS8555NGBipXK6uG8oc67N3AjSQcbQp9zP+CkgpddMVw/HzP
         C0h1GFcR+SWjfTOyE3qWEMIq/ti6KkJqEn4WdliA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 4.14 020/284] Documentation: add link to stable release candidate tree
Date:   Mon, 18 Apr 2022 14:10:01 +0200
Message-Id: <20220418121211.271650450@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -173,6 +173,15 @@ Trees
 
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


