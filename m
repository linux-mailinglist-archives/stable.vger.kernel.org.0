Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2707714621B
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 07:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgAWGoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 01:44:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:35374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgAWGoI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 01:44:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0041124676;
        Thu, 23 Jan 2020 06:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579761848;
        bh=+qi4DUw9jPqOv33t2VN4VutJS6xHK0z0lu0KmoxSSH0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=anNe+KQG2pZIp1XNx0+WyhYBUFamQ4nTVCDZec37Y4W1t+TN/3kWHXgTbg37y9uKW
         Tzq/55wSw3TCWQEolzVtFJTYGWlHogXAX0SClncc+iaLvLCof1tKELcgq38zkHfeqU
         1zWMytqKbrWi0LNsHTb8YGKGSfPH9M4m6EXnAxzo=
Date:   Thu, 23 Jan 2020 07:44:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/222] 5.4.14-stable review
Message-ID: <20200123064406.GB124954@kroah.com>
References: <20200122092833.339495161@linuxfoundation.org>
 <d1a53f66-136e-f1c8-34d4-9ead26cff0b7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1a53f66-136e-f1c8-34d4-9ead26cff0b7@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 22, 2020 at 01:51:20PM -0700, shuah wrote:
> On 1/22/20 2:26 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.14 release.
> > There are 222 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 24 Jan 2020 09:25:24 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.14-rc1.gz
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

Great, thanks for testing all of these and letting me know.

greg k-h
