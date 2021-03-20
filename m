Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE1D342C7D
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhCTLtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:49:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:32862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229600AbhCTLsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Mar 2021 07:48:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2176A61977;
        Sat, 20 Mar 2021 09:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616233993;
        bh=jJu7OZFpcdzufuo6TbzTb125/2qNrCyrdH8uF6VGjog=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cGVRrnO/4XaFAOxyWgcmkbjRQLPpaQjzWfCn33OFzb2NISZeorOykrOU19fCBH54Z
         /XIVglHs0o+vexHV4+GNoyOTDHuAANYwe39gc5XRdz9fD1NHnOR1TnuLGo6J4wD/+l
         Fk2DYrpHx4K9pBSkqtLGpIikeXS5OwT37XPBi35s=
Date:   Sat, 20 Mar 2021 10:53:11 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 0/8] 4.19.182-rc1 review
Message-ID: <YFXGB9edAJ5G4v1W@kroah.com>
References: <20210319121744.114946147@linuxfoundation.org>
 <20210319191722.GA6701@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319191722.GA6701@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 08:17:22PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.182 release.
> > There are 8 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> CIP testing did not find any problems here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-4.19.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing!
