Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEDD563187
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 12:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbiGAKhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 06:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234377AbiGAKhe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 06:37:34 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92F370E4E;
        Fri,  1 Jul 2022 03:37:33 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id v9so2577283wrp.7;
        Fri, 01 Jul 2022 03:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rccCJXuxAtqfnk+ScaILV7Ed8Efw6JIkPDPbqJTfyTk=;
        b=qJX/bsX1PGj5t8SiQEf3UWuVp2hpxsiI88G5s2qRNmKygOnAzQ0lvNsghcnxSheAVg
         98nRTDrRrAlcD//51XoZmHl8odihPYdEJlrZWhCE/+s1sIUHxE9JN/oSxxCVIgMHU+9M
         tUfNSH16iFezZXD4tXwfmA+0zZOeF+3CewJCQ0ypia2sMRpn6AVRQqWSJp3SPynahsWG
         jGDg3sMeBTGBixQ3lKVEXKJFsg7aYJ2/cS+mZrMlshII301mDRxuI6UUXU0FjNqs7fyZ
         jB/K8+LYrpdPq9llGCpudmt6f7BZIxngtrzqVeuWZJsBrBI/JjjYBZxjWPuAINBxWY3d
         Kvrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rccCJXuxAtqfnk+ScaILV7Ed8Efw6JIkPDPbqJTfyTk=;
        b=oSpJCzZhiIrQg3+OdeM/ctGe93PP+39WPhow8x7qtnbsfyzlnyoQqsju84yvUCQ+t6
         eR7ndN14XuTCZCtGAJ6DO6TK4tf9VJHktbKgnmW2S8VyA0wPXQCiZRCJ1AZ7SNanKoAY
         zSWRrcoepb3HP1aLpQeE1BVbPip0hFzoyUbM/7auPyQp2Y+8qeMzdUCabcKDrtVNY+HB
         mw8b+k8RD/3plM07zjKRnT05ET1ttBpZB4BvCa4swxvuvJTxZSLST0odtfYvIX9p/9Jt
         JC8QwHqeOKXzuS5rR0vzmJZAbTB/rnxlZimC0fnEcZS5EBFgzuPDn5epDiIS8H0C4hvU
         Ot+g==
X-Gm-Message-State: AJIora9mXctOY2EScqKIWvgv9q76x2BnJG9axVltfXmYSzoB4wXQKzuP
        56MeZCmU53G/8wGlm3VmUfA=
X-Google-Smtp-Source: AGRyM1uvCtABixT+QXXc45WKXxGEaNRhORLxMfKoRcy1igXVHIE8CsDFfgIhDro17j0EhpxTcUBwIQ==
X-Received: by 2002:a05:6000:cb:b0:21b:921f:9aba with SMTP id q11-20020a05600000cb00b0021b921f9abamr13282134wrx.554.1656671852291;
        Fri, 01 Jul 2022 03:37:32 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id r13-20020adfe68d000000b0021018642ff8sm23629462wrm.76.2022.07.01.03.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 03:37:31 -0700 (PDT)
Date:   Fri, 1 Jul 2022 11:37:29 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/16] 5.4.203-rc1 review
Message-ID: <Yr7Oabki2W2Qh7yo@debian>
References: <20220630133230.936488203@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630133230.936488203@linuxfoundation.org>
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

On Thu, Jun 30, 2022 at 03:46:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.203 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220627):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1422


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
