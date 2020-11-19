Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82DCF2B8B69
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 07:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbgKSGLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 01:11:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:51034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgKSGLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Nov 2020 01:11:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 977FC24698;
        Thu, 19 Nov 2020 06:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605766312;
        bh=561/nDWXjVno24Kfhs0pvADpAcQ1UUswTEKMFwXxjRg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1+b2MLdJLeQl3oRYIgyEZI2UHZaf49+yjcYxzmO4y24gokF2Ej86sEndRo3ExeymS
         YNoJNpc7aKtqcbJ0T5T1a+ymiIffQJwD/tmGba5MdJmMgKQjHK093UVvic3OLM75Br
         QWD5PFG7At0I44A09ekk/rj0WBhF0jf0FkDDRiUo=
Date:   Thu, 19 Nov 2020 07:11:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     JC Kuo <jckuo@nvidia.com>
Cc:     thierry.reding@gmail.com, jonathanh@nvidia.com, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] arm64: tegra: jetson-tx1: Fix USB_VBUS_EN0 regulator
Message-ID: <X7YMo45OlIOD3T6n@kroah.com>
References: <20201119030729.111333-1-jckuo@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119030729.111333-1-jckuo@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 19, 2020 at 11:07:29AM +0800, JC Kuo wrote:
> USB_VBUS_EN0 regulator (regulator@11) is being overwritten by vdd-cam-1v2
> regulator. This commit rearrange USB_VBUS_EN0 to be regulator@14.
> 
> Fixes: 257c8047be44 ("arm64: tegra: jetson-tx1: Add camera supplies")
> Signed-off-by: JC Kuo <jckuo@nvidia.com>
> Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
> ---
> v2:
>     add 'Fixes:' tag
>     add Reviewed-by: Jon Hunter <jonathanh@nvidia.com>

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
