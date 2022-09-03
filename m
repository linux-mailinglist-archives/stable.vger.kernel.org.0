Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C735ABE8E
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 12:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiICKmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 06:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiICKmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 06:42:35 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73F71D33D;
        Sat,  3 Sep 2022 03:42:34 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id z14-20020a7bc7ce000000b003a5db0388a8so5195111wmk.1;
        Sat, 03 Sep 2022 03:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=3PQH0dWX9JNDSDN4XcuzCwiRpv5jZ+8a7cZoLP5owgM=;
        b=bD8UDu1pSeBhX58E6wQSm68/I0gpCHRcFBiUy3JR4/m8H23k9WyVrKCwylHZWzuB+k
         OTyENh/s1sBrZx4MvvpxI2s3JA2Ib3NrZJgSYtoP17oUCv80etxUoTANgsILP0eL4iDc
         lW5vo3avdgGHZ4scDeCdnABUPP6KMT8WQvLGwYNDmfgaU32sdZypF+7eNGUO5bLcpiZo
         HU0eE33KppqFE978pW9eHjKkpIoDi5naSa3dNNwwCChp+w3IyvM7XwSYR/qL2T19+V4t
         6QlY3q8CWcl3Z9pFb/sxMwffzzC/63C1uImnGBnFc/h1Y11+JonqCg6hqOLD5rOuJy29
         PdAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=3PQH0dWX9JNDSDN4XcuzCwiRpv5jZ+8a7cZoLP5owgM=;
        b=xdUo1YkGaLa5IpZi8MlTosZFSk3/MfD/EADjIP++ff2apK9uxEsblnJztgpIGJxIHF
         R6ejyidFFGiBNLFgFNdUbSofAwO08H6z7v5JLoASB9dFH38hF0GuCJrqXHAyPb+F/b7i
         EEKTLsvoczxhRIDU8fVnWd9A2qrHcank/PiGcdBMRjl60xxLsjq98z8Wr0X/1/tdVH5z
         UU9oo5keh4QkvOQN2UIWskY82GuE/EDbipe2pc4THgz3sIfnDPH7AedsNvDkqtAKekNn
         j0jBiDkNAORMdfbrmLLPcvFtvAtCGJ52s21qNdisThCIVQtt5Th3adY0xCEJvyUBiK6h
         nX7w==
X-Gm-Message-State: ACgBeo3z3yI9LH1GvgdnF3vFNeM8S+ZpPiSa0dNMvzW3f2wC5Y7WMGGo
        OZ+IIe2zdcjFzZgGn/k1FTg=
X-Google-Smtp-Source: AA6agR4BUCM2Cl1iBplnlkD2x+aU2Ho9Tpr+zhUVX/gYDbcPhRGM6GbDTLIwixh3VJzq5MtWWYK8Fw==
X-Received: by 2002:a05:600c:4c06:b0:3a5:4eec:eb4b with SMTP id d6-20020a05600c4c0600b003a54eeceb4bmr5821215wmp.151.1662201753075;
        Sat, 03 Sep 2022 03:42:33 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id y2-20020adfd082000000b0021d6924b777sm3485801wrh.115.2022.09.03.03.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Sep 2022 03:42:32 -0700 (PDT)
Date:   Sat, 3 Sep 2022 11:42:30 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/77] 5.4.212-rc1 review
Message-ID: <YxMvlmnLQ9yDnDFU@debian>
References: <20220902121403.569927325@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
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

On Fri, Sep 02, 2022 at 02:18:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.212 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220819):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1755


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
