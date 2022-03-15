Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05EE74D9B47
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 13:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348332AbiCOMd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 08:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348331AbiCOMd1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 08:33:27 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E9553723;
        Tue, 15 Mar 2022 05:32:15 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id i8so28748708wrr.8;
        Tue, 15 Mar 2022 05:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KM4XwBUogsooi4yJ541eYsrpo8lcj3lydQ59nOWeD14=;
        b=Uy3jmElRUk9qhWFP2igEevDSL+gDln/8vwvBp2/IU5kg/4ONK/ZQ/t7HGiQlJZDNkY
         ETwDffArvCDm78BP9Y6SJ36VkQEjfRlkTsamOsmy4amjX2WLOp2oVLA9ClzPWHTpzkm6
         qqj67OQINwFr4DGBixQMc9d4ib4BlkHhSt2QX1RtzRbCIv0ExRvnPpxxWXn8JmLbvq2e
         fmUfPNSy0Qwtf69WW2HdkIweNsge1WDYsYvM2qgAgPZiUqZCmRx3jFOcir0JeTUAzu7v
         EMSQ94wPDrnN3FEMKAeaAwiLHZPQ+5O59zdGasDiIEgbpHfQPr52UqsCJjlP5gMuP/8u
         03cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KM4XwBUogsooi4yJ541eYsrpo8lcj3lydQ59nOWeD14=;
        b=UhZm4KYmX5kGy1ul0H7H/qcv5VkPnGPfYNltrxB4dqMIMW2kISzapck77/QCwniZk5
         t/Sj/CCHHj3jWvs5XdZh3yOsMqIcFQ9blkgCWrIB0GXG1yYFTs7vLK2rMTZUCnQ1VhfW
         u44PXvC/ZePzY70pgXA/KRspOZBcU0NsURH/udfiu/1RK5uGHss3wIUSA3xMHXc8x1Ci
         LF9mwLsIQlvcEhj5Rcqje5DtO2wz8H4EbPxARK4GT/UGiz4chPienzrI1+aoe/BTdFZi
         i+B8iymYBiP0wtMclRqbBrQ2P6kDW7woBGpluv2kjQtk58wpZNORu+sZVZdz5XNAkDu3
         YmVw==
X-Gm-Message-State: AOAM533E4BzJM622cNRDaEVR0/c8X0ciavOiI3r/P589qO/Up+W2I9ad
        PixPACcDHcYtU3greEdBpZ4=
X-Google-Smtp-Source: ABdhPJwdW3nEBCD7NgiE3+1XdBwDH/XokwsyFefqVd+z/2JH2X0m3QMELYZCYM36HZ9mL9luTOCxow==
X-Received: by 2002:a5d:508d:0:b0:203:dac9:d301 with SMTP id a13-20020a5d508d000000b00203dac9d301mr143038wrt.441.1647347534080;
        Tue, 15 Mar 2022 05:32:14 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id i74-20020adf90d0000000b0020373ba7beesm25454610wri.0.2022.03.15.05.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 05:32:13 -0700 (PDT)
Date:   Tue, 15 Mar 2022 12:32:11 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/110] 5.15.29-rc1 review
Message-ID: <YjCHSwkhM8yEjloW@debian>
References: <20220314112743.029192918@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
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

On Mon, Mar 14, 2022 at 12:53:02PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.29 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220301): 62 configs -> no new failure
arm (gcc version 11.2.1 20220301): 100 configs -> no new failure
arm64 (gcc version 11.2.1 20220301): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220301): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/883
[2]. https://openqa.qa.codethink.co.uk/tests/886
[3]. https://openqa.qa.codethink.co.uk/tests/888

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

