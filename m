Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2474030F713
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 17:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237675AbhBDQAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 11:00:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:38516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237279AbhBDQAA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 11:00:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E102961477;
        Thu,  4 Feb 2021 15:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612454360;
        bh=VNqcEDt8Zreb5i6SAVqO2ZC/dbmMeeu5CNyA6xfGbSY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tWgQrE8MM0nu1QtIP1ffhUPqvkkEd2O658aSFmnvWhkexewcMOfEsTRW0Tjqwfhjh
         g6bcICEYkHjX6xn2VbH+wjUlpC6qe+hgV3q6yc6wNpfmqsNW4ZVrl0e2PKa3Y5mF2S
         m1lvqMaSCVN3MnYhSodP3YgWAqXtrj0vBGXxOKos=
Date:   Thu, 4 Feb 2021 16:59:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Jann Horn <jannh@google.com>, Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RESEND] random: fix the RNDRESEEDCRNG ioctl
Message-ID: <YBwZ1a0VIdpTDNuD@kroah.com>
References: <20210112192818.69921-1-ebiggers@kernel.org>
 <YBiEJ9Md60HjAWJg@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBiEJ9Md60HjAWJg@sol.localdomain>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 01, 2021 at 02:43:51PM -0800, Eric Biggers wrote:
> On Tue, Jan 12, 2021 at 11:28:18AM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > The RNDRESEEDCRNG ioctl reseeds the primary_crng from itself, which
> > doesn't make sense.  Reseed it from the input_pool instead.
> > 
> > Fixes: d848e5f8e1eb ("random: add new ioctl RNDRESEEDCRNG")
> > Cc: stable@vger.kernel.org
> > Cc: linux-crypto@vger.kernel.org
> > Cc: Andy Lutomirski <luto@kernel.org>
> > Cc: Jann Horn <jannh@google.com>
> > Cc: Theodore Ts'o <tytso@mit.edu>
> > Reviewed-by: Jann Horn <jannh@google.com>
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> > 
> > Andrew, please consider taking this patch since the maintainer has been
> > ignoring it for 4 months
> > (https://lkml.kernel.org/lkml/20200916041908.66649-1-ebiggers@kernel.org/T/#u).
> 
> Ping.

Given the lack of response, I'll take this now...

thanks,
greg k-h
