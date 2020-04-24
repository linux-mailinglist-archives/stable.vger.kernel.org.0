Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374D21B7BFB
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 18:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgDXQpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 12:45:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgDXQpq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 12:45:46 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4A8220728;
        Fri, 24 Apr 2020 16:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587746746;
        bh=hSdOuXHZ6H52RFSXglqDDabE+HhcnOIacvjpipKNYAk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=HoblEk0sIPyOkuwbqQSVqGz4gl3vRfeAYoeBBrCu8MR3qS0Vz3E4u4GkHKzTaa2ed
         kHpOMdS9rkh4+19NHNugYcFsN0Zpn0sISoDZIvZ3BRcNDYdHmGeOQsv4+yolfYogyD
         zCB9Ehb7f8TmpHcWtF1weOr928mrLwy70odZ9wf4=
Subject: Re: [PATCH 4.14 000/198] 4.14.177-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200423103335.768056640@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <35b69c21-e415-66eb-4308-e95894da184c@kernel.org>
Date:   Fri, 24 Apr 2020 10:45:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423103335.768056640@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/23/20 4:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.177 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Apr 2020 10:31:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.177-rc2.gz
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

