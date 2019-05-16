Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4776120998
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 16:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfEPO15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 10:27:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726696AbfEPO15 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 10:27:57 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24D1F20833;
        Thu, 16 May 2019 14:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558016876;
        bh=BJtnyMXUmLAigNFJ6gGr4B9MNzUQokm2xobo1aVjRXU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=og9TgQYerl4BUC+ng49ZG32MFyNdpMhomkxl203YJFteVEilwu4ByiuZFllCnrVsH
         n7OQrrbCoz1fwgitz5HJs++KnnvupJwreSyrfsLALg2my85CvZw5/ob4nol6PHJNH2
         MZM1/x1Bj5ZCwHUw0K1fPQPH2aJRewFJE8H2Naag=
Subject: Re: [PATCH 3.18 00/86] 3.18.140-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190515090642.339346723@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <f2a05600-e302-9a06-80a1-421cae299287@kernel.org>
Date:   Thu, 16 May 2019 08:27:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515090642.339346723@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/15/19 4:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.18.140 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 17 May 2019 09:04:45 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v3.x/stable-review/patch-3.18.140-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-3.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

