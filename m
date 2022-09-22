Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE6B5E628B
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 14:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiIVMgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 08:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiIVMgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 08:36:01 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23601E723;
        Thu, 22 Sep 2022 05:36:00 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-324ec5a9e97so96885637b3.7;
        Thu, 22 Sep 2022 05:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Xyo63jPV0hrV+4ILfGWEvtGmdmXcqZr1Cu2x0MrjyVk=;
        b=q8D3YDmSMR+HlRkas5mekrnVkKVmEyq8sAdoityYt+vGWjOl7EOh1V1HI65W735HzM
         9KkxFqQFGz5lublh4Vfe+SyDUyMEl8Qr49mmc1sRdpK+qT4F7Zn4PTxuzAT+EG/Xqflg
         ZGjNpnW7x2mAYbd0XrY6HAwgDAP5zXqWH+2mIrdZjySRMxVLsRc/rD+LzUsUexsnBdks
         iteuTXqmsnf4FYOhAtgucux40Zh9j8iTiOnHSzO3zL709n9KFuIs+tNpHb//1PPHQ3Cb
         WryI29vh9pjsrCmwpGusmK5jgvwSczgDhCbepYMb0S+jmY+xqLmFlmKEjl1oyAe+9aGz
         be9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Xyo63jPV0hrV+4ILfGWEvtGmdmXcqZr1Cu2x0MrjyVk=;
        b=Kkpan3uxlcqQFFvzljOdoaM1B+9o3HOeM+es6bWtqDhF/cnkbFpQ/83cyQXGUhcj9t
         Xu2GXHysLB2w2GVcZJ5FWjIUeY6uHxj6JTHynahIYXQjfHtqGU+hV0cU5kg2RD/gLre9
         H58n5KOnnM6EW8MTliUB2wJCf1W0coxslOXJyfFIQL6SIjWcnM0fgOHRsy6Ft7MsOQJo
         Rva7Uu4vbmxOdmSWmcM3BPBhaYQdxuYL8GO/pk4jC1nEqiNqeYXHyQ0IRBoj0OGeN8Ah
         4Su3GKn/XfYCmswa40xi/1Y71r0hvHyIVN/DW+CyN9b9Z9RfVrbe4F8dyv+Xr5dC0zyy
         xETg==
X-Gm-Message-State: ACrzQf1GLuG+Gvd6M6MqTpCnVLpDaTOoBGD3RZPLJ8RZS7ajfbjgvgLy
        Mzfa+BL5qa3uqHiMFwJrDTSdD3+tCuPwibdcmL0=
X-Google-Smtp-Source: AMsMyM4tW+ZrxkWVzp7Xs6CFUloFOARLv7/3yhCL+PVEid7SEoIYg4jozeIXBfauq7ruE7Xlhpn2xwJj+S28vKtECE4=
X-Received: by 2002:a81:7058:0:b0:34d:a44f:2336 with SMTP id
 l85-20020a817058000000b0034da44f2336mr491794ywc.361.1663850160159; Thu, 22
 Sep 2022 05:36:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220921153646.931277075@linuxfoundation.org> <Yyw6es9RdujAwChq@debian>
In-Reply-To: <Yyw6es9RdujAwChq@debian>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Thu, 22 Sep 2022 13:35:24 +0100
Message-ID: <CADVatmMCmqXjo6_b-g3E=n6nXSftZ=49Q_OPvMOyGNCOKb0J=A@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/45] 5.15.70-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 11:35 AM Sudip Mukherjee (Codethink)
<sudipm.mukherjee@gmail.com> wrote:
>
> Hi Sudip,
>
> On Wed, Sep 21, 2022 at 05:45:50PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.70 release.
> > There are 45 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 23 Sep 2022 15:36:33 +0000.
> > Anything received after that time might be too late.
>
> Build test (gcc version 12.2.1 20220919):
> mips: 62 configs -> no failure
> arm: 99 configs -> no failure
> arm64: 3 configs -> 2 failures
> x86_64: 4 configs -> no failure
> alpha allmodconfig -> no failure
> csky allmodconfig -> no failure
> powerpc allmodconfig -> no failure
> riscv allmodconfig -> no failure
> s390 allmodconfig -> no failure
> xtensa allmodconfig -> no failure
>
> arm64 allmodconfig and rpi4 config have failed with the error: (fails with both gcc-12 and gcc-11).
>
> arch/arm64/kernel/kexec_image.c:136:23: error: 'kexec_kernel_verify_pe_sig' undeclared here (not in a function); did you mean 'arch_kexec_kernel_verify_sig'?
>   136 |         .verify_sig = kexec_kernel_verify_pe_sig,
>       |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~
>       |                       arch_kexec_kernel_verify_sig

Bisect pointed to 3a27b0950129 ("arm64: kexec_file: use more system
keyrings to verify kernel image signature").


-- 
Regards
Sudip
