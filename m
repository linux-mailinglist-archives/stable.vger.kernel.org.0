Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7446F33BF6
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 01:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbfFCXch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 19:32:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbfFCXch (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 19:32:37 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4997125F8D;
        Mon,  3 Jun 2019 23:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559604756;
        bh=MICd1l8KTC5vFcOtst67TZbYwlqcn2Id1uxeDyH1YxU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=YiPpF6sGltVh4FMQ5nmAjVZgV7l6RoObFkrKjbu/+xzor46jBuAgLxMdjQpp0bahm
         roz0C54SquTtV+W9QlPAXMSOYyvv/E0S8Lb0hhxK31cQeWfSY6266Ee0Lfb3F/XbY2
         6pFDbvc9q1yCF/VJolOybCIGHr7IRoOGB/FKhr5M=
Subject: Re: [PATCH 5.0 00/36] 5.0.21-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190603090520.998342694@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <80f9b6b6-0fc9-da12-9f13-691b40875044@kernel.org>
Date:   Mon, 3 Jun 2019 17:32:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190603090520.998342694@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/3/19 3:08 AM, Greg Kroah-Hartman wrote:
> Note, this is going to be the LAST 5.0.y kernel release.  After this one, it is
> end-of-life, please move to 5.1.y at this point in time.  If there is anything
> wrong with the 5.1.y tree, preventing you from moving to 5.1.y, please let me
> know.
> 
> This is the start of the stable review cycle for the 5.0.21 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 05 Jun 2019 09:04:48 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.21-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
