Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C853A6B7356
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 10:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbjCMJ65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 05:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjCMJ6X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 05:58:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4869130F6;
        Mon, 13 Mar 2023 02:57:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C82C2B80F97;
        Mon, 13 Mar 2023 09:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25991C433EF;
        Mon, 13 Mar 2023 09:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678701473;
        bh=Xr999vopoJfIV5dOhZG+te0SS5y7PvGv9+DeqIEoCOM=;
        h=From:To:Cc:Subject:Date:From;
        b=xHnbWUsWO7XKnNFBlMUJy7aknZTJiqiIvVgSzcGBovCP6nrFe2JjY5sd6rwyqwMRb
         aXmP45MH73GruM5cw1K8h1E1RJa0u6rzr383YSGt0S7gv9eBXsufTtJB+YGEuwUhEZ
         wc9RlveyI177ZIKEqw1sMR3+PIn5DvBlNTYyekyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.2.6
Date:   Mon, 13 Mar 2023 10:57:50 +0100
Message-Id: <1678701470253226@kroah.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.2.6 kernel.

All users of the 6.2 kernel series must upgrade.

The updated 6.2.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.2.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                   |    2 
 drivers/char/tpm/tpm-chip.c                |   60 +++++++++++++++++++++++
 drivers/char/tpm/tpm.h                     |   73 +++++++++++++++++++++++++++++
 drivers/staging/rtl8192e/rtl8192e/rtl_dm.c |   35 -------------
 net/wireless/sme.c                         |    2 
 5 files changed, 133 insertions(+), 39 deletions(-)

Greg Kroah-Hartman (1):
      Linux 6.2.6

Hector Martin (1):
      wifi: cfg80211: Partial revert "wifi: cfg80211: Fix use after free for wext"

Mario Limonciello (1):
      tpm: disable hwrng for fTPM on some AMD designs

Philipp Hortmann (2):
      staging: rtl8192e: Remove function ..dm_check_ac_dc_power calling a script
      staging: rtl8192e: Remove call_usermodehelper starting RadioPower.sh

