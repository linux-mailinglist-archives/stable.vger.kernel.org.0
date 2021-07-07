Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD8B3BE7F2
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 14:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhGGMbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 08:31:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231474AbhGGMbL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Jul 2021 08:31:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9263661C82;
        Wed,  7 Jul 2021 12:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625660911;
        bh=lD3dBJ+v8cGY30qLis9YjJwsKB+RlQzS2/JcSin5eyE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XOm/Omu/P3ZpDeDYcet1bu/rHPFQmGpGyKfamn46N2DqErZnIqfCnMSTn+x9G7CeK
         rTIDafeFwWd0vaiK4tR358e6mY7zucOk1aJZJu1KRQQM147Nu5HMB32ywhBnjbTdsq
         ClQPAabOG30ICws59RedW71/RmANO7ZhNrnwnUUB/cdB8bdhN06NnvsmFcqqfcy3C2
         IwznxKkCG9TpViz1LsyDihoKT/EvRkOUDKL+DI0K/qV8IrMIIp7g7aGaQHlFA342Sk
         wHhh4wFiqqC3gRxwuFNT60dT30BJyCvcOKLgGGImA9lVPIGFFpUntw5kT8wOLYXoO9
         fTEVxiYMa8g/Q==
Date:   Wed, 7 Jul 2021 08:28:30 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.10 0/7] 5.10.48-rc1 review
Message-ID: <YOWd7vNpijCXvnIV@sashalap>
References: <20210705105957.1513284-1-sashal@kernel.org>
 <20210705174333.GA7032@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210705174333.GA7032@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 05, 2021 at 07:43:34PM +0200, Pavel Machek wrote:
>Hi!
>
>> This is the start of the stable review cycle for the 5.10.48 release.
>> There are 7 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>
>CIP testing did not find any problems here:
>
>https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
>
>Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing Pavel!

-- 
Thanks,
Sasha
