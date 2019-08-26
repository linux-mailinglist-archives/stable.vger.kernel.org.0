Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 817AB9D8C0
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 23:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbfHZV4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 17:56:33 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:34120 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbfHZV4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 17:56:33 -0400
Received: by mail-pf1-f169.google.com with SMTP id b24so12696936pfp.1
        for <stable@vger.kernel.org>; Mon, 26 Aug 2019 14:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OsBdZ0KujVOBIt7JWvPS4ivMZTD8ZY3RV0eYVNAjbXk=;
        b=BbxdB/bOUjZcaLHyIfAnDLQiZhw9ayf5S7/Eutgp6CqwdVFQjVsXCASKKd5MiUzqBs
         hpMVVVO+3qpoSx0Qbk+I4mbNkfj1Wy1t57R8yU4v3Rf/klwlEfVcsQqT2cE8My9bnxaU
         fRl4LJFp+XtipDOQKNvNm6EhvPRc4zSlh6oAihLdZfUt7RPsX3QWUlzdiGLtZkewknMJ
         caIhHfqzl9T/dWIEMkCl2maqRI5sG0ARBN3w9OwcvPxb0YDvhKuqmez7DmHK/so0sEe4
         ykxtYpMP1cZ0DJDoWBHhhAfsf2MuDVTA1faLMlY1+zL9AurD0X0mVIgPc4aATtcHKPXU
         dxiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OsBdZ0KujVOBIt7JWvPS4ivMZTD8ZY3RV0eYVNAjbXk=;
        b=RfFnyUpV92qRozLta332dVQrjjb2ZEJvnQtHJFRrmkfqE404Jx6yPktF1gtKFnT57a
         vJ2Bl6yV8Yte53hoQZr4w0FBdtJFXsKQmXJBpUy26qfwMHAGpR1HnJoBO2RA/l2Hpba6
         ivxYXYNJrNTkBs000BLAlrzt9tYVJ9Ata7mA4A3zMJeE/mLblAoXPHiHvjjJT9+q51qd
         +CPp8CELuKqv6sKhUvmg0sEsJsDmvAa1ISp2UVj18wTiuTlAs0vgIfUf0hjUDDY+frBE
         6Y3GblZecpmBbvhCry/1TJL20HXN5RkuOjHccIXt14/oxhJ/Ck1x25E1ddYGaOOJCv+3
         k0JA==
X-Gm-Message-State: APjAAAVs0tro8gAopHNxk/Insjqfh4Av2pVsmv+atN/ib7ZE31qcKGfw
        ic5GAjrOyOpHOEpqm7icgZ67EQH/xumF+w==
X-Google-Smtp-Source: APXvYqzWsEeZohce9RUcUDFuCYECe4YuA/OypW3axpEYJbgTNJ3xzVwMJHeM5Wlv1XMUsJ9A9OvOFQ==
X-Received: by 2002:a17:90a:c588:: with SMTP id l8mr22565510pjt.57.1566856591811;
        Mon, 26 Aug 2019 14:56:31 -0700 (PDT)
Received: from [192.168.1.188] (66.29.164.166.static.utbb.net. [66.29.164.166])
        by smtp.gmail.com with ESMTPSA id h42sm407306pjb.24.2019.08.26.14.56.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 14:56:30 -0700 (PDT)
Subject: Re: fs/io_uring.c stable additions
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
References: <06ff6a5e-ecaa-ce53-5db0-6ff6e128c119@kernel.dk>
 <20190826214132.GM5281@sasha-vm>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b7419a63-cf1a-7618-0c77-c065aeb0c81e@kernel.dk>
Date:   Mon, 26 Aug 2019 15:56:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826214132.GM5281@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/26/19 3:41 PM, Sasha Levin wrote:
> On Mon, Aug 26, 2019 at 02:39:28PM -0600, Jens Axboe wrote:
>> Hi,
>>
>> Round two of this show, I forget to add these stable tags sometimes
>> apparently... Can you add these four to 5.2 stable? Again listed
>> in order of how they should be applied.
>>
>> a982eeb09b6030e567b8b815277c8c9197168040
> 
> This one seems to fix sqe links, which were only introduced in the 5.3
> merge window?

Ah yes indeed, you can disregard that one!

>> 500f9fbadef86466a435726192f4ca4df7d94236
>> a3a0e43fd77013819e4b6f55e37e0efe8e35d805
>> 08f5439f1df25a6cf6cf4c72cf6c13025599ce67
> 
> These 3 look okay, but I haven't queued them up as you were explicit
> with ordering instructions, and as I can't take the first one I'm
> playing it safe.

Thanks for checking, just these three is what we need for 5.2.

-- 
Jens Axboe

