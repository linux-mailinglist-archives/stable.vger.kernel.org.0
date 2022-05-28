Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A5B536B1B
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 08:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351187AbiE1G31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 02:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238302AbiE1G30 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 02:29:26 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124CF30F65;
        Fri, 27 May 2022 23:29:25 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y1so6095939pfr.6;
        Fri, 27 May 2022 23:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1r23yEDBEItMDeALyNnUeZNQDnTUxxOQR4RqwVc2CrM=;
        b=B0FC4dIwFHzozZvBrx4RAvX0BOV6dgKfm/EL58CjmFlRZ9fLzgOtSnls3+Qj+Q52+F
         y0yBiiXn4an+PGD5U36HRmdQu0p5ImHLCQpp8OqudpUgoCNYg0Vi4NAg5tnFGto90phY
         jtGqUazRjkvNEn3D3YZ7fbPAnZt5EhzKbqtwG0tqPneq10/apKxhjuBEQwDpn7FGlbd5
         41G/SgDyuKEXZdOmS6LOUhq4wt5i94FQfpF1ej3NRae6VJYNvTsHtr1vkJPJRQO7JISA
         oJpjUCYsUyPglcAFTWHFTpNmt7sH+7mNLswVtwrwl34hQr+eaRTgnaR6RKMKH8z+1kKX
         NFag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1r23yEDBEItMDeALyNnUeZNQDnTUxxOQR4RqwVc2CrM=;
        b=IXusNAlSi611h7fTqImIasIG8QDy7z9GhutIIk98xyLGbASkZREyP6z3V+xG4KPI9p
         7/bE8UbvJCKT9u/cPndmhLu2WumywQgP3eidbaLX+4tJL32J9T175L3SWLQGEP7ILD8X
         ytqaDZEXa4fr/htHHp9i9THTlwA/q4GinDSJj+ANUnODg7VxY06U1rzSYloAWoqC+K16
         BZWWTIhGvuwcbr20HFG1QXoAKWgzjyPcizeX5kBLmW+n9RobnRbxGOZOA0Bnqxxc8ZRc
         dFSYB19sNcF65fBVRI65Lf9tO/vps/gBi0JVKmQ/EtD7QvNyvK6VvBChmtNihhDIjvzd
         cMcg==
X-Gm-Message-State: AOAM533QhHESn53MvbiUdDQSI6XICcPAgoi7ThnZrZ7Ow+imPF16usid
        5iaFbu1TRvSOtzOrfGX+mEE=
X-Google-Smtp-Source: ABdhPJxp1JobKgrBuBQP90h3c7q7+k7/RAHzzE6fP8gFPsj9Dd00KdN8KDjygcP0O1JnTAl15TR7rQ==
X-Received: by 2002:a05:6a00:1acb:b0:518:986c:a7c4 with SMTP id f11-20020a056a001acb00b00518986ca7c4mr30163517pfv.2.1653719364510;
        Fri, 27 May 2022 23:29:24 -0700 (PDT)
Received: from localhost (subs02-180-214-232-4.three.co.id. [180.214.232.4])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902eb8c00b0015e8d4eb1d7sm4631588plg.33.2022.05.27.23.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 23:29:23 -0700 (PDT)
Date:   Sat, 28 May 2022 13:29:20 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/145] 5.15.44-rc1 review
Message-ID: <YpHBQHIDpIRbGTtt@debian.me>
References: <20220527084850.364560116@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 27, 2022 at 10:48:21AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.44 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
