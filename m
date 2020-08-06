Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128CE23DCCE
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 18:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbgHFQ4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 12:56:00 -0400
Received: from mail-ej1-f66.google.com ([209.85.218.66]:34184 "EHLO
        mail-ej1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728675AbgHFQkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 12:40:43 -0400
Received: by mail-ej1-f66.google.com with SMTP id o23so23589775ejr.1;
        Thu, 06 Aug 2020 09:39:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xoKFt55sK0HZiVmtkkBW5XeAJUo7lWS0W4XNGkbYJRo=;
        b=SkhBn1eWmDw1BaoB80754N7vh9SyPrdVbWRlsV5WH7lGgZnmpLetfq135Fs/11C0SY
         v0wTBSQHtxh+iPzn7OVC3/toBfsJ+W3q/1IVmSAkALACmqKzenPiv5/N3EQGpB3q9ZE7
         8EnCHzH4J4s01hlPs/PJ9y4dqyCC8UVNCHyqGXjdZyby241J/Ye1w/OQXiFcoKNEupk1
         YEKeBG3jRbW49ZGa74AXmNfz//6Q2Z/HtoDmxrmqSysDPMONvTIVrJ0FcJIbsW8iWPE/
         Ci7uGNWBeCMvlvRrQRuGP1sarv8MxuwqS1uEHNo9FaflVNzbCurl+XzhPQ78h5j2AWx4
         zihQ==
X-Gm-Message-State: AOAM5321naiscVaeezNDB1nBEVjO/FZsqr1gpx4HemKDeSMMHAEik0uj
        KexV8Xqi+Wp/80rm50GxFUkYgN5tlx4=
X-Google-Smtp-Source: ABdhPJwijY7JxNTtOMlVYw7kePlcC2ZLEmTCefhMzTWtAbbKb9KCZQ/Cqpfeyj4YjkJ2U8HamSc0dw==
X-Received: by 2002:ac2:5f81:: with SMTP id r1mr3676654lfe.168.1596715248829;
        Thu, 06 Aug 2020 05:00:48 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id g19sm2306729ljn.91.2020.08.06.05.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 05:00:48 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1k3eZn-0002y0-GA; Thu, 06 Aug 2020 14:00:51 +0200
Date:   Thu, 6 Aug 2020 14:00:51 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Patrick Riphagen <ppriphagen@gmail.com>
Cc:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        patrick.riphagen@xsens.com, stable@vger.kernel.org
Subject: Re: [PATCH V2] USB: serial: ftdi_sio: add IDs for Xsens Mti USB
 converter
Message-ID: <20200806120051.GR3634@localhost>
References: <20200806115547.8007-1-patrick.riphagen@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200806115547.8007-1-patrick.riphagen@xsens.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 06, 2020 at 01:55:47PM +0200, Patrick Riphagen wrote:
> From: Patrick Riphagen <patrick.riphagen@xsens.com>
> 
> The device added has an FTDI chip inside.
> The device is used to connect Xsens USB Motion Trackers.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Patrick Riphagen <patrick.riphagen@xsens.com>
> ---

Thanks for the update. I've queued this one up for 5.9.

Johan
