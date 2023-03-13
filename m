Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEA16B734E
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 10:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbjCMJ6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 05:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjCMJ6B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 05:58:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87888509B4;
        Mon, 13 Mar 2023 02:57:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BA43B80F96;
        Mon, 13 Mar 2023 09:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EB0C433D2;
        Mon, 13 Mar 2023 09:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678701460;
        bh=45ZGSJCXl1iFHFQgWOrLkJp4BgBNzSPztUq2saYkqv4=;
        h=From:To:Cc:Subject:Date:From;
        b=Mx/0fZ/ZAmyDnmDtz89K0cEnMvrR0jfjhs4XbjvGhr6P+Zd0qTaWeKic5BZc8Zpgj
         xyoZrYcUeYGl5xMwgCuy5+CgF+WUeno3sEONWNk/mie3L5XlDh09YmiXPubB3OjCfC
         NCzy4SAAIiSc+lyLxOLzprg7I0KC+eNf9OgovdIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.102
Date:   Mon, 13 Mar 2023 10:57:36 +0100
Message-Id: <1678701457238246@kroah.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.102 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                   |    2 -
 drivers/staging/rtl8192e/rtl8192e/rtl_dm.c |   39 -----------------------------
 net/wireless/sme.c                         |    2 -
 3 files changed, 1 insertion(+), 42 deletions(-)

Greg Kroah-Hartman (1):
      Linux 5.15.102

Hector Martin (1):
      wifi: cfg80211: Partial revert "wifi: cfg80211: Fix use after free for wext"

Philipp Hortmann (2):
      staging: rtl8192e: Remove function ..dm_check_ac_dc_power calling a script
      staging: rtl8192e: Remove call_usermodehelper starting RadioPower.sh

