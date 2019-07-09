Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93F9762E19
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 04:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfGIC1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 22:27:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbfGIC1H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 22:27:07 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26E702166E;
        Tue,  9 Jul 2019 02:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562639226;
        bh=yaEwzZUlzS6MaxG+YKPrm8CdjnhL5YPGU1ehpAZspaY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=d8fzonfgmf3b82cmZJVcmfh++gybax14wbQXPSKM0LK2YNY13GMghf7taSTqyjMmA
         F4Np9QD/3Xb+V4LxBqRKR4kcL/RasvMVa/jNkCz9lhX+NFtDWB7gpHDBH5+5F9XZNV
         MJRkFRtSZPawryHkf6ts5DN2WMYE50LjlSSm4wsk=
Subject: Re: [PATCH 4.9 000/102] 4.9.185-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190708150525.973820964@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <19b25b85-81a3-3c4d-1ee5-237a550dba98@kernel.org>
Date:   Mon, 8 Jul 2019 20:27:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/8/19 9:11 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.185 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.185-rc1.gz
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

