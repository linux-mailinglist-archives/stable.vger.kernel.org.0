Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B64313291
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 13:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbhBHMlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 07:41:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:49400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232058AbhBHMkS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 07:40:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C71A164E29;
        Mon,  8 Feb 2021 12:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612787977;
        bh=e8N7E+idCiScn0l+JIgyUjIPa5njsG1vWvbX6Fe8g24=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vcu1uWrANUkNaju9IIylSh8b0wmPor3CYuRkpgNxa7D2X1io3QH/8n8lCmvdy2Prk
         leUtoA6en+aMEnpragmLeCdgbnx6C7WiWCZSh+XttE+SPj6TaG3u+Ihanqs/r++IjT
         zOBwpAxyXsNlVBnA37lUyG1hBTyPPr67vewYdLCY=
Date:   Mon, 8 Feb 2021 13:39:34 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/57] 5.10.14-rc1 review
Message-ID: <YCExBoL9c0OQz/WY@kroah.com>
References: <20210205140655.982616732@linuxfoundation.org>
 <20210206160225.GD175716@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210206160225.GD175716@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 06, 2021 at 08:02:25AM -0800, Guenter Roeck wrote:
> On Fri, Feb 05, 2021 at 03:06:26PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.14 release.
> > There are 57 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 07 Feb 2021 14:06:42 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 427 pass: 427 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Great, thanks for testing!
