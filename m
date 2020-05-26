Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623DA1B7BD2
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 18:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgDXQjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 12:39:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726849AbgDXQjc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 12:39:32 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAEDC206D7;
        Fri, 24 Apr 2020 16:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587746372;
        bh=Zm7dE+egm6mY1mef4VDy/g3oTfP8PcrMnqQJ+X3oefI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=gV/mlfDyPJ2grOqLXzl3sRXK34i4OLnHwiclZroAiuklBH2Uo+fvzQJ9C/a6xJeN+
         b2qINdmHEkIb+qRaLj5SFCq/6MM9T0C3tyOxYNKkw+kB0ALRUNwU/hyx+TJX+6Q2pb
         +jeWDBwkr8kDa6d6Eqz6HkjOwyv0yej12Ywc3PGs=
Subject: Re: [PATCH 4.19 00/64] 4.19.118-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200422095008.799686511@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <05d9558b-622b-930b-72d3-1b14e88d80ec@kernel.org>
Date:   Fri, 24 Apr 2020 10:39:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422095008.799686511@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/22/20 3:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.118 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Apr 2020 09:48:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.118-rc1.gz
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

