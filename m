Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B28434AF1
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 16:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbfFDOuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 10:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:32830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727573AbfFDOuk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 10:50:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E0C220874;
        Tue,  4 Jun 2019 14:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559659839;
        bh=G/ERt7KeFDGLvlBEkaARKO68KsA4wWqnpkR2xmPvUoM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GcXA53ERk4s8WW7fdfjutYIvO0LTLCCSvh0O4qxBjFqsWxf08ARAkz03Wk7GYL21L
         ZPfl0ja4W6YTdRePKRd7eTrtGkrn8TCsVwLwCfIeRML8/HM2cSIDBTf0v4LLzJRbd6
         yxghKGOqfhC3TZV7Iy6CiNp5bs7DBwPhAkWWb77g=
Date:   Tue, 4 Jun 2019 16:50:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Todd Kjos <tkjos@google.com>
Cc:     Todd Kjos <tkjos@android.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [stable] binder: fix race between munmap() and direct reclaim
Message-ID: <20190604145037.GB5824@kroah.com>
References: <1558991372.2631.10.camel@codethink.co.uk>
 <20190528065131.GA2623@kroah.com>
 <CAHRSSEzopAbeAv4ap9xTrC1nCbpw1ZPrEYEMZOc5W_EcLZaktQ@mail.gmail.com>
 <CAHRSSEw=z4hyHMZV=WYAs_hy6Wp2qRk2mWGRSiXUO49d1SDVfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHRSSEw=z4hyHMZV=WYAs_hy6Wp2qRk2mWGRSiXUO49d1SDVfQ@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 31, 2019 at 01:09:53PM -0700, Todd Kjos wrote:
> Greg,
> 
> I'm really confused. [1] was my submittal to stable for "binder: fix
> race between munmap() and direct reclaim" which I think looks correct.
> 
> For "binder: fix handling of misaligned binder object", I only
> submitted to LKML [2]. But then I see [3] for 4.14 (that looks
> incorrect as Ben pointed out).
> 
> So the result is that fix is present in the LTS trees where it is
> needed, but it has the wrong commit message and headline.
> 
> I agree with Ben that the cleanest approach is to revert and apply the
> correct version (to 4.14, 4.19, 5.0). I think the correct version is
> the one I sent [1], but please let me know if you see something I
> screwed up or if you need me to do something.
> 
> [1] https://www.spinics.net/lists/stable/msg299033.html
> [2] https://lkml.org/lkml/2019/2/14/1235
> [3] https://lkml.org/lkml/2019/4/30/650

Can you send me a patch series that fixes things up properly?  I really
don't know exactly what to do here, sorry.

thanks,

greg k-h
