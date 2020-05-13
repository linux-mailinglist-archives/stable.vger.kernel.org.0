Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0967F1D2287
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 01:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731857AbgEMXAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 19:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731815AbgEMXAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 19:00:04 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 351972053B;
        Wed, 13 May 2020 23:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589410804;
        bh=yhgOy+HBIqe+YTLD0EU9sasHa8OQ4wIY+R54vtxpDU4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=c3Umq4IsUaRU+CdCE3tq1ph8DqMqpHh3Zo4v6ZjUetNZZ8j2bJ/QCpTfWYDcvi+Hu
         cFRvfDqZczu0qgb4dQeXbmcnUKWmIELwWPBBkruCDX12VFkrGKCiCY7Mjib+e9ni1C
         dE+UI9NB/TMtFeg4KuXoCO0R5HDgwpi/A7N0/CVA=
Subject: Re: [PATCH 5.6 000/118] 5.6.13-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200513094417.618129545@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <6ef26ca0-ebb2-9f9a-c9a8-32365667a7a9@kernel.org>
Date:   Wed, 13 May 2020 16:59:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/13/20 3:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.13 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 15 May 2020 09:41:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.13-rc1.gz
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

