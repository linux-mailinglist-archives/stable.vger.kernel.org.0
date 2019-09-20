Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01945B98D6
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 23:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbfITVRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 17:17:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbfITVRu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Sep 2019 17:17:50 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B575620820;
        Fri, 20 Sep 2019 21:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569014270;
        bh=oJgr9T6G90fYNCsqz4PI8X2WF1v3Ii6XZnZvBzAL/1s=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=lxh0BAIfKV4z0WA2G/OevpQuRfRyCv9UH4JPQIYQEkgCapDTzUpmlilPvtPDPVUiw
         ND5lP7LcV/2/UkJvJnCWN3/WPMWsxdynyFiQQIOPuZwhqtiLdPXY01dNTub/ZlkIR2
         0ytyiujj/NTgkJ5MaFh5np1p4MWDU0KTLvAqk5IU=
Subject: Re: [PATCH 5.3 00/21] 5.3.1-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190919214657.842130855@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <5aa8e046-439a-83d4-1cb0-6bff87edfb5e@kernel.org>
Date:   Fri, 20 Sep 2019 15:17:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190919214657.842130855@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/19/19 4:03 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.1 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.1-rc1.gz
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
