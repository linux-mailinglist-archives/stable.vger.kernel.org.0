Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5078E646C10
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 10:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbiLHJm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 04:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbiLHJm4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 04:42:56 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910DD5B85A;
        Thu,  8 Dec 2022 01:42:55 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id q7so930437wrr.8;
        Thu, 08 Dec 2022 01:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ssjl6nNbYIcMMvWXmfrSrcrvUMoKlpyQqbaApupR4d0=;
        b=okzDRwtvM7IxGFEPge95DAbqjdbg27DWzn3nf71+0EVULGdDD8pryn/Okzv8o7UiIt
         qK5SyIwrjS31tUf1olehlOnRJDLgG6qSZeEeVe0tzeCw+J1SrFmhEUIPoMSy5V/pKRyX
         ez4uwOQNWOLOn2lR3yZYgv+0teCr5zeABSvkO705CQxIHKewtHAeFpEM6Ya8an4TaxyR
         p/EbPPs7WfpsI2PzYVRiu++teTkQLPUo1j3uSPJMF9C1qSYqF58bJX2qqSUcq6limjm2
         nNL9ZIzWKcbfuP8fnbUxfrVekeY8fSuUFSEmExPF+jWFRsIHC+1aOatyUMBu5c96ulp/
         hxQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ssjl6nNbYIcMMvWXmfrSrcrvUMoKlpyQqbaApupR4d0=;
        b=8CfjuFhWhyuV/hv8lr0KO1oYdp6JTTWLj0C24em5AS43d1LXP0Xlq+Rquo0jprYy/0
         Rr1c9parqwZamW+BRRlvHQKkWZPlKEiCFIoRx95+rnotfKQq1jUayolwW07md1+FdKdh
         7cQwd+952sxADatqGqLvXapDXlM5LEoZZbo39w8mjypNlm7mUMzLtLF1G9IycC5puh+2
         GdOroEbaisqWlLmkJFYe6HK8879xCtxCqa9steit0idyjsd3baolVRvHJLevn6dVWoEF
         +tf933zXF3sPr+a8AwSZo2HED9TXseAIH9/B70ZdQ2MmemMQDgZa5PuCxNuDGecRi5DH
         cIkg==
X-Gm-Message-State: ANoB5pmUz3bNhLN7L+N9O1JvLf4TPoaNzKcI032GQt4eQr2i2DAqWVC+
        y1nfI9wECr1KG6UKpQjany0=
X-Google-Smtp-Source: AA0mqf6B+DLCqcsYtcnrYTBrUMfA1faDYe6r9sZqr1+4KOT+ygAkmvcEGWWMs8y/QsIZOXH4CpOKZA==
X-Received: by 2002:a05:6000:1004:b0:242:9e3:72b8 with SMTP id a4-20020a056000100400b0024209e372b8mr1156829wrx.31.1670492574076;
        Thu, 08 Dec 2022 01:42:54 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id bq8-20020a5d5a08000000b002302dc43d77sm11753479wrb.115.2022.12.08.01.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 01:42:53 -0800 (PST)
Date:   Thu, 8 Dec 2022 09:42:51 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/157] 5.4.226-rc2 review
Message-ID: <Y5Gxm5M607FW7+ug@debian>
References: <20221206124054.310184563@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206124054.310184563@linuxfoundation.org>
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

On Tue, Dec 06, 2022 at 01:42:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.226 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/2312


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
