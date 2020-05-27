Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA301E4AFB
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 18:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgE0QvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 12:51:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730994AbgE0QvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 12:51:05 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 893512071A;
        Wed, 27 May 2020 16:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590598265;
        bh=4KrOx9LZA6UgWW6S9RdgSWsnecwKtL62KC4WVxdtl8w=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=HJSjWRzVmt0kcmDQuGUCSM4bH7obXRUGtenGKuVjD+gvxPLjRyA7hjTJFWlxmW3Tf
         3UxFSvq6O0zDGGEDGUQhvHVImJ0nCc6KCX/sRlO1lzYglz0ZGVa9gHVC2o9mSDTjDA
         URk613IhqwPCmwyIYYezQNH922oRnh7sgMcxoxIQ=
Subject: Re: [PATCH 4.14 00/59] 4.14.182-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200526183907.123822792@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <8935fd6f-7d5d-bd86-d7eb-8f388fb09462@kernel.org>
Date:   Wed, 27 May 2020 10:51:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200526183907.123822792@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/26/20 12:52 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.182 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 May 2020 18:36:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.182-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
