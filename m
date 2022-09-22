Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B7F5E68B8
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 18:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbiIVQnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 12:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231714AbiIVQm5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 12:42:57 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168779C2E2;
        Thu, 22 Sep 2022 09:42:30 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id p1-20020a17090a2d8100b0020040a3f75eso2724643pjd.4;
        Thu, 22 Sep 2022 09:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=WcbcZz/pZufoN8PMbCpmX+UMj1kBvDZcSOX+j/VnA/E=;
        b=fg/4Gt47SxgsVOW+noU5GF/vQNnB7g8u8j65byTkAaBQpKa8Xn30IG92MwBb/hOul2
         /dFG8FIgrFEjmI089rQ0IOYfVU1N3iUcdO9QfW8KW7fYNLGYZVcdFuEN4i3Yg55zwj65
         XYKINt1N45rpFInpCpAVihUmr44liWopv9vvT8urgYZ3wI1EODAx5uhNO5XDkup8zwJN
         6t54nHA3sssUqO7l6THphM+Io5vUy8pD4BVmMXHUbbUDsXrPUNqeOTI3m2Z5BDCR9o/T
         LdkRGkjHMylnKhoPcN9okd5iJ8H4rlP2eypwH+5YazX+jPVmT/ZKpa9nBVzXxkje4dTf
         XPgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=WcbcZz/pZufoN8PMbCpmX+UMj1kBvDZcSOX+j/VnA/E=;
        b=uHoymC9laDlnl8jfeqZEPSBjxGy/s7w2DiXy8jeX21s7Kg2AJyJm6vFiq2fL1Z77aE
         X75lrCMpPQlVqpi/4Rfth+Bw1m4mR32eCzTWnwBGIlCe1gEZJoGYj5vkyr27fPHZZK+v
         xsMilC4u7fkQWNj+GtV+0YTVrxI9kJFGwsshzpU0U3gTlGHfOT+V4XWmhx7rkscJEhF0
         9/vSWHj2eXx7ULGC98pUNuuoVxnf0qrhVxuPDBgGmoJ9HOXSVlVPrIHrcbiN32gshk01
         FPQZw2Z2jxJ9xnxofGjLKi5GQiJdMmX2r46gol2pW0gHw4n6dagD4/7MCBg1xSubKimZ
         WnjA==
X-Gm-Message-State: ACrzQf0lm8dtDj+3TFYgiU2jg/3MW8LSyJ/yppBAkcl8u+EwtLt60RIs
        kSa5alYSTy0scdlOyCB+Fcwpx7pFPS69vA==
X-Google-Smtp-Source: AMsMyM45lq27Rhd07GwtDPbMw14pSQ4GDvD73HZu8n/FutKwjMpmmOV/TZWQ4ZX2eqaSke01he3P7Q==
X-Received: by 2002:a17:90b:2242:b0:200:1c81:c108 with SMTP id hk2-20020a17090b224200b002001c81c108mr4528430pjb.89.1663864949607;
        Thu, 22 Sep 2022 09:42:29 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p19-20020a170902a41300b0016bb24f5d19sm4249661plq.209.2022.09.22.09.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 09:42:28 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 22 Sep 2022 09:42:27 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 00/38] 5.19.11-rc1 review
Message-ID: <20220922164227.GA1138811@roeck-us.net>
References: <20220921153646.298361220@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921153646.298361220@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 05:45:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.11 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Sep 2022 15:36:33 +0000.
> Anything received after that time might be too late.
>

Build results:
	total: 150 pass: 150 fail: 0
Qemu test results:
	total: 490 pass: 490 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
