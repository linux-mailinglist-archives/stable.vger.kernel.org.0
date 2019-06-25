Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6396152160
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 05:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfFYDxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 23:53:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbfFYDxa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 23:53:30 -0400
Received: from localhost (unknown [116.226.249.212])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B33620665;
        Tue, 25 Jun 2019 03:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561434810;
        bh=SG26bYO56Ct0AuXTeKnwt8cQd353Qwg1893NFtQKAzw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0lffZ4z7QLh0fmRjOSbk0r0NLUV/FXL3S45N/S3wb7FI9oW4XY09GOvRvxL1vVdQ6
         qh4NkYdTCIWhyKJKLnyQpCg+gJOpT0D6HMafm1WCVrfUnHfuEKLNuldPjlh5twZfVX
         XVS2rAlCmvgJVqg4bx7TkBrOd7Z0BvXKZqi286hQ=
Date:   Tue, 25 Jun 2019 08:51:30 +0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiunn Chang <c0d1n61at3@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/121] 5.1.15-stable review
Message-ID: <20190625005130.GA8909@kroah.com>
References: <20190624092320.652599624@linuxfoundation.org>
 <20190624175215.s5gtvatc3gqqeact@rYz3n>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624175215.s5gtvatc3gqqeact@rYz3n>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 24, 2019 at 12:52:16PM -0500, Jiunn Chang wrote:
> On Mon, Jun 24, 2019 at 05:55:32PM +0800, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.15 release.
> > There are 121 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 26 Jun 2019 09:22:03 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.15-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> 
> Hello,
> 
> Compiled and booted fine.  No regressions on x86_64.

Great, thanks for letting me know!

greg k-h
