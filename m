Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA8E86EDC
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 02:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732796AbfHIAgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 20:36:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbfHIAgP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 20:36:15 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54B292173C;
        Fri,  9 Aug 2019 00:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565310975;
        bh=PzzWFln+8fBU8bt0haFLRBFaDYMg7dUpD/csKONbLIk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Fsb/UxdF05oPhxVYIo1F2JixyKe2p9W5n+LHaS24+ktJ3dszMtXqigIAjffrCN4a9
         aU7Sp2KtSIklciPAgmaOLVsrcZgvSUBk6oCKdKt+LCKW7iHqwxWjgempuiXQJN0zrS
         1mPjR857jTkIG/cPbuOvehniXaAKF6885J+lT4jo=
Subject: Re: [PATCH 5.2 00/56] 5.2.8-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190808190452.867062037@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <c3469416-8f7f-6281-0a28-ee0e1ff4bdf9@kernel.org>
Date:   Thu, 8 Aug 2019 18:36:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/8/19 1:04 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.8 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 10 Aug 2019 07:03:19 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

