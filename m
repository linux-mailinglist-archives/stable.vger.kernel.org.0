Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF0310265
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 00:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbfD3WcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 18:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbfD3WcO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 18:32:14 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3A4720854;
        Tue, 30 Apr 2019 22:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556663533;
        bh=XRVMa04kudlHTq2z7N3HsIVwyLgTj7ZVz8OS2PVDtX4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=UCSRWUfbjl6cuajEsqZVQJHL4EtO2TdNKLBhxLvrEpQdF7NrQGDZ4/XjSoNd98Vh8
         nf5hALAw3NTPm5E5kJuXNd80ZEo/alVbYMZsJtmVIYXQM3HZsG8CdHXaua0HjGT4PJ
         OVBnorCDoFJqTFdXrsxXMUa6RKJftY++VDlriyNw=
Subject: Re: [PATCH 4.19 000/100] 4.19.38-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190430113608.616903219@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <505d050a-6d02-9e62-fbb8-fa13129744c7@kernel.org>
Date:   Tue, 30 Apr 2019 16:32:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/30/19 5:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.38 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 02 May 2019 11:34:55 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.38-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
