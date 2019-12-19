Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 229A6127161
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 00:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfLSXYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 18:24:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:59268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbfLSXYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 18:24:37 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20EC624676;
        Thu, 19 Dec 2019 23:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576797876;
        bh=K3CvbaB8eN/Eb3ZiDlzpb2f2O7TIhZPxnGG8BvCApZA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XAspA5fA3wS6cyzuttDwywfqalB85K4DEU1gYdSGJKg97fof11phNpx85w8Z6Rwc+
         mhpmUK7TrloulsZiMb/hnrx297BtyaM0DEwZVHp97YKu27zY2uQVJiHo/LLPws1Vay
         ll3fTOlmTdBw9u4lL/Lwt9f+viCPxQWQgBa9LnXU=
Date:   Thu, 19 Dec 2019 18:24:35 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-riscv@lists.infradead.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.4 316/350] int128: move __uint128_t compiler
 test to Kconfig
Message-ID: <20191219232435.GU17708@sasha-vm>
References: <20191210210735.9077-1-sashal@kernel.org>
 <20191210210735.9077-277-sashal@kernel.org>
 <CAKv+Gu-KLGFUEP55iGFp-irspwoG1uc0ZVPW15YDFX9MtXQW2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-KLGFUEP55iGFp-irspwoG1uc0ZVPW15YDFX9MtXQW2Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 10:07:54AM +0000, Ard Biesheuvel wrote:
>On Tue, 10 Dec 2019 at 22:13, Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Ard Biesheuvel <ardb@kernel.org>
>>
>> [ Upstream commit c12d3362a74bf0cd9e1d488918d40607b62a3104 ]
>>
>> In order to use 128-bit integer arithmetic in C code, the architecture
>> needs to have declared support for it by setting ARCH_SUPPORTS_INT128,
>> and it requires a version of the toolchain that supports this at build
>> time. This is why all existing tests for ARCH_SUPPORTS_INT128 also test
>> whether __SIZEOF_INT128__ is defined, since this is only the case for
>> compilers that can support 128-bit integers.
>>
>> Let's fold this additional test into the Kconfig declaration of
>> ARCH_SUPPORTS_INT128 so that we can also use the symbol in Makefiles,
>> e.g., to decide whether a certain object needs to be included in the
>> first place.
>>
>> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This does not fix a bug so no need to put it in -stable

Dropped, thanks!

-- 
Thanks,
Sasha
