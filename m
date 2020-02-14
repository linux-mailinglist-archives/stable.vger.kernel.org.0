Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 819A215CF2D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 01:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbgBNAmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 19:42:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:36144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727955AbgBNAmI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 19:42:08 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D243F2187F;
        Fri, 14 Feb 2020 00:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581640928;
        bh=EmQcxiNvK/x4tD6mRsL2K1pR6nZqCXLY44gaFHE87Po=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=suquqWkHTNOPKJHcSWuBa5+udjHJg69mcP0J6LFI8c3sBPo1+RsjCZeUxV2szWM9f
         6KQ6o6C0tjhJA6rx+cHNAalUJSCAURjiielXCraBCOIhI3EM+JnJ3k2Uu4BdpqvOiH
         3lG1260MCJHixYp2m8vIGzPBrOuFJ/VGUiER9nNY=
Subject: Re: [PATCH 5.4 00/96] 5.4.20-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200213151839.156309910@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <fb4e5bfd-5415-801f-5be2-677f18abf3a8@kernel.org>
Date:   Thu, 13 Feb 2020 17:42:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/13/20 8:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.20 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2020 15:16:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.20-rc1.gz
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

