Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDA019A8A0
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 11:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbgDAJ3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 05:29:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgDAJ3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 05:29:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EEE62077D;
        Wed,  1 Apr 2020 09:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585733351;
        bh=ZC+oj+dv4+cXVp7A/zaS6x9g5aUmGdh0MbYPQjavR38=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=urxulJ4GJDNeh88GBKQWbF6o4acjvy6XMmoB8ZvuT5S4aLggDuEJKtUfnc4mtpWnu
         0fAYQ7PfCJyZRXmiL9HnN5scxzNvFfP6fmC/ikmoIAmROcMAkNUkSa19R3+MmUWmzW
         aG3QqIxfstAN0fLxC3J+0NMIXDUex0wHbOQpCyMo=
Date:   Wed, 1 Apr 2020 11:29:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Schmid, Carsten" <Carsten_Schmid@mentor.com>
Cc:     "sashal@kernel.org" <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH Backport to stable/linux-4.14.y] make
 'user_access_begin()' do 'access_ok()'
Message-ID: <20200401092908.GA2055942@kroah.com>
References: <8a297704c58b4b4e867efecb08214040@SVR-IES-MBX-03.mgc.mentorg.com>
 <1585733082992.99012@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585733082992.99012@mentor.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 01, 2020 at 09:24:43AM +0000, Schmid, Carsten wrote:
> >From eb5a13ddc30824c20f1e2b662d2c821ad3808526 Mon Sep 17 00:00:00 2001
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Fri, 4 Jan 2019 12:56:09 -0800
> Subject: [PATCH] make 'user_access_begin()' do 'access_ok()'
> 
> [ Upstream commit 594cc251fdd0d231d342d88b2fdff4bc42fb0690 ]
> 
> Fixes CVE-2018-20669
> Backported from v5.0-rc1
> Patch 1/1

What about 4.19?

thanks,

greg k-h
