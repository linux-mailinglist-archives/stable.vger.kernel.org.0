Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CEB3DB286
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 06:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbhG3E6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 00:58:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233861AbhG3E6h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 00:58:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 809C660E09;
        Fri, 30 Jul 2021 04:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627621108;
        bh=TRTrNsnNo5eJ4vtvr1dHZUrZFkK1tCCkXAVkPpZQtBY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IWQQH54I1YITjcX7P/EBdkNp9I6mdPH2yE+adeZYMQGaShCxktt4iPFW8biNJ0HA8
         jwhXQTt5YNQZVw5po5zG0JcinjwMzVFQ7J7hSJxQJRLaUG2/zEpLPrv4pVh7wDq6ea
         XviPa4PQDapfmAYIM0Wx9EAC0ihAtCzWO2rIk3kw=
Date:   Fri, 30 Jul 2021 06:58:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/24] 5.10.55-rc1 review
Message-ID: <YQOG8b/H3xg2A2YU@kroah.com>
References: <20210729135137.267680390@linuxfoundation.org>
 <126ef248-a490-24d9-2bf0-feefe5c64007@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <126ef248-a490-24d9-2bf0-feefe5c64007@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 29, 2021 at 04:53:12PM -0600, Shuah Khan wrote:
> On 7/29/21 7:54 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.55 release.
> > There are 24 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.55-rc1.gz
> 
> Couldn't find this patch. Will checkout the rc instead.

Very odd, this email can not go out unless that is uploaded, I'll dig to
see what went wrong...
