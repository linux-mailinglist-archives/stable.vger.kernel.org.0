Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2AC244C9F
	for <lists+stable@lfdr.de>; Fri, 14 Aug 2020 18:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgHNQ35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Aug 2020 12:29:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgHNQ35 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Aug 2020 12:29:57 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B202E20774;
        Fri, 14 Aug 2020 16:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597422597;
        bh=NYHDsKeu0aJSmtzjmQNYje62atOf54j6Q8q9CeWKhl0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GkHUwvePaACK9ySB2HkFpGylHR+wOLm8vNkinsXSVmixShiJvnXiUKgFBXMGard6R
         +Z+8SaGiT+oq+rkmezwnLoVyN3Ilq0AXEvhb+nJn01OftAMRRm9M5arf88meHuDmHH
         WvFEVVB3lSB/2aetwrslStNIuaoB5ez8Us1BDPFg=
Date:   Fri, 14 Aug 2020 12:29:55 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        linux-gpio@vger.kernel.org, kernel@pengutronix.de,
        stable@vger.kernel.org
Subject: Re: [PATCH stable (4.4 + 4.9)] gpio: fix oops resulting from calling
 of_get_named_gpio(NULL, ...)
Message-ID: <20200814162955.GQ2975990@sasha-vm>
References: <20200814074711.14044-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200814074711.14044-1-u.kleine-koenig@pengutronix.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 14, 2020 at 09:47:11AM +0200, Uwe Kleine-König wrote:
>This happens for the spi-imx driver when running a dt-enabled kernel on
>a non-dt machine on Linux 4.0. Among the still supported stable versions
>only 4.4 and 4.9 are affected. (However the spi-imx driver doesn't call
>of_get_named_gpio() since v4.8-rc1 (commit b36581df7e78 ("spi: imx:
>Using existing properties for chipselects")) any more, but the problem
>might still affect other users of of_get_named_gpio().)
>
>In 4.14-rc1 this problem is gone with
>commit 7eb6ce2f2723 ("gpio: Convert to using %pOF instead of
>full_name"). This commit however doesn't seem sensible to backport as it
>depends on ce4fecf1fe15 ("vsprintf: Add %p extension "%pOF" for device
>tree") which doesn't trivially apply to v4.4.

Queued up for 4.9 and 4.4, thanks!

-- 
Thanks,
Sasha
