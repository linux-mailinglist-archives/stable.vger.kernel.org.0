Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364ED1DA10F
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 21:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgESThV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 15:37:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgESThV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 15:37:21 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1474206C3;
        Tue, 19 May 2020 19:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589917041;
        bh=3DAfi1do7W57fgZnxWY0nr3tJPESpcQQcVW7ZVWB8Vk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=d6Q38dYoty1HXOz13soZXjc8bsN5RZu5xMREnE80n+lbFJHvjDU5G9mks/SdrkqSO
         px0DNWgZTi7Q+FbzqW4lFOX2ia57P4jY4U+qgUZXg7tMH++N4t8k0WtQbL8Omqq8jQ
         6BkTsAWpOK7ry0iWKXPB2AcT/f60y9XA9X26EYv4=
Subject: Re: [PATCH 5.6 000/192] 5.6.14-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200519054650.064501564@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <aa12b3ae-5b6a-5879-faff-aa0bbcf945f5@kernel.org>
Date:   Tue, 19 May 2020 13:37:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200519054650.064501564@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/18/20 11:47 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.14 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 May 2020 05:45:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.14-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
