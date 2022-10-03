Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D24E5F3517
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 20:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiJCR75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 13:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiJCR7L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 13:59:11 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D8F40BEE;
        Mon,  3 Oct 2022 10:58:45 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id x6so5078470pll.11;
        Mon, 03 Oct 2022 10:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=cx0JfgSyaiKd3LYZzcrQDUuWThTZxeMNkTxSZGlTdzE=;
        b=B9yEmnbkwgOn4zkLFk49Hh7XboTzGXBxLkobFKVsUniwOxWf8djlIR/FzJwVoIaTnP
         kvb7ScChkbdBrG5fA1+Ti2FjhKWCw9qAn4xut2Jhm//psidNwphj67PT71EZ0ZDcmWgO
         rQLZvcoVMgB0TNaaDyflkDKR5Z6U9Bs+Ay/7OfrI6e6aTc65Sf/Y8jm3mfMpRUwlCtvx
         pY+AgyhyAJ2UFSoS13P1mo8P7s+fedK+d42KC1IprOLZaiZA9DUDpwralppgF+/zKBGZ
         tNhU6gx0KVMKNVkT7C8t0D6uTqKM0OPd3yVXHBhOXFNYUa2egB5PCKdDyKhUoQxCciAa
         xD0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=cx0JfgSyaiKd3LYZzcrQDUuWThTZxeMNkTxSZGlTdzE=;
        b=ssvW5kKk0C0Awq6nE0XuiOupQW/tGIeUEUhcSdnUXZjsMSnHEi1ydJXnDVG5kthFmp
         JdjeuG/Bhqyc3MKsz4BXsjFOYNJ2VGFJkcNIql44IRzEgwPCqlRsPUfHHnfPRRfHAsol
         7Fnh3etgzn1f8LazcyshvhWKoEhDaOxvXlCldLn6wsSVwZfpqkgPaMiVNDdTlcqdlb4T
         VKusd5zg4xjskuzjSg2GZxQ2cA43aJ+ZcZsMITURtoYn6G1HfCgfZOjcNWqKdSoLZA1e
         rNhhk7ghbyMi+AzJyuerAEQazUCAXdjbLFoG+pdqf+L9S0eyVrY5++mWZzmEFHArUQ1/
         t8Sg==
X-Gm-Message-State: ACrzQf0Q3g9cQUhBguigGBBJXDAvgBX5WTQktArxkEEZ7ydrgMyAc/XI
        1hvxSSIQwZ7JXNfKW3UVPuA=
X-Google-Smtp-Source: AMsMyM7FxIp564FD8PMqku6dbgg1OG06LJ2WWW3hhTFOcRVoH9FujL+ry7yW7PAUVnxK6iojSPc7LA==
X-Received: by 2002:a17:902:8bc1:b0:17a:a61:ce68 with SMTP id r1-20020a1709028bc100b0017a0a61ce68mr23026290plo.66.1664819925425;
        Mon, 03 Oct 2022 10:58:45 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d67-20020a623646000000b00545832dd969sm7870103pfa.145.2022.10.03.10.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 10:58:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 3 Oct 2022 10:58:42 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.4 00/30] 5.4.216-rc1 review
Message-ID: <20221003175842.GA1023056@roeck-us.net>
References: <20221003070716.269502440@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003070716.269502440@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 03, 2022 at 09:11:42AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.216 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 447 pass: 447 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
