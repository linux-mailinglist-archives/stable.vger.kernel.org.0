Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0247159B3F9
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 15:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbiHUNgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 09:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiHUNfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 09:35:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC708220C6;
        Sun, 21 Aug 2022 06:35:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7923F60EA6;
        Sun, 21 Aug 2022 13:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7A0C433C1;
        Sun, 21 Aug 2022 13:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661088945;
        bh=t9/4OF3Mx2UHdp8HPqWerJGHWRlWcwAnk0JjstvydFg=;
        h=From:To:Cc:Subject:Date:From;
        b=KrAr4AYSclm2GeMe/K/uL8q6jzuHXR64m2Zd6fI3rPpcOJpIPSoIrqUQkJzM9w45f
         QE2l2j2EKGat1NmIebx2z/S/c42uM8vAogpFPvwB8kfh1l3m9cGaOMXKK/P4GsQz8b
         2sdrbKRkClZWTojmDHQ7saYvHWkcPoTBwXXsosFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.62
Date:   Sun, 21 Aug 2022 15:35:36 +0200
Message-Id: <1661088936412@kroah.com>
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

I'm announcing the release of the 5.15.62 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                    |    2 
 arch/x86/kernel/ftrace.c    |    7 --
 arch/x86/kernel/ftrace_64.S |   19 +++++-
 drivers/tee/tee_shm.c       |    3 +
 fs/btrfs/raid56.c           |   74 +++++++++++++++++++------
 fs/io_uring.c               |    2 
 fs/ksmbd/smb2misc.c         |    7 +-
 fs/ksmbd/smb2pdu.c          |   45 +++++++++------
 fs/ksmbd/smbacl.c           |  130 +++++++++++++++++++++++++++++---------------
 fs/ksmbd/smbacl.h           |    2 
 fs/ksmbd/vfs.c              |    5 +
 net/sched/cls_route.c       |   10 +++
 12 files changed, 215 insertions(+), 91 deletions(-)

Greg Kroah-Hartman (1):
      Linux 5.15.62

Hyunchul Lee (1):
      ksmbd: prevent out of bound read for SMB2_WRITE

Jamal Hadi Salim (1):
      net_sched: cls_route: disallow handle of 0

Jens Axboe (1):
      io_uring: use original request task for inflight tracking

Jens Wiklander (1):
      tee: add overflow check in register_shm_helper()

Namjae Jeon (1):
      ksmbd: fix heap-based overflow in set_ntacl_dacl()

Peter Zijlstra (2):
      x86/ibt,ftrace: Make function-graph play nice
      x86/ftrace: Use alternative RET encoding

Qu Wenruo (2):
      btrfs: only write the sectors in the vertical stripe which has data stripes
      btrfs: raid56: don't trust any cached sector in __raid56_parity_recover()

Thadeu Lima de Souza Cascardo (1):
      Revert "x86/ftrace: Use alternative RET encoding"

