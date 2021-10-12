Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3127942AE98
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 23:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbhJLVSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 17:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbhJLVSy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 17:18:54 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFABC061570;
        Tue, 12 Oct 2021 14:16:52 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id w12-20020a056830410c00b0054e7ceecd88so1044131ott.2;
        Tue, 12 Oct 2021 14:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tpRHrhRHOYU9iuoKoCcZIq+nm1ewybzfrH6Qbry9P/0=;
        b=MAxv7SfM+N0xJcoHOn/225jtHOWJ/1DmZkahHvJipbvzWf05w0D5UNLLLUmFKoDObF
         AtdUWEE78aEanAYCuASXspKkxKWqM0lc2ZdA5sAi3/LnlszsdSEB5Ty7MrBYHbk4+M5L
         ro5iCAiOsd+az0W4ItR8OdUm4rZltrTQ2KE84I4xgF5Mpmmn3P/m12Iv+dNI1wJ9kMoT
         HlKa9TptCsh4aD0Oq2N7c1u7RxQJDzn8tIVWADShNv/wkgt/Sm5Hb5toued/YGXvAKIQ
         +AK3uevu2Ph3int/WC02KXDuL8OAvsy3mI+YxF3lEYszuLF0ml5xd4b3e6chfiPy6Z3g
         UnTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=tpRHrhRHOYU9iuoKoCcZIq+nm1ewybzfrH6Qbry9P/0=;
        b=4z/HUhkpy0Zpb2Uv8Tsh2SXxFK6+43kxZd1xvjjoeVjjNWnK1sgm72U93yRhpxKv2z
         NA5mtniNNEqnxQPCWatqUAVwTzHaqBV7hNSlMi1B5dNO1gzbIzPFluY5WVWyYDGZn7UG
         rzpsZvIvH9rle5igcoGrOqmB37nwbPu/43Zwo0281rYdyTWa9xRoNvRVyeDJ7PYeOG/k
         qPkM5jdWbuzkZliGiG9gPj0sxsoCUKANAkfnaS5DLVuF2B6h+PLLxTorEsJRAkpjxyLk
         KtSxBzY3Qj3ckOCCPF7TULvaho0Yw2tePT5uvUte/xiYpwsJ2mmYekyvEPpprt9o7hO2
         xKxg==
X-Gm-Message-State: AOAM530mM5uew2LrqSBYUTd/cNKjC6GktkLPcJOg3unFa+cK3ZWxDIX/
        3k+T+Ez17UHelHPJjDJXxebRLoAw+S8=
X-Google-Smtp-Source: ABdhPJw1tQ6AYuGJu4KLnO0AwfFgOxJJglzxQgovqFJ3EqD5kjBeGKy3jYxJOTAKdBxQ+th1h1BhJQ==
X-Received: by 2002:a05:6830:95:: with SMTP id a21mr28675325oto.43.1634073411858;
        Tue, 12 Oct 2021 14:16:51 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o16sm2257525oor.41.2021.10.12.14.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 14:16:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 12 Oct 2021 14:16:49 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/27] 4.19.211-rc3 review
Message-ID: <20211012211649.GA646065@roeck-us.net>
References: <20211012093340.313468813@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012093340.313468813@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 12, 2021 at 11:36:57AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.211 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Oct 2021 09:33:32 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 439 pass: 439 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
