Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD0D6302ED
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 21:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfE3TlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 15:41:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbfE3TlX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 15:41:23 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C31C126105;
        Thu, 30 May 2019 19:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559245283;
        bh=Kp9BPLLBN6tTJkMEb1RnE7EbB1NWblFEwsGrRM/SKe4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=0ACqX00EcbIUYcKCDhrlQ/9VYtu2uPGHcOvfFzDQetvlXoE9jW+/uffTha1lm8MLG
         3mSKpPC70M3680eIHLKadP7w0qbp9NohwmU/7VbUg+H6knZYrYr9WrZpkbF/sKTuAg
         UedjYIlW9cfw3iRXpkQZD69us/6Y6hEKQKGa2pqA=
Subject: Re: [PATCH 4.14 000/193] 4.14.123-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190530030446.953835040@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <6c78fd91-647a-35ca-0386-e69136fb73f8@kernel.org>
Date:   Thu, 30 May 2019 13:41:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/29/19 9:04 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.123 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 01 Jun 2019 03:02:04 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.123-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Complied and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
