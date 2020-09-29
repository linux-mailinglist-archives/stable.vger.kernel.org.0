Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67C727BD7C
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 08:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbgI2G64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 02:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbgI2G64 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 02:58:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56CF920774;
        Tue, 29 Sep 2020 06:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601362735;
        bh=FoHeBmQF8o+xWr5HH47BqF+Qsfva4s/DP+SK8XIm/vU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1ZrdP5UXa7Jp4y777EvRf5itoxbL9b8sPctsaCI1Ywp4TBj6xvaBCIBuCFFs68Lix
         5ZKB3ngMfO2JEchNGjOmjEr2ND9fTgR2/397IVeM6ElRq9PjeCvDD0UCBv+bjfdCzA
         OV5+YSRezO1G/WHXO7OUJnu6GeH+ReTXWIhdqFmU=
Date:   Tue, 29 Sep 2020 08:59:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Raviteja Narayanam <raviteja.narayanam@xilinx.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        linux-serial@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH AUTOSEL 4.9 64/90] serial: uartps: Wait for tx_empty in
 console setup
Message-ID: <20200929065902.GD2439787@kroah.com>
References: <20200918021455.2067301-1-sashal@kernel.org>
 <20200918021455.2067301-64-sashal@kernel.org>
 <CA+G9fYuT_qF2sbmCV76C3B=KS7tSjo9XDkCLwm0A4ZBLJ_eBtw@mail.gmail.com>
 <CA+G9fYtRj=+KM0CJZjPnfCn6OHcW7iFAkE=ECKiz4uOOyq=B2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtRj=+KM0CJZjPnfCn6OHcW7iFAkE=ECKiz4uOOyq=B2Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 01:43:22AM +0530, Naresh Kamboju wrote:
> On Tue, 29 Sep 2020 at 01:41, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On Fri, 18 Sep 2020 at 07:55, Sasha Levin <sashal@kernel.org> wrote:
> > >
> > > From: Raviteja Narayanam <raviteja.narayanam@xilinx.com>
> > >
> > > [ Upstream commit 42e11948ddf68b9f799cad8c0ddeab0a39da33e8 ]
> > >
> > > On some platforms, the log is corrupted while console is being
> > > registered. It is observed that when set_termios is called, there
> > > are still some bytes in the FIFO to be transmitted.
> > >
> > > So, wait for tx_empty inside cdns_uart_console_setup before calling
> > > set_termios.
> > >
> > > Signed-off-by: Raviteja Narayanam <raviteja.narayanam@xilinx.com>
> > > Reviewed-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
> > > Link: https://lore.kernel.org/r/1586413563-29125-2-git-send-email-raviteja.narayanam@xilinx.com
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> >
> > stable rc 4.9 arm64 build broken.
> 
> and stable rc 4.9 arm build broken.

Thanks, I've queued up the dependant patch, somehow Sasha's builders
must have missed this :)

greg k-h
