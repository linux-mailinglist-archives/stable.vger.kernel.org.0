Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 493CA5E38F
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 14:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725847AbfGCMN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 08:13:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfGCMN2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 08:13:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AA7D218A0;
        Wed,  3 Jul 2019 12:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562156007;
        bh=0OHOuzTnvYbjUgVHufRHrrEuiY+/PcCmWxM3jbAsDhY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SawrdzvrViCQ1Zbb924DXiul4MZ9QwPln8o+yoiD9z6MwKnIq2BXzy1OGgkhlKUas
         bnUAGMy9PpTcdz9GqVD00X+sMOicwSI+Tl96geY4Y+hgqlmMQSdJ+WxjRzmtE+RzVJ
         litK/cs6KlAow7JaZx6Hq8zKs3+GMFhLBYYGW4wU=
Date:   Wed, 3 Jul 2019 14:13:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     David.Laight@aculab.com, akpm@linux-foundation.org, arnd@arndb.de,
        axboe@kernel.dk, dave@stgolabs.net, deepa.kernel@gmail.com,
        e@80x24.org, ebiederm@xmission.com, jbaron@akamai.com,
        mtk.manpages@gmail.com, stable@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject: Re: FAILED: patch "[PATCH] signal: remove the wrong signal_pending()
 check in" failed to apply to 5.1-stable tree
Message-ID: <20190703121325.GC7784@kroah.com>
References: <1561990639229217@kroah.com>
 <20190702172802.GA11460@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702172802.GA11460@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 02, 2019 at 07:28:02PM +0200, Oleg Nesterov wrote:
> On 07/01, gregkh@linuxfoundation.org wrote:
> >
> > The patch below does not apply to the 5.1-stable tree.
> ...
> > ------------------ original commit in Linus's tree ------------------
> >
> > From 97abc889ee296faf95ca0e978340fb7b942a3e32 Mon Sep 17 00:00:00 2001
> > From: Oleg Nesterov <oleg@redhat.com>
> > Date: Fri, 28 Jun 2019 12:06:50 -0700
> > Subject: [PATCH] signal: remove the wrong signal_pending() check in
> >  restore_user_sigmask()
> 
> because 5.1 doesn't have fdb288a679cd ("io_uring: use wait_event_interruptible
> for cq_wait conditional wait").
> 
> Please see the updated patch below. Compile tested...

Thanks for this, now queued up.

greg k-h
