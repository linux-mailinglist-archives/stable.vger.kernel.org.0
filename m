Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8244A278B37
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 16:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbgIYOtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 10:49:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:32988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgIYOtI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 10:49:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F0572074B;
        Fri, 25 Sep 2020 14:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601045348;
        bh=Xh5zHqsQINoewxrAcaERp/J+hHIMT//d273HKiEV6aM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mu+VOnyCsT2CGiDeh8JfNK5F2qZLvYvg/f3lSZHm7qQ9eJJrSt0Q+Nai47QSqtjn6
         9+erjAfhjD6S0Aq0sPGAQPoPbsp7RqT+xWCrY9N4l6NXozJq9lmk/ubD7hNzdZ/c4t
         PG5twGI8t3f4gvAP9SZnNbPdPOHllgmT8dpNNxIY=
Date:   Fri, 25 Sep 2020 16:49:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Oliver Neukum <oneukum@suse.com>, linux-usb@vger.kernel.org,
        Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] USB: cdc-acm: add Whistler radio scanners TRX series
 support
Message-ID: <20200925144922.GA3113925@kroah.com>
References: <20200921081022.6881-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921081022.6881-1-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 10:10:22AM +0200, Johan Hovold wrote:
> Add support for Whistler radio scanners TRX series, which have a union
> descriptor that designates a mass-storage interface as master. Handle
> that by generalising the NO_DATA_INTERFACE quirk to allow us to fall
> back to using the combined-interface detection.
> 
> Note that the NO_DATA_INTERFACE quirk was added by commit fd5054c169d2
> ("USB: cdc_acm: Fix oops when Droids MuIn LCD is connected") to handle a
> combined-interface-type device with a broken call-management descriptor
> by hardcoding the "data" interface number.
> 
> Link: https://lore.kernel.org/r/5f4ca4f8.1c69fb81.a4487.0f5f@mx.google.com
> Reported-by: Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>
> Tested-by: Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
> 
> v2
>  - use the right class define in the device-id table (not subclass with
>    same value)

Is this independant of your other patch series for cdc-acm?

thanks,

greg k-h
