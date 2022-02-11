Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE8104B20A3
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 09:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348243AbiBKIxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 03:53:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348217AbiBKIxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 03:53:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20373E6C;
        Fri, 11 Feb 2022 00:53:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0E1B61E40;
        Fri, 11 Feb 2022 08:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BA9C340E9;
        Fri, 11 Feb 2022 08:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644569584;
        bh=1wFw+Yj+c85IFdx1u2X56VHiB5GdbqcmfIjPgbK5sNI=;
        h=From:To:Cc:Subject:Date:From;
        b=X+tV1xAtLOj1vJc/hGlxuWLbZA8V6reDzqcO1bFHhOeqApEsKKbi+rUYslmwfU6Rl
         FTYQkxTvDmlr/e8t3LEFYWf6YjyTgA+v3lkB386zYFQNdRNGYrgX51tLLop5QQY42r
         IB/tzBV3R/Olcqey8c6jJyNDpoXil8ObGsrYE7N8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.301
Date:   Fri, 11 Feb 2022 09:53:00 +0100
Message-Id: <164456958019184@kroah.com>
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

I'm announcing the release of the 4.9.301 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                      |    2 +-
 drivers/mmc/host/moxart-mmc.c |    2 +-
 kernel/cgroup.c               |   26 ++++++++++++++++++++++++++
 net/tipc/link.c               |    5 ++++-
 net/tipc/monitor.c            |    2 ++
 5 files changed, 34 insertions(+), 3 deletions(-)

Eric W. Biederman (1):
      cgroup-v1: Require capabilities to set release_agent

Greg Kroah-Hartman (2):
      moxart: fix potential use-after-free on remove path
      Linux 4.9.301

Jon Maloy (1):
      tipc: improve size validations for received domain records

