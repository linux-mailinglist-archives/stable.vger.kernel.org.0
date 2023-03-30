Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563646D05F3
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 15:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbjC3NJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 09:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbjC3NJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 09:09:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B898729F;
        Thu, 30 Mar 2023 06:09:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A982B62070;
        Thu, 30 Mar 2023 13:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE347C433EF;
        Thu, 30 Mar 2023 13:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680181787;
        bh=znovWzvfx5PY5Sms5MRi5EX98o6iGC0ZUm1af/MrMIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4qEelipm7Q7SAx91JtzyznbguVE5hWSbqjNxZPA8TQV3FKZL9/MhtJUuSL9QN1M5
         vT3mPGBhT4di6mnDG7GO3lcQOr6QIX60u5p1mLeYkMQqrqLGGYOtGn3/NFI1kUKRyl
         1W/HQJtmD0bj3AUXIV8QPp5f2wY1eg0wNKhE5RbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.4.239
Date:   Thu, 30 Mar 2023 15:09:43 +0200
Message-Id: <168018172924773@kroah.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <168018172911225@kroah.com>
References: <168018172911225@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 436450833e1c..f966eeb6b9bc 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 4
-SUBLEVEL = 238
+SUBLEVEL = 239
 EXTRAVERSION =
 NAME = Kleptomaniac Octopus
 
diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
old mode 100644
new mode 100755
