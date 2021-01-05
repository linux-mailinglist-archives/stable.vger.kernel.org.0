Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397042EAB80
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 14:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730511AbhAENFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 08:05:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727063AbhAENFP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 08:05:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7679522AB9;
        Tue,  5 Jan 2021 13:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609851874;
        bh=/vqYgpMKu2hcBkqqsBMfs8P1d5Xpd9OHlU7GsZ3xTDU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OdfiePzrPT+X7OqHz5epLl+B0Sd9Kb1ng56057AloxLlnBk/Mb7pK9d6wBEC22v98
         ri0LxvSQeWp1zKNkW9dVEVmZrJmqaCQZS11uawzBcC8s5ktRt+7m+HNv1iRbQTGlKJ
         W5tR4gRlwvL0shkBNtDL++G50NSiylpoDq8zlkeI=
Date:   Tue, 5 Jan 2021 14:05:59 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/63] 5.10.5-rc1 review
Message-ID: <X/RkN6xJGasmekr4@kroah.com>
References: <20210104155708.800470590@linuxfoundation.org>
 <69f585d13328c51811441c967243f4918f6a3c84.camel@rajagiritech.edu.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <69f585d13328c51811441c967243f4918f6a3c84.camel@rajagiritech.edu.in>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 05, 2021 at 06:25:14PM +0530, Jeffrin Jose T wrote:
> On Mon, 2021-01-04 at 16:56 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.5 release.
> > There are 63 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied,
> > please
> > let me know.
> > 
> > Responses should be made by Wed, 06 Jan 2021 15:56:52 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.5-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> > stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> hello,
> 
> Compiled  and  booted  5.10.5-rc1+ . dmesg  related shows 
> no new errors  and  may be no major warning. 
> 
> Having said that, "dmesg -l warn"  show  a BUG related stuff.
> 
> warning-5.10.5-rc1+.txt file is attached.

Is this new?  If so, can you bisect it?

thanks,

greg k-h
