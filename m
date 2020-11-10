Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7056B2AE11B
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 21:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731696AbgKJUzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 15:55:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:59132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgKJUzp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 15:55:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16EA320665;
        Tue, 10 Nov 2020 20:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605041744;
        bh=AsoX3/7c/lWA404wXEL9/FPlEM0QZeXQAwB9QBdtt9Y=;
        h=From:To:Cc:Subject:Date:From;
        b=CgBxqe1AEvXL8mLPD9tHS/9flwIrEHqRzzECpPUDu4u3pnXexGqerqt091u0vXLM8
         upMn50su73/TwyAt5TfRIr4IgBUFSelHqPtNGCrX4+xMZzzztOdp9mDadc7rScHXfs
         acKZf1gOB7538Y6fCDw6el17LKI6dnQZMj3ae244=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.9.8
Date:   Tue, 10 Nov 2020 21:56:40 +0100
Message-Id: <1605041246232108@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.9.8 kernel.

Only upgrade if you are vunerable to this Intel advisory:
        https://www.intel.com/content/www/us/en/security-center/advisory/intel-sa-00389.html

Hint, if you are using SGX, then upgrade.  And then possibly reconsider
the decisions you have recently made that caused you to write special
code to use that crazy thing.  Personally, it still feels like a
solution in search of a problem.

If not, you should be fine, no need to upgrade.  Unless you really want
to, and the, great, please do so, it's fun!

The updated 5.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                        |    2 +-
 drivers/powercap/powercap_sys.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Greg Kroah-Hartman (1):
      Linux 5.9.8

Len Brown (1):
      powercap: restrict energy meter to root access

