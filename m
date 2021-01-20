Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B6B2FCEC0
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 12:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731346AbhATLCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 06:02:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:52304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733242AbhATKjA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Jan 2021 05:39:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64AD923339;
        Wed, 20 Jan 2021 10:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611139056;
        bh=GFcN3+ZTgf4aUWHYjTyEZAjk6XDfI2Px6VH7OV5kmfE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GkneV5Z4UpAOUk3tnK2ekiV9YZXMohPXzrohwdy0wmpCTbT7QKCdIjgNDmsJfYUJV
         YYgTtE/IZiBTsz0UFQL7fx+FkCGQJFjXCTbNwHqsEcQZRfaZ5MHV359gksOUp+8UqQ
         WTMZcaTYwsOMEVFrOO5ZYGdMBHrlVEUelHn21tIM=
Date:   Wed, 20 Jan 2021 11:37:34 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/152] 5.10.9-rc1 review
Message-ID: <YAgH7gRkipCserLi@kroah.com>
References: <20210118113352.764293297@linuxfoundation.org>
 <20210119092201.GA11679@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119092201.GA11679@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 19, 2021 at 10:22:02AM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.9 release.
> > There are 152 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 20 Jan 2021 11:33:23 +0000.
> > Anything received after that time might be too late.
> 
> CIP testing did not find any problems here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing!
