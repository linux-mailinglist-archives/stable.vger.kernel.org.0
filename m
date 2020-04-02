Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E498219C75D
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 18:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388465AbgDBQvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 12:51:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbgDBQvP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 12:51:15 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D553F20737;
        Thu,  2 Apr 2020 16:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585846275;
        bh=OWoWofA5/lIsAhLWpLfJf9L99GPd7+sOKnFrWNGUgf4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=aGV2qaGXe0XQ7hFCmEpdhRMZgc9etUQM5MLi6Cjv6BoFazdvHnt6gqt6H0idTEBzr
         j04OUfR59Qml010D8WdYOTwYJ1GwhbukmDoIskcWGmTlaP39QpnZdSoK99RgACNRlA
         DT9wWTJHC90gn2gGWvjbS0iyINuej+70gxzY24HA=
Subject: Re: [PATCH 5.4 00/27] 5.4.30-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200401161414.352722470@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <9c52baad-0be9-aa74-8f30-25201d15db2b@kernel.org>
Date:   Thu, 2 Apr 2020 10:51:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200401161414.352722470@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/1/20 10:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.30 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Apr 2020 16:09:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.30-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
