Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB2458ECFA
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 15:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbiHJNUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 09:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbiHJNUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 09:20:21 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13E4E7A;
        Wed, 10 Aug 2022 06:20:19 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id q1-20020a05600c040100b003a52db97fffso973238wmb.4;
        Wed, 10 Aug 2022 06:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=HE2ABaeXgOXIHdiQidoO9aBme8JkrqivUwZbhXXLjvQ=;
        b=LQKSbPlqHBgBgBNlm1HPvnhADexuMqqahkzd4xmk68phuJOWJOGYQqZm8Pd1afZL8u
         0XbtYHXUBv2ZBfQCv+QvLRV8uUJJVKNOp+IHEMK/kfF7/zLvUiMXbClS7PLLGlfXC6hu
         ZPJtbsQUKlvWzCUkCCPXSq10kz87MK7hQQBAxV4asKfxiTbK3uTJPwYV/a+6TH7h3UY0
         Lv/UeKeoJXbcEAtzcYabpSZ0PgIsB/fdSHQVdL6KhHWLwqu9R3z2rTmGfks06B8lWt0E
         KDEz2HX1rW5ptU85sNtvO50KcR8Xcb0ieuq2uoSlpBcFbob3qcMKUv5A40macfWuHhbe
         jn6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=HE2ABaeXgOXIHdiQidoO9aBme8JkrqivUwZbhXXLjvQ=;
        b=TQagWwZ1bFFmZPyK0RiYRp19ZCZzm8+MpnHxNO4B5JnJvpj4df4cChPUKBaXqCldAR
         ndbSBe/gBZAnMhp23/OGrJ6XMuTwW1nzC2UsQw1vT7C5qj41Lq0iQ8lX22F88N3bunoH
         YK5SwjkOQEafYtLi7V3KI9IwMojZtCIbOBS8ATB4WHjC6KT8tAGNIj+I3KxD+DlhC25O
         E9ZoDAOsboSQ3/4gtI4x7a6pwWNOXym3kgLzWLMBnrICFuwzGEneQdH8Ew5itYYeLrgj
         tpqqyxih0c4ru7BDUOmqNHmb/d4XzqQe/HW9U5ET03BGlRqsbCO2132QnMXaiBGapevi
         tETw==
X-Gm-Message-State: ACgBeo3ku3OfKKVOKswyfO4B5YTXTPIG8S/om0IyH2XXespL9zd/le8A
        ft0rVm/ra/Li/HiUPOZ20HY=
X-Google-Smtp-Source: AA6agR58d9vqvn5BwpudfR4cQ2xe5c2i7Zkrc4O0dp6mpLn3ujXlRdSfaG8pik/baWg5fyU5XPZ1fw==
X-Received: by 2002:a1c:7508:0:b0:3a5:923:3994 with SMTP id o8-20020a1c7508000000b003a509233994mr2407751wmc.173.1660137618342;
        Wed, 10 Aug 2022 06:20:18 -0700 (PDT)
Received: from debian ([2405:201:8005:8149:e5c9:c0ac:4d82:e94b])
        by smtp.gmail.com with ESMTPSA id l27-20020a05600c1d1b00b003a319b67f64sm8916827wms.0.2022.08.10.06.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 06:20:17 -0700 (PDT)
Date:   Wed, 10 Aug 2022 14:20:07 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/15] 5.4.210-rc1 review
Message-ID: <YvOwh8Rz3t9FXehZ@debian>
References: <20220809175510.312431319@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809175510.312431319@linuxfoundation.org>
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
> This is the start of the stable review cycle for the 5.4.210 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220807):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1622


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
