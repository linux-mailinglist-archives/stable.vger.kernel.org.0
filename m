Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638FF6A1596
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 04:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjBXDnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 22:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBXDnb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 22:43:31 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293229757;
        Thu, 23 Feb 2023 19:42:53 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id qi12-20020a17090b274c00b002341621377cso1489395pjb.2;
        Thu, 23 Feb 2023 19:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3KYhp7BVqrVyOrznEFnFb4ZtNJLmanhkAsoLMLCOK+Y=;
        b=LPgJHuS2FiIrAtIYRxjA3746GLb7RxOpWi0NeNzKvSc4+BMO0RDlTqhT7JYLSsdiET
         1M3I1Hx1TiJ5Z1LbLl2JGlILhZnhMJ9RtPQLP22K1pCn+Ez+JKVVOH8qr/+0PfcvzUO/
         wkf3acD71POeh4SIT3rcTtSvt95pqRw5740wA65tJKx5fcFjtii3NkdqApoyDU6clLSK
         RctLCp0ROyxqhAAqjcOFIJTLe9wZXYo69Z9V3g07boIb++mbZkmoE6I5ADaMJFaU8xaO
         S5cqXO773bfepkOJ8pzrckkOYDWLAmbvdKSrWoo1Ze8yMbO0tY5soIdSGnxzGXyoSd1x
         kOOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3KYhp7BVqrVyOrznEFnFb4ZtNJLmanhkAsoLMLCOK+Y=;
        b=t6/tJmVcFcOgRWgYt/DekBcdO9YtkyJnCXClZ9F7OYgJo8QFxRo+pc47O1yoCWFLFe
         TIJTRmGq3heY7hhyHi3ys6nmOlUaqb6bW+uDJFRHQCay4cHVnSLXyOiQcfQgEoynFmHs
         rybNhw3eFzNWQrqBosO/y3uTgQ30dp9uyad7yf9239m8PghDas03dGBz4/0jyDBuLyvN
         rF8Sye3iytkOPG6P6SFF6wlc9+mcoDSO3M7ufUXskSZDkU40UCQMKOXjVPl4a85pIZVX
         YOHxM4ofcowDRvo9eR+WEYsMHS1vvx4kgkiuCgUfH4G0LdU1q67iDMxxNn3mL6A7OsJu
         g+oQ==
X-Gm-Message-State: AO0yUKXP7h2f4pShxG2F6Fz2SjuLaM6GC8uv5ub2LYi4ol+htA38kr24
        2vVgrp1hC13+NIDeRkHxR68=
X-Google-Smtp-Source: AK7set99C8IMLIReuTwpFk7MxtnjBQoYQrGFX5q06LsSMcZL/ZLPFgDBCra0D9aUERuIU+Bc6UnWXQ==
X-Received: by 2002:a17:90b:4c87:b0:234:b35b:f8e7 with SMTP id my7-20020a17090b4c8700b00234b35bf8e7mr14449372pjb.7.1677210171873;
        Thu, 23 Feb 2023 19:42:51 -0800 (PST)
Received: from debian.me (subs02-180-214-232-89.three.co.id. [180.214.232.89])
        by smtp.gmail.com with ESMTPSA id 3-20020a17090a0f8300b002340f58e19bsm424520pjz.45.2023.02.23.19.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 19:42:51 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 5800A106506; Fri, 24 Feb 2023 10:42:48 +0700 (WIB)
Date:   Fri, 24 Feb 2023 10:42:48 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 00/12] 6.2.1-rc2 review
Message-ID: <Y/gyOLu5VtE4MbTO@debian.me>
References: <20230223141539.893173089@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230223141539.893173089@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 23, 2023 at 03:16:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
