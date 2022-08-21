Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4628459B3F5
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 15:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbiHUNhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 09:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiHUNhE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 09:37:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1184222A2;
        Sun, 21 Aug 2022 06:36:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D6C460EA7;
        Sun, 21 Aug 2022 13:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B7FC433D6;
        Sun, 21 Aug 2022 13:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661089000;
        bh=vAw8uvQ6/JiBFUTjvaYgkGPRnyYNYmOA68TGrf502wo=;
        h=From:To:Cc:Subject:Date:From;
        b=a6/BnRz+Nz7spx3WzdXbStNgXzKkpKKYB4ATOGmOgYH6b53Fkl319jk+OLiHeCY60
         ZZx++QMHeMyiDVfNh9V08+ZyJ4bI6oAS0bUku5v07AgHLYLdlw5RfJeGcrD2+dkuT3
         S4YESk2jGDukBoG+QvvG5IuDCf1rPNy8tsh7TelQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.18.19
Date:   Sun, 21 Aug 2022 15:36:36 +0200
Message-Id: <166108895535224@kroah.com>
X-Mailer: git-send-email 2.37.2
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

Note, this is the LAST 5.18.y kernel to be released.  This branch is now
end-of-life.  Please move to 5.19.y at this point in time.

I'm announcing the release of the 5.18.19 kernel.

All users of the 5.18 kernel series must upgrade.

The updated 5.18.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.18.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                          |    2 -
 arch/arm64/kernel/kexec_image.c   |   11 -----
 arch/x86/kernel/kexec-bzimage64.c |   20 ----------
 drivers/tee/tee_shm.c             |    3 +
 fs/btrfs/raid56.c                 |   74 +++++++++++++++++++++++++++++---------
 include/linux/kexec.h             |    7 +++
 kernel/kexec_file.c               |   17 ++++++++
 net/sched/cls_route.c             |   10 +++++
 8 files changed, 97 insertions(+), 47 deletions(-)

Coiby Xu (2):
      kexec, KEYS: make the code in bzImage64_verify_sig generic
      arm64: kexec_file: use more system keyrings to verify kernel image signature

Greg Kroah-Hartman (1):
      Linux 5.18.19

Jamal Hadi Salim (1):
      net_sched: cls_route: disallow handle of 0

Jens Wiklander (1):
      tee: add overflow check in register_shm_helper()

Qu Wenruo (2):
      btrfs: only write the sectors in the vertical stripe which has data stripes
      btrfs: raid56: don't trust any cached sector in __raid56_parity_recover()

