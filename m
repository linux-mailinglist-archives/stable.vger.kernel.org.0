Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A555ABE90
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 12:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiICKn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 06:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiICKn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 06:43:56 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8225F22D;
        Sat,  3 Sep 2022 03:43:55 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id v16so5187304wrm.8;
        Sat, 03 Sep 2022 03:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=lvszZfGmCXX8IrOggyhtAC+MmHjG2/LjQopHuFCOjn8=;
        b=dJYBM0EKFCzD/VWmoYP/V4rdN7gBcxNGojuuZL3kCieKVnGqPIO9RxTdTKiNbVGfjk
         SnxdOP1DYmP5ryigKEt10Xx3fmJL59x9e4vztJ8h/gbe1h+IBmc1WhbQT/87IUG737Uk
         36bNWkdpZpTXxWT4PMRw8DMkdUaxBqTDIOLvzj8N1ySpRde/cxbOlGxmyy33eK12oYFa
         Z/zwkVL231a9SskhHIa4Vk7CeR8HgTo3NO9WElgVMlEMYQkeujkJ9ty2hShKN/Qdpx5A
         DnQSher/Fwhp8U25WCk5h+hS2YECccdg+CdtCh9XbIBeqZM5mxyIa+UN2O4hZtkqyMx0
         uEzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=lvszZfGmCXX8IrOggyhtAC+MmHjG2/LjQopHuFCOjn8=;
        b=s77HpCAyjgy+4DLYU5hcKTfXJy1K+g04oX+KgNJyRriz96eRHFl6jBgx7s6JObyG7Z
         lWIrAFHoi/VTcnAFawRiJMRdmXYvcW1LZv/1Kyu8Gsrig0S5ku8T14XFujvMSlVN9BVh
         ltMSb3r6oPkUPT2cC94BgVyx3cj5Zr/3uf30W5mRQ3LbalFfOkT3p7ut7fmC4maLH9zH
         RijpmtSA/exa2nL4WSkdJSlD3Cr4BomF4JPYfAAsYFjQcucflkfR4/uugMQ4oG/CXK9l
         rsJ8Ic2qSM149tQAlCSSa2vBHsFt+IscpdASUdyw6ZIAfnQPACEfYysOxSvNRhdlnNk3
         4ndA==
X-Gm-Message-State: ACgBeo2otzYqPN1f6opBOqD520iEC+hfPTNa9FFcL8pxZo/l4rzT6cLX
        rAjniYtaJHEnIPb2rBrUao08dew45C8=
X-Google-Smtp-Source: AA6agR4TNSSU3j4i9cczSgvke2g/qY3bsCja8QZBqSRmA4lISs8pzw0fCGmSzah8Je+KHbdKRwI0aA==
X-Received: by 2002:a5d:6d03:0:b0:226:ea3d:eb35 with SMTP id e3-20020a5d6d03000000b00226ea3deb35mr10127509wrq.476.1662201833854;
        Sat, 03 Sep 2022 03:43:53 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id r11-20020a5d494b000000b002286231f479sm556661wrs.50.2022.09.03.03.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Sep 2022 03:43:53 -0700 (PDT)
Date:   Sat, 3 Sep 2022 11:43:51 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/37] 5.10.141-rc1 review
Message-ID: <YxMv5ziqECN8rqjI@debian>
References: <20220902121359.177846782@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902121359.177846782@linuxfoundation.org>
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

On Fri, Sep 02, 2022 at 02:19:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.141 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/1756
[2]. https://openqa.qa.codethink.co.uk/tests/1759


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
