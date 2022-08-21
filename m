Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3613B59B3F7
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 15:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbiHUNgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 09:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiHUNgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 09:36:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1495220D7;
        Sun, 21 Aug 2022 06:36:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64219B80D57;
        Sun, 21 Aug 2022 13:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB84C433D7;
        Sun, 21 Aug 2022 13:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661088959;
        bh=UmPqiUS5rQe8gjOswEf7IrNAWa6pD/hwHniF3eDVcOg=;
        h=From:To:Cc:Subject:Date:From;
        b=i913rlLSsLyH9yOLcQvoLZRFe9THv46PzQN+fftr+Ax5QFfILcnFQ2lNg1stEDqKq
         1OIt17LW/AhenwhTRsSvIjDdgXiwygdE0mpZqsqVTstoMYlzwVZ1njfrJ6qkhyMW6+
         OzejF4A3OHztolgG/phSsf53fS3m/hEilb53ldnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.19.3
Date:   Sun, 21 Aug 2022 15:35:44 +0200
Message-Id: <1661088945124200@kroah.com>
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

I'm announcing the release of the 5.19.3 kernel.

All users of the 5.19 kernel series must upgrade.

The updated 5.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                          |    2 -
 arch/arm64/kernel/kexec_image.c   |   11 ------
 arch/x86/kernel/kexec-bzimage64.c |   20 -----------
 drivers/tee/tee_shm.c             |    3 +
 fs/btrfs/raid56.c                 |   68 ++++++++++++++++++++++++++++++--------
 include/linux/kexec.h             |    7 +++
 kernel/kexec_file.c               |   17 +++++++++
 mm/kfence/core.c                  |   18 +++++-----
 net/sched/cls_route.c             |   10 +++++
 9 files changed, 104 insertions(+), 52 deletions(-)

Coiby Xu (2):
      kexec, KEYS: make the code in bzImage64_verify_sig generic
      arm64: kexec_file: use more system keyrings to verify kernel image signature

Greg Kroah-Hartman (1):
      Linux 5.19.3

Jamal Hadi Salim (1):
      net_sched: cls_route: disallow handle of 0

Jens Wiklander (1):
      tee: add overflow check in register_shm_helper()

Marco Elver (1):
      Revert "mm: kfence: apply kmemleak_ignore_phys on early allocated pool"

Qu Wenruo (2):
      btrfs: only write the sectors in the vertical stripe which has data stripes
      btrfs: raid56: don't trust any cached sector in __raid56_parity_recover()

