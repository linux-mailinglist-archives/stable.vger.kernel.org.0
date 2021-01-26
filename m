Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E04303FD9
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 15:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405566AbhAZOMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 09:12:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:52238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392714AbhAZOLs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 09:11:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73CD322B2C;
        Tue, 26 Jan 2021 14:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611670266;
        bh=qO17FhbVa3mQXfbFaSTtqkRgjyif4xmgiKHzen6itRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N+xve1OJpR7HBorZfqUr1945A9NAf59Lvo8Uq7T1lqXBFwT31Pa9jTP+oHJdYXgg/
         aYOVFbu86zBOF5WBky1usTgRxs2TPN+2wpcklFUA6l6WTWLZ7MKp9jhiotX94PQhnf
         mgCJV+QKA1rTPB65bcWaWiOHmmI9uwa49eKMslpJHkDQ/D/im6fmPXN2eaSnQV8dXc
         kiluAp+fKvxGgSxh0nFRRfBwgcYGY8XZJnnZwm20X5tU5bpAXbRanqDksS+i8nDs+W
         EQg/sIaRA61l3wj/SjTapp1o7D13yN+DE2F8BxyzNyN4Vi2VpALVWBjLgUkCkP+G4z
         tnyVMc2eP4JKA==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1l4P3r-0004bh-Tj; Tue, 26 Jan 2021 15:11:15 +0100
Date:   Tue, 26 Jan 2021 15:11:15 +0100
From:   Johan Hovold <johan@kernel.org>
To:     linux-usb@vger.kernel.org
Cc:     Johan Hovold <johan@kernel.org>, Vladimir <svv75@mail.ru>,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: ftdi_sio: fix FTX sub-integer prescaler
Message-ID: <YBAjA7rpUzUJrplZ@hovoldconsulting.com>
References: <20210126135917.17545-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126135917.17545-1-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 26, 2021 at 02:59:17PM +0100, Johan Hovold wrote:
> The most-significant bit of the sub-integer-prescaler index is set in
> the high byte of the baudrate request wIndex also for FTX devices.
> 
> This fixes rates like 1152000 which got mapped to 12 MBd.

Hmm. I played around with this using an FT232H which has a 12 MHz clock
so this example is off for FTX. I'll fix it up before applying.

Johan
