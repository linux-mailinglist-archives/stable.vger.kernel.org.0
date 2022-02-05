Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F6B4AAAEA
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 19:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380908AbiBESd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 13:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239809AbiBESd4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 13:33:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0675C061348;
        Sat,  5 Feb 2022 10:33:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A72ECB80CE7;
        Sat,  5 Feb 2022 18:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CC2C340E8;
        Sat,  5 Feb 2022 18:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644086033;
        bh=fMRcL9JwQh2KqIgeeMLhCZqxEdJotOclSndPGv4Gia8=;
        h=From:To:Cc:Subject:Date:From;
        b=T4aJ1DB3VUutlNcWNmcTBasWW3Vgp8qQG5pmhYVweQ5elqEEN2FywNcDhm9HnT2Fk
         XQHLsUmfzjymFBAuCqAAcI4EBaMdJ3nqiFVLkax7eD0K8VFbPRBbUp2Se3wD3yYI5v
         pI/R0y06jnXfRa/EJ3mFMef8+3gqo03GEbl6Qhgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.21
Date:   Sat,  5 Feb 2022 19:33:49 +0100
Message-Id: <164408602952101@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.21 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                       |    2 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c |   23 +++++++----------------
 2 files changed, 8 insertions(+), 17 deletions(-)

Greg Kroah-Hartman (3):
      Revert "drm/vc4: hdmi: Make sure the device is powered with CEC"
      Revert "drm/vc4: hdmi: Make sure the device is powered with CEC" again
      Linux 5.15.21

