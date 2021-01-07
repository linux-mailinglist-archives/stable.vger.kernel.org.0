Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04BBF2ED61D
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 18:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbhAGRyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 12:54:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:32870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728149AbhAGRyv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 12:54:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEE20233FD;
        Thu,  7 Jan 2021 17:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610042051;
        bh=UUdkZzAHAyFFZRZw07cLgdRfBklJxASyB71ohBH9Iko=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nsgsMKr+x4lqWPa5gU6giPVINpNLjPoDVz+5xQmP/OVnf12AsLoBKEYC7hvGH3319
         wDlenzSb4yD6csInpAcID+uKumpv+Gv/yuBpzGZbuIqYCbkqZ5+9TgemzqlLWIEjNz
         Ss1CUeZN/JOVsSnXSkg7SwONKqJc5x8KNL0aPqjo=
Date:   Thu, 7 Jan 2021 18:55:30 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/20] 4.4.250-rc2 review
Message-ID: <X/dLEsU/0BN42UQ7@kroah.com>
References: <20210107143049.179580814@linuxfoundation.org>
 <20210107163039.GB9524@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107163039.GB9524@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 05:30:39PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.4.250 release.
> > There are 20 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> > Anything received after that time might be too late.
> 
> This and 4.19.166-rc1 was tested by CIP project, and we did not find
> anything wrong.
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-4.4.y     
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-4.19.y
> 
> (I'm sending one email instead of two to keep the traffic down. If you
> prefer separate emails, let me know.)
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Separate is better as that's how I pick up the tested-by tags for the
release commits.

thanks,

greg k-h
