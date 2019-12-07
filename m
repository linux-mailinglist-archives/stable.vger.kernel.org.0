Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 572DF115D55
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 16:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbfLGPeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Dec 2019 10:34:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:33804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726409AbfLGPeQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Dec 2019 10:34:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E715206D6;
        Sat,  7 Dec 2019 15:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575732855;
        bh=IbdGZN5snVNbJMZBpNypHVfaA4DWkOXQfV9twAy1ahs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xea5s90sxatIap37aD5KcnhEuMy8Xy7CwQXVClJKNG6Cf1bBg8Qd0YwBse4LIziny
         g14f4XELGXGZdtjnoODsbb9IldYnitwxSX7WRuEMOT2jmUTXGDVfE+EMj5+VNgGQ6U
         kduWx5hsMlMYhfH2di6mHhySNYc2x6r8PsdlVmX0=
Date:   Sat, 7 Dec 2019 16:34:13 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: io_uring stable addition
Message-ID: <20191207153413.GD486148@kroah.com>
References: <a33932d5-c5ff-ff4d-2bb4-3a1c3401a850@kernel.dk>
 <20191207120158.GC325082@kroah.com>
 <eb01b23d-0e3a-ff36-47fc-e694618c4cb3@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb01b23d-0e3a-ff36-47fc-e694618c4cb3@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 07, 2019 at 08:19:18AM -0700, Jens Axboe wrote:
> On 12/7/19 5:01 AM, Greg KH wrote:
> > On Wed, Dec 04, 2019 at 08:53:43AM -0700, Jens Axboe wrote:
> >> Hi,
> >>
> >> We have an issue with drains not working due to missing copy of some
> >> state, it's affecting 5.2/5.3/5.4. I'm attaching the patch for 5.4,
> >> however the patch should apply to 5.2 and 5.3 as well by just removing
> >> the last hunk. The last hunk is touching the linked code, which was
> >> introduced with 5.4.
> > 
> > Does this match up with a patch in Linus's tree anywhere?  Why is this a
> > stable-only thing?
> 
> Because it was fixed as part of a cleanup series in mainline, before
> anyone realized we had this issue. That removed the separate states
> of ->index vs ->submit.sqe. That series is not something I was
> comfortable putting into stable, hence the much simpler addition.
> Here's the patch in the series that fixes the same issue:
> 
> commit cf6fd4bd559ee61a4454b161863c8de6f30f8dca
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Mon Nov 25 23:14:39 2019 +0300
> 
>     io_uring: inline struct sqe_submit

Thanks for the info, now queued up!

greg k-h
