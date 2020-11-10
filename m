Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8AB2AD237
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 10:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgKJJS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 04:18:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:41924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgKJJS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 04:18:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9C7020780;
        Tue, 10 Nov 2020 09:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604999905;
        bh=jIc5/GdXqTukmmucml0P0k6KJ4CCMon28lRVOqru5MM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PQJDvCVFhAUyyvf4p5xLTZIGQevUiLlOIUA2UFELaanKu2yprqZ3oViVlFdO2td/b
         3/8LSpVZDJiqS3uLS/u0d5qzqed053eTE3Xgw6Igl3hrPsFGFn4Ebxqde5pgUh4HsG
         kZnZc6b6V/RxyGtlTJVIPK3lzbhRhcNP1rPMny3k=
Date:   Tue, 10 Nov 2020 10:19:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     yaoaili126@163.com
Cc:     yaoaili@kingsoft.com, stable@vger.kernel.org
Subject: Re: [PATCH] ACPI, APEI, Fix error return value in
 apei_map_generic_address()
Message-ID: <X6pbGq24Gta7Go0t@kroah.com>
References: <20201110082942.456745-1-yaoaili126@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110082942.456745-1-yaoaili126@163.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 10, 2020 at 12:29:42AM -0800, yaoaili126@163.com wrote:
> From: Aili Yao <yaoaili@kingsoft.com>
> 
> >From commit 6915564dc5a8 ("ACPI: OSL: Change the type of
> acpi_os_map_generic_address() return value"),
> acpi_os_map_generic_address() will return logical address or NULL for
> error, but for ACPI_ADR_SPACE_SYSTEM_IO case, it should be also return 0,
> as it's a normal case, but now it will return -ENXIO. so check it out for
> such case to avoid einj module initialization fail.
> 
> Fixes: 6915564dc5a8 ("ACPI: OSL: Change the type of
> acpi_os_map_generic_address() return value")
> Cc: <stable@vger.kernel.org>
> Reviewed-by: James Morse <james.morse@arm.com>
> Tested-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Aili Yao <yaoaili@kingsoft.com>
> ---
>  drivers/acpi/apei/apei-base.c | 4 ++++
>  1 file changed, 4 insertions(+)

I'm confused as to what you are asking us to do with this patch?  Have
you read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly?

thanks,

greg k-h
