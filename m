Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4DF84E3ED1
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 13:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiCVMx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 08:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbiCVMx5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 08:53:57 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0048F5AEF4;
        Tue, 22 Mar 2022 05:52:29 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id q20so10838371wmq.1;
        Tue, 22 Mar 2022 05:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l2bDV4b4TCFWEDkXxb4VNiQbYgokIaYPX00HOgcG44Y=;
        b=cDHjbmOsGjw9EDe/wwMbSD/EraELO1KEwoqpIhzBQLFKhXGzl9+AwcigJLfGVzvPMF
         +M+VvVgZQFoJ0NiZWQwcYp9pmwKXpI/valOV10o1+iVweWmLO2zhP7qNnpI771VgHWWA
         FQuDWUboQzAL6cW66OExIjrGuCOwehrQEzkS/fmP/a9sVYH2RisZIdLVAVga0gTNytUJ
         /g27yYl6RdK4ilscTx0Q7/xVSVgB28E9rqAeO7iUpWARkIabmN1ntddFL1dlPOqG39iu
         PR3T4KHXX4eAAPobsSG3tLZDWIefcifYrJ6MVCkIzmhW/VPexrrkIet9pUNFvASbFx+j
         PO9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l2bDV4b4TCFWEDkXxb4VNiQbYgokIaYPX00HOgcG44Y=;
        b=ae8feWGB0t/0c4ne6FUSWy+cTlzck0EdaeDzdSHyB6mc8k81u92ZPbkzFu/6klxXfn
         AL17AYYdjPVFVdzZaKD/sprX62xdTk7ikPC7YD7sKztvFgWvUItCL6x6V+o4anaPP2em
         HZBrw9lG2ailFpbs1N33Ca0qIfmk44TVayXleSDvN+IZiEodslm7pmzh2oYjLq3MJSOM
         e1e2Fzv4ry+ZIbDmsDI6yaH4IuZFkQcBoVEMpgYmpyFP84I3YETnShs30GQ3tL7sUCqU
         6cMiBmXRsGGIKnD77oERBMExdb5Ypb/LUTAsbmqFHTyhOlIdsVX4N4uUrzYtJPIebLmY
         KkNw==
X-Gm-Message-State: AOAM530e6QMFS60OJc4otFkeqUquvhTH0o1RRQxO/WLXPn/aS2j/ldjY
        9OjJOZkqHVO1S6M4DE7aHNw=
X-Google-Smtp-Source: ABdhPJy48KatSSzIIQSDrn5sd0ztP2dShS9MhV10r9M9XN2whhNt5rBPNdQYbH5DW+/rRCr/7XpWcQ==
X-Received: by 2002:a5d:5987:0:b0:204:1f21:6a29 with SMTP id n7-20020a5d5987000000b002041f216a29mr4526845wri.716.1647953548459;
        Tue, 22 Mar 2022 05:52:28 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id g5-20020a5d64e5000000b00203914f5313sm15701088wri.114.2022.03.22.05.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 05:52:27 -0700 (PDT)
Date:   Tue, 22 Mar 2022 12:52:26 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/17] 5.4.187-rc1 review
Message-ID: <YjnGitsg6Y9ZXeeJ@debian>
References: <20220321133217.148831184@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321133217.148831184@linuxfoundation.org>
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
> This is the start of the stable review cycle for the 5.4.187 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220314): 65 configs -> no new failure
arm (gcc version 11.2.1 20220314): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20220314): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220314): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/927


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

