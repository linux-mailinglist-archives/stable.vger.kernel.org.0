Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D7C6376B5
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 11:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiKXKok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 05:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiKXKog (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 05:44:36 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81DB171CA8;
        Thu, 24 Nov 2022 02:44:32 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id x5so1868776wrt.7;
        Thu, 24 Nov 2022 02:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kpj9pPuHqShUQAecSc/JzvCTOVveZeOXiu5KZcFREsQ=;
        b=AQdPfz746R9VWSuTDQo6KifmQDSV5uNHO78N4bkrnj8RrYAM0R7N/LFHcoLYjFI0Gk
         3/iyhT15FXlFWnOX2yOMdyPrQ4jScRIDkUFRTXPMeth3jf12MWnn9jvJP/gIMVXK8W3k
         ehBi7pfpqO/kC0owC8KYq6mYtCmQ+OtfS/bBynjAaqcxY52PK5fLrf+sILsT3yPN9Gi+
         rQO6TY7Oghjzh65WUhqjI72djijR4nNFIXJgbhAp8vAATDJZyY1ymEndGqavaNslzZ5L
         1xGQb1I1U2ixAtbs8gOYy4OhR0pW8FYsygh+zjvzpJYIvBHj97eQ/c1qOn25s1PP05bk
         AQCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kpj9pPuHqShUQAecSc/JzvCTOVveZeOXiu5KZcFREsQ=;
        b=sHZ0+yoUFHt0n2LuvovA3Ha6L6XG3YFIqJ0qel06RhJrMpqSeWX8EhjVoFldfvWx+B
         HfxxZk2X7toaFweQm+woPOgEnDb96zareRgY7WWYLrQns2vnkcsh3ytxm0VpzX+1pXmc
         ww2o+Up48kfF5xiHlsup/Kh0sK6k+/0IW4Tc/7qNVfLAwYlurzKRLtkQmDGuF+SbiRhA
         sQmW7jx+UqEgd/O45oe1jZuU2b3GQ0RYv4KVSMWPlEq8205AvrC9dMo0KeenoNgpk97g
         CQ/BEJKHxS45YG+dQpsI61FFPWgxZDIV7yAYToAUmXsJMMiiFzgHKbhp1gQBRb/tzLip
         dUgA==
X-Gm-Message-State: ANoB5pm4DudW63MZAtl6Rn6t1ALLkaVlnDlaipJhsMHbTUxAa2m3Qkci
        JJH0JzA43O6uE2n4duNvFGA=
X-Google-Smtp-Source: AA0mqf5hmF3TvbQzbLSPgJ2JSMFrt/NZWTXbt4pQPZcOL5pIEXbca2U+vxuIqlAgmZHJ7EYZCk7pvA==
X-Received: by 2002:adf:ba87:0:b0:241:c471:72b4 with SMTP id p7-20020adfba87000000b00241c47172b4mr10709162wrg.238.1669286671103;
        Thu, 24 Nov 2022 02:44:31 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id k21-20020a05600c1c9500b003cfa3a12660sm12305424wms.1.2022.11.24.02.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 02:44:30 -0800 (PST)
Date:   Thu, 24 Nov 2022 10:44:29 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 4.19 000/114] 4.19.267-rc1 review
Message-ID: <Y39LDT+Du2XVqnFl@debian>
References: <20221123084551.864610302@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
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

On Wed, Nov 23, 2022 at 09:49:47AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.267 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221016):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/2206


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
