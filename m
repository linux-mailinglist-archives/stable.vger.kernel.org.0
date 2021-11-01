Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0B6441D6D
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 16:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhKAPbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 11:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230517AbhKAPbm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 11:31:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E2B760EFF;
        Mon,  1 Nov 2021 15:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635780548;
        bh=83oGevo08WlvBDtpmn0Igb5tu3l7SnucC2UDRKqaqik=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mKLfp1lW7PjC9mnrkI5hNW4su1iMYbNliMPNeQg83pdQENe5Tcc70R3wF09t+6ru9
         2yTm0kYtYefhQ+zmmlASUqqLII9YBedsXHhXTy2SQc4YLzza6GfeNSJSwSai5lMrJe
         kopSesX06JKcT5qxR2swrcbeenh/XFcwXaeRKkAs=
Date:   Mon, 1 Nov 2021 16:29:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     mike chant <mikechant@gmail.com>
Cc:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        webmaster@kernel.org, stable@vger.kernel.org
Subject: Re: https://www.kernel.org/category/releases.html possible
 significant typo?
Message-ID: <YYAHwHFaSqiJtP0l@kroah.com>
References: <CALNuP9Eo7nVW2vTm1pWNVQemyxn9GF6TNFgAVPxgXXb_vo5vtA@mail.gmail.com>
 <20211101152013.bbs3siqa5aezy247@meerkat.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101152013.bbs3siqa5aezy247@meerkat.local>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 01, 2021 at 11:20:13AM -0400, Konstantin Ryabitsev wrote:
> On Mon, Nov 01, 2021 at 02:43:31PM +0000, mike chant wrote:
> > Hi,
> > The table of LTS releases on this page shows an EOL date of October 2023
> > for 5.15. Judging by the other EOL dates, shouldn't this be 2027?
> 
> LTS releases are generally supported for 2 years UNLESS someone steps up and
> offers to help support it for longer.
> 
> With further questions, please email stable@vger.kernel.org.

And to further expand on this, please see this post from last year when
this came up last time:
	http://kroah.com/log/blog/2021/02/03/helping-out-with-lts-kernel-releases/

I'll work on adding some of the wording from there to the kernel.org
releases page later this week, as this comes up every year...

thanks,

greg k-h
