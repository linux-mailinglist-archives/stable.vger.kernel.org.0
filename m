Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC72751CB83
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 23:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386014AbiEEVo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 17:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386011AbiEEVoz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 17:44:55 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B28F52B06;
        Thu,  5 May 2022 14:41:14 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id e189so5690799oia.8;
        Thu, 05 May 2022 14:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6fkvWesuqVSeQrv7o/AhOsdNZtds9JzjGo6Hvkg4xtk=;
        b=C4/3UM6gnhghXmp+ZKWYnPdzmbSn0qgXkxImylft+ABW35qXiL74sUrGlFW01aEx51
         Q+KwBzX4tc0oUfhaMH7muodHS1o42IZZHJlyq1MEkBDwINFMOdWB+CZBXuYscxsxtEiZ
         uoWOiE3yt+W7MP3kVz/wk1FUAtUP6Ipaa/DI3sneIydlPwAJHTuS9HSUepYs2SSPXxR4
         WdKUgfQqf3CIKDPgwr0JCSlVvGUv+kq7gl6ptZ+jl4me/zFojTaaN0eDj2fs0qBCkDAL
         05y5jBveAVTMNjwhVG8dC5q3Mq2KWmVL1K/8NVa3lB3DNwZ0dYOx6TmtRzmUc1aoWPT+
         3Ksw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=6fkvWesuqVSeQrv7o/AhOsdNZtds9JzjGo6Hvkg4xtk=;
        b=6Feio0wVMOq/LaOHdTPPAyOIzFLq8f4wYbah5vWZ0nGOJqozJiWepBoN4/0duw0uLz
         eIVnPyhq0an8r+bFHbaVOcVenVh6Q2+kivXbVAu80xCcbFdJqGN4Crlf7CS+HAJH1YTI
         1UXTo7uWHNPFFR+PsJFJ1WTvRX/kMwqh2cHsenxTscvvm3ftX5g0OKQN8Q9qVBFjP3RI
         VnjCxAsZO9/Iy+b57BcsQ8O1qAuTEusKvik3ea6lMNAJsI450WkuWjriacyfwjAQ/qv6
         BeH36uAniX4LMJer3cCgCuShG/6r3GhzVOn4xMUNWXuWLSsW8Zn6+GHKLGTRwBFh3/yW
         skKQ==
X-Gm-Message-State: AOAM531xoD9mYuufiXeXz97d4vScZDG5mNH/1PXi3oDozGObHxKsGNEm
        QljV8m6Z4FmAWvQOhatAgYg=
X-Google-Smtp-Source: ABdhPJyJzpkpDN5wSZ+ywjNRGeIBokULB4kjj1j/pENvCB9ckg5BSZK2gaKsziGOSifRT3xCfRnVAw==
X-Received: by 2002:a05:6808:118a:b0:322:35d7:77f2 with SMTP id j10-20020a056808118a00b0032235d777f2mr3451707oil.79.1651786873815;
        Thu, 05 May 2022 14:41:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k1-20020a9d7dc1000000b006060322126csm1001613otn.60.2022.05.05.14.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 14:41:13 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 5 May 2022 14:41:11 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/84] 5.4.192-rc1 review
Message-ID: <20220505214111.GA1988936@roeck-us.net>
References: <20220504152927.744120418@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
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

On Wed, May 04, 2022 at 06:43:41PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.192 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 May 2022 15:25:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Guenter
