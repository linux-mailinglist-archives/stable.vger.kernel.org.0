Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F12327CEA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 12:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbhCALQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 06:16:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231907AbhCALQ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 06:16:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E0ED64DE0;
        Mon,  1 Mar 2021 11:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614597346;
        bh=rXWIApSn5fbyIydO0ULdQv+Nv75ZOvn/s5uDXS/exJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lmddRJD8KRd3nqRLxJVyZENJpYc9iyNYHGJUn+m0RMv0dtBIwzuLJieQW8H0CZYn5
         0IjAiSERWfFjSlclu4QzuzFZUzlE2YeEJubl1iaIneaKD683hi8UZcJoMoLzg/t88c
         9ZHdnrS/S76guk4PTFMxlgD0Q+UKI7GT6XoKOrV4=
Date:   Mon, 1 Mar 2021 12:15:43 +0100
From:   gregkh <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] drivers: soc: atmel: add null entry at
 the end of" failed to apply to 5.4-stable tree
Message-ID: <YDzM32cs/ZLoUYLj@kroah.com>
References: <1614594762206238@kroah.com>
 <CAK8P3a27HB89omfNGBWbbztB6Fg1qfOzjqtKJ7sDurMRi4AAPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a27HB89omfNGBWbbztB6Fg1qfOzjqtKJ7sDurMRi4AAPg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 11:52:17AM +0100, Arnd Bergmann wrote:
> On Mon, Mar 1, 2021 at 11:32 AM <gregkh@linuxfoundation.org> wrote:
> >
> >
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> > Fixes: caab13b49604 ("drivers: soc: atmel: Avoid calling at91_soc_init on non AT91 SoCs")
> > Cc: stable@vger.kernel.org #4.12+
> 
> Hi Greg,
> 
> Did you add a backport of the caab13b49604 patch to 5.4 and earlier?

Yes, it is in the following releases:
	4.14.219 4.19.173 5.4.95 5.10.13 5.11

> Without that patch, this one will not apply, but if you did apply caab13b49604,
> we need this one as well, and should do a backport.

Agreed, that's why I asked for one :)

thanks,

greg k-h
