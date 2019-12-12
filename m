Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1232511C381
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 03:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbfLLCru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 21:47:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727599AbfLLCru (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 21:47:50 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7549F2054F;
        Thu, 12 Dec 2019 02:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576118869;
        bh=yInUjrOmAen4VQcMDoR9IhktA9YAUcT9L7X74Aux65g=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=VNlFzildV7XsJ/AG9NeDceuoCaJf4tCig/tyg7J86L3ENR/oQGkZBw6puV5r3AUm9
         ZuSBVj0DV4DQIqBSxq5hVrfbm/Djj6b/nec2dKCvKjapCvene+hw61GTr37py/gUIp
         9g15ZouHBKH3+SYsqgdATnrSO4ugUJrpD42kIH0g=
Subject: Re: [PATCH 5.3 000/105] 5.3.16-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191211150221.153659747@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <96ac0eed-697a-e737-4032-08899d5f9cb3@kernel.org>
Date:   Wed, 11 Dec 2019 19:47:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/11/19 8:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.16 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
