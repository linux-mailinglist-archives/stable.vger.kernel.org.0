Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 443C16B733D
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 10:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjCMJ5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 05:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjCMJ5Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 05:57:16 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B655E26C14;
        Mon, 13 Mar 2023 02:57:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 29F0ECE0FA7;
        Mon, 13 Mar 2023 09:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13548C433D2;
        Mon, 13 Mar 2023 09:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678701431;
        bh=P7OH/paeGzFeUha18/vUKd29B3YRhN48njNhdHEAYrI=;
        h=From:To:Cc:Subject:Date:From;
        b=VwkiYl+LfJa4WWBKLg0pa4+jnMSyE8tyZjx0rTlzME3P9hiSIYyOSjVjPeb+8P43x
         kqfospe5AuuZveVVetvuw1Xnj9btKac01USlZ/4U0WAZmroP29Msdbnguq1nx/4k21
         jEytIkmogvH4jgIGovLtDM1wObU21vJxq/PkKlCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.309
Date:   Mon, 13 Mar 2023 10:57:07 +0100
Message-Id: <167870142822219@kroah.com>
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

I'm announcing the release of the 4.14.309 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
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
      Linux 4.14.309

Hector Martin (1):
      wifi: cfg80211: Partial revert "wifi: cfg80211: Fix use after free for wext"

Philipp Hortmann (2):
      staging: rtl8192e: Remove function ..dm_check_ac_dc_power calling a script
      staging: rtl8192e: Remove call_usermodehelper starting RadioPower.sh

