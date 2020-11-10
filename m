Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4682AE12E
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 21:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731740AbgKJU54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 15:57:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:59868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgKJU54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 15:57:56 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76ABE20665;
        Tue, 10 Nov 2020 20:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605041876;
        bh=7vQtlnI2khsuBQ5ek8VV+soKF7rZnPYPaTw5ittEe9c=;
        h=From:To:Cc:Subject:Date:From;
        b=Ox4m24hBJ0a1+1XQZnx55SZubBDF+HnV0rc9K64ZAEXhOrUEThKUEkb960Ukh7hZk
         UEgVy8jlrtPlRdkk6/jIDvJJ9kAyPAmdb40FWQIWa9LP/aI8m7pD85wCr8wWfWOkLN
         92jpc7wt5DAWWP+NLfUeOoXXtBLOhheCQx2RRhzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.243
Date:   Tue, 10 Nov 2020 21:58:57 +0100
Message-Id: <160504192649180@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.243 kernel.

Please see the 5.9.8 announcement if you are curious if you should
upgrade or not:
	https://lore.kernel.org/lkml/1605041246232108@kroah.com/

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                        |    2 +-
 drivers/powercap/powercap_sys.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Greg Kroah-Hartman (1):
      Linux 4.9.243

Len Brown (1):
      powercap: restrict energy meter to root access

