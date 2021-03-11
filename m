Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D439337B13
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 18:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbhCKRjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 12:39:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229711AbhCKRjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 12:39:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1F93600CC;
        Thu, 11 Mar 2021 17:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615484353;
        bh=R1YAcJ6QA/sMqQPbmpfRUSnTdqZ2ppgXaKinD5P/0hk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=edt0KihXsKqRZGjxHTy1yoFT4z9vyRX6Nk6+bHerSAt2Lc7FiarqFz+KcQTqc8YN1
         QuhK3R7r9ikMKDdcGX6BQh07CdefbkwXPw4rjAC9HFvfANBgCeV6qOqpIxYYTf0SRf
         xA+VUGR4d/bovzfGruZB5wYhxNJaX/qo3p/xcTHM=
Date:   Thu, 11 Mar 2021 18:39:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ross Schmidt <ross.schm.dev@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 00/36] 5.11.6-rc1 review
Message-ID: <YEpVv7d3lHrWcXyG@kroah.com>
References: <20210310132320.510840709@linuxfoundation.org>
 <20210311040955.GD7061@book>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311040955.GD7061@book>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 10:09:55PM -0600, Ross Schmidt wrote:
> On Wed, Mar 10, 2021 at 02:23:13PM +0100, gregkh@linuxfoundation.org wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > This is the start of the stable review cycle for the 5.11.6 release.
> > There are 36 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> 
> Compiled and booted with no regressions on x86_64.
> 
> Tested-by: Ross Schmidt <ross.schm.dev@gmail.com>

Thanks for testing.


