Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17C3F107964
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 21:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfKVUW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 15:22:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:39616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726568AbfKVUW3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 15:22:29 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06FAB20708;
        Fri, 22 Nov 2019 20:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574454148;
        bh=5QPC01ZTqYEFqgsRVhysNCL+8y6cbpPwWrKI7shNfNM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=PXN4g1fn6BbjjMNg/01gZY+BjKyF/bnD6KMr4051TOG31UTCzofbIq+/WSRBY0Ixs
         XbvncjScQlLFQIa0MeAGspzdtrx2RgUL4gahERz4fqFxev9VuHvpqjeTdrEQA3HxzF
         ov8Hyh8zx5WLxPmpCJD2uVIpTFe2aGXJdc8OuhXM=
Subject: Re: [PATCH 4.9 000/222] 4.9.203-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191122100830.874290814@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <ad39b30d-1108-3ed7-1c39-d9a97363c93e@kernel.org>
Date:   Fri, 22 Nov 2019 13:22:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/22/19 3:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.203 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.203-rc1.gz
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

