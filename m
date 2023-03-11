Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E82A6B5A50
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 11:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjCKKMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 05:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjCKKMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 05:12:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D016E1151F3;
        Sat, 11 Mar 2023 02:12:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7591360AF5;
        Sat, 11 Mar 2023 10:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B220C433D2;
        Sat, 11 Mar 2023 10:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678529567;
        bh=Ob0scV+nHjPOUcueq0VlNTKATtl25eb5NJTSJH6TY7o=;
        h=From:To:Cc:Subject:Date:From;
        b=GiKTtNvyBpCQ6PO4liXAQHP5ahEkBrm42lmaLIVnT0+4fVfRXLlIkkolGOnyfeV7W
         RO1sLMg6kYxTX5wvbpB1N1S9m4fwPILvmR0zvrEbTJo+qYwZKCOdZjKaFfzItkk9f5
         eoGwAx5ANbNFzQv87wDmqRMLwA2UGmXzuzIZKfXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.2.4
Date:   Sat, 11 Mar 2023 11:12:41 +0100
Message-Id: <167852956118245@kroah.com>
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

I'm announcing the release of the 6.2.4 kernel.

All users of the 6.2 kernel series must upgrade.

The updated 6.2.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.2.y
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
      Linux 6.2.4

