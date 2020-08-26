Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C6125292F
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 10:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgHZI2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 04:28:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726016AbgHZI2I (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 04:28:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A765206FA;
        Wed, 26 Aug 2020 08:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598430487;
        bh=cHTLDNEa084aWywrsMzXhLG36k3PLmsbjZOG8Hgx6NI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xTkEySzCK92GSsZ5izyHS+a1q2T+N6pygf0EXEwDMjVOet9EUC4/LkGk/cnbmT62s
         kKyGdOFyNdGPZHYWEZgW7++TFjED9uaEsOU07K4dw1bxGuBvXKrSPafMXozu3j4nSn
         rq86/ShNfNCtrypB1GY9A494XCURBDX+vdos63yk=
Date:   Wed, 26 Aug 2020 10:28:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/71] 4.19.142-rc1 review
Message-ID: <20200826082823.GA1806567@kroah.com>
References: <20200824082355.848475917@linuxfoundation.org>
 <20200826080732.GA9637@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826080732.GA9637@amd>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 26, 2020 at 10:07:32AM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.142 release.
> > There are 71 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 26 Aug 2020 08:23:34 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.142-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> 
> Uh. I believe this was tested successfully by CIP probject:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/181017473
> 
> Yes, there are two "fails" but there seem to be caused by DNS
> resolution problems (i.e. test infrastructure problem, not kernel problem).

Thanks for testing two of these and letting me know.

greg k-h
