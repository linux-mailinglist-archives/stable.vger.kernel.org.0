Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F7D637766
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 12:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiKXLRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 06:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiKXLRF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 06:17:05 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92F67D2A7;
        Thu, 24 Nov 2022 03:16:44 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 83-20020a1c0256000000b003d03017c6efso3013277wmc.4;
        Thu, 24 Nov 2022 03:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hhE3haZb45CNFULsHmxwy6vNCZW7lpy6GOVrdTfivPU=;
        b=a9W2owUCiWIJEl1zC8SQpHH6xMsKDPL6Zhomc9tVZyDc1RJPSLlEnSCj5e9zHhgxl+
         64x8vTJM9xRuDe9jbUmdmhR+1XeUwkJZMTgRt3PwC5lIv1AZqV0h7iGR9rzmstycsIXa
         B3aZZhkeK0K4qANLbOIoibhUS/WoOQLdXAv0nDHgkqrpstdpy9pkcG3zUj4NSQ41y/S2
         Y1HJ/+0Y1UJfp0wxxYcS9FQBxcIWu+1WdEDiDU3w9+AKZvUAqFrUZqaZjHqolTsrrlo2
         HSu0Lc54FOGorUS2iIpVEJbppZBeHxgZQKxqyjAuH/WbFwPdNpIDC1cnsNwIi4fWXXwY
         vhww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hhE3haZb45CNFULsHmxwy6vNCZW7lpy6GOVrdTfivPU=;
        b=V6F381ONCDan8o+TJQrWPku6O4zSoNcXb8ahLZDFeKVzaB1EfBY0IBcSFS5AmkG1xA
         IUwIE5Pc4wqeYHJv+jOR72nD3sZLQULQ/JGQA/dW0eGxwJyqwIeNkPQtIjw9qaxmWEoF
         5FTFXcmbgcCriOK9rcTuxt0Eh4mxbdz5tLJhg9+b1DJzTjWEwzaUaKe/8AGpb9ZZ+JeT
         7ImpRgMcDAKqN09bbtLN/uNiNOBnWNEnjWr4uCwoyEe5YMf01hSLrPt/Secz3tHPYQbI
         hINLpVwcld3Ru59ona3zu/i39JZYjF6ZYyqZqJnCL8bvzCzLG4PIJxEg+FmyRM5GQ2mb
         g0WQ==
X-Gm-Message-State: ANoB5plHsWF89LHge2HzSrnPrzAap7vaRfrgLy+LcDrAWWL1rQjkc4Ew
        /QScZA1TSpa+26tRGjEib78=
X-Google-Smtp-Source: AA0mqf4XBviurARzZqb6Yq7Pcs2grnbACeQWURwUcnvS+y6QDCrwTpM00ImOHe4vAL6jd5TymyL0pg==
X-Received: by 2002:a05:600c:4894:b0:3b4:91f1:da83 with SMTP id j20-20020a05600c489400b003b491f1da83mr12754098wmp.127.1669288603060;
        Thu, 24 Nov 2022 03:16:43 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id w16-20020a5d5450000000b00241db7deb57sm1057267wrv.114.2022.11.24.03.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 03:16:42 -0800 (PST)
Date:   Thu, 24 Nov 2022 11:16:40 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/314] 6.0.10-rc1 review
Message-ID: <Y39SmCRcY7EUhkhA@debian>
References: <20221123084625.457073469@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Nov 23, 2022 at 09:47:25AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.10 release.
> There are 314 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221016):
mips: 52 configs -> 1 failure
arm: 100 configs -> 2 failures
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> 1 failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Note:
1. As reported by others arm mips and powerpc allmodconfig fails with:
drivers/rtc/rtc-cmos.c:1299:13: error: 'rtc_wake_setup' defined but not used [-Werror=unused-function]
 1299 | static void rtc_wake_setup(struct device *dev)
      |             ^~~~~~~~~~~~~~


2. arm imxrt_defconfig fails with:

In file included from ./include/linux/bpf-cgroup.h:5,
                 from security/device_cgroup.c:8:
./include/linux/bpf.h:2310:20: error: static declaration of 'bpf_prog_inc_misses_counter' follows non-static declaration
 2310 | static inline void bpf_prog_inc_misses_counter(struct bpf_prog *prog)
      |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~
./include/linux/bpf.h:1970:14: note: previous declaration of 'bpf_prog_inc_misses_counter' with type 'void(struct bpf_prog *)'
 1970 | void notrace bpf_prog_inc_misses_counter(struct bpf_prog *prog);
      |              ^~~~~~~~~~~~~~~~~~~~~~~~~~~

Caused by a1ba348f5325 ("bpf: Prevent bpf program recursion for raw tracepoint probes").

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/2210
[2]. https://openqa.qa.codethink.co.uk/tests/2214
[3]. https://openqa.qa.codethink.co.uk/tests/2216

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
