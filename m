Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58910189261
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 01:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgCRABY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 20:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726680AbgCRABY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 20:01:24 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91F4020663;
        Wed, 18 Mar 2020 00:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584489684;
        bh=DIAheFs7QNZ2gzYAxdC6NPE1xIZ1nDkyvbAllPFdogY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=kkMN+scBLQ2foCDTngTO/Q7G24Kvde9NHzDXluk9o2irFazYGbmQ0M7p2Uh0SRwtc
         TwY5Fcq2Uzpoqlaeqq+dmsu6jk3DukILNQQW9rYC8O1myLQoDOknhjKEFF24Lb4LMR
         UuSyx4FehVkvzGR3M+gcQQQQgasu9SNOLZbXwFDg=
Subject: Re: [PATCH 5.5 000/151] 5.5.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200317103326.593639086@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <e2dadcaa-adba-7472-edf5-5e34c7f5e59b@kernel.org>
Date:   Tue, 17 Mar 2020 18:01:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/17/20 4:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.10 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Mar 2020 10:31:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

