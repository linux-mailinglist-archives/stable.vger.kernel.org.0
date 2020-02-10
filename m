Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13BDB15853D
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 22:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbgBJVtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 16:49:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:44052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbgBJVtB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 16:49:01 -0500
Received: from localhost (unknown [104.132.1.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DE3A20733;
        Mon, 10 Feb 2020 21:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581371339;
        bh=q3vR9LSrrtkEL8qbeG+qrytqcmy1i+GI2LkFaf0vAWo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cC+gHYLD8YmH+jXNDDb83k1dFFugp51CriBMH5wlVEbMXoHXVDo01Fsu5sMf6khzu
         8Wz1FwpnIP7vH6h1WnKlX/OeUswWPc7FNI0Qt3QbyjXx9iqirGWOmbRamvMnDcJlKn
         PHvjPgN+v/84EipiZlv2MkDaqKfFW9ocLIN8eEnM=
Date:   Mon, 10 Feb 2020 13:48:58 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org
Subject: Re: v4.4.y.queue build failures
Message-ID: <20200210214858.GA1622972@kroah.com>
References: <20200210214427.GD26242@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210214427.GD26242@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 10, 2020 at 01:44:27PM -0800, Guenter Roeck wrote:
> Just in case this hasn't been reported yet.
> 
> drivers/clk/tegra/clk-tegra-periph.c:523:65: error: 'CLK_IS_CRITICAL' undeclared here (not in a function)
>   523 |  GATE("fuse", "clk_m", 39, TEGRA_PERIPH_ON_APB, tegra_clk_fuse, CLK_IS_CRITICAL),
>       |                                                                 ^~~~~~~~~~~~~~~
> 
> The problem affects arm and arm64 builds.

Should already be taken care of.

thanks,

greg k-h
