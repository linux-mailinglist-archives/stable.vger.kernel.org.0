Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA164083E7
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 07:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbhIMFos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 01:44:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232931AbhIMFos (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 01:44:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CCA160E90;
        Mon, 13 Sep 2021 05:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631511812;
        bh=JfOTS11ofZ1WJ7YaYx68xEhIutjs54UH5PpkwHsI+04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QvbjFQaqEPkRljspkyxIOnqXkf/5k5l4ypxJmZ3XTHM3m9nWMt2TRuPfZAJlez8Mf
         99QEJTTwYqz+K3V06MT60o/8gaXi6hzTvwRghfs0gUgO3jsbecfCuADT9d4JxwC9Ah
         O83Ys4SVL3WJ6LL2EjN5Q4ijS3hszo/8OmlCVK6E=
Date:   Mon, 13 Sep 2021 07:43:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Cc:     Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] power: supply: max17042_battery: Prevent int
 underflow in set_soc_threshold
Message-ID: <YT7k7tUij9B02Tae@kroah.com>
References: <20210912205402.160939-1-sebastian.krzyszkowiak@puri.sm>
 <20210912205402.160939-2-sebastian.krzyszkowiak@puri.sm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210912205402.160939-2-sebastian.krzyszkowiak@puri.sm>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 12, 2021 at 10:54:02PM +0200, Sebastian Krzyszkowiak wrote:
> Fixes: e5f3872d2044 ("max17042: Add support for signalling change in SOC")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
> ---
>  drivers/power/supply/max17042_battery.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

I know I do not take patches without any changelog text.  Perhaps other
maintainers are more leniant :(

thanks,

greg k-h
