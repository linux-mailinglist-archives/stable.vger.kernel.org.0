Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D46C88596
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 00:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbfHIWHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 18:07:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726800AbfHIWHa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 18:07:30 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A507208C3;
        Fri,  9 Aug 2019 22:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565388450;
        bh=jLY3KsM/03IWR/+g32wXNHc4zyXVsVUUGyA/qa5S46o=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=gCtfRlfdjJ2/ku74zSwOk/nfxDA8iwBkLhL9BlAuAQZ0S8goHKM4VPIMl2iu6Pdlf
         F3WcAe1UDhhK3ndtMwmUNQVKc4xujretskiGKdDbxPdL+VcYkVSwI1x1+FLsk+oH2I
         hZOwxMCAnzNNEvkWnMfcGE25dTDOaTSO1xnSBHuw=
Subject: Re: [PATCH 4.9 00/32] 4.9.189-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190809133922.945349906@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <f6ab9977-49df-af3f-6bab-0eafc1b4c44f@kernel.org>
Date:   Fri, 9 Aug 2019 16:07:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809133922.945349906@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/9/19 7:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.189 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 11 Aug 2019 01:38:45 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.189-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

