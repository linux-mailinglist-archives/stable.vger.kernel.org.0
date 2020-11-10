Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B6F2AE139
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 21:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730979AbgKJU6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 15:58:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:60254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgKJU6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 15:58:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2651820665;
        Tue, 10 Nov 2020 20:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605041919;
        bh=B5DNdFf1iJiVn8VF9Y6VaOvmNy6ey72q1EwZgcbJyNo=;
        h=From:To:Cc:Subject:Date:From;
        b=GzdEnnJa4OEiaQwdVK4MBK+E41WE9WvfyN6v6vid8jBk1ME2xdbThN4FwSoph0bN9
         cjNCXchox8I8IhUYNYf3GyTGkmAUYEFR2u+Gh8rJjk7W2OLWwP82P5OLJ1l3dFGYw3
         e/5lgxJgr6pJPLvbX3fYtDbJMQUhtq5xU+UvHBWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.157
Date:   Tue, 10 Nov 2020 21:59:40 +0100
Message-Id: <160504197091230@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.157 kernel.

Please see the 5.9.8 announcement if you are curious if you should
upgrade or not:
	https://lore.kernel.org/lkml/1605041246232108@kroah.com/

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                        |    2 +-
 drivers/powercap/powercap_sys.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Greg Kroah-Hartman (1):
      Linux 4.19.157

Len Brown (1):
      powercap: restrict energy meter to root access

