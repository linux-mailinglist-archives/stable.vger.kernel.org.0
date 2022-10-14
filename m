Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8B75FED7B
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 13:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiJNLsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 07:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiJNLsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 07:48:24 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7174723EB7;
        Fri, 14 Oct 2022 04:48:02 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id o20-20020a05600c4fd400b003b4a516c479so3344573wmq.1;
        Fri, 14 Oct 2022 04:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kg5s3R233Yf0xgGrBFseFQZFPYeMaHk+dyRB+WOg9JY=;
        b=itIy519WsxOmRokEGrcCrpjJsrEgO2ul1Fa21UXVYG8aOy5DOhtn9duGA4DXVEwL7I
         DsYwrv9vccI0VXFxzbTGXEb4a2pYNdVOk8a4NNOhEWZY/vJiwfYlr67q15IkZsfX7pnj
         uSbOX+i92bxdGDOKa76AxsrMQ3E/8JvfNYKz7eG+ElLg30G+CoES18OZPXa7s1b/Txgs
         onjhb1swCf97RgQl6abMb4NU/GYzkKFN5Y43+Sg8iXmZvhtLG25pPEKE7d4/CbFgZAx+
         m7pu/c0xNk4ddxPqr6tH1HxSjzQD8msNvtb2t1jpiZ8SpisApkLt8rW6Lff4OWP+ycMU
         ry4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kg5s3R233Yf0xgGrBFseFQZFPYeMaHk+dyRB+WOg9JY=;
        b=vq++fLcetyYm++w2trXoEhnONB4IcdWxOusZuq3ef4+3beN1PjTY5OQv68Et5U6hFj
         5p85iVg3GEFD/pNxb51C5WpADlM3Sk4dXeIhJGSwfssbHD+kMnaeIzLJIs3Fuu3mnqFL
         VLhv3NEEB9jtDOm/pdP4YoEBYMWyG4yiJ1t+SokKeJR4qppatzSTljvo7OKoDnG18qB9
         q5Vkev0LNl9eCaWUNMBMk5Blxfh59Pp0chAa/BB7AArt0Ta2Fbe7ye8ElMXvLmtCw8qu
         8bw4Q+jpaME4Wou7/ysLnQN4NuGhaa32E7YOIlz+sCAHgdGOZZklJsoO9JJhJwY/k/tb
         YHvg==
X-Gm-Message-State: ACrzQf0+x+YiJ4To/n3dBbZjWWKgLQNItIMyD9DaofeAlbg2+wxcEq5p
        iJE+qVHveepmeaPijGKX/0eCiJC0FlM=
X-Google-Smtp-Source: AMsMyM4v9MXC9zYYYI9u+/619YBj6c7CYRvxY8CP784AaGv+2i3rJ82CUNynwg3eEwaHRNKZkbArFA==
X-Received: by 2002:a05:600c:1987:b0:3b4:9b03:c440 with SMTP id t7-20020a05600c198700b003b49b03c440mr3110046wmq.14.1665748072191;
        Fri, 14 Oct 2022 04:47:52 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id c188-20020a1c35c5000000b003b4a68645e9sm6964962wma.34.2022.10.14.04.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 04:47:51 -0700 (PDT)
Date:   Fri, 14 Oct 2022 12:47:50 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.4 00/38] 5.4.218-rc1 review
Message-ID: <Y0lMZquRplpSVNc7@debian>
References: <20221013175144.245431424@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013175144.245431424@linuxfoundation.org>
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

On Thu, Oct 13, 2022 at 07:52:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.218 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220925):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1987


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
