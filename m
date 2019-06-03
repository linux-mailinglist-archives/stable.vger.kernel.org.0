Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7B133BF4
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 01:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfFCXcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 19:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbfFCXcB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 19:32:01 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1782425605;
        Mon,  3 Jun 2019 23:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559604720;
        bh=E9CbAgEs9+d36Gh/v1+Cws4NtjKbU5ADhJ1M4gwvR9E=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=GH5sg4QwpgZM3iuEisPxKW+Ubw3VCRPMUMdNGNY3JHzOR6dceBUuZHWy3Q9dgI/Hq
         EgDQMP5vG54tCIkql1xtJXyssxV1w8R0fbMPyjBWes3mPEzpQUws40Nr6UajtTQnwU
         88QFAG8+2BP75gxbw9gXmdVT/5y7Qll76R/R4Pwo=
Subject: Re: [PATCH 5.1 00/40] 5.1.7-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190603090522.617635820@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <59b66e9f-69be-63a8-348a-9a24a1246dbf@kernel.org>
Date:   Mon, 3 Jun 2019 17:31:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190603090522.617635820@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/3/19 3:08 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.7 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 05 Jun 2019 09:04:46 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

