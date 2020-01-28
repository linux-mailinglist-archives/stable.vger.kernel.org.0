Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 659DD14C32E
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 00:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgA1XBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 18:01:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:42792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbgA1XBF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 18:01:05 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A36CA2087F;
        Tue, 28 Jan 2020 23:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580252465;
        bh=vUg0/wkA/cQsiYxbZnfQ3yyAzDEhwQhMEj5ujPRpJeY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=k6wAC3iv6s2DUNVMUurH1H5CNxSfqIhKAmwHHi35XQMy+kumJ8mF2Ik7LdWYALbq/
         TfzqOk5xMIEd59RpCqZ2Y8MxZ/NfuJ0WLFol5lCb+mpxYqTGwW56FJ/LsGpAPfMyRl
         /nVr53tJdXn/ousXLJYo79stsCd96yat67VDo97o=
Subject: Re: [PATCH 5.4 000/104] 5.4.16-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200128135817.238524998@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <13867bdc-88b4-5c0c-aa63-de003c44a44f@kernel.org>
Date:   Tue, 28 Jan 2020 16:00:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/28/20 6:59 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.16 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.16-rc1.gz
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

