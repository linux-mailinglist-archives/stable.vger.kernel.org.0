Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 163FE45612D
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 18:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbhKRRMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 12:12:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:59176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233940AbhKRRMh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Nov 2021 12:12:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3C7660FD8;
        Thu, 18 Nov 2021 17:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637255377;
        bh=OL/gcdD35tB/bHnXaWATF7fna6j32ygfB4abvS3lTmg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qZYTg/ddrY/1/mQUtZzb66SRdRDo8B4NuWWCL/wgF1xgLm7ceSOaIukHtG0KZDSW5
         6jpyVHpJfkG4wUt1QJhdU4v+EO+VYKY/6Gfz+Bq5xo922AM1o3OXD15IgVd54b6z7H
         HViK+wzZO8zlVC2PQLl7QEnQQfkLYDw/lpAhv+P0=
Date:   Thu, 18 Nov 2021 18:09:34 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Scott Bruce <smbruce@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/927] 5.15.3-rc2 review
Message-ID: <YZaIznUmsvR8nZ3T@kroah.com>
References: <20211116142631.571909964@linuxfoundation.org>
 <4ef11d86-28f6-69c8-ed79-926d39bdc13d@gmail.com>
 <CAPOoXdHjqm=9K5BHc8p48NEf0jzZ92yiZZFQwmhGMxcTAX020w@mail.gmail.com>
 <YZS3gwvOOXu0Vmzv@kroah.com>
 <CAPOoXdEWFWpeFtLkWqOVOZFJv3=7zyG2vrZtrZ9fHsODyPaf+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPOoXdEWFWpeFtLkWqOVOZFJv3=7zyG2vrZtrZ9fHsODyPaf+A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 17, 2021 at 08:05:13AM -0800, Scott Bruce wrote:
> 5.16-rc1 boots fine with the commit in, it's just the 5.15.3-rc builds
> with it that are giving me trouble.

Thanks, should be fixed in the latest -rc4 release.

greg k-h
