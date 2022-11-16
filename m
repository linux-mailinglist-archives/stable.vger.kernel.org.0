Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F346862BB44
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 12:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbiKPLRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 06:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236947AbiKPLRi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 06:17:38 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDC32E9C8;
        Wed, 16 Nov 2022 03:06:02 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id k8so29344467wrh.1;
        Wed, 16 Nov 2022 03:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BQx3mUtsIUh3Vy0b9GmrxhmpzLCHkLOldYvI6VMUkAY=;
        b=PagfyanFb0luTYvKTSg8oz5N/SnKghrXCv4UfuXCjAE15ywI3tvQZhnVNuAKBaUMqa
         4Wu5CDvGFIPSWneNKkM51lb3W9HOJ26l//zf2LbvAvqyAxl+LtEj9KQqeR/XR/Pf844y
         7pT6xeTirO7YEBQ7O9nFKIt3vVoiI5Ga2GITEP2sOEazgp1Tji2vJ6WL3UtQ/dnKmhSr
         5c/B3p6XyCgVD9G3hkRlKN5KItm2dzewleCyeJEs1cO/2pYJiFws5O4ybw6m6iTdRf4o
         SIyVmNfaRAgFdNbsMSGSpkUmWUjk+XqSU/IwYy9N/p0TMrAjPXpQauS5IY7mD0DHJ0pf
         IlKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BQx3mUtsIUh3Vy0b9GmrxhmpzLCHkLOldYvI6VMUkAY=;
        b=EQtT8DhPZYotQMkvqZoGZTgxDWvI5It+StHudPWo/icMCE1Vf45SSGJkPfZxN2IKtc
         mBCxVjNetp1E+ZlzrgUzl5X+GQZ+kkVG2p3/Sn9XoCNI3APPtj7jHRcFzzqiAydQ8nul
         1bA/cK8FNNjgvP9qVsXine72M3vnK6o7fnGMJNa0FR4Pr+tALnj14KGmlBbYjPxKp3yF
         z0vqAi/1oDIr/Ov38UuBb2slA9wCtlblDKNSpFaMiB2blpaQQzzbqM65r1ap3SU4DJoJ
         OI8UC18Rh+Lph30Cpw/y1qg7Y1L430eoful55u0EPXHGqcA+Zmqf7lgT7FfrrPEiVmRP
         UBaA==
X-Gm-Message-State: ANoB5pmb+qD2AhaSlAK5zWIqd8QJT8tJPvIK6L0x5y3TGp9YsZZ1Tt+B
        UnHBwhXmCjK2ttP8uYYVhqA=
X-Google-Smtp-Source: AA0mqf5+Askp+qzYt/NicE/3sALjyeDRdAyZXWwm1sSuh+ZpzsaN+OqOZ/IsCE/e4Bh3M+8bXo8p9A==
X-Received: by 2002:adf:e384:0:b0:230:e4e7:b191 with SMTP id e4-20020adfe384000000b00230e4e7b191mr12922337wrm.158.1668596761278;
        Wed, 16 Nov 2022 03:06:01 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id p15-20020a05600c468f00b003cfd10a33afsm1763981wmo.11.2022.11.16.03.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 03:06:00 -0800 (PST)
Date:   Wed, 16 Nov 2022 11:05:59 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/130] 5.15.79-rc2 review
Message-ID: <Y3TEF6piNsjAXVAY@debian>
References: <20221115140300.534663914@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115140300.534663914@linuxfoundation.org>
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

On Tue, Nov 15, 2022 at 03:04:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.79 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Nov 2022 14:02:33 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221016):
mips: 62 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/2173
[2]. https://openqa.qa.codethink.co.uk/tests/2174

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
