Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0DBB10E12A
	for <lists+stable@lfdr.de>; Sun,  1 Dec 2019 10:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfLAJj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Dec 2019 04:39:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbfLAJj3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Dec 2019 04:39:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A1B72073C;
        Sun,  1 Dec 2019 09:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575193168;
        bh=FFy1AHMraxMfoo7+0hwjeGuhw8w0IlEU81Fer4kO7FQ=;
        h=Date:From:To:Cc:Subject:From;
        b=VPgfiQCmLQTKakSfq9TBa5z0rnQlytXDOyhK2wKnwNtmKzNkJ4BthLk7pmZZDbk6V
         Cnu1gOnFHD+oYayjiBy4fPg2KNNpgR4rCNv+bvcSqjUAjmErX1f8b4U2dPSWlUigHk
         e5QKpb9gvbi0rRtJPWMN9iJiwq3CIVO6guf3iuBY=
Date:   Sun, 1 Dec 2019 10:39:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.205
Message-ID: <20191201093926.GA3777835@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.205 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile        |    2 +-
 net/core/sock.c |    6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

Greg Kroah-Hartman (2):
      Revert "sock: Reset dst when changing sk_mark via setsockopt"
      Linux 4.4.205

