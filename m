Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819BA4B20A5
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 09:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236465AbiBKIxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 03:53:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348256AbiBKIxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 03:53:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9D5E7F;
        Fri, 11 Feb 2022 00:53:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 292FA61E16;
        Fri, 11 Feb 2022 08:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC9AC340E9;
        Fri, 11 Feb 2022 08:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644569593;
        bh=wHR5u6Pz4uLnAfFt6yswOndOfk78n8sAmGBPIpx9fx0=;
        h=From:To:Cc:Subject:Date:From;
        b=2kGCXAzm7RAsVwRgvQTuqN/4ozU/CfkIsQEzgSQ7wy2z/L1ZMED39GZlafM39ndEN
         lfjUafATpqIB/qRPE7llc3R63AOqOGCrpKvG4xcTvfnhnA7tAewOA0H8i4eLEJEP3c
         pp28Sjr2V0c8aX7ZkxNqHQg2TquPBleaBZZYQv7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.266
Date:   Fri, 11 Feb 2022 09:53:05 +0100
Message-Id: <164456958616076@kroah.com>
X-Mailer: git-send-email 2.35.1
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

I'm announcing the release of the 4.14.266 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                         |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 drivers/mmc/host/moxart-mmc.c    |    2 +-
 kernel/cgroup/cgroup-v1.c        |   24 ++++++++++++++++++++++++
 net/tipc/link.c                  |    5 ++++-
 net/tipc/monitor.c               |    2 ++
 6 files changed, 33 insertions(+), 4 deletions(-)

Eric W. Biederman (1):
      cgroup-v1: Require capabilities to set release_agent

Greg Kroah-Hartman (2):
      moxart: fix potential use-after-free on remove path
      Linux 4.14.266

Jon Maloy (1):
      tipc: improve size validations for received domain records

luofei (1):
      x86/mm, mm/hwpoison: Fix the unmap kernel 1:1 pages check condition

