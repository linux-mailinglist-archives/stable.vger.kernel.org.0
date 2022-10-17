Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B926601306
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 17:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiJQPyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 11:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiJQPyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 11:54:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5066A6D84D;
        Mon, 17 Oct 2022 08:54:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99AA2611C9;
        Mon, 17 Oct 2022 15:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE23FC433C1;
        Mon, 17 Oct 2022 15:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666022039;
        bh=yAXd8v51+ZhAC75sa5BWu9HgAn7WWs3f4TdsC9hY9+Y=;
        h=From:To:Cc:Subject:Date:From;
        b=NUjZ11ZmLIIgzZsAMUvdb1nrLqEHPIExJucpy1gHNLJXSZcYLvuAAGuN/Zz34abDD
         ar3EckTmla23A5+sitsuZpRfFGbtKiZXUDPqDEhwXYaOUgI+gmRfvUqQcNca20mvhF
         VdjNKqX8CFf2ZK/Io8n6E6QqiGTHzgIxhH7hvf1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.149
Date:   Mon, 17 Oct 2022 17:53:51 +0200
Message-Id: <166602203213529@kroah.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.149 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                   |    2 +-
 fs/splice.c                |   10 ++++++----
 net/mac80211/ieee80211_i.h |    4 ++--
 net/mac80211/mlme.c        |   21 +++++++++++++--------
 net/mac80211/scan.c        |    2 ++
 net/mac80211/util.c        |   11 ++++++-----
 6 files changed, 30 insertions(+), 20 deletions(-)

Greg Kroah-Hartman (1):
      Linux 5.10.149

Johannes Berg (3):
      mac80211: mlme: find auth challenge directly
      wifi: mac80211: don't parse mbssid in assoc response
      wifi: mac80211: fix MBSSID parsing use-after-free

Sasha Levin (1):
      Revert "fs: check FMODE_LSEEK to control internal pipe splicing"

