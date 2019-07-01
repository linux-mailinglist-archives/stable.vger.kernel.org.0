Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7BE1134D3
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 23:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfECVVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 17:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbfECVVl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 May 2019 17:21:41 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84AF22070B;
        Fri,  3 May 2019 21:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556918501;
        bh=YAZxWrsiRX3Ld34/nINOdZ//GV5Wgyxn0ODfF6feze8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=FPGA1Pv5RUKSVn9vhDrlFvpykfNJmbmdcd1WkL7N6hX96mYYYOOjcUBEkMlD83sMs
         zVnQY5i8/3MjBqicOyV5GoCV0J0sGGf48NCz7dV9tGzv5mhZtG7emoD3z22kk909d+
         LSCjpfN6yGPzgiphmDh5FxKbtO/oSY3YXUE2ksts=
Subject: Re: [PATCH 4.9 00/32] 4.9.173-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190502143314.649935114@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <99f18213-b361-7a59-7e13-d287655b4bc3@kernel.org>
Date:   Fri, 3 May 2019 15:21:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190502143314.649935114@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/2/19 9:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.173 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 04 May 2019 02:32:02 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.173-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
