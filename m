Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F7C4BEC6E
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 22:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234633AbiBUVV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 16:21:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234636AbiBUVVz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 16:21:55 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DDBB861;
        Mon, 21 Feb 2022 13:21:31 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id g24so18451453qkl.3;
        Mon, 21 Feb 2022 13:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9DNednKh+8QUYPEGIfJcwNcNgtoD8QjlQ6U6n0h6q5E=;
        b=MEEN3VUH+SW8XY8fMyhnpWni1VSs71IaYmD4YTFubaJv8RDuGrZDHariaRh8i1g3fj
         560w469KUFbJH7EICAddpQp9O/WFu8GNlPK6FPGm+YX7/yltq8PIJuMp7nnsXVhW+J+W
         FRTmw5X1tt5XC0vR9w1EvSG4HhPAGWorQIMYHptDWkMocPnqq2g2R2wSYu1KQy4quk5l
         JSmpoywe5Sgb+ehnF9MPTv5r31cPDq10BA271p1580f+8cVHJbpWvgl/yDJdbyMRILCh
         kTU9oYYU/YcmFLO9GZho0aWihre4WGMFibRq0ugibizKPnFY4wtMOo5xZZErirDX2FIi
         h5QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=9DNednKh+8QUYPEGIfJcwNcNgtoD8QjlQ6U6n0h6q5E=;
        b=k+NUoEhenDpzwG/cHSkLCrr74FZj+hk2JAwpuYgNkILbjueMdpa4j3bARNrRST4BPT
         c9AoEXBEBR3Z+oMD177RWZBkJGc8tWzlbgHxCVc+FEWI8QaDmOlbbArhwTGePBEO8Y3Y
         I6+0imigLdtKtrsol5Z4UOTHplxJVJa+WtdFoVODFADHkwLG6d7osFSegvDjeUJATXNy
         OHPxLoYrfbFX9i2QezlSPr12rnv6qtriLDaiaXAMlkXTw4ll2mc4kApF5U3/c+8bstw6
         3Nn+FgqS+v1Jh5VNLKCyARRrSqqZQquhPyl/ZQ6+sNFpCFmoQK/FLAQav5MGw+Ee0TQN
         93tg==
X-Gm-Message-State: AOAM532SwZCWJTyPwQPplWKJ/inWjWK9ypcDfrIsjbPPB3bxSrEsZ2gA
        QhFOWagG8tMoe1qFKThgRYs=
X-Google-Smtp-Source: ABdhPJyyJH7QRHsr27+6KKzMoE8V2K0gvu13+Bsxw6ICf3/rTX+rK/VeyBiFcuZBQcPXU1bSqugXJQ==
X-Received: by 2002:a05:620a:44c7:b0:47c:f615:59a7 with SMTP id y7-20020a05620a44c700b0047cf61559a7mr13418805qkp.539.1645478490865;
        Mon, 21 Feb 2022 13:21:30 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i21sm10014800qtq.32.2022.02.21.13.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 13:21:30 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 21 Feb 2022 13:21:29 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/196] 5.15.25-rc1 review
Message-ID: <20220221212129.GF42906@roeck-us.net>
References: <20220221084930.872957717@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 21, 2022 at 09:47:12AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.25 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 152 fail: 4
Failed builds:
	arm:allmodconfig
	arm64:allmodconfig
	mips:nlm_xlp_defconfig
	mips:malta_defconfig
Qemu test results:
	total: 488 pass: 428 fail: 60
Failed tests:
	<pretty much all MIPS boot tests, due to the build error>

Building arm:allmodconfig ... failed
Building arm64:allmodconfig ... failed
--------------
Error log:
drivers/tee/optee/core.c: In function 'optee_probe':
drivers/tee/optee/core.c:726:20: error: operation on 'rc' may be undefined

Building mips:nlm_xlp_defconfig ... failed
Building mips:malta_defconfig ... failed
--------------
Error log:
net/netfilter/xt_socket.c: In function 'socket_mt_destroy':
net/netfilter/xt_socket.c:224:17: error: implicit declaration of function 'nf_defrag_ipv6_disable'

Guenter
