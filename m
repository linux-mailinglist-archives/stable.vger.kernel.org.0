Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF536B5BB2
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 13:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbjCKMam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 07:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbjCKMah (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 07:30:37 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A47612EAF4;
        Sat, 11 Mar 2023 04:30:30 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id q16so7411977wrw.2;
        Sat, 11 Mar 2023 04:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678537829;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nq3jzIw8qkZj50nUFqJA+HWT5jSIOVCQw4lTHi9m3Bc=;
        b=h6q9u9/zO3jte1IqviUmbqs9N9F9u1cp5f+od9Y8m7bHli8iGco99KGT/45t4dswX1
         5IoIQI9/ldHnF1mgZ1ZJtHqQ4I89kw1O230cFg7Xl6OFGPSX5Tgx2YHGb1QRF7PEzRDR
         0lqg+jVaXFon+UmuR3sDGUtxM/CBYKEAYmYkECAWYgzEF9AyJUa4yU0XMS0xnSU4VcFh
         lc+L5CKiDD+ganVjwKWeAvXRzoZ724vZDdYJKv03JZYhXvo6KS5BmwxGttf2LM4jWaIy
         daj43/siLCjNxAdyaJhJMnMGuxvsBM9GzVsnfTnn8goap47/sABVOilWxNTOGl0WaqpR
         IpgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678537829;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nq3jzIw8qkZj50nUFqJA+HWT5jSIOVCQw4lTHi9m3Bc=;
        b=bipbnYicPy/vw7lGY5Amzm/KZglOtIhKoZNiRKBTIYD9xS8pOQ1KVfbhfG8QHLV8R0
         l1O2TBncK66P4p6j9IInjN29wz28Bh/V9/ep3sy9cnegqThXqda3iFxPZozWEKwWlKHZ
         989MJjblJdxvdcTVcghbSLE6OQCFscyH0Kv7ux5QT+kfs3IRYfAOOBo3olYk9/qfFcOX
         HlUnzK8o+2szbUbHOfNggEJ18k1LfwcvdzlJY1pJ0Ji5OaZAxIb8uG7bk6GgzxxJT9ga
         oansH91jV4H9B0zNxrxqwuSJ3fVorCfwnHqbxAMs1H6K8XGrI6n292/u/CSq32j9/z3z
         zBuQ==
X-Gm-Message-State: AO0yUKWkreCYW1Bv02I72i6j8RtE+Po0NTsD6hs9pYlybOoP3MnSExcp
        dkoye+Q2Mmz1Yd45gKHaLhQ=
X-Google-Smtp-Source: AK7set/Wm2JO+lDCe3EQc+1lsmGqsZMIdnfELXQOBWxZyCbHg9It0mLOCPu3VxdQaGu1qyBAL6M0Mw==
X-Received: by 2002:adf:dfc3:0:b0:2c5:5886:850d with SMTP id q3-20020adfdfc3000000b002c55886850dmr17335171wrn.5.1678537828789;
        Sat, 11 Mar 2023 04:30:28 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id j28-20020a5d6e5c000000b002c551f7d452sm2239782wrz.98.2023.03.11.04.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 04:30:28 -0800 (PST)
Date:   Sat, 11 Mar 2023 12:30:26 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/211] 6.2.4-rc1 review
Message-ID: <ZAx0YrXQ8KpmDxRU@debian>
References: <20230310133718.689332661@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Mar 10, 2023 at 02:36:20PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.4 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230210):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/3082
[2]. https://openqa.qa.codethink.co.uk/tests/3085

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
