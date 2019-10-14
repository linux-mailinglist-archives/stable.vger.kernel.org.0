Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6F50D6C12
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 01:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfJNXfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 19:35:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbfJNXfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 19:35:50 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D83B217D9;
        Mon, 14 Oct 2019 23:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571096149;
        bh=9x7QTlJvEdWt7hKLckN4uAgui8PzFSsEoVxTdJGTrUw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VF9S5o431W4XboLdHnMMYjG8rvkeDw+upKBFATqEIzFMIQe0nbSUlN2ewdcxV3YqZ
         KEwBmGSXv9hBDAfNexU3VbenOTH4DO+fSoBWte0TsuXYIr4FC9va8hgRLM/j/XEfsf
         vXwEIJBrnzqTLGArScb3aOH3LuWUwbaC58K3eeVs=
Date:   Mon, 14 Oct 2019 19:35:48 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-gpio@vger.kernel.org, stable@vger.kernel.org,
        Marco Felsch <m.felsch@pengutronix.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH v5.3] gpio: fix getting nonexclusive gpiods from DT
Message-ID: <20191014233548.GD31224@sasha-vm>
References: <20191014155341.13145-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191014155341.13145-1-brgl@bgdev.pl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 14, 2019 at 05:53:41PM +0200, Bartosz Golaszewski wrote:
>From: Marco Felsch <m.felsch@pengutronix.de>
>
>Since commit ec757001c818 ("gpio: Enable nonexclusive gpiods from DT
>nodes") we are able to get GPIOD_FLAGS_BIT_NONEXCLUSIVE marked gpios.
>Currently the gpiolib uses the wrong flags variable for the check. We
>need to check the gpiod_flags instead of the of_gpio_flags else we
>return -EBUSY for GPIOD_FLAGS_BIT_NONEXCLUSIVE marked and requested
>gpiod's.
>
>Fixes: ec757001c818 gpio: Enable nonexclusive gpiods from DT nodes
>Cc: stable@vger.kernel.org
>Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
>[Bartosz: the function was moved to gpiolib-of.c so updated the patch]
>Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>[Bartosz: backported to v5.3.y]
>Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Queued this one for 5.3, thanks!

-- 
Thanks,
Sasha
