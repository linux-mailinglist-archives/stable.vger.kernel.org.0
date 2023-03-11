Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1E0E6B5A4E
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 11:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjCKKMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 05:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCKKMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 05:12:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7B01135F4;
        Sat, 11 Mar 2023 02:12:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD673B802BE;
        Sat, 11 Mar 2023 10:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5ADC433D2;
        Sat, 11 Mar 2023 10:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678529559;
        bh=fTbWaXDZBiEVTIjaVEMLEgYkydKCFYLwIdFaPpVm4cg=;
        h=From:To:Cc:Subject:Date:From;
        b=hygNhxdzaabAT2KAOHBrtEEhFI8Ns9SpPGOFVeiMUwQg64p/obw+IfjxDQwmZGz2v
         iVSzSjZmegp+48byf4i1fW/zZncOC+Mj1kBJz7wgc8dStW0R7AMLSq7Jr+S2sV+fNX
         rhPDODTtvYL916dTZIoe1rLSH2lf4NkFwEiOX9fQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.1.17
Date:   Sat, 11 Mar 2023 11:12:35 +0100
Message-Id: <1678529556116102@kroah.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.1.17 kernel.

All users of the 6.1 kernel series must upgrade.

The updated 6.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile               |    2 +-
 block/blk-cgroup.c     |   39 ++++++++-------------------------------
 include/linux/blkdev.h |    1 -
 3 files changed, 9 insertions(+), 33 deletions(-)

Greg Kroah-Hartman (3):
      Revert "blk-cgroup: synchronize pd_free_fn() from blkg_free_workfn() and blkcg_deactivate_policy()"
      Revert "blk-cgroup: dropping parent refcount after pd_free_fn() is done"
      Linux 6.1.17

