Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8E81CB288
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 01:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729439AbfJCXxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 19:53:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729398AbfJCXxP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 19:53:15 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72AA22077B;
        Thu,  3 Oct 2019 23:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570146795;
        bh=66HQ2qm+zi9bgty9yf1Yvit0/vFxmI3AFDFGOXiUEZY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=15dte2KDSwpH+jEgu6I8MDEjpHZkqIH3tSAT3lYBFEtj1lJwp6YcvOJ3WKTHZ7Lsf
         +rj+jYg7p5ORs92Zgem83rTPT6uhzlEWwmyRa++1kJlAgtC696L1tKw+ic6940++IR
         4ER5zjMfmkJhhU62Zk2GiaRf0x+7+OJKjhE5QhL8=
Subject: Re: [PATCH 4.14 000/185] 4.14.147-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191003154437.541662648@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <afdd0fb5-7ced-d906-9588-92dc5340d4d6@kernel.org>
Date:   Thu, 3 Oct 2019 17:53:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/3/19 9:51 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.147 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 05 Oct 2019 03:37:47 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.147-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
