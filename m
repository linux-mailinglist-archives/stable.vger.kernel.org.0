Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1C2012D2E9
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 18:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfL3Rnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 12:43:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:48554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727236AbfL3Rnj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Dec 2019 12:43:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A90C2053B;
        Mon, 30 Dec 2019 17:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577727818;
        bh=YbYygZcpVEYLU0r2Vnvxcd4zQX2dtCyrY0tyKU9ztGo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uwMwmblB4fEfmrG9bhjWHuhsDNBU/rJwKqDdBSIMuVint/apKR6JFa1lOL6kJW/on
         YcURHaWn55ZCnIhkPtE2Y7qyjWcfP3h0agPW163sF8Di0IkExhP8sVV1T2AXj1719w
         xF54Iq3ohHLhlUW1f2L78ayGVkqvraFE9rht+Hg4=
Date:   Mon, 30 Dec 2019 18:43:36 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/434] 5.4.7-stable review
Message-ID: <20191230174336.GA1498696@kroah.com>
References: <20191229172702.393141737@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 29, 2019 at 06:20:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.7 release.
> There are 434 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 31 Dec 2019 17:25:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.

I have pushed out -rc2:
 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.7-rc2.gz

to resolve some reported issues.

greg k-h
