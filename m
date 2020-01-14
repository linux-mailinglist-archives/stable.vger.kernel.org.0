Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2D313B4D8
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 22:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgANVz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 16:55:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgANVzz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 16:55:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADD852072B;
        Tue, 14 Jan 2020 21:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579038955;
        bh=+xqwiOYcBJrdVaCNI+KhG1JsykzRIQyfBAXhDvOo3DU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZvENRmQbQ6ymSxSnglOoLMb6iGLnA16Oju0J4WGyUX29PGkXhLbq4Yp5Ht2/TVCYo
         c+t16TvvSxacU53w2f9T4eXBVl2lEatEBnex4BX72DSy9aWxinZaDQEJjdI69I/fYi
         bXSRE272xAHplDTu9xOZSwpj2evuAWOHDm2CDMQg=
Date:   Tue, 14 Jan 2020 22:55:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/78] 5.4.12-stable review
Message-ID: <20200114215551.GA2362026@kroah.com>
References: <20200114094352.428808181@linuxfoundation.org>
 <0c5ca0ba-fac2-03e6-72b8-3d1a4a52f346@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c5ca0ba-fac2-03e6-72b8-3d1a4a52f346@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 14, 2020 at 01:19:41PM -0700, shuah wrote:
> On 1/14/20 3:00 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.12 release.
> > There are 78 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 16 Jan 2020 09:41:58 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.12-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Thanks for testing all of these and letting me know.

greg k-h
