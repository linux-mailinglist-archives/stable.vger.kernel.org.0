Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E3845D67E
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 09:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353336AbhKYIzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 03:55:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:52978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353378AbhKYIxW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 03:53:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1964610CF;
        Thu, 25 Nov 2021 08:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637830211;
        bh=o0iOqGHw6NrZ733vzB6scwPIfwhRv7Ig7YAOyuyQFEw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IDHwJLF+powjl/mMS8o5BGKtlTjDtL6Fr536rTJeWGVGjyC7IgATNxjGibdhX+x66
         H9vy96qzJ3WdSa0xGHQ/di4UmtLUXL+KJBcnXh9EhL8ps974oOrQbPhLJR8NeEBhpP
         2pHWzqVhXejrBqtQYW8dpk+vQhG4z+4Y2sfLy8qA=
Date:   Thu, 25 Nov 2021 09:50:09 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/100] 5.4.162-rc1 review
Message-ID: <YZ9OQT/TCnDHoLOw@kroah.com>
References: <20211124115654.849735859@linuxfoundation.org>
 <CADVatmPxvqhQ-iUo3_wY+9D72O0qdBDh02Ewx1Yjz4f2=7uz7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmPxvqhQ-iUo3_wY+9D72O0qdBDh02Ewx1Yjz4f2=7uz7g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 09:09:53PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Wed, Nov 24, 2021 at 2:10 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.162 release.
> > There are 100 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> > Anything received after that time might be too late.
> 
> Just a quick note, my arm64 builds are failing with the error:
> arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi:412.21-414.5: ERROR
> (duplicate_label): /soc/codec: Duplicate label 'lpass_codec' on
> /soc/codec and /soc@0/codec
> 
> I have not yet tested, but I think it will be for:
> f4850fe1a15d (\"arm64: dts: qcom: msm8916: Add unit name for /soc node\")
> 

I have dropped the offending commit now, thanks.

greg k-h
