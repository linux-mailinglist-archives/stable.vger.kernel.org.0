Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551E431610F
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 09:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhBJIbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 03:31:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:48244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229692AbhBJIbC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 03:31:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FDD264E25;
        Wed, 10 Feb 2021 08:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612945822;
        bh=FhmD7Id8w3BM/pFcOmfQtXONHAx6/gP1u36wip+6LZE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L+wbN9cIgPfofgXFq5dSbqfj1IZS05GEfowCsPAPuWVSqBkyuyCnCu7pOeET2rV++
         caPfaIC3Dghhh7IagFk5uTLdJsp6/XorKy/tNbACLyabiMojFaEWlZjSYt48pJ7a5/
         bopXUMxHBwbScmC621LwhBwqqPH58JYujm3DEqLU=
Date:   Wed, 10 Feb 2021 09:30:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/120] 5.10.15-rc1 review
Message-ID: <YCOZm6xtxYmwC7VQ@kroah.com>
References: <20210208145818.395353822@linuxfoundation.org>
 <20210209181444.GB142754@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209181444.GB142754@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 09, 2021 at 10:14:44AM -0800, Guenter Roeck wrote:
> On Mon, Feb 08, 2021 at 03:59:47PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.15 release.
> > There are 120 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 427 pass: 427 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Great, thanks for testing.

greg k-h
