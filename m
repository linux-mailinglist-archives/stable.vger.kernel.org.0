Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD6B552F03
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 11:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347196AbiFUJme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 05:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349197AbiFUJmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 05:42:33 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C8727B05;
        Tue, 21 Jun 2022 02:42:32 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id p6-20020a05600c1d8600b0039c630b8d96so7453174wms.1;
        Tue, 21 Jun 2022 02:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=btc86v5TQcy90uuk1N9RpScCFkueM16jNpK6mhRNLV8=;
        b=TJjVB1tvi62vYwE3ABDpeBd8DSuQyCAiJvOmUkIYsiQEWGhVg0icd4dT2tpq+YAE8y
         /3fqW1NuGA9UNssp/OPip8a1EOB+6JBhXeCiJOjX2hLsigqKtvJD/4pVsI66lJotIUID
         kE2DJICiXrby5lR4pP8d81S8TLqqTyGeTkjRhYiQvMxoDUkEewuNeACt37tgMYnRvQ35
         BCvJo6hoNRoRqhVh6OyX/A39hpuPMqPgQ/Ah822BMz0cNa87KTrvC3PPnWvbBf1eLDSL
         uEu8UVl0IUyjL052uV2zzI3LD6pQNLCobh5HHLGFsfg5ZmngQJ9ZfMFwYPcvJ208j96C
         3GGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=btc86v5TQcy90uuk1N9RpScCFkueM16jNpK6mhRNLV8=;
        b=78sa2YOFNBRR4jHOCsPOfrdy62a6/5NB1Pa3tBlNo/RKCvYd2aLoEXntgch4BhAqrJ
         rgbEGMVHh2eZRECVFzTJvr6SkSQlggG2Qg022TdOCaQDA+ZyP1SG8AxJ/xmrwcszl2ua
         USbYBp4gziaivb5DjRX6+HrtiIY9P1B36QPRCj1JI5gAepvgsspszFrSGQ55Pxmb40Jw
         72ODKkGDtQKLo1LMIdl12Udfg1FPCw+E+3RGQxF32PzEJxQj/Fypyar9atra0Lhr6ixC
         +kWTebYuJ0oSf/DjlNfx3vK2Jh5hToUpY0dePYT2VUc67xOPzZDORRUkTRC7HgUP1Hsy
         cSdg==
X-Gm-Message-State: AOAM532P3F0xiGUzFZ8YdKTNXhibBy5d1skTIb4uKKDlYevE68E95Jgm
        NBKzYYFO0tBR8EmbH/sNFWw=
X-Google-Smtp-Source: ABdhPJxkxVFFpJf9pN2TvA8AAGNm0J3lETq+GdXcA6hLRf+ijBNIkRFpJkbmwJYydJDhJXowzc0skQ==
X-Received: by 2002:a05:600c:3b05:b0:397:54ce:896 with SMTP id m5-20020a05600c3b0500b0039754ce0896mr39311303wms.3.1655804550662;
        Tue, 21 Jun 2022 02:42:30 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id h15-20020a5d504f000000b0021b8a78fba3sm7553816wrt.95.2022.06.21.02.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 02:42:30 -0700 (PDT)
Date:   Tue, 21 Jun 2022 10:42:28 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/141] 5.18.6-rc1 review
Message-ID: <YrGShIQL+iwGuQ2b@debian>
References: <20220620124729.509745706@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jun 20, 2022 at 02:48:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.6 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220612):
mips: 59 configs -> no failure
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
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
mips: Booted on ci20 board. No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1363
[2]. https://openqa.qa.codethink.co.uk/tests/1368


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

