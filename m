Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1D43169873
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 16:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgBWPky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Feb 2020 10:40:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:39172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727064AbgBWPky (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Feb 2020 10:40:54 -0500
Received: from localhost (95-141-97-180.as16211.net [95.141.97.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1FD9206E0;
        Sun, 23 Feb 2020 15:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582472452;
        bh=qn0y9/cBVAUjxkM0UFdQOXpbojYXWUWzzbvoVOT+lHs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=atVQxI8vo024g56fBXEusBOQZfhjc5AC4kHj1JBdbK/o7pUQaOUvVTh69cRIFt+Au
         s0LMETL514SQlFa79WDmVM51ffMBsDtOUDFI0voMD71mFVbI5aOcwS5b1inBAOKqhz
         TqD7yp5pad+u4kU7OUDVgM5FwoUlh2yP1O9Q+m9Q=
Date:   Sun, 23 Feb 2020 16:40:49 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/344] 5.4.22-stable review
Message-ID: <20200223154049.GB131562@kroah.com>
References: <20200221072349.335551332@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 21, 2020 at 08:36:39AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.22 release.
> There are 344 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.22-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.

-rc2 is out to hopefully resolve the reported problems:
 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.22-rc2.gz


