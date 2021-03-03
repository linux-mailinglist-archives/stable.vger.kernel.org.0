Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6493E32BC2D
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239545AbhCCNme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:42:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1582440AbhCCKVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 05:21:54 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E786AC08EDA0;
        Wed,  3 Mar 2021 02:18:35 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: gtucker)
        with ESMTPSA id 246B41F45B37
Subject: Re: [PATCH 5.10 000/657] 5.10.20-rc4 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210302192700.399054668@linuxfoundation.org>
From:   Guillaume Tucker <guillaume.tucker@collabora.com>
Message-ID: <d26f494c-4906-4ed4-e277-0c486e83e343@collabora.com>
Date:   Wed, 3 Mar 2021 10:18:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210302192700.399054668@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/03/2021 19:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.20 release.
> There are 657 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.20-rc4.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


No build errors seen on kernelci.org:

  https://kernelci.org/build/stable-rc/branch/linux-5.10.y/kernel/v5.10.19-658-g083cbba104d9/


No test regressions either:

  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/kernel/v5.10.19-658-g083cbba104d9/


Tested-by: "kernelci.org bot" <bot@kernelci.org>


Thanks,
Guillaume
