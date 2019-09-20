Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1672AB98DD
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 23:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfITVVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 17:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbfITVVF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Sep 2019 17:21:05 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3DDC20820;
        Fri, 20 Sep 2019 21:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569014464;
        bh=+bRQwTdkKmvPBYTpqi24ENrmA27J9S+NsNle7g3miX8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Ce6Hv1pViMMKBUUV70YS+RGt4YHdZ8vWanBZWETLMPusRLq8ARCENepfPNAN1qy3/
         39IhRYxI+N0OnE/QGJzRSDiVOgaLNt4FPo9hx71R401Biwj/JydNFj2SnB+uwQacNj
         3pElwZ8OT0Jkmm1tYJYsfOqLIzlv2eKeG+1GlZSA=
Subject: Re: [PATCH 4.19 00/79] 4.19.75-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190919214807.612593061@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <1569385b-344a-2e34-cb36-6da2e3b186f1@kernel.org>
Date:   Fri, 20 Sep 2019 15:21:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190919214807.612593061@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/19/19 4:02 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.75 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.75-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

