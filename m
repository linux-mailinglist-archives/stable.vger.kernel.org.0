Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FAB4A2DE3
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 11:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbiA2K7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 05:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiA2K7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 05:59:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D42DC061714;
        Sat, 29 Jan 2022 02:59:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E930B8235B;
        Sat, 29 Jan 2022 10:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE17C340E5;
        Sat, 29 Jan 2022 10:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643453952;
        bh=MkpMBmCx54BpZ95FOgB5QCa990GueaKQb+byClsXqJw=;
        h=From:To:Cc:Subject:Date:From;
        b=T3BW3jgvaxu65rmGmTDqx7W6wzlbp116yiruGAlcQB25XYf44dXL4bh0hYarErADt
         duW0cGf4/HRNVyHbxkB1uj36zGBx0cgt7AKFjN7CyvPnCdOEYaS1h+vH1/gtCBTwU2
         qMJ0IoAMfufgyz2sbDs2SkC67pV2bQ5DbARlkPYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.301
Date:   Sat, 29 Jan 2022 11:59:02 +0100
Message-Id: <164345394359198@kroah.com>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.301 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                            |    2 
 drivers/gpu/drm/i915/i915_drv.h     |    5 ++
 drivers/gpu/drm/i915/i915_gem.c     |   89 ++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_gem_gtt.c |    3 +
 drivers/gpu/drm/i915/i915_reg.h     |    6 ++
 5 files changed, 104 insertions(+), 1 deletion(-)

Greg Kroah-Hartman (1):
      Linux 4.4.301

Tvrtko Ursulin (1):
      drm/i915: Flush TLBs before releasing backing store

