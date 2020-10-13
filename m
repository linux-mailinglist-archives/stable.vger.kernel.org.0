Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C29228C9A2
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 10:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729937AbgJMIA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 04:00:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727744AbgJMIA3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Oct 2020 04:00:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C7B320E65;
        Tue, 13 Oct 2020 08:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602576027;
        bh=KoG+jgyrOOp6Y6EChRAmOvtgGcnvwOlxFNSz4vbrks4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cpvDuBHDqtUUnoIACzrNxRL8v497/x7kALkTocXKMYTF3BZ5WmbyWd9kva+YWNmI+
         jR/HhDDt2E1S69xfvFz8ZQlddkIRi0NJqA18NWS+HK6n5G2/4CwwR0NibdxkGfnc3S
         mpoKNGU6QzKPyJYZgjhd+VvUSny7xmuboWB7miLQ=
Date:   Tue, 13 Oct 2020 10:01:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ben Chuang <benchuanggli@gmail.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        ben.chuang@genesyslogic.com.tw, greg.tu@genesyslogic.com.tw,
        seanhy.chen@genesyslogic.com.tw,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: sdhci-pci-gli: Set SDR104's clock to 205MHz and
 enable SSC for GL975x
Message-ID: <20201013080105.GA1681211@kroah.com>
References: <20201013074600.9784-1-benchuanggli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013074600.9784-1-benchuanggli@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 13, 2020 at 03:46:00PM +0800, Ben Chuang wrote:
> From: Ben Chuang <ben.chuang@genesyslogic.com.tw>
> 
> commit 786d33c887e15061ff95942db68fe5c6ca98e5fc upstream.
> 
> Set SDR104's clock to 205MHz and enable SSC for GL9750 and GL9755
> 
> Signed-off-by: Ben Chuang <ben.chuang@genesyslogic.com.tw>
> Link: https://lore.kernel.org/r/20200717033350.13006-1-benchuanggli@gmail.com
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: <stable@vger.kernel.org> # 5.4.x
> ---
> Hi Greg and Sasha,
> 
> The patch is to improve the EMI of the hardware.
> So it should be also required for some hardware devices using the v5.4.
> Please tell me if have other questions.

This looks like a "add support for new hardware" type of patch, right?

If so, why not just use the 5.9 or newer kernel?  This is really big for
a stable patch.

thanks,

greg k-h
