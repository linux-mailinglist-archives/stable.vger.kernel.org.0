Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 596CA5BB8AF
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 16:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiIQOJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 10:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiIQOJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 10:09:42 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF3EA447;
        Sat, 17 Sep 2022 07:09:39 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id cc5so30464413wrb.6;
        Sat, 17 Sep 2022 07:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=pYbqr2aNSQFCJHmzjmksLP49N3LtXcB9vNHYigKSSVs=;
        b=HiqH78Kdk4LcaRNy0dm2QjIAS3gNnDqSywE3ziG0txsoTjDDkgQaLg1Wni2axMT0ue
         0Pk92kVVcyKRzowlwHScfIi2rnVqdDNYzc+MNtMx8hprCkDhYPnq2SDK0K5x3NXmywwM
         zVqWCOg3XmCtI6JjFouZhonYvmXa7lNwoANIkL06m61iEc+bAukmLHwM3wrJOxW+4zO0
         yHk+Oy0zK0RPTlYVS3pe1LuM8s4bu92BMOZ69NpMcyrCzrdO/qAN55Ul1VCFbMXr8nFO
         sbtzf/xFURLhj2v+Dl5ZhMrJM6Maxb1u/geLF/y3BbAaOa1lYiq1jWsoua2lMB30FtYh
         frvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=pYbqr2aNSQFCJHmzjmksLP49N3LtXcB9vNHYigKSSVs=;
        b=g+PM9iWCptMdUnljv9Xccq4ps27cgXYbguR+Usp89fx/lcKlk4V74tjNwuNL5DS3lN
         iiuNVDQ+OHgpJk2WQNRQEQzZGAzI0MM5PjR3rn7Lkwlg4n2P5Urim0IYtcZZbaSv7rf8
         nnqinldD/DHlfz9+O56n4b4P7m9ydisyslBtuEWW54pz7WrojwUnp+HbXeQuBvjCVtTA
         zTsdrTClDeNQxb+WX9b0JiXX+hQio+TXSMr2JAY5YMNoQHHAPk5T4wkvdBH+rcMuOBmo
         xIJFD+hdvxMfpe5O2kA6rAOImuterIw9va01UHZ2Eg68ifQLE0fEuuNXlMEVhKc9mJ9k
         dMGA==
X-Gm-Message-State: ACrzQf102nlHQOoeab12BzxB/x6aJ6sB52osBcpc2e4eQO2s0xIacD9X
        nekU7dF1UqTjKWnLD4naH2w=
X-Google-Smtp-Source: AMsMyM6C1cgsU+Wbq62GHr4yf2QxG2l5XT6+Y39IGB1UFy7mWTWEP8b4DnaeYvwv6FifXfaGbAPcbw==
X-Received: by 2002:a5d:540d:0:b0:22a:4069:1e3e with SMTP id g13-20020a5d540d000000b0022a40691e3emr5771318wrv.239.1663423778267;
        Sat, 17 Sep 2022 07:09:38 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id j15-20020a5d618f000000b0022af63bb6f2sm355570wru.113.2022.09.17.07.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Sep 2022 07:09:37 -0700 (PDT)
Date:   Sat, 17 Sep 2022 15:09:35 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/35] 5.15.69-rc1 review
Message-ID: <YyXVH7+avo0rxXT5@debian>
References: <20220916100446.916515275@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916100446.916515275@linuxfoundation.org>
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

On Fri, Sep 16, 2022 at 12:08:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.69 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Sep 2022 10:04:31 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20220819):
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
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1845
[2]. https://openqa.qa.codethink.co.uk/tests/1848
[3]. https://openqa.qa.codethink.co.uk/tests/1850

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
