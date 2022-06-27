Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85B955C7CE
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239179AbiF0RDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 13:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235544AbiF0RDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 13:03:10 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCF2635B;
        Mon, 27 Jun 2022 10:03:10 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id r1so8708125plo.10;
        Mon, 27 Jun 2022 10:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=rGfyA4qJjKKkXwIS/Jt9GkdBhguVFiA2hQLFBi775QI=;
        b=FaM85x3kT+wtUxWMOLGjkDy2YZ0Qkn4Qs3dt5XoQvzVK4sDYETLdmlJwVkIf0VBdU4
         8YYnmFA91S+hCFM5KnMZdB+F8eQAJuUH653ekROLMT5aSailee4MvUbHUAqZpMFLPeKe
         nms+ZxHcgKuYhQNDdT97L8ODD1VrVMGcVrVnjbwjHW707A3f61JIFEY7TROVBsrCBjOL
         ARI0cLW365TsI9WxzK+XJRs8YCoPohQqz/8Huqvjk8YH8KHN0HiEawGDuFATosbaJt5S
         lBW9O09q2S2B2Dep0fBM+y8+FdhOnar9YDkPofNQhnhrOBUKNv8IG/qBZ78lfKb/ho4W
         oLXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rGfyA4qJjKKkXwIS/Jt9GkdBhguVFiA2hQLFBi775QI=;
        b=xh/FvzsKJMY+g1//KC2it3YTslamPwMnIGufmWUzOuRLlYyPI+C/MILTS7DDOYUzis
         lnmG8Xmnkc5XyKICG6O8evv3VG8VVvI39pWMyTDLfgDZIcDShB9KBPSlKgesDaLaLQQv
         PhZBrgNLBAam3kGwcxOFlxIWF/2QihQe+LHHVGKotiIhfMztTFH5NuQYAQ9gxZAjhNRJ
         zrvcwj0cEa/mZ3s7r26MtGtu6VUBtZ+MY6v8TOgbsgKAoCJwmoxd4/KyETqFTfxOhMTl
         jHNn3x2i1H+wnOEKN11q2/Kh42wtrC0IEuln7ctOhb2cMgFzHd881V8LUopDF7uLP+gU
         mZuQ==
X-Gm-Message-State: AJIora/HP9+E5CssVTbyD8PAyRH4/XspeJETJkIMaoCxdu7veKhfvBxA
        F53WJ1AW46b0VmZ2vyn+QdI=
X-Google-Smtp-Source: AGRyM1t9pIr14VyXDTKGuIVCpHCRItGNMLxRYLx96NQ+JJJ3PaNL1PMwr1vbuvrDq2LS4khJiykQLg==
X-Received: by 2002:a17:903:22c7:b0:16a:7114:feb4 with SMTP id y7-20020a17090322c700b0016a7114feb4mr15432598plg.22.1656349389433;
        Mon, 27 Jun 2022 10:03:09 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w15-20020a1709029a8f00b0016a1c61c5f7sm7466424plp.71.2022.06.27.10.03.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 10:03:08 -0700 (PDT)
Message-ID: <6cd16364-f0cd-b3f3-248f-4b6d585d05ef@gmail.com>
Date:   Mon, 27 Jun 2022 10:03:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.4 57/60] modpost: fix section mismatch check for
 exported init/exit sections
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
References: <20220627111927.641837068@linuxfoundation.org>
 <20220627111929.368555413@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220627111929.368555413@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/27/22 04:22, Greg Kroah-Hartman wrote:
> From: Masahiro Yamada <masahiroy@kernel.org>
> 
> commit 28438794aba47a27e922857d27b31b74e8559143 upstream.
> 
> Since commit f02e8a6596b7 ("module: Sort exported symbols"),
> EXPORT_SYMBOL* is placed in the individual section ___ksymtab(_gpl)+<sym>
> (3 leading underscores instead of 2).
> 
> Since then, modpost cannot detect the bad combination of EXPORT_SYMBOL
> and __init/__exit.
> 
> Fix the .fromsec field.
> 
> Fixes: f02e8a6596b7 ("module: Sort exported symbols")
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This commit causes the following warning to show up on my kernel builds 
used for testing 5.4 stable candidates:

WARNING: vmlinux.o(___ksymtab+drm_fb_helper_modinit+0x0): Section 
mismatch in reference from the variable __ksymtab_drm_fb_helper_modinit 
to the function .init.text:drm_fb_helper_modinit()
The symbol drm_fb_helper_modinit is exported and annotated __init
Fix this by removing the __init annotation of drm_fb_helper_modinit or 
drop the export.

The kernel configuration to reproduce this is located here (this is 5.10 
but works in 5.4 as well):

https://gist.github.com/2c3e8edd5ceb089c8040db724073d941

Same applies to the 5.10, 5.15 and 5.18 stable queues FWIW.
-- 
Florian
