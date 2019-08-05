Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 564B2817B4
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 12:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfHEK7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 06:59:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727158AbfHEK7Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 06:59:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24A0120880;
        Mon,  5 Aug 2019 10:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565002764;
        bh=BdI8/BpkJiqKX+9Vm2ng2suk2R/G27+dGa4vCpmdg68=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JfG5ef1Xp6ITXTFyJXLNGAUoHLNJ2GXvTbXigO9EgV/jtcA8VfEWqZAB8eGIl7UCF
         PNtCI6LL12sj5D43zjDkStNJTmKYgxdeILLeEKYldUI7whKvnqiVokk44t/XJTQvnR
         ICiiyaJ9TKGE2VlvpUUfITDXk+VNP3iemuridwTo=
Date:   Mon, 5 Aug 2019 12:59:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc:     Jean Delvare <jdelvare@suse.de>, Andrew Lunn <andrew@lunn.ch>,
        Arnd Bergmann <arnd@arndb.de>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        "Stable # 4 . 20+" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] eeprom: at24: make spd world-readable
 again" failed to apply to 4.19-stable tree
Message-ID: <20190805105922.GB1157@kroah.com>
References: <1564982748230183@kroah.com>
 <20190805103242.4816abcc@endymion>
 <CAMpxmJUfPKwmhBD_cNHUA9m_AZ3a0ekX+6oeptU6z6COGBwV4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMpxmJUfPKwmhBD_cNHUA9m_AZ3a0ekX+6oeptU6z6COGBwV4w@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 10:35:41AM +0200, Bartosz Golaszewski wrote:
> pon., 5 sie 2019 o 10:32 Jean Delvare <jdelvare@suse.de> napisał(a):
> >
> > Hi Greg,
> >
> > On Mon, 05 Aug 2019 07:25:48 +0200, gregkh@linuxfoundation.org wrote:
> > > The patch below does not apply to the 4.19-stable tree.
> >
> > Technically it applies. Just it doesn't build ;-)
> >
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> >
> > The backport is trivial, I'll take care of it, thanks.
> >
> > --
> > Jean Delvare
> > SUSE L3 Support
> 
> Hi Jean,
> 
> I already sent backports for v4.9, v4.14 and v4.19 earlier today.

Thanks for those, now queued up.

greg k-h
