Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1EB576074
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 13:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiGOL3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 07:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiGOL33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 07:29:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF877B16;
        Fri, 15 Jul 2022 04:28:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B4D86229D;
        Fri, 15 Jul 2022 11:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B030C341C0;
        Fri, 15 Jul 2022 11:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657884513;
        bh=vp1cVpr7c7zxLwHC81smniOEpRs4T8fxGs1VDAnDwjg=;
        h=From:To:Cc:Subject:Date:From;
        b=E4lDoFwYDzFs5oJqcMkOlp/yqcICnf89kNBJriOznlmRbk/LFeFsZmhptbUhFg11k
         b7t8i929glhrdEsmfG6h/vu9REIXqQZuMV/HeR154gKMsCKk3Upw4K2N8OSZr7fidr
         qaznXfOQN3U7NM57N+ymWJBL70EwUnwgzK1K3S3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.131
Date:   Fri, 15 Jul 2022 13:28:26 +0200
Message-Id: <165788450619772@kroah.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.131 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                   |    2 +-
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Greg Kroah-Hartman (2):
      Revert "mtd: rawnand: gpmi: Fix setting busy timeout setting"
      Linux 5.10.131

