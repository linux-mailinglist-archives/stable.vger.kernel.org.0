Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC32568545
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 12:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbiGFKSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 06:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233108AbiGFKSN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 06:18:13 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C716A255BA;
        Wed,  6 Jul 2022 03:18:11 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id g39-20020a05600c4ca700b003a03ac7d540so11296781wmp.3;
        Wed, 06 Jul 2022 03:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MLpBgzOegxkPueNCcd9RuELHHNmoFrpxAWlGqgmIe48=;
        b=Q8P8jmx0eRWtDHSREQGdVtn9QJhXJXHvi4iQbBDAE5UbTswr/asBx7O1+HSlorEj/7
         haaCMFS3zmO4VlDhgrKRKBTMnffQiP7Pr/Hxbe4rKNtdmQiIZF3XcCkqxUej1EletlBL
         MsyMM4JKQzEg53RdUZsa8PGTUs/WPavqnN/sU8jG1LS1eYHUw6iYwezeAm3w6hQi38L2
         hJi47PlGUWpCF6twkyPlZY6OGFB1bqZGYGPRhP5OS4oIviKoIbG3VWYCAjNjtORA4ImE
         agDW8t2iqbfdODMt+UwSRwBuEd0DH9xOVsxojEP2XOK87OuwUPdRw7OHQ/uQ2+cgUWeA
         uRzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MLpBgzOegxkPueNCcd9RuELHHNmoFrpxAWlGqgmIe48=;
        b=LHio4HGTNPEnA5S5sy0au/AfggXoxTBDq4NjLaaQiyvg0jl3cuL8CafoojLpVrKA6r
         eeMqqHsCWFibAFoVNyZxhytpacgACQDVBKlZR2Z983r8+GewzeSPI5zHRg0czF8lJiNI
         ZyFVKK/adYMV1cfDSWXeQgbzgf1eO1NCx8LeDqRzMs/RFfT/iNv4peEP0WRPvgDBmyl5
         jqsSFcD9GD+e/4RdE5S5RRfcF5F9TnGmPbc8FWx84p8qRkPNXONKOyE3De4ZpkeZrNed
         Zvv/9j+jee2wGqHCK2ZIQpsxc1tD5FpZzwCFJkRk0IVEZ/lWpolEYcXDiK3fqH5XyFuG
         OLCg==
X-Gm-Message-State: AJIora+R4x+EOEP791VGCGjvSjvyTNDFPqktM9uAErZIwS9vpPLjhO8/
        5GnghaRP8k3wTXpCTATc1sw=
X-Google-Smtp-Source: AGRyM1u6cjj1wubk6f6VtqGHM6XSGi1s7KLVMeBbBAAfgecJZEqA7bpXalLmuFp1JFEhAE9Cy8WZWQ==
X-Received: by 2002:a05:600c:3510:b0:3a0:f957:116e with SMTP id h16-20020a05600c351000b003a0f957116emr40106170wmq.179.1657102690164;
        Wed, 06 Jul 2022 03:18:10 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id l1-20020a5d5601000000b0021d7799cf4csm2910921wrv.61.2022.07.06.03.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 03:18:09 -0700 (PDT)
Date:   Wed, 6 Jul 2022 11:18:08 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/84] 5.10.129-rc1 review
Message-ID: <YsVhYBCbj77Iza4d@debian>
References: <20220705115615.323395630@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
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

On Tue, Jul 05, 2022 at 01:57:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.129 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220627):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1457
[2]. https://openqa.qa.codethink.co.uk/tests/1460


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
