Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582E4515C38
	for <lists+stable@lfdr.de>; Sat, 30 Apr 2022 12:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347283AbiD3KV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Apr 2022 06:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238687AbiD3KVz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Apr 2022 06:21:55 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187F17C159;
        Sat, 30 Apr 2022 03:18:32 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id b19so13670396wrh.11;
        Sat, 30 Apr 2022 03:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5tHBW8oQv6afZO81ll5/BlzeMeG7vLilLXD2oh1u+mg=;
        b=hSA0SNhjbQPCBt4iJMF4FWGgrX0Ly64iX+2mVA9pLmScmQEpwF5FO6UakSMAivtxin
         jhQC4UeagnwBmmV7jtVrTsDL6ULM5dQ02DscZDOPGa2nvSkOnwdEjahuBlGNK+qxpkSr
         GcwjcrVAM7OZYQ+XvIdKChwB9b14ofqy81ywPrKrgvgyYWsG+lvP7MJS1s+Q1e1tBOA4
         Z4G/U9EoRndRvbeG0r3DijMLs+SiPT+Kwudj44eElt8d/hMJ+1FMelWpsKk7oc94MPFO
         WKPX5Pv8GQkOm53cP6zMB0OBSpMKjbvWc5bcBvg/T3r9dw8yV9hwxAT2niVz6Czjh70x
         olxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5tHBW8oQv6afZO81ll5/BlzeMeG7vLilLXD2oh1u+mg=;
        b=RVkUgL8zKOcbZG4n806OW+0zdeJi2qwcwNuBaMKKiMf5reZVTehCr99RF/qaUCYaeK
         fBsOihjNzLdl3Scp8RWVnUMp5tIPbJJEgABpEURQJjvVWTWinF7oCXc5GeG/hwNl0GKZ
         HTz8YUI1FnE2MqEsyiOACA4J5u8Dq7pTlZWDxsnV3xukzlDSUT95vnSjGBJq/j7cg5Sx
         GCB9FWpptzVsCJHtumrRXrJCbBf/Re0ijEg2jQULkdtmBmsvlYXizGV76gg2rb7WkV1N
         0mKqW7jzH/PWM9k7MhWH82IgzdEiFHFk1+AKxnj8mZ8FledvDch3Tu0W8gsJDQDSYyj6
         xniw==
X-Gm-Message-State: AOAM533FhI9oK3xvmaSz/6ghR59f8W7Uu3ShA9y3GcJsVa6MPIg3MwcG
        R0yQaU8QZa8YMhVXZq7K9gk=
X-Google-Smtp-Source: ABdhPJxJOOsTPRVw5X15QImnBQAd5moMu9AdycaW6z+C3nk3hKPCzN5th+ABYoocQkvFuseGl2Gq7w==
X-Received: by 2002:a5d:5502:0:b0:20a:e0aa:90bd with SMTP id b2-20020a5d5502000000b0020ae0aa90bdmr2705185wrv.551.1651313910559;
        Sat, 30 Apr 2022 03:18:30 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id q8-20020a1ce908000000b003942a244eeasm1435063wmc.47.2022.04.30.03.18.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Apr 2022 03:18:30 -0700 (PDT)
Date:   Sat, 30 Apr 2022 11:18:28 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/12] 4.19.241-rc1 review
Message-ID: <Ym0M9AyQHxnWHMOk@debian>
References: <20220429104048.459089941@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220429104048.459089941@linuxfoundation.org>
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

On Fri, Apr 29, 2022 at 12:41:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.241 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 May 2022 10:40:41 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220408): 63 configs -> no  failure
arm (gcc version 11.2.1 20220408): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20220408): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220408): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1085


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

