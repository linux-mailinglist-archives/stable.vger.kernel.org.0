Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973E44B20C0
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 09:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234572AbiBKIxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 03:53:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbiBKIxp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 03:53:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB2CE88;
        Fri, 11 Feb 2022 00:53:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 551AAB828BD;
        Fri, 11 Feb 2022 08:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC70C340E9;
        Fri, 11 Feb 2022 08:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644569622;
        bh=//SkeYPt3w1ZTUdu7Q9OCIr+zPRS42qwYR5X1XNltRw=;
        h=From:To:Cc:Subject:Date:From;
        b=HBGdA31avos9f/M9mxhUoyKVT++i2QHWz4zpI4d4dksvXM+yRcYxnvY0ahS/zAiY7
         HLZIJavzQhb25Up5+jWTpdvMK8KafKSFeuGWW0zCz7Eb3k1cWXdZiNQFP2OEmHIkR4
         eB4k0C0fOw7IpnjmQGoR+zYVvsqXIlRWseWOZSqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.23
Date:   Fri, 11 Feb 2022 09:53:31 +0100
Message-Id: <1644569611153233@kroah.com>
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

I'm announcing the release of the 5.15.23 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                         |    2 +-
 arch/arm64/include/asm/cputype.h |    2 ++
 arch/s390/kvm/kvm-s390.c         |    2 ++
 crypto/algapi.c                  |    1 +
 crypto/api.c                     |    1 -
 drivers/mmc/host/moxart-mmc.c    |    2 +-
 fs/ksmbd/smb2pdu.c               |    2 +-
 net/tipc/link.c                  |    9 +++++++--
 net/tipc/monitor.c               |    2 ++
 9 files changed, 17 insertions(+), 6 deletions(-)

Anshuman Khandual (1):
      arm64: Add Cortex-A510 CPU part definition

Greg Kroah-Hartman (2):
      moxart: fix potential use-after-free on remove path
      Linux 5.15.23

Herbert Xu (1):
      crypto: api - Move cryptomgr soft dependency into algapi

Janis Schoetterl-Glausch (1):
      KVM: s390: Return error on SIDA memop on normal guest

Jon Maloy (1):
      tipc: improve size validations for received domain records

Namjae Jeon (1):
      ksmbd: fix SMB 3.11 posix extension mount failure

