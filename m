Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15883389FD7
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 10:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhETIcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 04:32:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230447AbhETIcp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 04:32:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C521610A2;
        Thu, 20 May 2021 08:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621499483;
        bh=w3cSr46Gu7qYLH2FVMvtbLaOseZ1aN+CGEAn47g8lOc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d0yTm1FGDUBgExJX9st58wR5BJq3u/HObMX6lGYgIk+/aYqYPLJ51v56GZy83hB1Z
         SIA0YTr2WN7x4vhkeXgi/QkZqip2H8UsZ6EtgVvy9J1/DXvtMKTMua15bkMx8KJ89S
         uzDT3iEkP2KAXg4TMkv28SLR2r61M6LCAdK6RXYA=
Date:   Thu, 20 May 2021 10:31:20 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc:     "sashal@kernel.org" <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 5.4 020/141] ip6_vti: proper dev_{hold|put} in
 ndo_[un]init methods
Message-ID: <YKYeWAAnWPEESPGK@kroah.com>
References: <20210517140242.729269392@linuxfoundation.org>
 <20210517140243.443931506@linuxfoundation.org>
 <5520be7988fb894c0f4a7c9d7031410c51fcec1c.camel@nokia.com>
 <YKYBS0W1vh1949rK@kroah.com>
 <c776ad9a2695c14a65e63796fcfd11e877b9d92c.camel@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c776ad9a2695c14a65e63796fcfd11e877b9d92c.camel@nokia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 07:55:49AM +0000, Rantala, Tommi T. (Nokia - FI/Espoo) wrote:
> > I do not understand, what needs to be done here?
> 
> Sorry, email formatting got somehow messed up.
> 
> Please cherry-pick this to 5.4.y:
> 
>   commit 0d7a7b2014b1a499a0fe24c9f3063d7856b5aaaf
>   Author: Eric Dumazet <edumazet@google.com>
>   Date:   Wed Mar 31 14:38:11 2021 -0700
> 
>     ipv6: remove extra dev_hold() for fallback tunnels
>     
> 
> And these:
> 
>     Fixes: 48bb5697269a ("ip6_tunnel: sit: proper dev_{hold|put} in
> ndo_[un]init methods")
>     Fixes: 6289a98f0817 ("sit: proper dev_{hold|put} in ndo_[un]init
> methods")
>     Fixes: 7f700334be9a ("ip6_gre: proper dev_{hold|put} in ndo_[un]init
> methods")

Ah, that makes sense.  Tricky as the "Fixes:" tag for those other
commits were not backported because they pointed to a feature added to
debug these issues :)

now queued up.

greg k-h
