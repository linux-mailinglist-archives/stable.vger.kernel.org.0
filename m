Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 055DAAA5AB
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 16:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733096AbfIEOW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 10:22:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725290AbfIEOW4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Sep 2019 10:22:56 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E825C206A5;
        Thu,  5 Sep 2019 14:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567693376;
        bh=Y49Pw93Kmg/6UZTb9gRSuwQkNuuRJuxwKt59AgHDvnY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=iQjp9uB35mLrCL1slK8xqZAF7vrVPh7ARF93psDG/8IsVX/ikoMRD2ElVCOaoc7jX
         +YxLAAasHaDsg+bcjtOuV0NmezKPcIIOh//Q+Utxd/iBn7hMX172TLRm24+zbCk/Q/
         OTLxwQMYEU2ZJ+hyX/GmYBEp+JDD728PaqL8fWhg=
Subject: Re: [PATCH 4.4 00/77] 4.4.191-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190904175303.317468926@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <6320937d-1730-39f3-2af4-447e04079739@kernel.org>
Date:   Thu, 5 Sep 2019 08:22:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/4/19 11:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.191 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.191-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

