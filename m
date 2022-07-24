Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C10C657F3EC
	for <lists+stable@lfdr.de>; Sun, 24 Jul 2022 10:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbiGXIGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jul 2022 04:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiGXIGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jul 2022 04:06:34 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538B1DF28;
        Sun, 24 Jul 2022 01:06:33 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id v13so4105868wru.12;
        Sun, 24 Jul 2022 01:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HRdU5JtuY9ef3rVZKjUZZjPh20tou+CtkwGg5+ahh00=;
        b=c6WfNPEv00bRY+G76Bisyk/YuLO3xl7eLE/joEw5OhmvD0Cgq12trBU3l5aMdASe7A
         g19qf3nDXKmRXFlOnWwK5iHyaPUlp6Pr3nF8Lr7SoV87M1F566tWH48QUDmScUUHIgpT
         tphPuwtrafZLiANVKIdENxb65B1I4Di5p/I3JkHEhA4d1YPItaIKSwQdwjeXJ+mAVYkb
         r2Ph+FbHUM+d7uRatncBJAfd+prsUhZwLDrSk0V4yVHo7hzX/TnMIh+X/rl+oe8/uM4i
         8BB8oIJymjCtP0Z25mSKb+ax1JpGCV1DEFlTxktzO+ruBQCKOd00rXnslhJChsdmR3yt
         9Njw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HRdU5JtuY9ef3rVZKjUZZjPh20tou+CtkwGg5+ahh00=;
        b=WcLepLiz6WAw2fquh2ciuX+XWkoTeiTnCRIVaE7oQWnaZ4WA2qK/+01lxf7jmCLVSo
         2K8TseAOLj7jIt0wocDfxYcvMJkSFd8vg9v/sC5PLWr7yGE5l5fCOnzz/YPsUaz4n5sa
         WirjW0w/GC1UgdxQjV1MeBsND/3kIEcu6eTetMqURks8OioFhodugnosuMhW0MTIm/H5
         n+n+3V9UhsDTSK2Imdji59nrDyjQqKSbL9AODs1K+xNpwMf4IA9/48QOwswmdKFLbiH1
         XOUirtHac+h4z7GPgOctEGHOnPLBGEUmQ4d1hVTI5o4YHj5HAQCh04AzrVyvTGt2V6N/
         QXQQ==
X-Gm-Message-State: AJIora+ApSO89gqIjAAGZOOuFxoTB1zczTVjftC8E80Ti2ujw2lodvVM
        uKhDYQyV5G+9LzcLqp2nVXQ=
X-Google-Smtp-Source: AGRyM1vpN+Wd+kw63oObUTEuMlgBYqIu9tMJiDj02N4d/FRk2koGW10bLMjoWMiP4xRM8B6JuBVGww==
X-Received: by 2002:a5d:6082:0:b0:21e:6bae:a4e8 with SMTP id w2-20020a5d6082000000b0021e6baea4e8mr4753761wrt.658.1658649991049;
        Sun, 24 Jul 2022 01:06:31 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id a21-20020a05600c349500b003a317ee3036sm10735976wmq.2.2022.07.24.01.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 01:06:30 -0700 (PDT)
Date:   Sun, 24 Jul 2022 09:06:28 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/148] 5.10.133-rc1 review
Message-ID: <Ytz9hLXOuoGSwHMc@debian>
References: <20220723095224.302504400@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
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

On Sat, Jul 23, 2022 at 11:53:32AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.133 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 25 Jul 2022 09:50:18 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220706):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1556
[2]. https://openqa.qa.codethink.co.uk/tests/1557


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
