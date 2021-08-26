Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1AD3F87F7
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 14:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbhHZMvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 08:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240886AbhHZMvO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 08:51:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D4F7610A4;
        Thu, 26 Aug 2021 12:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629982227;
        bh=wZF2URXmMYj+OWy2bGz2KXh6jnmg/W1C+egqPumy4dU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PbRl4o7ajauS6zz4dE0yjdUSeyKZnbyqyQ4+C8bGQ852C5E3BvgRJsRhqX2NQD9mY
         Yr+Mj3Ea90OVRm5HUp9Qa50CZNf4Nhq4ssPiDvwz67xwpDj5Sbzw7OeGrx8UAg9ipM
         PmyvPb4DWQ96VDINz76mFXon+O80XnJS/basm8L0OlyemZG/YdoKiSp6yRJZCtjGNu
         79NdhmwwGLt8ioGPZ14cJrqD2roqmvgH+629DRl+4n2miiLUbELOKSDI94W89tw00J
         Pmvu8GoG0i57IBPE6TIkFp9LfGjoxBjyTuo5TOC9R/vQnAf0X1WsjPDt3Yfq+gaqFM
         DGAN87uJsRB4w==
Date:   Thu, 26 Aug 2021 08:50:26 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.13 000/127] 5.13.13-rc1 review
Message-ID: <YSeOEvHwlRMJJsiJ@sashalap>
References: <20210824165607.709387-1-sashal@kernel.org>
 <1d26e6ba-29d1-15ce-093e-5cda076b76c7@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1d26e6ba-29d1-15ce-093e-5cda076b76c7@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 25, 2021 at 04:34:55PM -0600, Shuah Khan wrote:
>On 8/24/21 10:54 AM, Sasha Levin wrote:
>>
>>This is the start of the stable review cycle for the 5.13.13 release.
>>There are 127 patches in this series, all will be posted as a response
>>to this one.  If anyone has any issues with these being applied, please
>>let me know.
>>
>>Responses should be made by Thu 26 Aug 2021 04:55:18 PM UTC.
>>Anything received after that time might be too late.
>>
>>The whole patch series can be found in one patch at:
>>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.13.y&id2=v5.13.12
>>or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
>>and the diffstat can be found below.
>>
>>Thanks,
>>Sasha
>>
>
>Compiled and booted on my test system. No dmesg regressions.
>
>Tested-by: Shuah Khan <skhan@linuxfoundation.org>

Thanks for testing, Shuah!

-- 
Thanks,
Sasha
