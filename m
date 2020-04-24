Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32601B7B83
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 18:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgDXQYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 12:24:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727033AbgDXQYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 12:24:38 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 910BF20700;
        Fri, 24 Apr 2020 16:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587745478;
        bh=LvKHAjnn2HMnG88kLXWaBsIX08L+10a1y0Eksgp8qVs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=fgbVNgPWBjParX/QrVh1/yIsaVVuo+fObeycRciInja3u6D48e1aIvhZoBHd8OG5p
         V7+5vykbUiuZHmZre71/qzvUQsz9N25Ea9tuO0Du5DegPfihJ+J5wKKXwQFEqrEWLz
         5CfUXmj5GLy3gfHpSafVISUK3SwX2/w7JkLLL8Fs=
Subject: Re: [PATCH 5.6 000/166] 5.6.7-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200422095047.669225321@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <4e438765-b045-4201-8a6a-4ab0b986b753@kernel.org>
Date:   Fri, 24 Apr 2020 10:24:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/22/20 3:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.7 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Apr 2020 09:48:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.7-rc1.gz
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
