Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEC8452B49
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 08:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhKPHKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 02:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229735AbhKPHKB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 02:10:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A15361B4D;
        Tue, 16 Nov 2021 07:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637046425;
        bh=EFTlEHfTDjpaZRxOGOQZ5uhImICq79FV4PVV0ZAJpj4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DGUdYhxnCouwRGZC/018sMXPOomeLKq4nIAYHlJFz/B3F95My5ouJDql0NRGOX+53
         fJobo3UEjZD48uJlzhNdMo3rhaUeqdzKwuQA1sIfVPF2aR3cHcThVW+LjAPIkvD1LU
         n2EcTs7fnyWqqyvj1WkUGBRItG5LeDLAiO0K7YiIUn6A5z4npomVCbwUGFN8hq3xyU
         U/R9h6fr5fIKGILLHNCiVcNK4Xz1HFigHfWp23FR5zknPgSY5A0w4K1oaQd0Mudn1N
         LANLQ4+W+MDhk/ywfFob94a+UPpflm5pNdozlV5jOWspdu60v27KskpA9hv+SdJH7k
         egG1L7sw8qiJQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mmsYL-0003qL-0k; Tue, 16 Nov 2021 08:06:49 +0100
Date:   Tue, 16 Nov 2021 08:06:49 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Stafford Horne <shorne@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilia Sergachev <silia@ethz.ch>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Filip Kokosinski <fkokosinski@antmicro.com>
Subject: Re: [PATCH 2/3] serial: liteuart: fix use-after-free and memleak on
 unbind
Message-ID: <YZNYif9oANkUNQsd@hovoldconsulting.com>
References: <20211115133745.11445-1-johan@kernel.org>
 <20211115133745.11445-3-johan@kernel.org>
 <YZLN2d4jB9AuN4BV@antec>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZLN2d4jB9AuN4BV@antec>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 06:15:05AM +0900, Stafford Horne wrote:
> On Mon, Nov 15, 2021 at 02:37:44PM +0100, Johan Hovold wrote:
> > Deregister the port when unbinding the driver to prevent it from being
> > used after releasing the driver data and leaking memory allocated by
> > serial core.
> 
> This looks good to me.  Just curious did you test this on a Litex
> SoC/FPGA?

No, this series has only been compile tested.

> > Fixes: 1da81e5562fa ("drivers/tty/serial: add LiteUART driver")
> > Cc: stable@vger.kernel.org      # 5.11
> > Cc: Filip Kokosinski <fkokosinski@antmicro.com>
> > Cc: Mateusz Holenko <mholenko@antmicro.com>
> > Cc: Stafford Horne <shorne@gmail.com>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> 
> Reviewed-by: Stafford Horne <shorne@gmail.com>

Thanks for reviewing.

Johan
