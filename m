Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5FE30E6A1
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 00:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbhBCXED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 18:04:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:45432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232591AbhBCXD7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 18:03:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9796D64E3D;
        Wed,  3 Feb 2021 23:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612393399;
        bh=shTAkBeqUGEaf+SDn8KLZSZGHXYMRayYpnt99lxbqWo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A2DlYp7Q1Bn2uRkG8lj1nA9Frnn8Qy+0wtNeG7o2XRjTp635CLhpcTE++z1dXeEPL
         aqrzC1MkybQDpxWMIM2auv4De4RvSwn2YAAnj+e95BxAstKSM005SlUhPIZajvotcm
         lk/A6OvZt/i15k653TgBvJpOMBDOVtrJb6HbbdXM=
Date:   Thu, 4 Feb 2021 00:03:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/142] 5.10.13-rc1 review
Message-ID: <YBsrtBMiCQuMdaOd@kroah.com>
References: <20210202132957.692094111@linuxfoundation.org>
 <20210202171844.GA7807@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202171844.GA7807@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 02, 2021 at 06:18:44PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.13 release.
> > There are 142 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> CIP testing did not find any problems here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing some of these and letting me know.

greg k-h
