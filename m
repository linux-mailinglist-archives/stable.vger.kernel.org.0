Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B5240D8F5
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 13:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236506AbhIPLoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 07:44:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235686AbhIPLoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 07:44:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0BBC60EE9;
        Thu, 16 Sep 2021 11:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631792577;
        bh=rIn4jdPd9035Erpy762gciVEoVSms4HyFnZTM2Entqw=;
        h=From:To:Cc:Subject:Date:From;
        b=IBrxT0rGX+dh2JOEcXu3eL1SVFbkTSelZ0BMusO4V8G7CEN4jH1qfzq0f5IqzbSjm
         2PAYLcbcugHG/g/+9WpS1V5k8SkxVKRd8Hv5HrvYn61V6s4W87H3AVOPXz4Xr4tMEI
         /yp5+EkUhh+kmfkIZ/YHtK4D0ZxkFhywoCs5DEv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.14.5
Date:   Thu, 16 Sep 2021 13:42:47 +0200
Message-Id: <1631792482198242@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.14.5 kernel.

This, and the other stable kernels released today, consist of only some
reverts to solve some reported problems with the last round of stable
releases.  Upgrading is not required, but highly recommended.

The updated 5.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                       |    2 +-
 include/linux/time64.h         |    9 ++-------
 kernel/time/posix-cpu-timers.c |    2 ++
 3 files changed, 5 insertions(+), 8 deletions(-)

Greg Kroah-Hartman (3):
      Revert "posix-cpu-timers: Force next expiration recalc after itimer reset"
      Revert "time: Handle negative seconds correctly in timespec64_to_ns()"
      Linux 5.14.5

