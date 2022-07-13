Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 097DD5733E4
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 12:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiGMKLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 06:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235808AbiGMKLd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 06:11:33 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C4FFAC97;
        Wed, 13 Jul 2022 03:11:32 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id n185so6207613wmn.4;
        Wed, 13 Jul 2022 03:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=chaQ8H4UsAcSNsWX0c9b4q/mrqunkPNAhDNMlUhBWnE=;
        b=J/AlKGltxnmTIwHszaIBoZybxyFpv8Y2VRtMLjB1wZcOWJAYiHh+h7suGDN5E05UGe
         M1rTxeGeAaz9/tRvzmRl6fJSGQK4g6vTza11j/lgVmg50k9byqDsCBlrgu8Ld49GAkne
         PTWKJHZxn7pCwgixA2+Qgxr9JfaKdNXtHXYBlksuBWNkd/oTAooCEbO25EtVP1s4URi1
         5Q1IF1N6H44/Iez9eMKRKQtENUAzj3k4vmhObGbcA4Z2TEGyyLLIq67BnzFvowyiTohB
         ueS/SHZYuqQ3oR/3RxxN0QbXImqB+Kd9MjD1WsoViLLqZVTuhJbtMVbGIEQHL1+2oJqe
         /piQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=chaQ8H4UsAcSNsWX0c9b4q/mrqunkPNAhDNMlUhBWnE=;
        b=a9/907lehvAOgdOrnXcRyoWG3Z0AtnBA4WmWBwzWWsu5ICNBW7W76pBjuQza3dBGya
         w7sK1SgMAB1R72hH27862wteQq66jV5bEgEMyDVgFOGDx336A2HuB3LucIikIWRVMOc0
         ejGqR/ntmnsr/zLiOQ2/jweBDI+nEK5cD+ewg4E5gJS+XjsfGKVXGnc27Ypp40cYMboV
         NHXIcvQvdl+qmtc1fUQEOuDb6KqQQR29YDQKVAzfEr8+4xrsBvbPNzkf0OSPsAcPt2+P
         +qengI1DT/zMHNTMcuWNYohbsMAxYiairluhBzaF9J8UUqJbpmzsUSWODdNOKzOjb06n
         l5mw==
X-Gm-Message-State: AJIora8+sVf0CfGnjoYRe53XvS9qZgPqfd5UHiB5AiUgUmSqKJTFplxe
        3TBUQiUlvXtwdxLkpeDoq/A=
X-Google-Smtp-Source: AGRyM1s6y8cOem5PC7WF9eF0q8vvGlfLk+3gfgDTCXC38DC0UbJySbTEUO+JgcMyi0a77zfcqAWKkw==
X-Received: by 2002:a05:600c:4e46:b0:3a0:4d54:f206 with SMTP id e6-20020a05600c4e4600b003a04d54f206mr9151459wmq.151.1657707090883;
        Wed, 13 Jul 2022 03:11:30 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id d7-20020a1c7307000000b003a0323463absm1676060wmb.45.2022.07.13.03.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 03:11:30 -0700 (PDT)
Date:   Wed, 13 Jul 2022 11:11:28 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/130] 5.10.131-rc1 review
Message-ID: <Ys6aUCS1Sewa6qcZ@debian>
References: <20220712183246.394947160@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
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

On Tue, Jul 12, 2022 at 08:37:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.131 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/1505
[2]. https://openqa.qa.codethink.co.uk/tests/1509


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
