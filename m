Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF974ACE86
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 02:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiBHB6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 20:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244596AbiBHB6B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 20:58:01 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397ABC061A73;
        Mon,  7 Feb 2022 17:58:01 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id h7so19366826iof.3;
        Mon, 07 Feb 2022 17:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y6LL15sKBUCB5jpcMtEzuUx11A37XJsokGmfmwHbmTw=;
        b=eRcL3Nm87C1GFPXlf9w0y99ThD2XUhUBMCPvD4G3K0WCSoDnhpHlbNxbOfOpviMiea
         VwHLV+119v0VSfWHIhGhN951e8a2EEiqs3oNbWGnjQcWUn6pmO/c7nYriLm9TvLcSwXV
         aWfFyH9bFY1k07MJ+Ssnsb2R+VSxFr1dsQP+9+zjnFHP0rKE9BzGWlEVMUAh2C1MFecx
         JPAV3GUS4P6tswJ3LhAPrSX9pPuB0eZ1MnwkbL57jgfNAXBb2HkYDkOWg2PWMqCLF2TB
         hnem8HhRiFw3z62j6glh3A8VV0qbsBgM3eaf/ZynTcYbipgqR0gEB21nz/GNHRFPSfes
         kJNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y6LL15sKBUCB5jpcMtEzuUx11A37XJsokGmfmwHbmTw=;
        b=O2NhDqgRX6NuZpWLlm05DkWj388qxV0LFZSDFsuPkZO6JeCI9eet+e4OXAgeCl6UZm
         jMoYWqlPT7kSkRT3xLq5TF6xQKQT416DnFHhp6BzTwlc6svL+WRrUETOae69hbv3PiXO
         pRJyY3jS7eSN4FX6+OXYpJQC7p8wNzGRJyvbiNHC7ICnod/BeBf207qjkJmiicrm03sU
         52ECgLkyBUdnoDIcfUYpWdQrvyUCXr0hUJ1W91ewyavyXNAzrQDjZoyrvZTycKeMrOhe
         NKf1rlS0ImKwu+UD770/MJSf7RzTPhANt3Orohp+rKnS5EqKU9oq7DnN9R7LkDLYHu1I
         rNBA==
X-Gm-Message-State: AOAM5338rd2SmQzGxJN5JttCQ9s998yP0L4Rw55EyRmKUQTYiS8uEMS7
        Mh/E4uITxKNZY5nvX/MrbWDfumEHS8gtntaUYIM=
X-Google-Smtp-Source: ABdhPJyL4wkgnkqRf0wUUrIPAwFmAD6zaYr7NnN7z+A/JQrbvNh8Dv4kdWm/XKMy6lhdNgsbHa+kISWa0TIJlVfgy/o=
X-Received: by 2002:a02:6988:: with SMTP id e130mr1129766jac.120.1644285480118;
 Mon, 07 Feb 2022 17:58:00 -0800 (PST)
MIME-Version: 1.0
References: <20220207133856.644483064@linuxfoundation.org>
In-Reply-To: <20220207133856.644483064@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Mon, 7 Feb 2022 18:57:49 -0700
Message-ID: <CAFU3qoYBZ1+nWTjiJUSaYNZMPdU8rfLR0X0vaQyr9kv8xA2fow@mail.gmail.com>
Subject: Re: [PATCH 5.16 000/127] 5.16.8-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 7, 2022 at 8:18 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.8 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 09 Feb 2022 13:38:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.8-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Hi Greg,

Compiled and booted on my test system Lenovo P50s: Intel Core i7
No emergency and critical messages in the dmesg

./perf bench sched all
# Running sched/messaging benchmark...
# 20 sender and receiver processes per group
# 10 groups == 400 processes run

     Total time: 0.449 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 9.039 [sec]

       9.039568 usecs/op
         110624 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
