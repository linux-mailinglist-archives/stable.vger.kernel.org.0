Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A263E523074
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 12:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241485AbiEKKNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 06:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241715AbiEKKMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 06:12:36 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4611721935A;
        Wed, 11 May 2022 03:12:33 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id i5so2217017wrc.13;
        Wed, 11 May 2022 03:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QjOiABWwDVf3MfqksGqkegesFaJHfof1rS6bjlGGuC4=;
        b=I7I4zJv9xEfpD5ecwkADzCpE5qp9p57z38WYdroMV8d0VO82lQvp2QgYca56YNLhkG
         TBrna1GBY3oG7pOMiJYV3aJHV8F06B9g1Ayfrmi3NjG3Zt2eeiBzWaUmz9NKRa24qf0/
         Oyghabp5978mKCONdpUR9XLN6YfWf0eN1ZtlwLUDvfbd7BU/Nt7K8YzD4OO0VeiqIg23
         u31t1pNfeSS5h0zRbaa95Ti+0iKWGpw2qElQIm6QgdjILwUtFmOFTM7Gb072Fts9okgV
         N3lGgxCYG4Tqy/RPTE6n2ztbhjnLPmA5t007wE2On8DXz5euksqeMRcevagyzgoMJ2z7
         wxvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QjOiABWwDVf3MfqksGqkegesFaJHfof1rS6bjlGGuC4=;
        b=yVIR5DE+ENbk5DB7R4XxbG05t7TFLFUEAu2Qwbpgxz1anncweSCyJCyxt3asDHvz6h
         NqijYn/xRTtpTqDOqPHulHWWjRYjYxuFXOM2UhYlo5/lBGYshqHjIeIecAOskTuHLKOe
         G35sF+FWZSuGmk2ydnFOD4WXlm+w2VipzAK8yUpz1D+C0NnGhtrvx2P8t6oaGCJNsFXm
         2ZX0Lvrl0Cx+Z7rFHHDqdX34Pfa1cGE+gqPARJZLg4eWqHY6IhA6jEbwiSLSOmU5m8i1
         pqqWr3AG0O2YbWkpvxoEerEKFXwrnLe6QD0P82V1jUMwhVOMelnK5zSOf0FFOYd8BCia
         RFoQ==
X-Gm-Message-State: AOAM533zburcmvXfy1Vty6LeiCi/7VCYSvuV2mLT10COMnwIur6EBbvh
        tNbfEZK0FRBApPuQW8g/JWw=
X-Google-Smtp-Source: ABdhPJyYxjVyKLnHJy496AZEtBYq6bkEgwwoC4B35ncrexX+oqDPGhsdeoruGD6BWteaKfURf/KqbQ==
X-Received: by 2002:adf:f3cb:0:b0:20c:8afd:9572 with SMTP id g11-20020adff3cb000000b0020c8afd9572mr21546958wrp.179.1652263951554;
        Wed, 11 May 2022 03:12:31 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id e13-20020a5d65cd000000b0020c5253d906sm1267182wrw.82.2022.05.11.03.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 03:12:31 -0700 (PDT)
Date:   Wed, 11 May 2022 11:12:29 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/135] 5.15.39-rc1 review
Message-ID: <YnuMDWIReGg6z0Al@debian>
References: <20220510130740.392653815@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, May 10, 2022 at 03:06:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.39 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.

Build test (gcc-11):
mips (gcc version 11.2.1 20220408): 62 configs -> no failure
arm (gcc version 11.2.1 20220408): 100 configs -> no new failure
arm64 (gcc version 11.2.1 20220408): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220408): 4 configs -> no failure

Build test (gcc-12):
All the allmodconfig builds failed. Will check later what is needed.

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]


[1]. https://openqa.qa.codethink.co.uk/tests/1122
[2]. https://openqa.qa.codethink.co.uk/tests/1126
[3]. https://openqa.qa.codethink.co.uk/tests/1127

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
