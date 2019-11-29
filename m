Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A211610D011
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 01:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfK2AEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 19:04:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbfK2AEI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Nov 2019 19:04:08 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D5642176D;
        Fri, 29 Nov 2019 00:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574985848;
        bh=Z6jFq6+RHkXdm65R0mW4Qwzx5PTCJR79t7yQMV9j8EM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=bUlyb/06fDoRIq1S5dPQsgKBN2uqeBsh3pJFw70Z2JW1au/r0JsbGDaa1jPYjAWPy
         t+LPl5rCj63jVPNrGr6TFGbUBz4Q0mJhUFjAh9kghRjjxuQ/HBHYSogyKjYOJ+pf9R
         XJ4Q8eAADAnd9Tml/vPyPyRc0pAt8nxU/oyCnQrU=
Subject: Re: [PATCH 4.4 000/132] 4.4.204-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191127202857.270233486@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <9fdfd4ea-88b1-8ffd-7b08-6ec72988ab08@kernel.org>
Date:   Thu, 28 Nov 2019 17:04:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/27/19 1:29 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.204 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.204-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Boot failed. I am seeing the same panic on 4.14, 4.9, and 4.4 on my
system. I will bisect and let you know.

thanks,
-- Shuah
