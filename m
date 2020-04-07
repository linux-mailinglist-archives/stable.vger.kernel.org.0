Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 333DB1A1573
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 21:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgDGTBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 15:01:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726332AbgDGTBm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 15:01:42 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 629DA2072A;
        Tue,  7 Apr 2020 19:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586286102;
        bh=qExfZl6EuelhQPmpm+Nq0ya3pNbAUgYou+YKYSDsnxU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=WrhAxqbiT3aEI9o7CkYSNcIPJr0KIyd5K1kyarsYAlgfUDKKggu+A2XKPY07gei9i
         RoQbw+TEXlx0U3MJQjgqnrJ2MasajduRjgURrrxZIgQlDePbjZmunMTT3gm15881lj
         4xkCDIAnAfzxrkbly3RDAgBqe7hsz+EMnvPOpJGI=
Subject: Re: [PATCH 5.5 00/48] 5.5.16-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200407154800.629167305@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <2b6cf5aa-39b3-46d2-f76a-d8509f1261bd@kernel.org>
Date:   Tue, 7 Apr 2020 13:01:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200407154800.629167305@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/7/20 10:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.16 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Apr 2020 15:46:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.16-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. NO dmesg regressions.

thanks,
-- Shuah
