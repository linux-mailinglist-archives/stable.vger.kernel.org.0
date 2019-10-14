Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54CAAD6C22
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 01:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbfJNXiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 19:38:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbfJNXiW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 19:38:22 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71AD1217D9;
        Mon, 14 Oct 2019 23:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571096301;
        bh=/lTFU3bGOmz6U9q2KN673HaxpJFJaR5x02Fbwhl8xOE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TFj+P6onCnpo087A4cCLNfwZjTr7uM/bWMJDFiVPYRR8XdPCqfagSrFARSVu///1W
         KHgff587jdGPKQjz7p7wBx+3zBZpBrVYbJ8hmTiyNEtqBRqKmS2hXYvchIskLNfyUQ
         LcNjjl9PZk/yp8oKs7LcZB42ZsxaiCKmLoo9zCJo=
Date:   Mon, 14 Oct 2019 19:38:20 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-gpio@vger.kernel.org, stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Kent Gibson <warthog618@gmail.com>
Subject: Re: [PATCH v5.3, v4.19] gpiolib: don't clear FLAG_IS_OUT when
 emulating open-drain/open-source
Message-ID: <20191014233820.GE31224@sasha-vm>
References: <20191014155435.13234-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191014155435.13234-1-brgl@bgdev.pl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 14, 2019 at 05:54:35PM +0200, Bartosz Golaszewski wrote:
>From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>
>When emulating open-drain/open-source by not actively driving the output
>lines - we're simply changing their mode to input. This is wrong as it
>will then make it impossible to change the value of such line - it's now
>considered to actually be in input mode. If we want to still use the
>direction_input() callback for simplicity then we need to set FLAG_IS_OUT
>manually in gpiod_direction_output() and not clear it in
>gpio_set_open_drain_value_commit() and
>gpio_set_open_source_value_commit().
>
>Fixes: c663e5f56737 ("gpio: support native single-ended hardware drivers")
>Cc: stable@vger.kernel.org
>Reported-by: Kent Gibson <warthog618@gmail.com>
>Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>[Bartosz: backported to v5.3, v4.19]
>Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

I've queued this and the 4.14 patch, thanks!

-- 
Thanks,
Sasha
