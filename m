Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C8C5841FE
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 16:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbiG1OmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 10:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233007AbiG1OmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 10:42:00 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD2568DD7;
        Thu, 28 Jul 2022 07:41:17 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id d8so2458799wrp.6;
        Thu, 28 Jul 2022 07:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=aZFISERAvCB3NmFVS+M2rujlrdNM/5Xh+THD7cOT+5o=;
        b=EAnHLOIIav58uezzVkPExmYtGc1AoRmEfivX1X9sOpybdcryqE+WaAMN4p3MQPz7Mz
         8wo9TVgYt6NWurqFwQxzS3uJPJ8KmmbY20EI3MNmnelQ29BXtl4rtQ8y9Q3FpGJYX0Fs
         ccs6yNOnsSivklcKFW+Ne5gehpou5S/M5Hp6a6kueCFUTdlYgRE8NA6iq4hUQ+8k6vL4
         9QW/dPoYghsNn2Q/mC5CX/XnSN1BC+eyPnJmFOqFLf5yvdAMf3WnKRo+s0Q53s8uoF2/
         wt25NTAgwZRNVVhgVLvtF7tEQ00rbdd96MJxbmSk+huXM31zTflA6xurlgy11siXUvMD
         pGHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=aZFISERAvCB3NmFVS+M2rujlrdNM/5Xh+THD7cOT+5o=;
        b=3l1nOaRjVxULI+CGmK9N9aX9ZokKjOAzTFR/CODGcAw+ygSU2K9TpzW/KYKNfb/sGW
         zHG8xpNF3Typg8i2BEInEPixHOCf65qZghWDwRGYgABcqIlp5dhfAl+NiDIThnyFXMWl
         fWZbjVrOdS4sVJ/C6ZdNHcZmDyPhIEfX3/m3VVKy0EVWOeIVC896paZkvlkqDDkx/loc
         ySV+UCjVh0fyN6q+vmDUxwI/YmP2GGui4xQjCJhUtakSM+Du7/0z8bUoHVGHKbYMIc8+
         m5ztN3iszmPg7w5qZ+Fj8MnPxglbTV3RIa4PNO7zx/lenl6DkjQ8HaaEo6h/lNXqaket
         uedQ==
X-Gm-Message-State: AJIora/EIBUGYlJP2lcqVK3gEvTsnoAUH6aDyEPpJqcFpbWjWmXEM50b
        5ykJVJcyzNrncG09LdL3MBk=
X-Google-Smtp-Source: AGRyM1vrZox56aghHqqKhK3pXSHfUp4FyQ4hFF73KuJSVtMNOltczbTWNRZfn97gwD+MV7ErCEIamA==
X-Received: by 2002:adf:f94b:0:b0:21e:46fe:bcdb with SMTP id q11-20020adff94b000000b0021e46febcdbmr16645978wrr.143.1659019276279;
        Thu, 28 Jul 2022 07:41:16 -0700 (PDT)
Received: from debian ([2402:3a80:196b:933a:553c:d695:8a60:6d86])
        by smtp.gmail.com with ESMTPSA id d6-20020adff2c6000000b0021f0452eca6sm1075166wrp.107.2022.07.28.07.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 07:41:15 -0700 (PDT)
Date:   Thu, 28 Jul 2022 15:41:04 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/87] 5.4.208-rc1 review
Message-ID: <YuKgADNbdaY1orfy@debian>
References: <20220727161008.993711844@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727161008.993711844@linuxfoundation.org>
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

On Wed, Jul 27, 2022 at 06:09:53PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.208 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220724):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1571


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
