Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25454E3EC7
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 13:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbiCVMvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 08:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbiCVMvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 08:51:15 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDCF23177;
        Tue, 22 Mar 2022 05:49:48 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id i186so1437279wma.3;
        Tue, 22 Mar 2022 05:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cI6JrRwQRBk0wOsq5ngKZkMLLny8sD3vOnlcyYocSi0=;
        b=AkUikKpcc13bQ016kRZQCfvLUQpPGDecAEXx7DHDD1vEgnn1hQ+Jbm8xxwrEFq2BwZ
         3K/3ni+NTe+Jki3La241lvDZKELJqpJ4UrmSF9yyB69c7W8YK9+QL4u9I8yM4Wi7kbMI
         k+9ouIpXUQfiv7uQa7j/v33Cb4g6IHkkXtyQquOL9D371atKIPaqfanPnEqdU7wthc3l
         W+bKW/AjcdTfgptzWiYlpkAGbcabPJK+FtRNK1TFKl7QVS+jX3Ytq95qrlrN0G6T7nkn
         o+h468yvH4m1N5tiMBV01vv3xRWPiglRzQbzknQllpdZBKllJsQSrGKiXI8OY+NfMqit
         xFOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cI6JrRwQRBk0wOsq5ngKZkMLLny8sD3vOnlcyYocSi0=;
        b=OPrmtjoWe0r4fIIrXOPyRvyb10xZqozoOZE3QXQiT4P/b73b/sIgMwvzimiJWgkNF8
         KV3++Mu3oS4GWP3Qvn3YUkSiCDc1j/wj0k1rLPdBekxxKdRhsE+S8pO4zy5LMGnuGUzq
         hJf9FN1ojNQKdZ99zdwLOont6lvmCxhqdzNNVkSlIztNTsZ07Y1o5f/5+0eYXOahV+hR
         q5ZyYUcgcDaDnxXvA7+MzybB/gQLTn4PCxpphD++9Le6X9fOlb178dE1SIqJ/pwf5sHQ
         EwzLq2ziEUSxa+tlaxWHrMfy9YvogIuNv5+qZFo0JgaodwST/voxeNpLf6LY8zWhiSUF
         yjog==
X-Gm-Message-State: AOAM533GJGzdnEEXozR+44wAAQIbmP6BksJKEFGuQrbnB+wg1dzd/2OO
        +xVPi/WvJTLTAKzyEOvkiCI=
X-Google-Smtp-Source: ABdhPJxjgBt4Z5A6pGlIZchA3ICSNrxCZ5Zw1DELB0tvg4sWj4o4sW7WE9mwig3DXdqXVGAftUbHKQ==
X-Received: by 2002:adf:e589:0:b0:203:e324:3485 with SMTP id l9-20020adfe589000000b00203e3243485mr21653498wrm.271.1647953386852;
        Tue, 22 Mar 2022 05:49:46 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id az26-20020adfe19a000000b00204154a1d1fsm4542129wrb.88.2022.03.22.05.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 05:49:46 -0700 (PDT)
Date:   Tue, 22 Mar 2022 12:49:44 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/32] 5.15.31-rc1 review
Message-ID: <YjnF6GOV5RDOkJu3@debian>
References: <20220321133220.559554263@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321133220.559554263@linuxfoundation.org>
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

On Mon, Mar 21, 2022 at 02:52:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.31 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220314): 62 configs -> no new failure
arm (gcc version 11.2.1 20220314): 100 configs -> no new failure
arm64 (gcc version 11.2.1 20220314): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220314): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/925
[2]. https://openqa.qa.codethink.co.uk/tests/929
[3]. https://openqa.qa.codethink.co.uk/tests/930

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
