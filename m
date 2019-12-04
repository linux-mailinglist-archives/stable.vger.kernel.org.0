Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB61D113125
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 18:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbfLDRxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 12:53:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:49202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728104AbfLDRxY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 12:53:24 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA8332073B;
        Wed,  4 Dec 2019 17:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482003;
        bh=nJjRT7RzV2oFiV0GMR0TfWueKCr+f9VxjX2fzvD24VU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Z1MauNYRFHTxGpWZ6cY4MpiPFEbAdxWxFZGcslTvzCoUsBR+/JsVPHrdp/q7m8lQr
         /3J/Du0W+AsxP0qrBU/zbXCdjJVM4wOXYootkId1e374bZkgwPuKhsssYsZPQP6XNB
         2I16AhLeZ6VuEmZNUSUJfNrgbPTJ8j9UO3izXDJM=
Subject: Re: [PATCH 5.3 000/135] 5.3.15-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191203213005.828543156@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <d2fed422-b8f1-fc0c-ab7b-ff61a75302f2@kernel.org>
Date:   Wed, 4 Dec 2019 10:53:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/3/19 3:34 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.15 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Dec 2019 21:20:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

