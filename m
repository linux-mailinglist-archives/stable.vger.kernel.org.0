Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9464AAAED
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 19:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380920AbiBESeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 13:34:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59358 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380924AbiBESeD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 13:34:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1623460FB7;
        Sat,  5 Feb 2022 18:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6AA8C340E8;
        Sat,  5 Feb 2022 18:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644086042;
        bh=bfCHxMaYx7OAeCa+nl7hUkUUhRa1kN26idddDv9m6q8=;
        h=From:To:Cc:Subject:Date:From;
        b=ne6LfvgCYXLAkFA5rLnRTd33Apnsz7tsgZXmdvu73UVcG75qf7pVjx9sxOR8E6+W1
         +V5/QAZqnhoiyATxlFzw7tiiAX7Vv8CR6NSEsMualzoDyIV3lUZupusiir/Oz8xZJv
         JjAYUMsmTf+dpbyOpePHMDUAJ/HON7TDz4xjxr4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.98
Date:   Sat,  5 Feb 2022 19:33:55 +0100
Message-Id: <1644086035165161@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.98 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
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
      Linux 5.10.98

