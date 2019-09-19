Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E14ECB7067
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 03:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729872AbfISBWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 21:22:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729856AbfISBWw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 21:22:52 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E64521907;
        Thu, 19 Sep 2019 01:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568856172;
        bh=0Ci4KhbCJK9AkFl4vPsROl5y2ypTlJgdmVLThfY0y5A=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=NsoBOodlEK2G1M997AOd17DDtFoY2asWPk/PksN4yHH/thiGRMGz94uXkzh0Omolg
         LeHyVvL7xrGK+YfvICi97LdLUNZNhNIhKIGoSynjURvadDSfiUs7CjltTenH4fHhkJ
         figmqlG0eP9qlpe8ib6EZDozQO/jRVk7liH6V+iw=
Subject: Re: [PATCH 5.2 00/85] 5.2.16-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190918061234.107708857@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <4ececdb6-6263-97d3-727a-39d89792634c@kernel.org>
Date:   Wed, 18 Sep 2019 19:22:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/18/19 12:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.16 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 20 Sep 2019 06:09:47 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
