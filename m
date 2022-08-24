Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7DB59F858
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 13:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236892AbiHXLGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 07:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236890AbiHXLGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 07:06:32 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38ECA7286D;
        Wed, 24 Aug 2022 04:06:32 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id x15so15251625pfp.4;
        Wed, 24 Aug 2022 04:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=f4UzmRb8Rl2QVNEZOgxnNZnRwFBVOMUYTO8qP3ClUV4=;
        b=GMaNQa7VNeQv24xIF09NlVpdip4KmpS1q1XVh8eLj2p7qL8xOUqVk+kuDiTi6jPn5w
         gy7Q9oUCFgsBUox0mnb4d6x6Fwypk0D7aptj6Jpt+n76bsnAoV9fVWPVDylGAwNbIakO
         KdzwwspBdztawg0bBdgW/amzjXk/EWpTCjeAizJ9KpvOSIGJQK6dhIX1LiHrs9z7EhXA
         jHrYbkEqCuBuRfZXrF2BH/5yrKpt+vMNkAdX6YIm5pIC0yb+f7OUEBYyreRn8BPU7lRN
         Iqu26N15qIQTEZY1Kxt58j8S/dbsE9yuzusrzYlSRgrUAsPi9d744WXHpyt1Ej1PGLeX
         GQxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=f4UzmRb8Rl2QVNEZOgxnNZnRwFBVOMUYTO8qP3ClUV4=;
        b=YxDF9vTUQPCtCbx28530MWwAszqdBjzYhP9UHusD9H5hzmkeIVmYu5Fzt7ckAqUYmE
         7ut7g0p06J8rgSABAjQ4u0PlTUsvtURvKWx4DifEAtE6MI0jiewrXdHAvOtO8eESZiH3
         da4e466JRpr00+0U9a7wwCWLQwiNqi+TqNomhGTyejSK6IBQiK7SN83U44TrCT0xAHmm
         liGQ488Co0en4EFHFi5VMjL1nhk8Gw9tNgSkwWWmQQzas6DZNsQg7rWxCxxaYWCFKzRm
         J1a4OaasR/xxy8CuAHDFj3/jUQVAs/Q7+Ct9It0wAcbmJGGsttK2uIDGHal7md+7WPKc
         uncA==
X-Gm-Message-State: ACgBeo3Sth3f2FrlBwikco/z6nVdF94I22CkZmlnwfvmDp0agIbHooVL
        D65BpbU2JvRP0XfJvGa0JvU=
X-Google-Smtp-Source: AA6agR4oMi4kW4t7fMyVqPf90aTAFnftohdbKpUEU9zKBVuzBznqDGIZxqvmUobGtqmkvElEAIFQHA==
X-Received: by 2002:a62:1c56:0:b0:536:4f4b:d99e with SMTP id c83-20020a621c56000000b005364f4bd99emr19223146pfc.64.1661339191641;
        Wed, 24 Aug 2022 04:06:31 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 123-20020a620681000000b0052d417039c2sm12667482pfg.133.2022.08.24.04.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 04:06:30 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 24 Aug 2022 04:06:29 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/362] 5.19.4-rc2 review
Message-ID: <20220824110629.GA852409@roeck-us.net>
References: <20220824065936.861377531@linuxfoundation.org>
 <20220824105354.GB13261@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824105354.GB13261@roeck-us.net>
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

On Wed, Aug 24, 2022 at 03:53:55AM -0700, Guenter Roeck wrote:
> On Wed, Aug 24, 2022 at 09:01:14AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.19.4 release.
> > There are 362 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 26 Aug 2022 06:58:34 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Now I get this build error:
> 
> Building s390:allmodconfig ... failed
> --------------
> Error log:
> In file included from include/linux/string.h:253,
>                  from include/linux/bitmap.h:11,
>                  from include/linux/cpumask.h:12,
>                  from include/linux/smp.h:13,
>                  from include/linux/lockdep.h:14,
>                  from include/linux/spinlock.h:62,
>                  from include/linux/mmzone.h:8,
>                  from include/linux/gfp.h:6,
>                  from include/linux/slab.h:15,
>                  from kernel/fork.c:16:
> In function 'fortify_memcpy_chk',
>     inlined from 'copy_signal' at kernel/fork.c:1716:2:
> include/linux/fortify-string.h:344:25: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
>   344 |                         __write_overflow_field(p_size_field, size);
> 
> This is with gcc 11.3.0.
> 
The above error is spurious and not new, so not of immediate concern.

Guenter
