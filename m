Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82AB54B20B7
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 09:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238738AbiBKIxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 03:53:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237211AbiBKIxm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 03:53:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78046E7F;
        Fri, 11 Feb 2022 00:53:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F01EB828C2;
        Fri, 11 Feb 2022 08:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D54C340ED;
        Fri, 11 Feb 2022 08:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644569619;
        bh=alu/kFhiWX5o3q7Y7qq4zx1FB4//fwWYKFtEkS8ibkg=;
        h=From:To:Cc:Subject:Date:From;
        b=UW10DqhAC9eWgBFGCkzpvepyCIs9wT69D3XGVEt1WM6CV4Dt0H2/CPUOBUdo/Y37I
         cLWnTDmrNmtbC8bBw6GUyjmkyjhwZkM54gCf2pCz+3Yuj3fewfIM2MFRRPYURU+k/A
         sr7SSgc6cM3TBIqs9qCRy+c6jf23m3PUMWOWSoWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.100
Date:   Fri, 11 Feb 2022 09:53:25 +0100
Message-Id: <16445696062149@kroah.com>
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

I'm announcing the release of the 5.10.100 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                      |    2 +-
 arch/s390/kvm/kvm-s390.c      |    2 ++
 crypto/algapi.c               |    1 +
 crypto/api.c                  |    1 -
 drivers/mmc/host/moxart-mmc.c |    2 +-
 net/tipc/link.c               |    9 +++++++--
 net/tipc/monitor.c            |    2 ++
 7 files changed, 14 insertions(+), 5 deletions(-)

Greg Kroah-Hartman (2):
      moxart: fix potential use-after-free on remove path
      Linux 5.10.100

Herbert Xu (1):
      crypto: api - Move cryptomgr soft dependency into algapi

Janis Schoetterl-Glausch (1):
      KVM: s390: Return error on SIDA memop on normal guest

Jon Maloy (1):
      tipc: improve size validations for received domain records

