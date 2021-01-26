Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FAB304025
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 15:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392747AbhAZOWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 09:22:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:54432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392734AbhAZOWu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 09:22:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 055C5206CA;
        Tue, 26 Jan 2021 14:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611670930;
        bh=X9FPMC+4Y+0/AZRlsJrrFltkMpDOxXsBtu6Y11Swzas=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Objua34gZ+98ZM4wpEQotlhOcI2eOHQGFgvPubgnYlu09mru8s99eBoNAjUHoYufG
         mfZvwh9dR6+3WiygTSvzN4Y0BTRD/e9TvETI+AaroS1l8bc/GCf7TIjpdUJfjMEaqn
         7wWPRYIza+Ba9ASuT61QyaAY0VbMCr9LfbkjRnf3wELh4jaxUlnCFREkd72PUOugmz
         wlhLNk1sBZHZi4azZRHuhmqlff981eUck6d/1Wh+OX550vGsQU9lcUcdHM1ymHR1cY
         WgweClKtN06ASBavLRfly07BsggO3b59QRuXDTZYrDzLZxmxEBpUmY/+lHogf/Pq2y
         lRw80ipVnpQ+Q==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1l4PEZ-0006gT-BQ; Tue, 26 Jan 2021 15:22:19 +0100
Date:   Tue, 26 Jan 2021 15:22:19 +0100
From:   Johan Hovold <johan@kernel.org>
To:     linux-usb@vger.kernel.org
Cc:     Johan Hovold <johan@kernel.org>, Vladimir <svv75@mail.ru>,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: ftdi_sio: fix FTX sub-integer prescaler
Message-ID: <YBAlmwKnlmYeqc0j@hovoldconsulting.com>
References: <20210126135917.17545-1-johan@kernel.org>
 <YBAjA7rpUzUJrplZ@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBAjA7rpUzUJrplZ@hovoldconsulting.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 26, 2021 at 03:11:15PM +0100, Johan Hovold wrote:
> On Tue, Jan 26, 2021 at 02:59:17PM +0100, Johan Hovold wrote:
> > The most-significant bit of the sub-integer-prescaler index is set in
> > the high byte of the baudrate request wIndex also for FTX devices.
> > 
> > This fixes rates like 1152000 which got mapped to 12 MBd.
> 
> Hmm. I played around with this using an FT232H which has a 12 MHz clock
> so this example is off for FTX. I'll fix it up before applying.

Nope, false alarm, it still holds.

Johan
