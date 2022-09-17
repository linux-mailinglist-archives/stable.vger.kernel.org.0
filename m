Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85F45BB8C1
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 16:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiIQO3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 10:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiIQO3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 10:29:13 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D02933A38;
        Sat, 17 Sep 2022 07:29:12 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id c11so40333203wrp.11;
        Sat, 17 Sep 2022 07:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=PIym3/kOVXqn2/v+kmu5Yo8JvA1EQnCMe6xfAguooJw=;
        b=mu1CFF8PwQlQUq0kS7pRD452maW7+3O1LDo9Arz4QISS5xb3bGPVD2ig+/hBuPb5QK
         QJt6bWt+9FTyTvQTOGlXp2Ho4QkiTbGkbz2Nf9oerpblb9G1E59ucbW52kC+jCdX+zrA
         XT2VzdzZd6aBDilSDrdS4d3Qbzmj1M3SRK8cDTEpBBahlcexo6M+XkjF13NrYc2CbFyA
         7u5tquTRUrmZVgZymW7ZclVW/+SciFfYp0nMgXjg3+Ky9+BFxPibgNqNAC4V3XJc2mw9
         dKj+WHpnvhKNHQQHxrKU4fEOnjGiEOjMT+1XXd2AhgyZ3o+L3nEnaxzEQoq24VV9IB49
         XsPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=PIym3/kOVXqn2/v+kmu5Yo8JvA1EQnCMe6xfAguooJw=;
        b=5R9b+EoOKRN82C4SWHV58avI7hQugC0kTVPEYUeGrihiftYYLG2b6TivOX1Ymkl8p4
         0SrCgSlSoXk5LC0bKRzfyBiaw9cllqMeOybcY5qTCSW7oS3jw+ZerASHYHT/TWEaAeaa
         A4jzDigs1y5cDIqvQBOXFtYAbXZ3Sm9AO2VKVsM/SY3LWtxySSHUFhPH/nz99guP0jNO
         uyt1Jbr/PU7WUJX4/uFT8+nG1mAjPybO1QqYfFBM+RJV5+q1pTWDoepZB1WevlpZ/B7g
         8zhu6bIk6DsNbXfgGekoY5sQV6Jb6tgPNopRkxj01NFMFFTb93TMkY5KdPCDQqnCoSrd
         9YjA==
X-Gm-Message-State: ACrzQf2l09nrT2snMN7zPQOd8yCr0WZ6ps0nZRpvsMNtkh+L7VVofvs5
        be/IGeANQNoLOPsaUot4DXc=
X-Google-Smtp-Source: AMsMyM7rCKh2hl9DutzpxY/d5ZMMWhwlXNKPPzowb+JEjrezKUFw0/ztWQehHMpmsm6UA4wOqwPgHA==
X-Received: by 2002:a5d:5591:0:b0:22a:e401:2052 with SMTP id i17-20020a5d5591000000b0022ae4012052mr3674828wrv.435.1663424951031;
        Sat, 17 Sep 2022 07:29:11 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id k128-20020a1ca186000000b003a5ffec0b91sm6119037wme.30.2022.09.17.07.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Sep 2022 07:29:10 -0700 (PDT)
Date:   Sat, 17 Sep 2022 15:29:08 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.19 00/38] 5.19.10-rc1 review
Message-ID: <YyXZtKyLqiay31Ko@debian>
References: <20220916100448.431016349@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916100448.431016349@linuxfoundation.org>
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

On Fri, Sep 16, 2022 at 12:08:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.10 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Sep 2022 10:04:31 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20220819):
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
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1846
[2]. https://openqa.qa.codethink.co.uk/tests/1849
[3]. https://openqa.qa.codethink.co.uk/tests/1851

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
