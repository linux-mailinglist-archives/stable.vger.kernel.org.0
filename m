Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3533311C3E
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 09:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhBFIjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 03:39:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229742AbhBFIiy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Feb 2021 03:38:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B5BE64FC5;
        Sat,  6 Feb 2021 08:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612600694;
        bh=7liFlNUyQncivbxVFHjM6nmFcI6+mZPsMTnYfBxZ8Ew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=psYujYGjrOUf9h+M5dphZzjC7rILqS2uzntYXC/q2utQYL6FQ41fxo/GkUzBYkOhE
         y4iw+CBYVDKUgYy7uc1M8bLx6a6GjHXAhRCCA/aXQeFKjFuML3AbQqPJWI7rMdgwLp
         qOXEKxPVNfQq9Vr4kqiKgObRqV0Ab5gpIXME07GI=
Date:   Sat, 6 Feb 2021 09:38:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dave Pawson <dave.pawson@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: How to help with new kernel?
Message-ID: <YB5VcQTUbpe6lSVQ@kroah.com>
References: <CAEncD4esY38Z-Z9t=KOXriZczry7htCYfCh7+B=eC_kUds5miQ@mail.gmail.com>
 <YB4/ESyrjZJ1uMQK@kroah.com>
 <CAEncD4f6pceioDQghmwReRhmHPPMjFMmfJj_Xi_NBzsum17PYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEncD4f6pceioDQghmwReRhmHPPMjFMmfJj_Xi_NBzsum17PYQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Sat, Feb 06, 2021 at 08:31:30AM +0000, Dave Pawson wrote:
> Kernel how to you mention?
> http://www.kroah.com/lkn/  is that the one?

Yes.

> Guessing that is more up to date than the O'Reilly one?

Should be identical.

Also see kernelnewbies.org, it has a lot of good tutorials and
information to help you get started.

good luck!

greg k-h
