Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2953260DFDD
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 13:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbiJZLnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 07:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233658AbiJZLlq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 07:41:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58E14F688;
        Wed, 26 Oct 2022 04:39:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7501461E54;
        Wed, 26 Oct 2022 11:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85111C433D6;
        Wed, 26 Oct 2022 11:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666784397;
        bh=h2XmPKP3yEiVKMCF7OckMw8f94rMCilv7K2mZ0TlHWo=;
        h=From:To:Cc:Subject:Date:From;
        b=ikdhTDQ8u2/D7vWkjYsV0wArcJTWAyVf2SKsER47Sm5o3NEj8aiFZwRh3ykr/vKHg
         DXktvuNf3yQIjitQ1WhWG5XJ0+RllW69ZBtTMuSeXZP3+usspBarBMFG1UKb7vU42I
         PVtmdCdUKZoUoFDq6RbkXe9ad/KLq8L0lwWiigbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.0.5
Date:   Wed, 26 Oct 2022 13:39:54 +0200
Message-Id: <166678431512192@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.0.5 kernel.

This quick release resolves a much reported problem with a tiny subset
of systems that have btrfs volumes, as well as a Tegra platform
regression.  If you do not use btrfs, nor run Linux on a Tegra system,
there is no need to upgrade to this release.

The updated 6.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.0.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                         |    2 -
 drivers/clk/tegra/clk-tegra114.c |    1 
 drivers/clk/tegra/clk-tegra124.c |    1 
 drivers/clk/tegra/clk-tegra20.c  |    1 
 drivers/clk/tegra/clk-tegra210.c |    1 
 drivers/clk/tegra/clk-tegra30.c  |    1 
 fs/btrfs/free-space-cache.c      |   53 ++++++++++++++-------------------------
 7 files changed, 26 insertions(+), 34 deletions(-)

Greg Kroah-Hartman (2):
      Revert "btrfs: call __btrfs_remove_free_space_cache_locked on cache load failure"
      Linux 6.0.5

Jon Hunter (1):
      clk: tegra: Fix Tegra PWM parent clock

