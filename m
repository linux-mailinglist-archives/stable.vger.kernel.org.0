Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80918526ECC
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 09:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbiENFfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 01:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbiENFfd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 01:35:33 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A37C32;
        Fri, 13 May 2022 22:35:31 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id u35so8707806qtc.13;
        Fri, 13 May 2022 22:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=P5EBwPxO7F3Bf/qG9NarzoG73cWYhwY7BWfsZP4MJDI=;
        b=g9hAs8IZE11uKkgjwp/fBSGfzPSlEhlsPPS4fBbrOKAyEW1DNBZvgT9Ti3hmIlkMiD
         rA7aZXDMD+LhXv2pf7aF1PVRMiAwNk6KDn5CGJc9u6lfzhnBnHDSeKN9xqMZAOgwFRa+
         edJGnAqauPuogSXdETyT6KyugrzNISixpb40xS5K2kUNBZLpacO9oW5RIysC3ZjPvFUl
         8g7VNweIlS7kFVUmoNUfqbQ/wdWaY0bVuk3xMa6WJU3/8rYWU0IfgdPfqItXW4qMhxY6
         LhJZGdsPdVNr2KxQJN2BDlaGEjNap2PMJxS+gyzD6m18XTRWfHesPM2vSxVKIoz2wPxm
         6gkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=P5EBwPxO7F3Bf/qG9NarzoG73cWYhwY7BWfsZP4MJDI=;
        b=zAaUJgd330pUv5gBDuzOM50YQTk2b3O7/E0o8u5eIpLsPX0jRpSoQZPALNcMXBdbwd
         9uuysTRQnVkMy+s8XgG0YcomUzpptoxq7wpLCqLFKp2IhiXo02SyzNLFWnq8t0La0S1j
         hKYPZ9VoBfchuyLss0kunRDzmwKyJKxna/H0eEmPgz0FG9tHONmCifaX9d0MBIVEfn8Q
         Tpj5F/BXVh0kwcEGcLw2GMEO/MsWL78c1mArPmzZTJqPgWd3yx4lq1gpLdns0V2J9fhs
         z4rHgEBO7Lc4ox3IdLU36XBQz09UMaEMWqwiy4CJ6I9sjXrvlNZABVTn9X+gSx/GO+Go
         Cc/A==
X-Gm-Message-State: AOAM531SD7BfpiwQXuqEIAVSt8BVhnh9e0w0zyqrJFsLEFWfgixB4G3a
        c2s5rybg+7rmEQkpP9FZfOMx97/cZ+iho5DmvQs=
X-Google-Smtp-Source: ABdhPJxPYd4/dWJxlNdFCA0BxZiPQInT3hsXNXSPIB5xEj1MWtoYkkpLuFdRgQY5f/9eR6GsZqDF7Q==
X-Received: by 2002:ac8:4e50:0:b0:2f3:f51c:de64 with SMTP id e16-20020ac84e50000000b002f3f51cde64mr7577224qtw.585.1652506530388;
        Fri, 13 May 2022 22:35:30 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id r18-20020ac85212000000b002f39b99f67csm2387116qtn.22.2022.05.13.22.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 22:35:30 -0700 (PDT)
Message-ID: <627f3fa2.1c69fb81.5e14.dfbd@mx.google.com>
Date:   Fri, 13 May 2022 22:35:30 -0700 (PDT)
X-Google-Original-Date: Sat, 14 May 2022 05:35:27 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220513142229.874949670@linuxfoundation.org>
Subject: RE: [PATCH 5.15 00/21] 5.15.40-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 13 May 2022 16:23:42 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.40 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.40-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.40-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

