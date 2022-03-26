Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B724E8140
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 14:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbiCZOBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 10:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbiCZOBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 10:01:17 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF72C49921;
        Sat, 26 Mar 2022 06:59:40 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id h4so14239468wrc.13;
        Sat, 26 Mar 2022 06:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j3g6QJXfHg8D2EN/cwexEeNaYf3LM23ijybrooX6Uek=;
        b=JZ8fHpUzMBC973g28QZB+lGCDiFWaHhPM1AuGWDCiGkK7QqwSUGuN/5kg7YiSnj6/i
         9H/nYmuofWBhFWpu7GkPsftXDvuX+gO3Qy9YX5wwagg2ZLbYI/dLxsMNUZvq2mnYsHb0
         +ROivbmonSD6HN/hUhXkGN9SjSstSSwM4X8o6J/2jEYdPYM6aG1pINIE/opHyVgVtYo1
         cNq0gBh3OeP1+PlAGunP+G5PejIqH7/FTfwFKPwQFolynaFn+cw1UA5CmhbucuPzaWdc
         +EqgoPB/0phq3/aZmNuD8OId69KkyPFdfBHpyosiND70mOQrNs5xeZA6iIqLw2B7/jvh
         9kPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j3g6QJXfHg8D2EN/cwexEeNaYf3LM23ijybrooX6Uek=;
        b=UpkKOSR/Qj85ros3L4pnP8Nc9U4N/UvUqy/basHrZecmp2Hcp92cVvlI+YjpV2ls6U
         kHHX1yCk8/7HGb5kBjWusgKcJr9t4TZInw4HxwL8pOYZ9fDyUCjNoIKGEv5l0uw9N8Ov
         itRlDMddZHoyxVqWV1p7bmwFkYIBQksZWSFrBAqvvrid8UQgSHtNe+QaW+ZOfK31ns+W
         z4Cp9nHuudbCRdHyhnPJjC/2UG0MfZcii7hG4ZHwL389BIZmg/eWl7/+HGyglYaqA5IY
         igfKvACRmHIIy7SYjj2FMOY3HA2wIJL8LBLi/z812HRIH6UMpgKgNbok5uOlIrDXZBox
         Kfow==
X-Gm-Message-State: AOAM53323ITXBloP0WZEcrmy7L8j/InIIf7oRkcdBj4gXmObI0ryvZ6a
        CpGUm7EmNeIKzSS2T/B3kI4=
X-Google-Smtp-Source: ABdhPJwebd82dMVAcszH9u4I9tjyk3K7gb96q37KDtxOR7u1oDeDwh4ngzxM6aD7v0MXoZkOjfU1Nw==
X-Received: by 2002:adf:f24d:0:b0:203:ee8a:2160 with SMTP id b13-20020adff24d000000b00203ee8a2160mr13170330wrp.497.1648303179332;
        Sat, 26 Mar 2022 06:59:39 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id p8-20020a5d4e08000000b002054b5437f2sm7404602wrt.115.2022.03.26.06.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 06:59:38 -0700 (PDT)
Date:   Sat, 26 Mar 2022 13:59:36 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/37] 5.15.32-rc1 review
Message-ID: <Yj8cSFEiNtEYpRww@debian>
References: <20220325150419.931802116@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325150419.931802116@linuxfoundation.org>
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

On Fri, Mar 25, 2022 at 04:14:01PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.32 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220314): 62 configs -> no new failure
arm (gcc version 11.2.1 20220314): 100 configs -> no new failure
arm64 (gcc version 11.2.1 20220314): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220314): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/943
[2]. https://openqa.qa.codethink.co.uk/tests/945
[3]. https://openqa.qa.codethink.co.uk/tests/946

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip


