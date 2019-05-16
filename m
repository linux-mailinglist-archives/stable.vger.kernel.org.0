Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7323B2090A
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 16:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfEPOFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 10:05:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726692AbfEPOFI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 10:05:08 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9938E20675;
        Thu, 16 May 2019 14:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558015508;
        bh=FrVkYbssWDJwRrZj8al2aVioeZd0SpKnP5mWCbSSDR8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=VtMgvBAIJzoqQWUm/f2p2Wgzt8P0IOo3Rhcrp02jl5VH6K/XEcRcje8HGAFBW11Ed
         ZAe3nn/YfYbmxk7oG6OElNfGH3wfUdcvmQrmp3Y82ESE4DNjkeL7rV4C0l5o6enxXl
         vNCS8zwZqK1f0kLNym/FJPc0Cx8FbXGmRtDCr+BE=
Subject: Re: [PATCH 4.14 000/115] 4.14.120-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190515090659.123121100@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <e147000f-d2ce-912c-222e-a2fd2dd49296@kernel.org>
Date:   Thu, 16 May 2019 08:05:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/15/19 4:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.120 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 17 May 2019 09:04:39 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.120-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
