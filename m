Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47655180A27
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 22:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgCJVQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 17:16:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgCJVQp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 17:16:45 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2857C215A4;
        Tue, 10 Mar 2020 21:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583875004;
        bh=TiW2oRRAsVeSGLGm2tTtzW2BJSgtHOl+hNXOWfrg0WU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=rRqV7NJ5D8KzX7yn/pGMcU06AHBQxJATaTFw7RfKdMZbc7isVYPEjN3eGEYvr+two
         pcGP/9TJJTX1bLBWA2RFi45aIkZxjpgE03LhfKV10ppmdaYQ/Nxhtzgq4mxxU1l1dO
         MB7T82DBpasYeB88Mzl+bJSS/J3jtYmJVneCkYks=
Subject: Re: [PATCH 5.4 000/167] 5.4.25-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200310144113.973994620@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <349639e0-3d3d-a4b6-8785-39965289e411@kernel.org>
Date:   Tue, 10 Mar 2020 15:16:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200310144113.973994620@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/20 8:42 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.25 release.
> There are 167 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Mar 2020 14:40:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.25-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

