Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10401173196
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 08:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgB1HNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 02:13:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:37618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbgB1HNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 02:13:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8BB92469D;
        Fri, 28 Feb 2020 07:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582874018;
        bh=nscebRBkFu96VQOWUklNoxyN62+4yjlFmVkow0WZJqo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f/LvZhJlCAGMo4BwObfGmr0BaFhEaKbdJ5Rn3vTJZ8uPIPaJ3e6C7jrTONYFu0JiD
         Z6aqRot9tPxQ44AFRuq65bYa5WCwHnPrg9Fk/TKr0ztCGN0+fO5CIk/zVmThuxpkln
         sqFqw9iiGR+HgzKzT7jU8njaGAwrsvU/yXvQWJxE=
Date:   Thu, 27 Feb 2020 19:50:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 5.5 133/150] scripts/get_maintainer.pl: deprioritize old
 Fixes: addresses
Message-ID: <20200227185028.GA2019187@kroah.com>
References: <20200227132232.815448360@linuxfoundation.org>
 <20200227132252.076691216@linuxfoundation.org>
 <dd96f64a5fd44278e48a1f7ee9269c485278d183.camel@perches.com>
 <20200227161829.GE3308@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227161829.GE3308@kadam>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 27, 2020 at 07:18:29PM +0300, Dan Carpenter wrote:
> On Thu, Feb 27, 2020 at 07:20:32AM -0800, Joe Perches wrote:
> > On Thu, 2020-02-27 at 14:37 +0100, Greg Kroah-Hartman wrote:
> > > From: Douglas Anderson <dianders@chromium.org>
> > > 
> > > commit 0ef82fcefb99300ede6f4d38a8100845b2dc8e30 upstream.
> > 
> > I think adding just about any checkpatch patch to stable a bit silly.
> > Including patches to checkpatch.
> > 
> 
> On the other hand, Greg is one of the worst affected by the old behavior
> since he has so many old email addresses and he's also the stable
> maintainer.

Exactly, lots of people still do development against the latest released
kernel, which is 5.5 here...

thanks,

greg kh-
