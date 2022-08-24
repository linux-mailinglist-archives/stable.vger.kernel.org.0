Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E5259F855
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 13:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235862AbiHXLGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 07:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235675AbiHXLGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 07:06:04 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A9D6F24F;
        Wed, 24 Aug 2022 04:06:03 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id b5so16031302wrr.5;
        Wed, 24 Aug 2022 04:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=0xDYPLeehvGBgE/+A99URbf3gOSPMqygYMXHWfUE/jY=;
        b=CjsTt68lwd9LdDU692We+leDenSGd+7JZFn0P+R5pwoop/3iG+20+1HGbrmXuTlv+0
         BuMZTg4mimyQuLiovKQYM3+7mX5GTq/6yiUVIbU93x0Zj8BmpMk+iAeXlJit2xK/sEwg
         cH0lFEY80gg20EIE0Sub70HtOK9jSm13MeusUO7Q4vzFujb1abrYLDg1Z9u2HQvslJwt
         sc1rxBXUZniwcfgwRbQxMrSTYhVrOM63A4aZvgyUxCdNQqipxynbsclIyK645C1zMjKw
         gbsi3dJKcH3Ad0cVyzHQgx09DO5e9PNSRwp3pzv5ZqvbNKV8xp2sdYv5+DeP84MupjZv
         ArNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=0xDYPLeehvGBgE/+A99URbf3gOSPMqygYMXHWfUE/jY=;
        b=i+Gef/Hy3SfWXvfaZ0S1XuEVb8OumU7wFk6492BIBIMT1vXTnbUl7F7fs/50Tk+DxW
         FBU4CW/Bpwa9yKedqMhUASFUMptMZOA/clNe+28SETXWje4B6IpBFpDFiQgYOWGnXcjV
         BH20rzvqSPi2pu2T74VNBseoXO8PiMorHao7JQho2MBXEoHH0GW7BG0h7CySsjYOTlwm
         BQoxGMmwMyzHmuRtUPPjP8FOj0soHTpAg5uvLT2sfFZkW9pxXUOAWDOSuAtlMYezQ770
         d5Q4bHmYgFMyLFKE8HX/JQfegeVWoKf/NUmt0eDJ425tIAyTzxYpsYm0KaJot3tiqcI2
         mS7w==
X-Gm-Message-State: ACgBeo1Zsd/Wn725l//hkjwjJETYVIX3ImW/aoYyiLHXrGJpRHI9gGWs
        oCsTBCa5re+Vk6BXlSA3jULNQ+q5mxt3bw==
X-Google-Smtp-Source: AA6agR69lLi4iBS3LZgPvjBexrOP9BfyC7sZ6Jzii6quJUTQf8C4P/+b9odxznF8cmMugGwrihCw+g==
X-Received: by 2002:adf:fb0e:0:b0:21a:34a2:5ca9 with SMTP id c14-20020adffb0e000000b0021a34a25ca9mr16024004wrr.472.1661339162185;
        Wed, 24 Aug 2022 04:06:02 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id r18-20020a05600c425200b003a603f96db7sm1631569wmm.36.2022.08.24.04.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 04:06:01 -0700 (PDT)
Date:   Wed, 24 Aug 2022 12:05:59 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 000/389] 5.4.211-rc1 review
Message-ID: <YwYGF122K1G/bJAX@debian>
References: <20220823080115.331990024@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Aug 23, 2022 at 10:21:18AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.211 release.
> There are 389 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Aug 2022 08:00:15 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220819):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/1685


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
