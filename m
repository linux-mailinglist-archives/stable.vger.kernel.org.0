Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F14D64B4AF
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 13:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbiLMMDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 07:03:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235203AbiLMMC4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 07:02:56 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7591164;
        Tue, 13 Dec 2022 04:02:53 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id ay8-20020a05600c1e0800b003d0808d2826so808608wmb.1;
        Tue, 13 Dec 2022 04:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6mFtsYasizY4EnEvFPGcZwDwtORvegty1UNGXXDdlcA=;
        b=aNB6GU0HK7lNhwrGNZxozn2hA5HH8ZpwCJiQD3sHUlLl7UQ/NlskbUp+6gvfzu+Zcq
         2fUK3Fm18A7zlZH20l5dprEveToDg4Zz6Wx2gfB/fmt1tLJ4kc0awDLhSc6ggZrnmSEt
         9ftM0VvqRI4CQAqJDanPcOqMEcJdVzItBYU0PQQOsXOK86eTEjzT2BZF8Ow5rOGjor5L
         4po2iPo7jqEkpv67a/AzTYHeV1HLSCD6AQ38gw+xNAan7sCEGegGDSzJfBBYlQQvo4wO
         UA5pFYR56WzG0zFCrYXNSKUqhayeAzVfEycucLHmvLkolkdLqKeeRF31+BfFsV6mQxiN
         hwgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6mFtsYasizY4EnEvFPGcZwDwtORvegty1UNGXXDdlcA=;
        b=LbJ+kOnGh55zfsZlfITRlcwB60/+55s0E+yNQpt+ejks54ZjiGjh+HQ+kKok/l6yB5
         zKvik1EXY/We809I1oNR6ma08U0esrltbQ5MJ+odLv7IfT57vyFuxByd3SRwKjiGbiHr
         Oj2cVGVwfk0iKvKnGUt5trZ6E1QqyeMtKjDCTTAiRlxoDq/bgs6S5J6Duz5wrNDWmSID
         Zw3UsmJlSdQAO4zpm5vPrT3jMD8Pe9KolHj0LR48INaer0QHnOKMA672rn0YdBhA4qHN
         1WORaF/B9jFjaOFsr7iTzG0qKA05N8DUtqnxb5FxF26gkQ5rAuVDSVnUbEYmmIIlbwyv
         EzDA==
X-Gm-Message-State: ANoB5pmtUN+B3Em2KEY6OneFHtUNWzD6tCbfosNs5IoO4nd2DlCl5VbO
        lL/abxXLy5UHCMsNOjGxTfM=
X-Google-Smtp-Source: AA0mqf57ul3/Zzp1LTiqvkWkaYPsQs/LREr1jt08JLo6fAl7aakenGYUskTQCdJ5PQwGSwDwFe+qJA==
X-Received: by 2002:a05:600c:4448:b0:3d2:813:138a with SMTP id v8-20020a05600c444800b003d20813138amr12934792wmn.35.1670932971854;
        Tue, 13 Dec 2022 04:02:51 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id i2-20020a1c5402000000b003c6c182bef9sm15335531wmb.36.2022.12.13.04.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 04:02:51 -0800 (PST)
Date:   Tue, 13 Dec 2022 12:02:49 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/67] 5.4.227-rc1 review
Message-ID: <Y5hp6RnTARlHT9YD@debian>
References: <20221212130917.599345531@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>
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

On Mon, Dec 12, 2022 at 02:16:35PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.227 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221127):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/2338


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
