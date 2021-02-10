Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DF13168C0
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 15:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbhBJOLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 09:11:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:60400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231817AbhBJOLO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 09:11:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FF5D64E7A;
        Wed, 10 Feb 2021 14:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612966233;
        bh=+AHPAbY2Omn02r90l7z3c/7R8FzCiF1+7hR1mIE0dac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=swcSwWxBD7UOMlSvU0ZHOEOhasBjkYoKjHdMkQKLYjgGP9Otf8BlM6DrMdbUJj+9d
         UZ+kfQaS6V5veHBynVDQom1u+jB/7UeUaTZSOd96OxHgcECIFB0iNYKcj7rnokKCCp
         vfxhMjyLn9P0U9ikJ/xYLI4DXv0yc4zkKVr3n0ds=
Date:   Wed, 10 Feb 2021 15:10:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kent Gibson <warthog618@gmail.com>
Cc:     stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [BACKPORT 5.10 PATCH] gpiolib: cdev: clear debounce period if
 line set to output
Message-ID: <YCPpVqNwYDsy29eQ@kroah.com>
References: <1612779107255191@kroah.com>
 <20210208233325.6087-1-warthog618@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208233325.6087-1-warthog618@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 09, 2021 at 07:33:25AM +0800, Kent Gibson wrote:
> commit 03a58ea5905fdbd93ff9e52e670d802600ba38cd upstream.
> 
> When set_config changes a line from input to output debounce is
> implicitly disabled, as debounce makes no sense for outputs, but the
> debounce period is not being cleared and is still reported in the
> line info.
> 
> So clear the debounce period when the debouncer is stopped in
> edge_detector_stop().
> 
> Fixes: 65cff7046406 ("gpiolib: cdev: support setting debounce")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kent Gibson <warthog618@gmail.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>  drivers/gpio/gpiolib-cdev.c | 2 ++
>  1 file changed, 2 insertions(+)

Now applied, thanks.

greg k-h
