Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC7D5EC03D
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 13:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbiI0LA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 07:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbiI0LAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 07:00:25 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A6027B06;
        Tue, 27 Sep 2022 04:00:22 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id x18so14390724wrm.7;
        Tue, 27 Sep 2022 04:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=8Dw7PnH+G2Bh6k4CKjwpqJqAR4B+90JCnNrI22kvuHk=;
        b=Lc3Cav/OwSRwG1/9OrtThBRc8lgqAN5vfp73D6QSTYorQqB4v47aqOVUtysoaURyCY
         WBep4VgRWYy4vQIDACNAgc9nXVbnERrgBsfPJ2o5GFsNjQWN76wZGmu9pV7e+wdGUi3M
         k7e5s5pyyGk1FWUsm5MECbTbDgQaa3s7+gPv5JdieBKjWtnXXgrBZY/HG+atoBsAhDrm
         8ccJf7RBAxc7SqGbKKYyJF8UbdwN/06BeTKZ/JB3ZKPj0qzM+tV+5rkAt/HZHCLVCneS
         LJU+CMndrsO+tYF8Siso+lC3e3dHRBmkZQv42Xgb/rmbbhMMGwz5DGVPtBH6uC/cHaOf
         a4CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=8Dw7PnH+G2Bh6k4CKjwpqJqAR4B+90JCnNrI22kvuHk=;
        b=af6oIKHMD+qw/G4OkdYLjeeEiroFB8mE4U3lDMyP3QZLV0mbKv3Wk/423IPx52vlWR
         5bfCt4JuXbsaK5ziWLRU5hoU3f8lMbCZfm74EyEVtFzWMWG/dgJtJW+R1JfZql1JsXha
         47+YIfUgOz4NVpccaseybyvI7sb1qO5VewP4mZovRbKlZ6zk9pV7r2qP325KgPsK4wEq
         plcmj9xee3h2/rNokG3sy3gmCbf2qVluiQrXecg19dqtw3++eK+gTr6rf9D1y02kcuZY
         y0ME/kMk8Fh+xfl06z3Tb5PS5Ol0jzqdmJQFbVSn7jGOOWOH0SbpxvQcB8bdhckS132t
         iBlQ==
X-Gm-Message-State: ACrzQf1IAo7RZ5qp1NR9J/KuFjms9kxnX6YOdLs52Cc3OYgOQla52mjr
        yK4SXDLl7GDDm+U9xoXYNXI=
X-Google-Smtp-Source: AMsMyM5UNsMufZuKmYD+bEDyW3y2ncpRlaZCUrExfqme5TJXyRQfuutXX6kIfZu0+F/y/395V/glfA==
X-Received: by 2002:a5d:6907:0:b0:22c:b9b7:c96a with SMTP id t7-20020a5d6907000000b0022cb9b7c96amr1957606wru.44.1664276420848;
        Tue, 27 Sep 2022 04:00:20 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id n188-20020a1ca4c5000000b003a8434530bbsm13256435wme.13.2022.09.27.04.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 04:00:20 -0700 (PDT)
Date:   Tue, 27 Sep 2022 12:00:18 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/55] 4.19.260-rc2 review
Message-ID: <YzLXwrCjFeK/GBX5@debian>
References: <20220926163538.084331103@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926163538.084331103@linuxfoundation.org>
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

On Mon, Sep 26, 2022 at 06:36:43PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.260 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220925):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/1903


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
