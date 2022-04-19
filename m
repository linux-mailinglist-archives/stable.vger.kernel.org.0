Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B10506BB3
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 14:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352010AbiDSMH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 08:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352020AbiDSMF1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 08:05:27 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F54534BAC;
        Tue, 19 Apr 2022 05:01:03 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id g20so20928231edw.6;
        Tue, 19 Apr 2022 05:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CDvOrAhwSvPrqnuZ6scyYGviD1rsMWQWWOrY3bk02fM=;
        b=jrkrhKbDk0wT5XZFBVmW8OYoaYzhuOH6rMnJ4BwnijMy5HqN2SXLb9jAqu4uze/zfe
         XTrLg1SI0a8yVCNAuJQjJAcQYOATPNn5cvUc4S4AL9gaHQ2fBpWHmR7c53cmGMaXShbb
         9jXbKMutpmcFaYG8QNWD8qzfYdxSF6L2hq/tAZ2evwRHHC3snx6TbhjkxkWd3SZr5p34
         cb+xoNbshUlpyqSuiLbG2ltCjxbA97PhK9WYdDD7yGZAdk7KGVLidfdPP6pimClHBQWF
         NQrqrO38p22TunAIrUrsPiSKmmsguf01Wn3LSmIVhli7CQsULID2SMTw/vMqzMGT6yYv
         egZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CDvOrAhwSvPrqnuZ6scyYGviD1rsMWQWWOrY3bk02fM=;
        b=puoD6pr/dnZOjLFH+9htEe1vuroMFY5apTOkEAiQHBuaIHEXTwxO8DvDOeZUJ9OQRa
         xCJB056/rh+MK+Yp11qFuNnpRgHWnk9YlaxiQCwO95unXrLsaa2nD+ScTaTrSTYJcPab
         SulprwRSdf6RduiFLV/KA9tAiwRgfYMsKDyOLODYjh0hMkvhPwUpdFc4iZnAPeiFpwIh
         1XECVvUHSLUPmzWFMD93+hnQpmMhphch8tKTMZm9Idqh4mzGh+knQ9rhnjNNnUSpzE7X
         awrvgOdJjObJ2EsB30PfwRk5R/IXrSwtDowPU13vzsqT5sY3M4n6EU9zwIl/cvog93U7
         keBg==
X-Gm-Message-State: AOAM530z/Q3U5PfSY5xkzZoTt6sWPrtFjcb/GQhpifJAisOKodS/oU/H
        z8Wl4jWZz9u14+VDSJ8d21U=
X-Google-Smtp-Source: ABdhPJywbMtLQJFjjTprwH4JkceNMacFUkblQRK9uErqFfkVKXDKKD+zvziDe5nV7x97wNPLRgs6xA==
X-Received: by 2002:a05:6402:1e8b:b0:41c:59f6:2c26 with SMTP id f11-20020a0564021e8b00b0041c59f62c26mr17332842edf.156.1650369661655;
        Tue, 19 Apr 2022 05:01:01 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id cw23-20020a056402229700b00421c1574f01sm7636805edb.9.2022.04.19.05.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 05:01:01 -0700 (PDT)
Date:   Tue, 19 Apr 2022 13:00:59 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/63] 5.4.190-rc1 review
Message-ID: <Yl6kez5gKpVNYoQt@debian>
References: <20220418121134.149115109@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418121134.149115109@linuxfoundation.org>
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

On Mon, Apr 18, 2022 at 02:12:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.190 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220314): 65 configs -> no failure
arm (gcc version 11.2.1 20220314): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20220314): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220314): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1033


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
