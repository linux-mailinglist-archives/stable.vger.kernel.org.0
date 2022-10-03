Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA405F34DB
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 19:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiJCRwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 13:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiJCRwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 13:52:23 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9502B360B0;
        Mon,  3 Oct 2022 10:52:22 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id w2so10858958pfb.0;
        Mon, 03 Oct 2022 10:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=kL1bwIJjsfYL4eWUMgIQ7iYb2RgcU1KLniz8+kXvL/Q=;
        b=CvQ5G7POCWPgJpxlFSVMDMpmJpK8RG57WlUHNw13Z2MYLArhcDS7/GGqdenCsy61GL
         /ec89GR6g7jn/7W+ZKalNSdashvl7sGHHXBKj31CkqrxFfZHIZmdE8+CQN4VDw0ltSSE
         uFinvfXWWLi3VFGxwe7IWt+fPYGELkvBUB65cXCrw1jEtzutHpqlew0bNTlk2UCnPMxZ
         cuG3sjxRXZwPmdmkY+ohL5jVpnhY3TbdWTMG7/d3AgB1qyiilFLJ9Q88qZEgRYtfaJkR
         9UVIJ+BRw6SDmSw1jd6Onv/Ly9UnuR8Pgk/lk3JZ+EsjcDfBuhJWevKJ7x5tF/zPABiO
         Tg0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=kL1bwIJjsfYL4eWUMgIQ7iYb2RgcU1KLniz8+kXvL/Q=;
        b=Dm1FGdXZ31qrtRvesVgoUGAhzEG9sU5BCfvzpbMW4q68ayP8EaZ05nvOXJWjCvh1am
         uYhB2JYAROr+6z09d4jZRxs6t+OP6vTxTmiQEVaZG1TMErQ4+y+78UV1pI85vBCLlj7u
         AVbB2smDCLjThYBHH7znFoExdQHwT2nR/Xh7oxVtr6oU30yFaoKNAut09ipoYpSMJrjl
         DKap+AWkvAVfOK1cxHIa15RNHjZ+2I5yQ2iYW2G3a0hILJP1/PvitA98UBdDrTeIOXxo
         VFMc4qurWnBqcoigKNCMvJ8QUGRJYpTbunPbKXMXU1JIg2jqflCq+HDazZCUzMcpFmnD
         RXTw==
X-Gm-Message-State: ACrzQf1HyjJQDty/mp3nnSL3y6dizir1+aa3cGbj/dyi56UB9l8dCBje
        KwwhCrQs4cTmIH/kqyvCSAw=
X-Google-Smtp-Source: AMsMyM5BChkXR4gC6Da1oOEx7thmlB8cVRLuaeTn1Q1oNskXqaSFBZySc+un8/OC07L0W61PrrL86g==
X-Received: by 2002:aa7:8893:0:b0:544:7429:b077 with SMTP id z19-20020aa78893000000b005447429b077mr23743517pfe.69.1664819542149;
        Mon, 03 Oct 2022 10:52:22 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y23-20020a63de57000000b00440416463fesm6885037pgi.27.2022.10.03.10.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 10:52:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 3 Oct 2022 10:52:20 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/83] 5.15.72-rc1 review
Message-ID: <20221003175220.GB1022449@roeck-us.net>
References: <20221003070721.971297651@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 03, 2022 at 09:10:25AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.72 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 157 fail: 2
Failed builds:
	i386:tools/perf
	x86_64:tools/perf
Qemu test results:
	total: 486 pass: 486 fail: 0

Perf build failures as already reported.

Guenter
