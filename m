Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D830532122F
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 09:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbhBVIoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 03:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhBVIoC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 03:44:02 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5FAC061574
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 00:43:21 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id m1so13551886wml.2
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 00:43:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=yKej7T5kLmr+k2xw8VNYQ7x65jHObwyuBaPP/18rguY=;
        b=TLYWwz9fu8GhxUXjtGvMY435gTA6hEDoKZnVcMgHFD1XeTi1txWjYvhGJud4i4jgNe
         jy3VpefiG96DZAX+vEVW8HF72XStTnYpOpXH6HPTWO7UqH1jf/FBX1jIGCkpBrK0n2kq
         bYlelA+vj9yBkE/utWXbe8Q/IzNYhTTzGcWYHPNaKQPvVsmaYCTbiFBoTj1H4eBs+uJg
         Tl8d12jgB5gz3IHTDk/FdaMHBvnIbag4FkZ7lbTXcRz+oJt/MYNFnKGFEK4+8rzyVglr
         UmDYLqpmZJDinr/LuFhgaY6z6qhWTOWt8aio1/q4Puk30OoDGwlUp3pU7R0B7vBaPryj
         QuLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=yKej7T5kLmr+k2xw8VNYQ7x65jHObwyuBaPP/18rguY=;
        b=D7XA7GuDx2eEfNXUD78FsCdfUxShv00zq932U+yQ3bE9/FTneRg8pR+/dYglHBOWGN
         R9M9xlFI6xuN8u8n0NTdVAmI5xbhICmn8ZtoNZtocR/vsoivtuceUF+zJl9D3FkLViX8
         NfZjxIoAScBofh7Q9pxzzaqITi1eIJZKXq5uK2SoxdwnN5duqi2Apk6zkZ6dguRf8RHz
         EXR6xs+KNdA/td01qeaQsaGxKhzU1yPZ/krkzS1xNez7rWwwX7yl8YZ8OJLLimqFfbM2
         E3iUPGsVewQwTgD7/x6kkMN1Cbgdm/psUgB/fYO7TuuLefGCIFWdjjn5ZkCdHWtnpmwZ
         hwGg==
X-Gm-Message-State: AOAM531hDaj4C2dwUwQvqYkOeq8XAtoGa4dIe8ck6zkeH6gbcJwtU4dz
        iN6f0DOYzZ3MTzicAG8y8fo3MQ==
X-Google-Smtp-Source: ABdhPJzdQx3I1Pt+dLx/6sG5SGvAwsi61BkyKGVIOv7iGIEFRpm9SMNo5vDUTGkbe90nxcM8Xi6M4g==
X-Received: by 2002:a7b:c924:: with SMTP id h4mr2263891wml.67.1613983400254;
        Mon, 22 Feb 2021 00:43:20 -0800 (PST)
Received: from dell ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id o129sm25748334wme.21.2021.02.22.00.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 00:43:19 -0800 (PST)
Date:   Mon, 22 Feb 2021 08:43:18 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Zheng Yejian <zhengyejian1@huawei.com>
Cc:     stable@vger.kernel.org, judy.chenhui@huawei.com,
        zhangjinhao2@huawei.com, tglx@linutronix.de,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 4.4.257 0/1] Bugfix for ad4740ceccfb ("futex: Avoid
 violating the 10th rule of futex")
Message-ID: <20210222084318.GA163314@dell>
References: <20210222040618.2911498-1-zhengyejian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210222040618.2911498-1-zhengyejian1@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Feb 2021, Zheng Yejian wrote:

> *** BLURB HERE ***

You need to replace this place-holder with your own description of the
problem, how it's being solved and why this particular solution was
selected.

> Peter Zijlstra (1):
>   futex: Fix OWNER_DEAD fixup

To clarify, this *is* the right fix.  Thanks for taking the time.

>  kernel/futex.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

Reviewed-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
