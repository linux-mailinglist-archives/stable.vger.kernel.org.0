Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB686B5BF4
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 13:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjCKMra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 07:47:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjCKMr3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 07:47:29 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96DF611CBC1;
        Sat, 11 Mar 2023 04:47:27 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id l7-20020a05600c1d0700b003eb5e6d906bso5063442wms.5;
        Sat, 11 Mar 2023 04:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678538846;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JG+XDDsuS0ZSnVTC9Y0KL7M1HHk6RFW1/rF+Zc3EvoU=;
        b=Lk25gEEq+pGPmf7NgSfolMBtNmooCjRuWdWhl8XJOARRdE2hr/HJFxxnYIB4INAFJm
         +ZJfXopXL6VX21ZjBVvPOU1vJqQbpP6BNw98OSrnx5BKdsdCWMaWVaUaiSeiEEwjpEmC
         AIRPFl8MP8xgm/fCnZeowKYtzfahh8hLbi1WFRHzcxxBWFk3MvqViNhjVO5wi6XL32M9
         ZezRt+arpjqEKvnw7JKOOWFGmXBAQxkolWn7PwfdYQg2uMLlmPnFivWHdaTUUcEuGM68
         IJbOqED71Gt+wMZ5gS2n+GtYJ0k1N7B4eb+4Oqe4ePvIJnyTFB/o+dG9+i9ZYuOW6NNO
         iuoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678538846;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JG+XDDsuS0ZSnVTC9Y0KL7M1HHk6RFW1/rF+Zc3EvoU=;
        b=E+KCGUswRlTac/J4nnaAynt4t/NoyMhB2oj+AjL3LqT+xE/Hzl+Cnerc4Qm9JEq3U9
         aTN8Oqhwued9b1tGHyhzb6jb5odZPlYPR0AnaNvIfzYPLKa6OvoQF0ipS+7DrgOIUfZO
         IGTtC9cSbIjarngoxLFkawVxbuKhSDTqLgKlL26iSgWehyaEBN9kY5yIPq51/xatxkd7
         cZoyJ4y11k9PLLqYD8oaZJeGF1xA8CftOOBvJd5kB4LOaqDyO31t+HLeoTeETgYo7N70
         i/jdlHYMd6Xv3dIUlzS+7VwRyawH9cSGj42rVcnBVcuDZoJBLVYyIBw0lBwEOr5JzPpi
         gT2A==
X-Gm-Message-State: AO0yUKVggnxS6FRwfuYm5KnmiSeFsKZz/dSmOyC3nIYDQ4zmDkad8EN0
        mdyfneAoTINijqmj44D9XoI=
X-Google-Smtp-Source: AK7set9JSjHy6wHUEUe39Ir6qYIqFyQG3TiAh/Chj112lk3wx1xNetuk+R2dS8eYeGVyrF6BUVSkPA==
X-Received: by 2002:a05:600c:35c4:b0:3df:9858:c039 with SMTP id r4-20020a05600c35c400b003df9858c039mr3596885wmq.14.1678538846080;
        Sat, 11 Mar 2023 04:47:26 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id d12-20020a05600c3acc00b003e2052bad94sm2711439wms.33.2023.03.11.04.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 04:47:25 -0800 (PST)
Date:   Sat, 11 Mar 2023 12:47:24 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/136] 5.15.100-rc1 review
Message-ID: <ZAx4XI1QOYyHPA2K@debian>
References: <20230310133706.811226272@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Mar 10, 2023 at 02:42:02PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.100 release.
> There are 136 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230210):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Failed to boot on my test laptop.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

Note:
Failed to boot on my test laptop, just black screen.
Bisect pointed to 4eb6789f9177 ("drm/i915: Don't use BAR mappings for ring buffers with LLC")
which was added in v5.15.99. I failed to test v5.15.99 due to lack of time. :(


[1]. https://openqa.qa.codethink.co.uk/tests/3075
[2]. https://openqa.qa.codethink.co.uk/tests/3084

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
