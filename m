Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41FC6D05F6
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 15:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbjC3NJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 09:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbjC3NJx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 09:09:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67AE9760;
        Thu, 30 Mar 2023 06:09:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 54A88CE2A71;
        Thu, 30 Mar 2023 13:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD35C433EF;
        Thu, 30 Mar 2023 13:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680181789;
        bh=6xI9gZRxz5rAHgRltvcqKe9CY/16gq3ROLsfof8w9wk=;
        h=From:To:Cc:Subject:Date:From;
        b=DbOxAW8UkFxMhzpIgyUQJLyktdWSrSc8lAaSaai2IDlcHOVMLuZmpibeQiejGCYQI
         snYtnzVXrRuRZ09SNYRcAORW2ivov2tVv84e65TSimM5M5zyk9yVt3BHbul+XhYdFL
         dw9X7a3amDy38VFLniFv0qNyV896yMo2j9mr2WB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.239
Date:   Thu, 30 Mar 2023 15:09:42 +0200
Message-Id: <168018172911225@kroah.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.239 kernel.

It just fixes up a permission of one file,
tools/testing/selftests/net/fib_tests.sh, if you don't have an issue with this
specific testing file, no need to upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Greg Kroah-Hartman (1):
      Linux 5.4.239

Rishabh Bhatnagar (1):
      selftests: Fix the executable permissions for fib_tests.sh

