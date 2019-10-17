Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D837DB0AB
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 17:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731768AbfJQPCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 11:02:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727600AbfJQPCs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Oct 2019 11:02:48 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9A9A20820;
        Thu, 17 Oct 2019 15:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571324567;
        bh=z3zy2j0zI2cPZpGPvgQgYRrGyjU/4GB3G6qW1p4Qht4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=kTA28ng8rpBgGTSxZGxiyy0F0UhNeszpLSRJ/y6Dr98n7Z8EctX8/R5igMYVijSKz
         Q92Nijt3wJCEhYEaJpyU/K8hSNIrSoza8TdKHEqZdgheZnhYywXjXAmUJ+oB1BsIeV
         sdrBthXYit8YNc4xSXLi0dPRtSDNzCnE5fNnEcLE=
Subject: Re: [PATCH 4.19 00/81] 4.19.80-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191016214805.727399379@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <472b9171-68a7-a63f-ec30-b551a428d0f2@kernel.org>
Date:   Thu, 17 Oct 2019 09:02:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191016214805.727399379@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/16/19 3:50 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.80 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.80-rc1.gz
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
