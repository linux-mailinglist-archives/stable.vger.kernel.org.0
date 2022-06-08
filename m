Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80930542D4B
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 12:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236634AbiFHKXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 06:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236437AbiFHKW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 06:22:58 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7C81EEBBD;
        Wed,  8 Jun 2022 03:11:47 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id m125-20020a1ca383000000b0039c63fe5f64so460169wme.0;
        Wed, 08 Jun 2022 03:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PFtvE+sjdjTR4WfMkXireHfiWAN2ebk+j1aP3yHfqKs=;
        b=IeYoHLLXZTcsfY4OvWWaBPI5i0t37LPtnKbBpJWVNflQ4SmN5fHZA9n/qsbZ3PQMnr
         EN3ESrqbB5a7Fm0xfNMa9rJ0xBP++U0u8UHDYD6+ICWrEAo2h8dZ4XSAdJoASisl2+1v
         hE3JQI9VJkWVyi7i+aNlduHKkh0MMiq24/2Kuw020SkQEV8oGujxXRZEjpGdBQ8mnEBE
         dkGsyKjFfh0bPHEqwrrhsawPbqxfUouPVOhhnddGEuVWOFJmYldMiWo6G9usdAdH2qIU
         0FHrvEYnR5pJg8NFdcu68NZCMQ6xPGtpZ8eV2ibx1fz8xsACCWQQctFRNVDzZrAKO31w
         PAoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PFtvE+sjdjTR4WfMkXireHfiWAN2ebk+j1aP3yHfqKs=;
        b=WmMTcyasOS+J2JeaWwaxrexgIqj7eEaJeCd8IfrYWpUobtZLjDePEV9HXGqr/ngMTn
         aGT4PXnVaaS+7QayFwXX3OrELSuzAZu7qHinIzfblWpUz8I9BVz4+u5BVn7uFZXPtOW5
         fab9wUkECVKs3CMrmRg2vBw/UEVqzYePev7Pn2JO+kM5TcV0XGtSbcgX9++EyzYoz0Da
         Z1LJ6/ziC9V9oWKdh06KuHeijP22pi45wAnG7k6rOhAj2DWt1jZn3dDMFZqx/dwskAfE
         AkQyAnQ6pvWJhGpPMG4DsLr3HJsnKzYPZM4YOOwV5t2s94z7j1KOzd4p7EHTh/LvTqLu
         zzQw==
X-Gm-Message-State: AOAM532yrvymON6zvRQApWHRMi4f3wa9GHBHmq5gaKG9+xkWzYvaWclu
        n8eAwqToV0VIBRYLfFxqOzs=
X-Google-Smtp-Source: ABdhPJwIlMTGM5t4blGDk9b9txINiVFwxAtPe3wZIg7xHfnnsdYIT7dOE5fwjHV2kkIdZ0DLD8Wdmw==
X-Received: by 2002:a05:600c:3d98:b0:39c:5cad:ab58 with SMTP id bi24-20020a05600c3d9800b0039c5cadab58mr6333391wmb.100.1654683105036;
        Wed, 08 Jun 2022 03:11:45 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id x4-20020adfffc4000000b0021018642ff8sm20689744wrs.76.2022.06.08.03.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 03:11:44 -0700 (PDT)
Date:   Wed, 8 Jun 2022 11:11:42 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/452] 5.10.121-rc1 review
Message-ID: <YqB13i/CMVGRYDYj@debian>
References: <20220607164908.521895282@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
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

On Tue, Jun 07, 2022 at 06:57:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.121 release.
> There are 452 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220606):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1288
[2]. https://openqa.qa.codethink.co.uk/tests/1292


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

