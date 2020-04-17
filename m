Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107601AD8C0
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 10:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729747AbgDQIiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 04:38:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729650AbgDQIiP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Apr 2020 04:38:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD6A92137B;
        Fri, 17 Apr 2020 08:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587112695;
        bh=oCNzy0t4sxeoxnGthh5iQksvuo1ZlihCYZL9R7th3Pg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xaEMDebf7M3yj+FU5f/0vkW4dqhblnrvbg1YVnsj9N5dImwBHAuTK1U2C+jEToAHV
         4CDiMJqY4Ydip3tSR/jnjUuasgDDIxvW5+v85Xw37Aettea27fDekZX9atpKBpxcQb
         3+ERxNxjiHMB0N75HpcdR0Soic6FYiAdA9vLNFvU=
Date:   Fri, 17 Apr 2020 10:38:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.6 000/254] 5.6.5-rc1 review
Message-ID: <20200417083813.GE141762@kroah.com>
References: <20200416131325.804095985@linuxfoundation.org>
 <a83ee7a6-d13d-6929-e4be-669058714fd9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a83ee7a6-d13d-6929-e4be-669058714fd9@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 16, 2020 at 03:35:35PM -0600, shuah wrote:
> On 4/16/20 7:21 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.5 release.
> > There are 254 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 18 Apr 2020 13:11:20 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.5-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.
> reboot and poweroff hang forever. I saw this problem on
> Linux 5.7rc1 as well.
> 
> AMD Ryzen 5 PRO 2400GE
> 
> I don't see this problem on Intel i7-8550U
> 
> I haven't started debugging yet. I will have to go back and
> check if it is introduced in 5.6.4-rc1. 5.6-3-rc2 is the last
> good one.
> 
> I will update you later on today with bisect data.

Oh nice, we are bug-compatible with mainline :(

Thanks for the testing, let me know if you find the issue.

thanks,

greg k-h
