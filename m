Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19BDE30952E
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 14:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbhA3NBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 08:01:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:34948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229804AbhA3NBg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Jan 2021 08:01:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E2DC64DD6;
        Sat, 30 Jan 2021 13:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612011655;
        bh=5Tq2NcQDKndnGyT7gy9FBXC99oU9GBET5462mH6D0+M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kN/yAvBGhhr72Xc/OHbuBZ2LUKgESl3QhIDWQoQ2yCtOUAnSL0XaWJlzIidYK35Mv
         0iyYQsfH0ccDA5sLAoqKb4HAsBvEOfeESX0pnyQ5EdaEVRa66xiXgHo9RvN7jjgb6v
         +YSG6XafAZ1p3av8etQt5z4xVR9Ush0k9FSiDQK0=
Date:   Sat, 30 Jan 2021 14:00:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/32] 5.10.12-rc1 review
Message-ID: <YBVYhQshqCzPg4A0@kroah.com>
References: <20210129105912.628174874@linuxfoundation.org>
 <20210129125914.GA23853@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129125914.GA23853@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 29, 2021 at 01:59:14PM +0100, Pavel Machek wrote:
> On Fri 2021-01-29 12:07:10, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.12 release.
> > There are 32 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> CIP testing did not find any problems here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing these and letting me know.

greg k-h
