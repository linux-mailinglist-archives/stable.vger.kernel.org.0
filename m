Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3978645C9B3
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 17:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242167AbhKXQTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 11:19:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:36810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241890AbhKXQTf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 11:19:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2B4860D42;
        Wed, 24 Nov 2021 16:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637770585;
        bh=igZAeYA5PZp9Nz8jfjcYJyr/8VIqz3gTMGGJ5O6lTcg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IbXaDlnFMoaPIUqfjHeOqxgf1EmfmAIj6kaoO3LE1FCJ1SPKC7ajlvSV/dD+a8q8k
         fgM5Q0lDDIauMsUXbMTkiLrEvxdXJlo4rCiAkGwWr1gozPDF6gtq6NnbhZGfomIz6I
         qVt9099DOT3t8VaqxalhFbfFkuwR8sWst2MQFGAk=
Date:   Wed, 24 Nov 2021 17:16:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/100] 5.4.162-rc1 review
Message-ID: <YZ5lVkawMxlHwikI@kroah.com>
References: <20211124115654.849735859@linuxfoundation.org>
 <20211124154017.GA1854532@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124154017.GA1854532@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 07:40:17AM -0800, Guenter Roeck wrote:
> On Wed, Nov 24, 2021 at 12:57:16PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.162 release.
> > There are 100 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> > Anything received after that time might be too late.
> > 
> 
> arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi:412.21-414.5: ERROR (duplicate_label): /soc/codec: Duplicate label 'lpass_codec' on /soc/codec and /soc@0/codec
> ERROR: Input tree has errors, aborting (use -f to force output)

Will go drop the offending patch, thanks.

greg k-h
