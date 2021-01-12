Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A778C2F39AC
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 20:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbhALTJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 14:09:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:43170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726110AbhALTJ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 14:09:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2ADB230F9;
        Tue, 12 Jan 2021 19:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610478527;
        bh=Hfl+Zyik6gisPpLx92NnWMYrxf6SeLkIZaCamH4+1Nk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZDlsocqlDSEPufCKxmKtxrsJmk1aX8qkImn2z4CQyVs17d8eLonmiXfVn/KZ0FJ57
         BeGuLiDtzqh23YdQQzc35KsKdxHvSc64ueXFNy0FoGrPDw0LwFtFe7EgYNn8s3EdPU
         oERN0e0cEQlb4QXMiYt3gbY+W5PGFK4rwhh2PLac=
Date:   Tue, 12 Jan 2021 20:09:55 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/77] 4.19.167-rc1 review
Message-ID: <X/30A7FzVB5H597+@kroah.com>
References: <20210111130036.414620026@linuxfoundation.org>
 <20210111162415.GB6322@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111162415.GB6322@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 05:24:15PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.167 release.
> > There are 77 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> CIP testing did not find any problems here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/239960426
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing 2 of these and letting me know.

greg k-h
