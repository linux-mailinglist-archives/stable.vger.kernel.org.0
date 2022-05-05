Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2730251CB8D
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 23:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235818AbiEEVql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 17:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiEEVqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 17:46:40 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD6252B0A;
        Thu,  5 May 2022 14:43:00 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id r185so885494oih.5;
        Thu, 05 May 2022 14:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QdqHpvfU7yJy8/zWQX+UqTiWTPsnfqhOap5+E38JDKs=;
        b=GD4VshbpPgbSon20B00UXrZvspIDct2GJ4tHMnCBI70UU6uk4hMTzSB7SCTDJjgV2p
         Y03ocm7KnENMFiJq55VgjJkTls8G3wQAfJVpOfhjF/XJ4c/py4AivFbomw4gPCGLQ/b+
         xVGt8sUcrLeQYi8/2NoaNTueUyzsBv3z/2dc+aT9QaJiO1pKfroiJsaLeuBi5kBZWgSN
         1l+OMPUAvxssUuJvOsP0xmYguGcFCNsHUrmT/RsG2aI9zL8r3vSHtxmf1a3pKIBP/3lv
         kMENbMOfXvFBy5oDkflonEsKD0BhkF11nStahOPqfVGOl+O7lDSKWUV3smOk2gFS3mBg
         jYHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=QdqHpvfU7yJy8/zWQX+UqTiWTPsnfqhOap5+E38JDKs=;
        b=Hx07HUW+3ro0V4pwj+lWCQdggpckCY5TgEiGIP7qgH8MkwajJOT8TYlX/4EqlI2Ndq
         bQdnb8teKLqx+PCODK26Lfesys338FmT08yscQTot8bNOqLvOYWD8DtRPQL4+DYdkYDL
         i2vn9WnSKL73gLCJV3zUihinEKvUa13cZNn241kbYVjxbMyaRNNJ79c/bMySoEQciANy
         X/9Kg/nzoluAEQ/DYZRniAgejE7VNzDhbe39Mh4GA0VW2OJ8q69ZyWhoJobNlPtmd1fN
         4T7hAHzcs6NIffYAoGa9fmkgiXrgy7oa9S4ijejdTr6b97DrnXFDuysz92Jm3nUGVys3
         oAmQ==
X-Gm-Message-State: AOAM530BtbeBnslCS3A20dhBLrHcv+KJANIfCatiOXbgcaHHSEHVRnNA
        90rFVsNg+oWswi60Vv4FTtk=
X-Google-Smtp-Source: ABdhPJwOIP5wD+VbF9YjBtnNzfuUosZueHMMV/T+pYRm0yBZJrIImUeAveo7Ao2YB0wlgsIpAZmd+A==
X-Received: by 2002:a05:6808:1b29:b0:326:4992:3d96 with SMTP id bx41-20020a0568081b2900b0032649923d96mr3512667oib.42.1651786979788;
        Thu, 05 May 2022 14:42:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p1-20020a0568301d4100b0060603221270sm999430oth.64.2022.05.05.14.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 14:42:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 5 May 2022 14:42:58 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/177] 5.15.38-rc1 review
Message-ID: <20220505214258.GC1988936@roeck-us.net>
References: <20220504153053.873100034@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 04, 2022 at 06:43:13PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.38 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 May 2022 15:25:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
