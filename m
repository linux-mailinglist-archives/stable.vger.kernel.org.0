Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0DF253CCC3
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 17:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbiFCP4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 11:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343509AbiFCP4G (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 11:56:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834D74839E
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 08:56:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 426FBB82378
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 15:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B680C385A9;
        Fri,  3 Jun 2022 15:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654271762;
        bh=muf7yJm2PP8juhF7NPMlyGs2sDOlOzMelpFwD16okYc=;
        h=Subject:To:Cc:From:Date:From;
        b=Y0hZbzVkMVPwiDJ2Wmd7nMzU241x3eeW2G/BDvrWQUTCO12qiKqwJG4lL42vXZTfr
         yYO2eCJlu+636XTkZ7Gyj0qSncTc26dC4x5+LyFkL7KqtHFMfv9Mb4CPnBv4aDj81E
         +QnHURdHyv/8+zfkATkqXI16CA2oqzZ9bkO9AKkU=
Subject: WTF: patch "[PATCH] Linux 5.18" was seriously submitted to be applied to the 1731160ff7c7bbb11bb1aacb14dd25e18d522779-stable tree?
To:     torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Jun 2022 17:55:56 +0200
Message-ID: <1654271756154144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below was submitted to be applied to the 1731160ff7c7bbb11bb1aacb14dd25e18d522779-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4b0986a3613c92f4ec1bdc7f60ec66fea135991f Mon Sep 17 00:00:00 2001
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 22 May 2022 09:52:31 -1000
Subject: [PATCH] Linux 5.18


diff --git a/Makefile b/Makefile
index 5033c0577c6d..7d5b0bfe7960 100644
--- a/Makefile
+++ b/Makefile
@@ -2,7 +2,7 @@
 VERSION = 5
 PATCHLEVEL = 18
 SUBLEVEL = 0
-EXTRAVERSION = -rc7
+EXTRAVERSION =
 NAME = Superb Owl
 
 # *DOCUMENTATION*

