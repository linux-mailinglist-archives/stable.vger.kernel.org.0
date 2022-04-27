Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224095115DA
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 13:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbiD0LLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 07:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbiD0LLB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 07:11:01 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1744B44740;
        Wed, 27 Apr 2022 04:07:29 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id u9-20020a05600c00c900b00393e729e655so1006481wmm.0;
        Wed, 27 Apr 2022 04:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aWeabFjSPFJCE1ex6sBRRNmsXi3iYIbVczYC13dwVaU=;
        b=AHWW5jnG4vjqFgGw7AhoXQt9fNxt7I3wC4L4pAbPDzkc3gjiZNx11inPOBZ+64Np5g
         hjFox2jk7kil2+TJC4+YjBbrmFJlOROGBiV2jOuGwrhT+7xeP8EwE0ceamU3oDV1dpTa
         BCQ2bOWeshfk9vBaHzZZqafbUcBzrU/fUu8CnfSKMTz7O9s5WWGAXb7uZ4QL1dlIM5cw
         wBJdAWI5sNwIrUiFxxjVUadZ9EGbEghH2ofsYHpzdj0+m6TUeNTjcjsmnF2/TYg15moF
         7eVm8/GkjU6RQgPFb1C0aQmKmiZkqL9gFp5rDIfvwaPczAb3Upi8ZdEpV24htVotcZ8v
         iYeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aWeabFjSPFJCE1ex6sBRRNmsXi3iYIbVczYC13dwVaU=;
        b=YLkqpmDgF58D1rDM8gU9V02vvRQznyTk9IxzUD2rUZ4R+MQf6KWWLibkfHKYVS39Jv
         KIsMmIYnIYFkymbnSj8HaYp5w0dEluH0dLmjjt67Hu/ZaKt33Tuyc1gPuIQGzsHhC2s8
         z7hTyJBMqkxAqx/wKDYHGzBZr7cvCnUF6Ijl4NLjYBi+/gRoAIQW1xOmAnhZEoS5Uws/
         RUZCSiZ2tdjmNXFEhuHBil+GX0SDBzEAcUZOFms0xGmDHJG13f8E80rceby1RLxnqqeX
         YLP+ItKCDaR2RiFNIzwzke6SAABRPu/rA8wAY3Xvkcz0VRlpRN9Wq8hGbvVR/K/4p5VP
         LDpw==
X-Gm-Message-State: AOAM531MgmkK7Af/VE65AQZzqMtmk9bATxpfRfzIW0pRND8jS0N1MFvP
        V551wiTttY5IdRNiTtiqfJg=
X-Google-Smtp-Source: ABdhPJxyo7dxW+DyHCFdV6AZPrChtE7SZwP69fmZbc8kq8lpleDIG/V5KBAOdpyA3tzhKUAGX8vHqA==
X-Received: by 2002:a05:600c:4808:b0:393:fbd3:f1fa with SMTP id i8-20020a05600c480800b00393fbd3f1famr5789248wmo.100.1651057646451;
        Wed, 27 Apr 2022 04:07:26 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id p26-20020adf959a000000b0020aca418f14sm15659728wrp.54.2022.04.27.04.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 04:07:26 -0700 (PDT)
Date:   Wed, 27 Apr 2022 12:07:23 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/53] 4.19.240-rc1 review
Message-ID: <Ymkj66PE3OwXqYeB@debian>
References: <20220426081735.651926456@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426081735.651926456@linuxfoundation.org>
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

On Tue, Apr 26, 2022 at 10:20:40AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.240 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220408): 63 configs -> no  failure
arm (gcc version 11.2.1 20220408): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20220408): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220408): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1065


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

