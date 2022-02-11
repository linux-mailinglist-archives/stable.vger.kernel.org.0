Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24CFF4B20A8
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 09:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348224AbiBKIx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 03:53:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348220AbiBKIxZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 03:53:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E8AE6C;
        Fri, 11 Feb 2022 00:53:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0375E61E16;
        Fri, 11 Feb 2022 08:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32B9C340E9;
        Fri, 11 Feb 2022 08:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644569604;
        bh=EtHgBem02Cr5zn++prCwv3xz3KvidZ2itOJ49Br6zsA=;
        h=From:To:Cc:Subject:Date:From;
        b=A9rSkrGdxAB4/rdIVOTUcsMHdciw46ggHXVm41u3KtMJeCdkie/B3u+Nn30lfbIyC
         XbO9oSJO2TVUpEUKW8M1i1kf+At/bZQFvlgQDqIW8O+m1CGneZjkDCElfkL3cWJ31p
         4kMhXIcbG1v/vVi/skz3H3WWrrWiCWC2Bx91VEGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.229
Date:   Fri, 11 Feb 2022 09:53:10 +0100
Message-Id: <164456959130183@kroah.com>
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

I'm announcing the release of the 4.19.229 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                      |    2 +-
 drivers/mmc/host/moxart-mmc.c |    2 +-
 kernel/cgroup/cgroup-v1.c     |   24 ++++++++++++++++++++++++
 net/tipc/link.c               |    5 ++++-
 net/tipc/monitor.c            |    2 ++
 5 files changed, 32 insertions(+), 3 deletions(-)

Eric W. Biederman (1):
      cgroup-v1: Require capabilities to set release_agent

Greg Kroah-Hartman (2):
      moxart: fix potential use-after-free on remove path
      Linux 4.19.229

Jon Maloy (1):
      tipc: improve size validations for received domain records

