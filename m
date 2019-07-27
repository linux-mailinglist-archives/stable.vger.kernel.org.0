Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4D1775FD
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 04:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfG0Cd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 22:33:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbfG0Cd3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 22:33:29 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 437142084D;
        Sat, 27 Jul 2019 02:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564194808;
        bh=nG/DP4zu0+bBCKaJ08jsk7eT0QH5jK3U1xszKcdFgFc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=nFZcfZNNGk1+yNVcRbfBjZyzh4gTdMpPOAsSRpVREAH2JUugvJJNjl72M86s9jyhi
         xKXh+6a1yMVzBz+35Lf+fkM2kFrrDbEyllTbI9RornOA/n8G6/XD4pdg4PyBPHp6fa
         lD7qawx4cwrZylHaRNnN+qHISn7Wt45ED+XsOhXE=
Subject: Re: [PATCH 5.2 00/66] 5.2.4-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190726152301.936055394@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <2cd55ec5-ea26-2d47-1aa2-276662329e59@kernel.org>
Date:   Fri, 26 Jul 2019 20:33:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/19 9:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.4 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 28 Jul 2019 03:21:13 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions,

thanks,
-- Shuah

