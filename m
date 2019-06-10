Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7BFF3BF0D
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 00:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbfFJWBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 18:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728453AbfFJWBn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 18:01:43 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8253C20820;
        Mon, 10 Jun 2019 22:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560204103;
        bh=cM+J0IxraqOeDKfno/APqmDwhBPo2pavmzkaa99k+58=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=c6p0cUJm7UDjFfELpCJlvq0G2GfwthOD/h6HzSyQtUL9LL2tEU8a33DS+9HACnZep
         KhKv2rgB/G3Zq2h9Aw46GtbkbJnzIz9HO+LqjjvIeKnL5q5qM1iLYqyKRgFJuA4gFe
         Icd16UNU2Jt6gZullLis5wp0UmS8JeSUCv6I+mb8=
Subject: Re: [PATCH 5.1 00/70] 5.1.9-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190609164127.541128197@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <6708fcff-8a84-5756-bc68-0de47397ab91@kernel.org>
Date:   Mon, 10 Jun 2019 16:01:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/9/19 10:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.9 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 11 Jun 2019 04:40:04 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.9-rc1.gz
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

