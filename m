Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4687812CF96
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 12:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbfL3Lec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 06:34:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:35506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727360AbfL3Lec (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Dec 2019 06:34:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B7AB206E4;
        Mon, 30 Dec 2019 11:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577705671;
        bh=ZF4QpeWMRzVNh/7YVGePhghEgMWqiWlwc6VbNwNqTFo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iDejW0Watpe54MljfLJtjmUxDSOm8qGIALDCJBuUPqBOFPA2MPo4/KZXVhiEo4d9Q
         4dU1MbheR5qbe9OAtlUJ06v8AePEYByODwt7JGtu/0U15E1dY0AcVWtWf9krXrOanF
         5Cinl6LiulKKrK2c7J+xiOBJ3Otq5ghCTjL0Hmr0=
Date:   Mon, 30 Dec 2019 12:25:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-usb@vger.kernel.org, linux@roeck-us.net,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB-PD tcpm: bad warning+size, PPS adapters
Message-ID: <20191230112509.GA884080@kroah.com>
References: <20191230033544.1809-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191230033544.1809-1-dgilbert@interlog.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 29, 2019 at 10:35:44PM -0500, Douglas Gilbert wrote:
> Augmented Power Delivery Objects (A)PDO_s are used by USB-C
> PD power adapters to advertize the voltages and currents
> they support. There can be up to 7 PDO_s but before PPS
> (programmable power supply) there were seldom more than 4
> or 5. Recently Samsung released an optional PPS 45 Watt power
> adapter (EP-TA485) that has 7 PDO_s. It is for the Galaxy 10+
> tablet and charges it quicker than the adapter supplied at
> purchase. The EP-TA485 causes an overzealous WARN_ON to soil
> the log plus it miscalculates the number of bytes to read.
> 
> So this bug has been there for some time but goes
> undetected for the majority of USB-C PD power adapters on
> the market today that have 6 or less PDO_s. That may soon
> change as more USB-C PD adapters with PPS come to market.
> 
> Tested on a EP-TA485 and an older Lenovo PN: SA10M13950
> USB-C 65 Watt adapter (without PPS and has 4 PDO_s) plus
> several other PD power adapters.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>  drivers/usb/typec/tcpm/tcpci.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
