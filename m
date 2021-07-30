Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164AE3DB89E
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 14:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238663AbhG3MaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 08:30:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230355AbhG3MaC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 08:30:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC6B46103B;
        Fri, 30 Jul 2021 12:29:57 +0000 (UTC)
Date:   Fri, 30 Jul 2021 14:29:55 +0200
From:   Greg KH <greg@kroah.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Charles Yeh <charlesyeh522@gmail.com>,
        =?utf-8?B?WWVoLkNoYXJsZXMgW+iRieamrumRq10=?= 
        <charles-yeh@prolific.com.tw>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris <chris@cyber-anlage.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: pl2303: fix HX type detection
Message-ID: <YQPwwygDuJklttlP@kroah.com>
References: <YQPsgPey1V+7ccGq@hovoldconsulting.com>
 <20210730122156.718-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730122156.718-1-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 30, 2021 at 02:21:56PM +0200, Johan Hovold wrote:
> The device release number for HX-type devices is configurable in
> EEPROM/OTPROM and cannot be used reliably for type detection.
> 
> Assume all (non-H) devices with bcdUSB 1.1 and unknown bcdDevice to be
> of HX type while adding a bcdDevice check for HXD and TB (1.1 and 2.0,
> respectively).
> 
> Reported-by: Chris <chris@cyber-anlage.de>
> Fixes: 8a7bf7510d1f ("USB: serial: pl2303: amend and tighten type detection")
> Cc: stable@vger.kernel.org	# 5.13
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/usb/serial/pl2303.c | 41 ++++++++++++++++++++++---------------
>  1 file changed, 25 insertions(+), 16 deletions(-)
> 

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
