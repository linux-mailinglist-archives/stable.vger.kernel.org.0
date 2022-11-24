Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A03863707B
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 03:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiKXCg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 21:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiKXCgY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 21:36:24 -0500
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3F867124;
        Wed, 23 Nov 2022 18:36:22 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-142306beb9aso561828fac.11;
        Wed, 23 Nov 2022 18:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lKu6dFZkege7gh2XFt/Jc2wITLyP+TssjbYd/0rYDtA=;
        b=IugpXe4bF5HBztBSSTS9Bdc9NxzYLyWj1yftjniondPennQgrpCb3uHUwTUh602yEN
         4ngb/F7oVyfDPVTLsJ0WoH5Kl7AqcYpevOveGts9KHQlsTWieg/jjZC6PlBIJQVSh56A
         XgFe020xmpqkQF2/J0IG5cuvwZTRyIaCmsMWolUr1ngDGYPqJj5sUI/TW95Y4idDu+iX
         RgxiC6RwEHm3mWhV1CSasFoDKI/xnnOnQbJwOnTBY++QQ1wY2jjvkYdaA1vVHXGQOWOp
         BGkKVssQd5gO0SPq0qpiBjZGnZaYiCvoMhBqkZEzLRBTqNg89GjBtY9VPPagt5x9m0Bg
         lF9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lKu6dFZkege7gh2XFt/Jc2wITLyP+TssjbYd/0rYDtA=;
        b=aFAtkFTbMMJh7pMUbkBCZgOxt9WUGWBvmkI0FYpCjV0lrUWUUhTsMYdzJ8yxfFNfLm
         b9HPkRMXgtCA1P8LK5B9wEjgtKwR8G1cR5M7wsnUsECRZm4uqXDmoDmrOaL/WZEshrSE
         KItVUm8ViMZdiYQ70tSD+X9SDuFCpDRm9zUjKNQJewSJuNFDYUJiT76OzTen5Lf34516
         b4KN4PRyQdqu+w1C0+hqaYSEf/tPzJj4AzJSJj2dleHBFE0kMIlrOkw9hhQf7IbRR5/j
         IXZsTEzehZp1qx3bFvZqHdHP3lF9Opwnn5H0s5PAQrU6XUDzsXTanhOB1/ElLXe2yoio
         xQ+w==
X-Gm-Message-State: ANoB5pmHPKKI2qQIra6DyBUryCIHBUtt6R1sir5s4sfaQPNQZXBQ+6uw
        ydIZKdRF2FiCye6AsrCahsE=
X-Google-Smtp-Source: AA0mqf5B6Zjb/dYephIVdV9c5Iu6/OprCrRtwGjwTifMcC3Hp9MroBuNRg+lVMsfU37yezcroHkhlA==
X-Received: by 2002:a05:6870:c895:b0:13a:dd7e:7bda with SMTP id er21-20020a056870c89500b0013add7e7bdamr20135013oab.222.1669257381679;
        Wed, 23 Nov 2022 18:36:21 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h16-20020a056870171000b0012c21a64a76sm5950oae.24.2022.11.23.18.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 18:36:21 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 23 Nov 2022 18:36:20 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 000/114] 4.19.267-rc1 review
Message-ID: <20221124023620.GC2576375@roeck-us.net>
References: <20221123084551.864610302@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 23, 2022 at 09:49:47AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.267 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
