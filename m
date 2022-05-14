Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F340D527244
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 16:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbiENOxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 10:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233564AbiENOxm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 10:53:42 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4D1344E5;
        Sat, 14 May 2022 07:53:39 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-ed9a75c453so14028452fac.11;
        Sat, 14 May 2022 07:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1r4u5fajpfI86Wbi3BufLqEvtmP17yYKjtYfVNbXrEI=;
        b=YBdS9d4YwhcJcTecBsq96c3YzTPmvBy0bEGJujP1qDT0cdiOc3qKOOpW2ZjqLiU42U
         Cg4RSpb3gIWzmkx+8ueCw5I+i1Xj95XeKrPvINAPo81/IFYJlOqvQGvKPI384wuq5Alk
         0OtfNtr9Q4xZTZO8idWyVzf9cbuq2CMoaBsAHReZSjH9sz+jKcBqVuNpRPc4nH6gsqGw
         kt8vmAb9ZAYBOPGm0QFJFd53m6mq0GOH9XR5dGvWsHqefWOAJUdCnnt3dHnYLYsHc4p9
         WBSybKhntm/EY1O7+ICAyYwl0Vn0Ta0VieN0rd+peFSg1ymVQCcrJy7pTRYsV0tw33C/
         UC9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=1r4u5fajpfI86Wbi3BufLqEvtmP17yYKjtYfVNbXrEI=;
        b=FS/z8CGBSfd27lRh2v+YNjpRaTZ1zGowKy1ttyUGh5o8Y7icGFCFtr1il1Sf3F2bvw
         SnfFLgjXMAA5k7SxIbHioVGbzXJhXG/80dwZ3wwxkzSdCAf2TyUXtx9oup0Jr6Tt26NC
         kFXRKsPQ1HnTu9j8rpfSSwVs+udjj65AYWri5w908/vlW3kemUndgYidPjEtu3vHYU3O
         wTPapyeBWQjrd6gdTjqbDF3/asMh9odCnfpSBhPMG+e8hOYJQUkRnPNIilIk8PsN7IxN
         j7EAIYuiAInYrpirFyatSgeaiUkAo1YrcIRxrzZNwMiV5It12GmYIVJzYJwOFO8HdKNT
         slQQ==
X-Gm-Message-State: AOAM531RyKElI7rLZ8uelM3gIXoWkXbVRCp0B38LvOpOzqVadqgbT5rF
        o7oHEu1wktzB82uzK3CGeyg=
X-Google-Smtp-Source: ABdhPJwGuyash+uRgccyOpgzTs71J3oLdqTp+CFb2S/poMMoH39UfFYqZyMYQf6vaK7E63lN2O8aDQ==
X-Received: by 2002:a05:6870:55aa:b0:e1:f826:c241 with SMTP id n42-20020a05687055aa00b000e1f826c241mr11095073oao.84.1652540018675;
        Sat, 14 May 2022 07:53:38 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bi5-20020a056808188500b00325cda1ff96sm2319528oib.21.2022.05.14.07.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 07:53:38 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 14 May 2022 07:53:36 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/15] 4.19.243-rc1 review
Message-ID: <20220514145336.GC1322724@roeck-us.net>
References: <20220513142227.897535454@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513142227.897535454@linuxfoundation.org>
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

On Fri, May 13, 2022 at 04:23:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.243 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
