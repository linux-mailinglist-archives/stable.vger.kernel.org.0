Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A24E75A460B
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 11:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiH2J1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 05:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiH2J1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 05:27:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608E74CA05;
        Mon, 29 Aug 2022 02:27:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1A7260FAB;
        Mon, 29 Aug 2022 09:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C15C433D6;
        Mon, 29 Aug 2022 09:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661765221;
        bh=tmJ0wOooOYsTfBgso9W7TJAc65M1mnAkqlk01AU2yy4=;
        h=From:To:Cc:Subject:Date:From;
        b=KXFA1HzoZgUfxNjJtoO3m0ZmFoxvehjWZqS+U8I6JuRBQBH90scuMVuQmWuOZBWV6
         VeRsYkK5+c3X5vkP2gbEoxcHTyFa6AovTdUFXJSZQTDMMpWbFK6boV+UoT3QsDpseZ
         x92bBQCGjQ3HLyV7ajo09e1r2uXqtWJ/7snCdK80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.19.5
Date:   Mon, 29 Aug 2022 11:26:57 +0200
Message-Id: <166176521755100@kroah.com>
X-Mailer: git-send-email 2.37.2
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

I'm announcing the release of the 5.19.5 kernel.

All users of the 5.19 kernel series must upgrade.

The updated 5.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Greg Kroah-Hartman (1):
      Linux 5.19.5

Ondrej Mosnacek (1):
      kbuild: dummy-tools: avoid tmpdir leak in dummy gcc

