Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12EC2CD291
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 10:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388597AbgLCJag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 04:30:36 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39188 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728619AbgLCJag (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 04:30:36 -0500
Received: by mail-lj1-f195.google.com with SMTP id o24so1782940ljj.6;
        Thu, 03 Dec 2020 01:30:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eXTBe4HsxPobzAstKcEDPTEAEKNBBgf2Gd7hq1PS7lU=;
        b=RI0MMV6rwbR0hvzFUdEMRIFaR4TavPXQOrNiQMQVIMIQDzMc1J3t1kN7nawfUxu6D3
         zJP6iGYGBCdfCwMqpwGw4XPnM9KJiuEzxJ3zj57zhon2P/yEZS+eUxs7aWGvdvTkMpAC
         sJ4NcI589Jektn6dHhP64uf4M1QGtGNVaBBciSdoxJ4569upi2L63bqClU4zUq6eZtG1
         f2W7GOxNL1EeShttoc4apusbmakxGsNQLYb8JoC6CUAwTToDFuGp+j0P2Cy/I89njPBA
         /Itpz8xT4Mjp8aFD54twbr5SbJkmo3wbXzJ/TvwV9r9Ih7h3pZHuVP4aWRxhEC0qo9gV
         YmBw==
X-Gm-Message-State: AOAM533toyYuZDF2BiZyTsdinHz+9ccuRd7QUS5k4GRVGAsM60uv9WNc
        A0GotonSfX4X6bibRaUbGiE=
X-Google-Smtp-Source: ABdhPJyU3Qh1A0YBCbshEE2KNXUS41ltlszW602p/gobr/m23VweEOPJbOs+orcwnGSSeT+8Asj78w==
X-Received: by 2002:a05:651c:2105:: with SMTP id a5mr889476ljq.170.1606987794545;
        Thu, 03 Dec 2020 01:29:54 -0800 (PST)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id b21sm311025lfj.125.2020.12.03.01.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 01:29:53 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kkkwU-0004P1-Ud; Thu, 03 Dec 2020 10:30:27 +0100
Date:   Thu, 3 Dec 2020 10:30:26 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: ch341: sort device-id entries
Message-ID: <X8iwMm3vsXfVU4hK@localhost>
References: <20201203091159.12896-1-johan@kernel.org>
 <X8iu7y5GjmhmeWdH@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X8iu7y5GjmhmeWdH@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 03, 2020 at 10:25:03AM +0100, Greg Kroah-Hartman wrote:
> On Thu, Dec 03, 2020 at 10:11:59AM +0100, Johan Hovold wrote:
> > Keep the device-id entries sorted to make it easier to add new ones in
> > the right spot.
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks. I've applied this one to go in along with the new device id.

Johan
