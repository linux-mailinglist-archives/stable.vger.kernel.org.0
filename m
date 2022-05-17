Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3541C529849
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 05:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiEQDgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 23:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbiEQDgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 23:36:49 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B4240A33;
        Mon, 16 May 2022 20:36:48 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id t11-20020a17090a6a0b00b001df6f318a8bso1209753pjj.4;
        Mon, 16 May 2022 20:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=9UH7nsHqxv3GZUiGZguvD9MQggvfUiCqtWb/PY2zXlk=;
        b=VU7lab9t7G0J808DJqpc6sxvs32j1ONfh8Bd/HoQlQqjkvpAzIwV0ciXPT7DCv/fxw
         UC7/9DNQ1cyQ+kDIyu/0/9AG//Bpb7jfxzZTMTIKDQQkJQuOomxGz56wwNjEdwiMHjl3
         Xd3OgOdUm0FQeE27Sb6BNKFmq1a1Fy6BBYx5V812u7KmQknc5thpyZiK9QnpO3lV4tpR
         1mHiEIxDIpBYpcWcjoe3nKRqBbId3dr+NpwZLoMD9Q4HuNtImJHydXn+yp4Vkh0swgkG
         Fcq6YQPS9L1Y00n64HH09BuANSGLHTKa6FUZLOiCt5Nrnn1hYbhAxcNpEuYhEO2qHrwT
         brOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=9UH7nsHqxv3GZUiGZguvD9MQggvfUiCqtWb/PY2zXlk=;
        b=jrMRvTU1gp0/QS01dkSirO79sbg19lCsxw2dBVC5W6Gq8azztBr7w9SJJxuM7IsiDh
         rfOEGBcdU7X4KXjEMA5hHKYlHjOUxvQT6tjhifXiMtq5HF7iULo7urf1+SGr9ex2ptJr
         DO+XpXxS2VYtVf8EM8viM6pP/HEinPQ8oX4Txq9BoWRF8SDApzahhSqVV/ZfAhFCNHxQ
         Id9jcTngwLzbz6EAO6FpTDfwEvnSzWs4SgLHRzpsX7PSwIBPk2Vei/CRljxXT0sy+JqD
         u4xH4kSMu7TfCcRRZSDvhUnReDU85J3kSElBFvMb15k0MULdrPmoZJU63jnDXKGMiAZI
         XW0w==
X-Gm-Message-State: AOAM532zu/02XnxXWO+xeoeELsFOU3OqCfNWrCZPMw4w+wjPOmj4rOeA
        RCjR9/2EfHUui5qVqpHS2hHhU7TrD+E5b/4A
X-Google-Smtp-Source: ABdhPJzTQryVpLZvViK8PXUsV9+SAef+bIUYEoX0NgWad5rVNmz+nyNMxXqzsexkh6v6Cn0q4S6gIw==
X-Received: by 2002:a17:902:8644:b0:15a:3b4a:538a with SMTP id y4-20020a170902864400b0015a3b4a538amr20623181plt.146.1652758607871;
        Mon, 16 May 2022 20:36:47 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id be11-20020a056a001f0b00b0050dc762818fsm7570995pfb.105.2022.05.16.20.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 20:36:47 -0700 (PDT)
Message-ID: <6283184f.1c69fb81.ceccb.3c9b@mx.google.com>
Date:   Mon, 16 May 2022 20:36:47 -0700 (PDT)
X-Google-Original-Date: Tue, 17 May 2022 03:36:41 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
Subject: RE: [PATCH 5.17 000/114] 5.17.9-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 16 May 2022 21:35:34 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.17.9 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.17.9-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

