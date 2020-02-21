Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A54921687C8
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 20:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgBUTuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 14:50:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:42724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbgBUTuX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 14:50:23 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83992208C4;
        Fri, 21 Feb 2020 19:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582314623;
        bh=jN4g4WSuKcWzVoT6NqAvvjqRtCEUHvJuV6lBGt7ilc4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=SwtpSDilq2/X4194/+fpgk83ZQd6ITpoOcJypXVS+AjI+NPAgFsfL9pYsDFOOhbbz
         loD2PuM8hq9QbcbQltKpLtLKFOuMBgClyumwykqvxTkE8kS+t+AM3If44QgQjUaHzq
         +6zrsGmS3GTGPB8Nmh0MNbLgsmL5fi/gI1ucq1VM=
Subject: Re: [PATCH 5.5 000/399] 5.5.6-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200221072402.315346745@linuxfoundation.org>
From:   shuah <shuah@kernel.org>
Message-ID: <66e39cf3-03a4-73b9-2886-1fdd0ab86866@kernel.org>
Date:   Fri, 21 Feb 2020 12:50:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/21/20 12:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.6 release.
> There are 399 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
>

Compiled and booted on test system. No dmesg regressions.

thanks,
-- Shuah
