Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 329D0D993B
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 20:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394253AbfJPSb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 14:31:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391082AbfJPSb0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 14:31:26 -0400
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6BFE21D7A;
        Wed, 16 Oct 2019 18:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571250685;
        bh=2wAyGU0cUCFqc/8Sq42nh9uu/5+uzjYvLgMet1RoezY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=znZ2ibZLzc9MrZ18ZkPUt9B1GkhgYfZs48gTIYNPKAhAJj+ur1wnb2WgjiTvyD7rE
         /VJ1ImpjowBfY0Yy0lbF6tGBpvspvNwQTnIQUI/StDFOYY+4cb2Pgx1n3dlW6CKi2T
         Lz1SOiwZwIAybVdgHpd15pwIQMy6k5tTIYdf2uEQ=
Date:   Wed, 16 Oct 2019 11:31:21 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mathieu Poirier <mathieu.poirier@linaro.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [stable 4.19][PATCH 1/4] ARM: dts: am4372: Set memory bandwidth
 limit for DISPC
Message-ID: <20191016183121.GD801860@kroah.com>
References: <20191015065937.23169-1-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015065937.23169-1-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 15, 2019 at 12:59:34AM -0600, Mathieu Poirier wrote:
> From: Peter Ujfalusi <peter.ujfalusi@ti.com>
> 
> commit f90ec6cdf674248dcad85bf9af6e064bf472b841 upstream
> 
> Set memory bandwidth limit to filter out resolutions above 720p@60Hz to
> avoid underflow errors due to the bandwidth needs of higher resolutions.
> 
> am43xx can not provide enough bandwidth to DISPC to correctly handle
> 'high' resolutions.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> Cc: stable <stable@vger.kernel.org> # 4.19
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> ---
>  arch/arm/boot/dts/am4372.dtsi | 2 ++
>  1 file changed, 2 insertions(+)

What about 5.3?  Is this ok there?

thanks,

greg k-h
