Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17FBC1150B0
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 13:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfLFMxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 07:53:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:55418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbfLFMxg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Dec 2019 07:53:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10AF321835;
        Fri,  6 Dec 2019 12:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575636816;
        bh=kwxWoqS9xILkEjONis4/ORM0o5iabZMST50G1y8w8FA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zVzAKCSEhH86c6XwjHX0Qtdk2AxBtHCSrhjfyRoG9GpL5Y/BYLmbPM0S+Q1WP02Dq
         4YHin0J4P7lyzAQRMd0K3VzlkK3wLhVspppPYvODU82goPXC80cQIOdtsgpZ9Ar7ej
         13Tv8nVKRK0FFYY0k5IVQV+2dxgtDxaeNN7dFs8M=
Date:   Fri, 6 Dec 2019 13:53:34 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     stable@vger.kernel.org, linux-tegra <linux-tegra@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Re: stable request: 5.4.y: arm64: tegra: Fix 'active-low' warning
 for Jetson
Message-ID: <20191206125334.GA1361962@kroah.com>
References: <16724779-0514-ca92-58b2-95f4e244c6f7@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16724779-0514-ca92-58b2-95f4e244c6f7@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 06, 2019 at 10:55:17AM +0000, Jon Hunter wrote:
> Hi Greg,
> 
> Please can you include the following device-tree fixes for 5.4.y that
> are triggering some warnings on a couple of our Jetson platforms. This
> is currently causing one of our kernel warnings tests to fail. Both of
> these have now been merged into the mainline for v5.5-rc1.
> 
> commit d440538e5f219900a9fc9d96fd10727b4d2b3c48
> Author: Jon Hunter <jonathanh@nvidia.com>
> Date:   Wed Sep 25 15:12:28 2019 +0100
> 
>     arm64: tegra: Fix 'active-low' warning for Jetson Xavier regulator
> 
> commit 1e5e929c009559bd7e898ac8e17a5d01037cb057
> Author: Jon Hunter <jonathanh@nvidia.com>
> Date:   Wed Sep 25 15:12:29 2019 +0100
> 
>     arm64: tegra: Fix 'active-low' warning for Jetson TX1 regulator
> 
> Thanks
> Jon

Now queued up, thanks.

greg k-h
