Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB93C3BE7C6
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 14:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhGGM2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 08:28:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231537AbhGGM2A (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Jul 2021 08:28:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DD3C61C82;
        Wed,  7 Jul 2021 12:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625660718;
        bh=uGWuNbS1UqkrT7eCHB7t06PPRE7y+S/9XQQu9Cir6zs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QIj8mtGP5BWiRsouTpFWHr01y3DbevVpUAFi1sVpw3ecl296tJo01Wzn449zqsXUt
         MHKVzrfQzphOwACuAY3r/npm9P/dpuXW5kzUnyyv2GH8VAYjfLFyrONsHFFb7laUi+
         jRp8XUm6+uFxrwFPBoiZoZ+yveR7g+uneN+My+axchK7jAwHltM5WRihcE/QmGvyOn
         vwwUIxIycuWBEwsumBBRibSVrv+Zf37KkHCkD0mB1vF3+QA8SVVvxOGTmptORCi1+6
         U9uG/9XTlGDX+tExtWTPwujzv87AFX9k1CR1oP/1CDEHf1t2Ebo9pe/Nj4iCc//4cM
         RalTIpSHdfoEg==
Date:   Wed, 7 Jul 2021 08:25:17 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.13 0/2] 5.13.1-rc1 review
Message-ID: <YOWdLXUFrADxXQqX@sashalap>
References: <20210705105656.1512997-1-sashal@kernel.org>
 <20210705204020.GD3118687@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210705204020.GD3118687@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 05, 2021 at 01:40:20PM -0700, Guenter Roeck wrote:
>On Mon, Jul 05, 2021 at 06:56:54AM -0400, Sasha Levin wrote:
>>
>> This is the start of the stable review cycle for the 5.13.1 release.
>> There are 2 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed 07 Jul 2021 10:49:46 AM UTC.
>> Anything received after that time might be too late.
>>
>
>Build results:
>	total: 151 pass: 151 fail: 0
>Qemu test results:
>	total: 462 pass: 462 fail: 0
>
>Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing Guenter!

-- 
Thanks,
Sasha
