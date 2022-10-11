Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A85295FAA99
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 04:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiJKC1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 22:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJKC1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 22:27:41 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5ECC857F3
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 19:27:40 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id o2so548756qkk.10
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 19:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R0kZnhfesPl9qNaPTyscrmeO3Cgv6kK7ijXhflaJOE4=;
        b=mDm13BocLQVhzw+jM56VKsIkpaU2AlBUCzFy39mjbKP117HakVY163fK/NGsr67ld+
         e3oe0Ss6GH9wRb2FB/nPlpP8EBPcHQ9n9gzpXcjUbncvagOqaz3LOA7FSeIF1ydDeeVP
         ekOVnmXv5BXzUwShYLVyA4uC2SO311hJnk6TfpT3H6H3uohDOvANdZYCj1GADvpF+C3/
         zH5bbdkbrLN/26tUCDyDeoujhXfEUOkxQSrCPfkoy/L/mXElJC/VEXJnRhaqozuwABt2
         Fbj2i0tbJunPM20svB4PQaHSBUz4Ix72bsLS04tQS4ncWvyXUyUdKlJxacdiYMS19Ayy
         /1OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R0kZnhfesPl9qNaPTyscrmeO3Cgv6kK7ijXhflaJOE4=;
        b=ckT7bnXa5lW8SjKA25sQUwhMz/+E+IJSPChh+HPGhLiEbc6P+mhpfimPYNo9Ljaz1z
         LI27yDKhW2NF8Nz/F1H6HOcqLgNTMFFwlRptVrz3j3csnznyVnvB9rz4B9Fw9bMwMTNq
         jlfhT0sxZhHggd7eG8vfXprW2rwG/jFUrHJE8JhL0oEOXqGAIMxvnxfR8TAQvx8kmOtY
         O4vG1u9V7eyQOhC6JdcqV+xwQrgYdwaLQ3wDXhe1jEMJFy0o3wQESaBq69oZfgdZ0dqz
         r02FSoEh9rDqbpj2sVA0v3peZ6x95YpBso638ev1pomqr6xmHHYEcOVyjbnaacGwRfmA
         KEXQ==
X-Gm-Message-State: ACrzQf05/GOcSuAb1eIOPwNw85V3zI6OkRR+3z9s0YRalRPtbfkOyMHK
        0vnawiSyDldFIiv/hGC038brvQ==
X-Google-Smtp-Source: AMsMyM4Ba/uq7n2O8aHdGu9N/VomhCQ0H8a+eEyaCBPB35dfrS8nWOjaxc/NqUQzmgzxPcfCAsnQ+A==
X-Received: by 2002:a05:620a:46aa:b0:6ee:80c5:4246 with SMTP id bq42-20020a05620a46aa00b006ee80c54246mr150056qkb.87.1665455259884;
        Mon, 10 Oct 2022 19:27:39 -0700 (PDT)
Received: from sladewatkins.net (pool-108-4-135-94.albyny.fios.verizon.net. [108.4.135.94])
        by smtp.gmail.com with ESMTPSA id fg27-20020a05622a581b00b00399ad646794sm4362034qtb.41.2022.10.10.19.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 19:27:39 -0700 (PDT)
Date:   Mon, 10 Oct 2022 22:27:37 -0400
From:   Slade Watkins <srw@sladewatkins.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 5.19 00/46] 5.19.15-rc2 review
Message-ID: <Y0TUmfzCm1mGKeac@sladewatkins.net>
References: <20221010191212.200768859@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010191212.200768859@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 10, 2022 at 09:12:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.15 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 19:12:02 +0000.
> Anything received after that time might be too late.

5.19.15-rc2 compiled and booted on my x86_64 test system. No errors or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Thanks,
-srw
