Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A15C7518E
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 16:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388498AbfGYOnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 10:43:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387957AbfGYOna (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 10:43:30 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7780522C97;
        Thu, 25 Jul 2019 14:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564065810;
        bh=WdVDLufKWW7fGdYQDWk/rYLodV3eL36Zpldc2S1tmNQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=pAjfXr3HltIBn2757lv1RkMD/BRnzVWzP3wbhuggAlIeewuD9R1ZvdD+Dh/xBR5DF
         vhKXVr7u71DydPjcJZ18y6SQyRyvuf5A/w2pPzFJwqCsvhBDlBDG9XzqoSbSk1cnnH
         AEB/Hisp8Al5yq5tl55G6K1PtQcsmEOVjSuWcvYc=
Subject: Re: [PATCH 4.19 000/271] 4.19.61-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190724191655.268628197@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <aaadf790-b5c9-c2ce-c687-e82b5eb393d8@kernel.org>
Date:   Thu, 25 Jul 2019 08:43:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/24/19 1:17 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.61 release.
> There are 271 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 26 Jul 2019 07:13:35 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.61-rc1.gz
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

