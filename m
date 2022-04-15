Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9396501FFA
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 03:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348439AbiDOBNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 21:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348399AbiDOBNJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 21:13:09 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F40449F30;
        Thu, 14 Apr 2022 18:10:43 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id r8so7197776oib.5;
        Thu, 14 Apr 2022 18:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sGKoZaQdFRk+sG/ltITJHi12TPhdXQPMEhR6eRRjlHk=;
        b=MgUjLXgo9WmH+1UYXDoAzsHI2EYXUj544H4YVotXMxgB4BuB04hTJzq6q7jzVZEuMs
         h4F2p9Clc2rLgq/s+I8UNim9thJJfG3QV4UtzB3lBjBJggZGUsMEyNZ5Z5A5fDtiFbTa
         FNkZZQVR4GmPboMh5Ek6TW9kcY5vuwcKzH5JmXvp3XVjMWq7kFrluvMbt+7B+DmnMbbz
         Lz6z6Xp/WoFAihOq/v0fszCkjWH5jN46l5GGb/u0ijVbKj/OvZGzVYoXW1zGsbTv2RwX
         mCZzsvtlE1hsJSZo7OPuDlnYbMMs0BqgKcedclsHN+ADmnA/9EZhAr3OykwwhZf3MWwY
         vFUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=sGKoZaQdFRk+sG/ltITJHi12TPhdXQPMEhR6eRRjlHk=;
        b=UTt6oZb7H/rSoYd/M3wI7dVwgLYNfkITtYh3AJ0MYpsQwBnpAVVhZp84ew7qs+BP4R
         So7b7RrxAgRjRGW8dSwsK4KhlCdnZTojYs7bAqgT16E+FDh9koMIRpmbRhV6qafs1gxs
         XeKoPw9YdZeCxyaVRL3d9UX/uviJDJlxyxCmZq/r0d/fahQkANp7Xk899CdluhbtS1Gn
         5coKreZP8c8ugQMufZDb5joYyNZHKjuMXFaTxfVs3bx1YMj1Wb1mCYtpJ93tjqUN/bH6
         zYUATxrXNzy5qN2UavVcwgErUVSOJhmX0FXRzj/MLNq5tYyXTXaxmHJ3BXcjpIgTcDwG
         x85Q==
X-Gm-Message-State: AOAM532Ise4p96CJelvnZjhVIUA5jyEoAqo42SkjTwzKWQHrbIYh7ZiQ
        A+FhmVBdeBWwwQz06GOP9g0=
X-Google-Smtp-Source: ABdhPJwRoGoRzA8CvP7gP4hpYeHl5aQgcebMKT9RWENMdOiZFp1rQtw+N58+EELJLMtlVBiftltrEw==
X-Received: by 2002:a05:6808:1115:b0:2ec:e78e:3fc0 with SMTP id e21-20020a056808111500b002ece78e3fc0mr586834oih.207.1649985042404;
        Thu, 14 Apr 2022 18:10:42 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l33-20020a0568302b2100b005cdad9100desm646524otv.40.2022.04.14.18.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 18:10:41 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 14 Apr 2022 18:10:40 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 000/338] 4.19.238-rc1 review
Message-ID: <20220415011040.GA2791443@roeck-us.net>
References: <20220414110838.883074566@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
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

On Thu, Apr 14, 2022 at 03:08:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.238 release.
> There are 338 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
