Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD9E1B30DF
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 22:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgDUUAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 16:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgDUUAy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 16:00:54 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33749206B8;
        Tue, 21 Apr 2020 20:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587499253;
        bh=Pgtr14zkEd3dUidoqzOruoFu9MVxappF7KVHduBWCbY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=UCFcCqK7pH7/fL5+i/RUYjUJbM5lRY6/msVXFscgkRpXIbAHpwfE12Xh9oNyMqmbF
         /pjoJSEerCHO2DehqHLO3M/wlLSPyiR9tTtpTi5bmh4sbOrO0nUtMvUtDMtIkBt6os
         mU6pyoNUPXmaTM2P9ZTLAJYRZ8i4DTByGIEJYzT4=
Subject: Re: [PATCH 5.4 00/60] 5.4.34-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200420121500.490651540@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <9c496fa9-3b76-1828-0a67-f3f4682b693a@kernel.org>
Date:   Tue, 21 Apr 2020 14:00:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200420121500.490651540@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/20/20 6:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.34 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Apr 2020 12:10:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.34-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regression.
Reboot/poweroff hang problem fixed.

thanks,
-- Shuah
