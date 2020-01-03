Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54F4F12FE7D
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 22:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbgACV4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 16:56:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:43146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728549AbgACV4H (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 16:56:07 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D2F8206DB;
        Fri,  3 Jan 2020 21:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578088566;
        bh=Zp+eL4OD+MxFpPRmfAE90hzCcvrmIQxVJlwDlEL0u+o=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=LAeuksZDzHquLNXtJddQdbYWgjHgcOhtAgJWVrFCJdqR8sCPCfe0XZOK9HIH6/yAJ
         5ooZCpH4MMRhCtFMMD53WR9SkSHZHGMh1krA4arHyUu8vtLsyJKW+BIY8HE+0s5ZqW
         ByqG53v/jT3gg3WpAhESeDD+Axd0o50Oix69ulyw=
Subject: Re: [PATCH 4.4 000/137] 4.4.208-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200102220546.618583146@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <14657b51-8df8-0b40-f64c-3b2cb9cda1ac@kernel.org>
Date:   Fri, 3 Jan 2020 14:56:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/2/20 3:06 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.208 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jan 2020 22:02:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.208-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
