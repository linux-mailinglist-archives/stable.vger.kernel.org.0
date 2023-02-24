Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9DC06A1B35
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 12:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjBXLPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 06:15:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjBXLPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 06:15:36 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD1739B8C;
        Fri, 24 Feb 2023 03:15:35 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id az36so1581437wmb.1;
        Fri, 24 Feb 2023 03:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0boVBTb7DoukQXQ50pLX7toWXVRfMvz+YuIAjUtNoB8=;
        b=VLJfQenKlJfF3VXqkE09W2mCmFGkwLCx1N1vROMbo7C2ZvELdPXIarWD3nwghVAGLs
         n4joDG1O99tGVZMvbtqf8ApkG2GjLd3KVz8M1N98Zb9U05YbAq9Z0L1UT4km0/yqSge1
         n9gXvMzk9v7uwuwlL7w7HUBDUAM4IN+6859GuwhPPDCrmOKEwk5ymulH1w/fiAJA5jrP
         iFiMlbSDwONs8Hg1L50hO/7TgRxSPsWE1LzuhdGcJQZ3pPuzR1GJvWkCfoCd5IUmqIH0
         jLvQNpihkQHxjHFNUKG4bjxwcE73pujC7RPrXPmJPmcBy0p4hcTa64mK8jymrBc8WABf
         o0HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0boVBTb7DoukQXQ50pLX7toWXVRfMvz+YuIAjUtNoB8=;
        b=xldN1jzqL1w1wN5xJa8k40Jk8l3NQ57WGVUp7qrxsX9fz8G/8NJ8hjxQlhz6zuHUP+
         ZUZapm9CjtX+wSnGfcO0g8i+w0Nnwil5E7Mj+WypNOaJ3YdIz1fsYAJTs14tXQxsGTfJ
         MwkuBsEB7Pke2frIBaU6rlq0TGtd1SAGj8tfkupRYUyqJvFyLT60JM+5bpUxnXtSIzPU
         7yiDQiqgrpHuLsKbmZnqFbJffQmYCzVtlXtvMWJGe9naYW0ST2eGio2M17nEMq3e5a9m
         oQhklOXn9iJ9V6vWEqdiaIxY6eK6fSWsrNq56g6EMyaP5P1XelcMqESzID06yZhjAZpW
         xRNA==
X-Gm-Message-State: AO0yUKVhpz6He8mVXJhMnLNVCTZKl+1KeRraAoH/aetyqXJieddfkH9U
        6+CetdNBX0HKGvhp7Ps5rRc=
X-Google-Smtp-Source: AK7set+3MyW1HIv+ADZHInPpjeEvm3w6Qnr1mDb8hUJY1kEvctlJGkCw/bAP3Ngy8hihKYZe2FEkAQ==
X-Received: by 2002:a05:600c:998:b0:3dc:5b88:e6dd with SMTP id w24-20020a05600c099800b003dc5b88e6ddmr12199715wmp.10.1677237333987;
        Fri, 24 Feb 2023 03:15:33 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id w2-20020a5d6802000000b002c55efa9cbesm12903925wru.39.2023.02.24.03.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 03:15:33 -0800 (PST)
Date:   Fri, 24 Feb 2023 11:15:32 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/19] 5.4.233-rc2 review
Message-ID: <Y/icVIHZ3SGogB1q@debian>
References: <20230223141539.591151658@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223141539.591151658@linuxfoundation.org>
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

On Thu, Feb 23, 2023 at 03:16:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.233 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230210):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2929


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
