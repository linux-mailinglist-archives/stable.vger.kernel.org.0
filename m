Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515F74AAAEF
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 19:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380963AbiBESeT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 13:34:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59000 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380972AbiBESeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 13:34:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D4C5B80CE4;
        Sat,  5 Feb 2022 18:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A67C340E8;
        Sat,  5 Feb 2022 18:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644086054;
        bh=CYXK4IbZS6vhDfO+29+Q+rxRhsD3PXr2Z8oJOHdpk+g=;
        h=From:To:Cc:Subject:Date:From;
        b=dEHLeGO1G2hKV8Lcqa4Qc+DTKHGJloeUKBRKg0aj/MRzcAiSuJpmfxa1K0+qZXC80
         HdoAMWZMpYpP0AlSTUJ6KttiWWgFXvCsBlFRKf4syq/TeC39pckB3A9ZnV/Nm6d9f9
         O1UAcsjcc0S4aZJrcDO7JGx7TuhagROIweOlBT/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.16.7
Date:   Sat,  5 Feb 2022 19:34:00 +0100
Message-Id: <164408604121961@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.16.7 kernel.

All users of the 5.16 kernel series must upgrade.

The updated 5.16.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.16.y
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
      Linux 5.16.7

