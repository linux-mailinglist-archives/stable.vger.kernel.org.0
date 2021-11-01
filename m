Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBE544241B
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 00:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhKAXiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 19:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhKAXiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 19:38:15 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8865EC061714;
        Mon,  1 Nov 2021 16:35:41 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id x27-20020a9d459b000000b0055303520cc4so27533329ote.13;
        Mon, 01 Nov 2021 16:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eczd74ynSvvNO+3oN311R9sRaRLzkeL1ZGe6BSfvIx8=;
        b=YZ8ri2ssoZBslLLMd8E3SqNIwna7S2x3M8WbAPssw4UGiBWP6EvTOeCemgnCXwfBe5
         ZUCHjoIjl88xq7vK9S5jUTZ0nF+5Feo9TSTIizMLORI6nNjp8uwO+w8izd++pwmeZ0xg
         EAxp7dp/cQ3d4KzIqUEalAYWErRLsfOXTncmt/5HACGnf0yhfbtVJT8kRufe9UZbHRws
         4EbKHqLksaWaBUPUPY4pP8lrhvRkmmD59M6+vyO2CgY5irAVN/SeXm7UIAMs5fBFAwN4
         BWcnvBtSMd1i87hcIZI4CAZuP8QER4lK2Rl7xAsVY2nWykGDtnQwfgASQKRi7xkY01Zg
         LZbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=eczd74ynSvvNO+3oN311R9sRaRLzkeL1ZGe6BSfvIx8=;
        b=x6LAzKMHUSn9+2j11ILPG9yEBHylf5kSXiZXl5UD8DKF1Hgi+Jx6yJPUvYF1MpGpLo
         Ebz+PymanCo0e5OiK92zRZdFp+l+hjgwD2kOZvKoXAF/JFEjCtM3QAftc/JCG443ILd3
         ZWDRK/jEjbDNEh/1+rb5l4g/ovZfJLTSyZXqmfls89yslFyFdNUX513TezzEmTZR7S7F
         SXo/gh/GHwAem4mh3f6rJbcm8RHpqCGsz/vVUe3Mg74XkUrmCKB6yF1TnVpae+bUsPFT
         /Y1IUgAsTkAgu122qXaMjoORAIHPIYRk81hdsO4KGNGA79tk9jP6jghn37eieLaZDwzx
         6alQ==
X-Gm-Message-State: AOAM5325CZ3kLHUAU1znIikfQHwsQadi8NSVKTyCvy6zUmeXhyVXJrOm
        cq9kbal4oGwusf+dPiRuoT9eFPBRdSQ=
X-Google-Smtp-Source: ABdhPJzqN1snoBJBPU48DUAmwX2un8yVo/1FF3WLThDA2nx3qrIL0Sqm+oRr5i+UKziVfqr/regDqA==
X-Received: by 2002:a05:6830:237d:: with SMTP id r29mr23551860oth.190.1635809740988;
        Mon, 01 Nov 2021 16:35:40 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p21sm2720025oth.15.2021.11.01.16.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 16:35:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 1 Nov 2021 16:35:25 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/20] 4.9.289-rc1 review
Message-ID: <20211101233525.GB415203@roeck-us.net>
References: <20211101082444.133899096@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101082444.133899096@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 01, 2021 at 10:17:09AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.289 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 394 pass: 394 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
