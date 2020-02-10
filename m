Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 616901585AC
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 23:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbgBJWki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 17:40:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:44142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727422AbgBJWki (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 17:40:38 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88EEF2072C;
        Mon, 10 Feb 2020 22:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581374438;
        bh=vfIug7xDahfDUqF78fzqkLMfyX2qbVFQqEKwa9yHIMU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=o+TIYpShEGjS4Z3/QNpey5LkRT3gd9/ramRwfPvP4fz8avT7PrjpyKwBECfic6Gil
         j6dilsoLmumi17FBgdcuOjzMwroNv3GZShoGyUV25C46KB8MVHMEVgKrpSR+CeAvfY
         TItHcsHP3zuKVqmx78XKLSj5NX8PoIqScgOshrcQ=
Subject: Re: [PATCH 5.5 000/367] 5.5.3-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200210122423.695146547@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <e641b25d-02c1-d169-bf36-511ded28ec09@kernel.org>
Date:   Mon, 10 Feb 2020 15:40:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/10/20 5:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.3 release.
> There are 367 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Feb 2020 12:18:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
