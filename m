Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939C958ED05
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 15:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbiHJNWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 09:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbiHJNW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 09:22:29 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41B8245;
        Wed, 10 Aug 2022 06:22:28 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id ay12so4975096wmb.1;
        Wed, 10 Aug 2022 06:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=K63ZqEflkKlHTjrE9821DuVo5tu42pOb0LECm60UMOs=;
        b=I7skc4jMkGwwslJWVtNslWOS/iXCsgjz/gM8Bn2vnAnhVKRiJ5Y5ggqRC8NmrdM4TH
         no4igQRZZLoPjcXhUI7VvN8wfmr8f2MHdq7CmzTzMqmJJnILH+JIukLfoXHwfn+WfQU6
         LeNnvZjuacN9WC750cdNnLjHy4N+1Mua+N55a8UJhGI6mwf6y97eMaICtDtb1g+dkMqn
         GY+pyHGe5Hfz6T4sqn02Q/ZX6eU44OVemTz+CCuGvFuxAz3vT4cNvLcAA4GwBX4EGpNY
         5eGTFZ4iYJ6BckWWJwIkSna1UZfOFvkMo3yFmE/EaumKyDSVpZpv0BS3B+8p6in/QyPI
         LHHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=K63ZqEflkKlHTjrE9821DuVo5tu42pOb0LECm60UMOs=;
        b=NrIjgTlF35JCHymBHqxTq364lzuOnc3voDgEoZz79m8hF0kPEEm6q/eJUm5RUaqX1P
         l2bisNKvInuhkny87YDdyceFT65AreO5nZ825Qf3BCj7aJcu6BPAWkeY+CM1uwgeZrZ1
         PqzftLLtGIis8NlXaLKgb7A4HxQHKGqs2lGu2YJUhGKUTx2TqdVFdGIHtXOu7J7IuopV
         SHVaj+zmoYguweytyTEf0NhoXwrJZBrku08yVFUCo3eGIsgsMx5ryxzay7zu3l3qAIv+
         tSNHOPkHjrVs64Fe/m+PlKCvVj9jbAlSWD/trkDJwVMEpJiw1uj7ER0ouzLjTAP7ghms
         48Gw==
X-Gm-Message-State: ACgBeo1jpB31Kso3MguEBid0d/WKFaYt+s8SVtmZBcW+naSRdGHRATqU
        Wzg1LMgXRp3rW1I0Z57Ul1k=
X-Google-Smtp-Source: AA6agR58igy2RDlStj+pSzD7fSnafgPftynLcrKVb9EHpUs9Oi4TxvD8EIMfvHVx557ZDAj4GnRCYQ==
X-Received: by 2002:a05:600c:3495:b0:3a4:e323:9edd with SMTP id a21-20020a05600c349500b003a4e3239eddmr2472046wmq.104.1660137747251;
        Wed, 10 Aug 2022 06:22:27 -0700 (PDT)
Received: from debian ([2405:201:8005:8149:e5c9:c0ac:4d82:e94b])
        by smtp.gmail.com with ESMTPSA id bq4-20020a5d5a04000000b002206ba7430bsm17342050wrb.15.2022.08.10.06.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 06:22:26 -0700 (PDT)
Date:   Wed, 10 Aug 2022 14:22:16 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/23] 5.10.136-rc1 review
Message-ID: <YvOxCEKN1BsFxDjz@debian>
References: <20220809175512.853274191@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809175512.853274191@linuxfoundation.org>
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

On Tue, Aug 09, 2022 at 08:00:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.136 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220807):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1618
[2]. https://openqa.qa.codethink.co.uk/tests/1623


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
