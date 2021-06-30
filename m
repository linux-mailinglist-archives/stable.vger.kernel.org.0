Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9563B825E
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 14:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbhF3MsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 08:48:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234455AbhF3MsS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 08:48:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA2BD61414;
        Wed, 30 Jun 2021 12:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625057149;
        bh=j2BZKL4pPCi2IT7cwbVz9DbsLgjpljgAdJT/aeMyyI8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nUfPdopo8jjoBWFCoOxQwtakkeJoXnj+bNMe9XYHsExS1PdPZbVbcx5579fhNyIkg
         UJpEHTs+do7Sd+CuNS6oweamV9eaNO5eWLtzx3MIBqducDy4bXyXCmnVV3fFmOZNaP
         sQBPx2G7TlCjbVUoVHZJCFNJmTQDtI1B4UL884Qj8RPhj+atiLSeYRe4Mq0dA2Kc+D
         hz90LouHUkj8oGquAEm8LQKhJFXTpaPklLEDkB15JFjdnD5S501CUj7MejvXr02bZx
         2zg7lvyKVBnZ5okdmRS/HpJW+TxcZQCIeMF1fjzz8x0Q/ArKbB2Bh2om+0LtG6u4aq
         kSqqhyAJKxb4A==
Date:   Wed, 30 Jun 2021 08:45:48 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.12 000/110] 5.12.14-rc1 review
Message-ID: <YNxnfF6uWpFU9Eh2@sashalap>
References: <20210628141828.31757-1-sashal@kernel.org>
 <20210629182102.GG2842065@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210629182102.GG2842065@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 29, 2021 at 11:21:02AM -0700, Guenter Roeck wrote:
>On Mon, Jun 28, 2021 at 10:16:38AM -0400, Sasha Levin wrote:
>>
>> This is the start of the stable review cycle for the 5.12.14 release.
>> There are 110 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed 30 Jun 2021 02:18:05 PM UTC.
>> Anything received after that time might be too late.
>>
>
>Build results:
>	total: 151 pass: 151 fail: 0
>Qemu test results:
>	total: 462 pass: 462 fail: 0
>
>Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing all of the kernels Guenter!

-- 
Thanks,
Sasha
