Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8A0199F24
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 21:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbgCaTdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 15:33:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727509AbgCaTdG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 15:33:06 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A8B6206DB;
        Tue, 31 Mar 2020 19:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585683185;
        bh=tMedG35WwRtk7PjEq+x762pVod6GpukC/H/linMNbJA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=MHs+EKmn8cNMJWJdHC8ylRr1JniFlPy/5vf3k/56akUEJp7kYeKq5oCQ8/lUNWWMt
         I+86t13Dx8uxI8TjgfysTGW41B/A3WS9eQlKKHuu9J9fkaEiF9OSVLMW9e9csmYE2h
         K6RLqXYosEpgF0evEUmrUvrhWa/8RP5MuVQ00550=
Subject: Re: [PATCH 5.6 00/23] 5.6.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200331085308.098696461@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <0c4aaa5f-0f85-4b00-e938-4f34c55e3711@kernel.org>
Date:   Tue, 31 Mar 2020 13:32:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200331085308.098696461@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/31/20 2:59 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.1 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Apr 2020 08:50:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
