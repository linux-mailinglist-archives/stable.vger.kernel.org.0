Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 119105BB8AB
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 16:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiIQOHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 10:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiIQOH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 10:07:29 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF782F388;
        Sat, 17 Sep 2022 07:07:27 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id t7so40252120wrm.10;
        Sat, 17 Sep 2022 07:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=HBhD/3Y3FZtAn1EX0FX5OyvA/53I5mO3MmIG7irpdTI=;
        b=O44aT8+T/5/UeEZ0skuUxyjaUHBecKl5T+OuXVYvl9EnBmm7PpCbu2Gkm0ZG8rIZhr
         u+eQcR1IEfIeCZQN/l8MpUrzboBD7YwHoHB288tw8EJT2rtN7dEsWaa5Sv96E65ZSpeF
         nooY+pvdCwVN5BNNxl/jbplFeLB8xzxwDeoMKoXkhKpXZpVg4D/2edsUSOrKe39UjWbu
         i6FGGGUtpDYXYstCostHUVubEHh0dZUSvkiv/6NuXES6jdOscYNxlJD0MBTG6lNitS8N
         ryPWPwpyFppBLDlSYlNRaTKrQ1iuafQKKtC2HjopSaENCOnwsNcduhe3C612vywjgSDv
         qE5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=HBhD/3Y3FZtAn1EX0FX5OyvA/53I5mO3MmIG7irpdTI=;
        b=6zcZhYum6k3Mwbwwbc/iXcOitdaRUPL0b8XJTmpOnWBAbTqt0ewFbrGI1erLSDjUNu
         CS4xTalAhl0a6Z+WSZ0GkKAZbdFMcBHBA5/DLMoD4gkpxwAiyNSyx0PrkhDqgiwn126F
         Cm6xNSMlUV+oqlK50GIaQnMJ7xccE8vOal/G5IScCTz81Tkr4mm2514coK3HXS81SEmg
         6xPGbeOjkTy+cRK/lL4q6Vgdk9l6uehiZL/QaMsSoXSTY4lz4r9pyog+DkMdC8s8ErNu
         bGXhwPpqb21nDXFET58Mm3xn3NbguWq2I8OFUNbFHg8GK6kh9D8FuoSQKcfKJ5f5YYMJ
         KUag==
X-Gm-Message-State: ACrzQf3+1S8U4N0RLVAJzjj/eRUXO/2y6HQnoGfDsFh4phQpub02W36y
        ZNbbc+qC9hOn4QY//y4MjTo=
X-Google-Smtp-Source: AMsMyM7F5OC8G5qChx7h01p6i1fo2dzMJyrUY2K/RcKfNCfy6JsNxPmQ6kqypmAZ86Pirtc7SzWoFA==
X-Received: by 2002:a05:6000:1048:b0:228:6898:aa50 with SMTP id c8-20020a056000104800b002286898aa50mr5684117wrx.233.1663423645929;
        Sat, 17 Sep 2022 07:07:25 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id j13-20020adfff8d000000b0022ae59d472esm2858694wrr.112.2022.09.17.07.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Sep 2022 07:07:25 -0700 (PDT)
Date:   Sat, 17 Sep 2022 15:07:23 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/24] 5.10.144-rc1 review
Message-ID: <YyXUmxeGXs72PrCf@debian>
References: <20220916100445.354452396@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916100445.354452396@linuxfoundation.org>
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

On Fri, Sep 16, 2022 at 12:08:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.144 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Sep 2022 10:04:31 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220819):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1844
[2]. https://openqa.qa.codethink.co.uk/tests/1847


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
