Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D896B65D0
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 13:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjCLMFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 08:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCLMFc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 08:05:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541D710A;
        Sun, 12 Mar 2023 05:05:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04E02B80B18;
        Sun, 12 Mar 2023 12:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEE8C433EF;
        Sun, 12 Mar 2023 12:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678622728;
        bh=cgObdzA98FRE4J0VOEKCUzbl2WTybBEuY/NlBDuGsyY=;
        h=From:To:Cc:Subject:Date:From;
        b=x7sZxhvX6j/G1cjZILO3w+9wWn5KYqbPq/5CE48iNaBGoJs6KADQFmJavHn+bqIUh
         jhzVd/N3rVfCwImmUbQo0CRl2wXKXTwGrhcpLnzWI/y/+Z3I1r/YKxy1IS4euRlfQo
         hb/HTfU4fE1fBHKKUWVwUT40IJHz97hpyeXwfmQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.101
Date:   Sun, 12 Mar 2023 13:05:24 +0100
Message-Id: <167862272511368@kroah.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.101 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                             |    2 +-
 drivers/gpu/drm/i915/gt/intel_ring.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Greg Kroah-Hartman (2):
      Revert "drm/i915: Don't use BAR mappings for ring buffers with LLC"
      Linux 5.15.101

