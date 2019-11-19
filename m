Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEF2102860
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 16:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbfKSPpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 10:45:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727509AbfKSPpr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 10:45:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76C2C222A2;
        Tue, 19 Nov 2019 15:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574178347;
        bh=2A4V+QTjKVdclRaSKrXFXbwEDtY6OhcEom9OfXnM43U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wTOfx/xGn0eZ0lIx4jRt6aq0sbRfGvHVDC30VdCssHM+oZseXEY/Sjj2rwcdEOcOY
         tb4aX+5vouN+I6VEL7sE8KI+Z+dnvoWkCk1Z+leGUhnXkmQF8fyWWMGkp0VHTWnIPF
         jpII+nwVYRwAz4a6zMgCc4jiWIzKlhVrgpU6MeKc=
Date:   Tue, 19 Nov 2019 16:45:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Richard Genoud <richard.genoud@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Radu Pirea <radu_nicolae.pirea@upb.ro>,
        Sasha Levin <sashal@kernel.org>,
        "stable # 4 . 4+" <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 4.19 150/422] tty/serial: atmel: Change the driver to
 work under at91-usart MFD
Message-ID: <20191119154544.GA1982025@kroah.com>
References: <20191119051400.261610025@linuxfoundation.org>
 <20191119051408.360814564@linuxfoundation.org>
 <86754813-17ae-46c1-f222-1635c535668e@gmail.com>
 <ee45d6af-82c1-86e6-1abe-d9ac97307eec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ee45d6af-82c1-86e6-1abe-d9ac97307eec@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 02:17:16PM +0100, Richard Genoud wrote:
> Le 19/11/2019 à 13:01, Richard Genoud a écrit :
> > Hi all,
> > 
> > Le 19/11/2019 à 06:15, Greg Kroah-Hartman a écrit :
> >> From: Radu Pirea <radu.pirea@microchip.com>
> >>
> >> [ Upstream commit c24d25317a7c6bb3053d4c193b3cf57d1e9a3e4b ]
> >>
> >> This patch modifies the place where resources and device tree properties
> >> are searched.
> > 
> > Maybe I missed something, but I don't see why this is backported to stable.
> > I don't think that this patch was send with a Cc: stable (I just came
> > back from holidays, so I may be wrong :))
> > 
> > Moreover, it's part of a series that introduce "config MFD_AT91_USART",
> > but grepping MFD_AT91_USART on stable-rc/linux-4.19.y only returns:
> > drivers/tty/serial/Kconfig:     select MFD_AT91_USART
> > 
> > So I think this is a mistake (but how it got there ? it is by a bot or
> > something ?)
> Replying to myself :)
> 
> Mystery solved, it was added by Sasha's bot/AI
> [PATCH AUTOSEL 4.19 118/205] tty/serial: atmel: Change the driver to work under at91-usart MFD
> 
> So Greg, you can safely drop this patch.

Now dropped, thanks.

greg k-h
