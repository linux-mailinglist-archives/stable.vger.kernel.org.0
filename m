Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10CB5B1A22
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 12:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbiIHKhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 06:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiIHKhr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 06:37:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34650A723F;
        Thu,  8 Sep 2022 03:37:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7A6E61C44;
        Thu,  8 Sep 2022 10:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF644C433C1;
        Thu,  8 Sep 2022 10:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662633460;
        bh=8eKwQ7sn7lcu0oqHqPkCo0ePxdEUVOCehDotVWJ8MN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JFcGhzWn2+2hQuOB/ejnsWKOAW6kVtXoUtxYlyUIbF4j5RujFBXBGzNq1WyukYjmV
         koBg38tKYTgXHHTufn2jb5t8fCufnwJ2uRtl/Zcfw5Kq1ntZz5rY6DT5WV2Auk+h/F
         QmhIv0E5fI8SYKmU4XQlwjU9V1vge2vBo3E45DQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.67
Date:   Thu,  8 Sep 2022 12:37:53 +0200
Message-Id: <166263347253126@kroah.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <166263347214161@kroah.com>
References: <166263347214161@kroah.com>
MIME-Version: 1.0
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

diff --git a/Makefile b/Makefile
index 4e747c99e7e0..eca45b7be9c1 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 66
+SUBLEVEL = 67
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/scripts/pahole-flags.sh b/scripts/pahole-flags.sh
old mode 100644
new mode 100755
