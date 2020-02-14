Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2B3C15CF39
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 01:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbgBNAui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 19:50:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:40386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727595AbgBNAui (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 19:50:38 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4CE92082F;
        Fri, 14 Feb 2020 00:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581641438;
        bh=0Ic9tM2bq6Nw3FeE6ieUxNEfgBSgk02FEM7SI7u+U+Q=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=jxgjDlxCuv6SlXXTVAoumZW50hI8e24Tk8kSh+ObZHEBpCh/WJzDLXc3nT7l8T+Xi
         GJcvIHJMoOfUvXyStNk9umuO589vlPA/1KuT2pEKxcXzCAuBvAxyt787jcq290LoYj
         +IAWvttW4RHvh6sZb5oEe87vpoz/eDUvBe59ufoQ=
Subject: Re: [PATCH 4.14 000/173] 4.14.171-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200213151931.677980430@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <a72a5ea0-ff41-b632-b410-7049435e5077@kernel.org>
Date:   Thu, 13 Feb 2020 17:50:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/13/20 8:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.171 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2020 15:16:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.171-rc1.gz
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

