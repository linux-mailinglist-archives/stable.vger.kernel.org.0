Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69E42C7F91
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 09:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgK3IQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 03:16:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:58462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbgK3IQi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Nov 2020 03:16:38 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D2952074A;
        Mon, 30 Nov 2020 08:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606724152;
        bh=StJZyUTZlK/zGHzfI0uu7FfQoqRxutjhzlAcDZjKsN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2OfxX2LL239Kst4fs7VDihPh9f23fl9xQ+AblTuJkSEqkxOTmOi+Bjck5440iMCbG
         8O7TLveLdis1uahzrvZGiXPRgAd1of4p9dT3ZcTskTxKGC/wo6IT0hkMvLyRKkIhtD
         Z6o+pG1PALwC8XgGEX3/NVC7GfMLb30ds4OK0ceo=
Date:   Mon, 30 Nov 2020 09:16:55 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Lukas Wunner <lukas@wunner.de>, linux-spi@vger.kernel.org
Subject: Re: Apply d853b3406903a7dc5b14eb5bada3e8cd677f66a2 to 5.4 and 5.9
Message-ID: <X8SqdxSC6Yq5YFS9@kroah.com>
References: <20201130014016.GA1980658@ubuntu-m3-large-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130014016.GA1980658@ubuntu-m3-large-x86>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 29, 2020 at 06:40:16PM -0700, Nathan Chancellor wrote:
> Hi Greg and Sasha,
> 
> Please apply commit d853b3406903 ("spi: bcm2835aux: Restore err
> assignment in bcm2835aux_spi_probe") to linux-5.4.y and linux-5.9.y as a
> fix for commit e13ee6cc4781 ("spi: bcm2835aux: Fix use-after-free on
> unbind"). I did not realize that commit was tagged for stable so I did
> not tag my fix accordingly, sorry for not noticing sooner.

Now queued up, thanks.

greg k-h
