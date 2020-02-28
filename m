Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22092172F68
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 04:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730654AbgB1DhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 22:37:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:38188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730638AbgB1DhW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 22:37:22 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1AF1246A0;
        Fri, 28 Feb 2020 03:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582861041;
        bh=ymTpglhTx/DxbF09iIi5giWzbiRWHgLTMxpkbIlzpmQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=rVZZIoYVx+3OuJlNPvSc1b9jVk6O6QW0MUd+/qM2a0M9CabJI73CQPSoaUI3CSzKs
         TLtw60nCnFp/60oxH+6VaYJ6nvNK1afq5PgWE1NC53jExBJ1wPzThDRTzWuKzRXCfc
         RIETkq5xqfUNgmFXqpURLKEGM0H9oboPKdaEblM4=
Subject: Re: [PATCH 5.4 000/135] 5.4.23-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200227132228.710492098@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <380fc830-f329-3a0f-10ee-5f01ede6e68b@kernel.org>
Date:   Thu, 27 Feb 2020 20:37:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/27/20 6:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.23 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.23-rc1.gz
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
