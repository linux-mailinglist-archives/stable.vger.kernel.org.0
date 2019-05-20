Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2FE231F6
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 13:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731504AbfETLH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 07:07:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731093AbfETLH5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 07:07:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D1ED20675;
        Mon, 20 May 2019 11:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558350476;
        bh=gUebIO41eM4dP3W87kylj25xYXVbXqq++tSnwHd3WA8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o4wQgOzUML/HjfQpBnjlFCzlds2GNuiwJ+KT3/q3i+STijwp4FQKX/zE/cFUKQgJz
         GcBklVFWy+tTBcE3QpMYMYedrMIWmkWcyvGHxRBryAOi0Pmz/v3q/+4JrpatWB9vIC
         olpU55Zdf4SchWdjHoAdLh1n/H8lLR4IY5rfIzn4=
Date:   Mon, 20 May 2019 13:07:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Doug Anderson <dianders@chromium.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH pstore-next v2 2/4] pstore: Allocate compression during
 late_initcall()
Message-ID: <20190520110754.GB20211@kroah.com>
References: <20181018185616.14768-1-keescook@chromium.org>
 <20181018185616.14768-3-keescook@chromium.org>
 <CAM0oz-91yjPQKnxGDjwFThs19U=+iziuUr=9z13NSibr_uRxZQ@mail.gmail.com>
 <20190505131654.GC25640@kroah.com>
 <CAD=FV=UV7x-qJU86MzHxY8bqDV7rcc3XoyotKyy_+1MpMM22bA@mail.gmail.com>
 <CAGXu5jKzH0Ttdtp5bXP_EAfp+fA+tEQwLXh=VmZ1r5q6wdpqaw@mail.gmail.com>
 <CAGXu5jKtteYVhB=jpjBBkGqW5_XK=zpCP24Fj+mM0L8RBnhh=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKtteYVhB=jpjBBkGqW5_XK=zpCP24Fj+mM0L8RBnhh=A@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 06, 2019 at 09:05:12AM -0700, Kees Cook wrote:
> Doug said:
> > > > > I'd propose that these three patches:
> > > > >
> > > > > 95047b0519c1 pstore: Refactor compression initialization
> > > > > 416031653eb5 pstore: Allocate compression during late_initcall()
> > > > > cb095afd4476 pstore: Centralize init/exit routines
> 
> Okay, confirmed. These look sufficient to me, and the resulting tree
> passes my pstore tests. Greg, can you please pull these into 4.19?

All now queued up, thanks.

greg k-h
