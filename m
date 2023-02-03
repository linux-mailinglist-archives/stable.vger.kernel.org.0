Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91D168A029
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 18:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbjBCRSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 12:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233740AbjBCRSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 12:18:41 -0500
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C8522DC0;
        Fri,  3 Feb 2023 09:18:29 -0800 (PST)
Received: by mail-oo1-xc2d.google.com with SMTP id c29-20020a4ad21d000000b00517a55a78d4so546970oos.12;
        Fri, 03 Feb 2023 09:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6Sf5BOgBYoKexxio9oBRlmrzfjBVgiqa9tGRvXK5Y6M=;
        b=Jwv74C0IllnWgjEJgrRBHp8ZGd3of0X0grxtfUAn097Bu9LwwJdIlFMN0hIdOQnnIy
         HHDBbSwqbIiq4LwPrWMvXTXvmNDw+599LNsBWkDkM1hdr+kgmg4EG1HlpXe7it2fQ0NP
         TxEZy/GYsKSnnwpxRr0gUnpZpUreR4Pg0wT3Qsy+RLoQeY8P9C/0YtorPvAMjscMb17T
         ELsKsTBmfREQreBn4ycFfB8e3VvplcAMaeeEcnmuxPheLekmzXiU2u/HymbHZCaoG9NO
         3HGbUyWTwhdAoGF19sM4GlhvBGngixXoblyO+D+F7768/G2ZEB/NrcGZfW1cS7SWde9q
         zHSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Sf5BOgBYoKexxio9oBRlmrzfjBVgiqa9tGRvXK5Y6M=;
        b=lWr4St8+jT5MCw/MiGdI6QL+g9wIg8Ufc46RDc3tL8pVXWP16IZWem1ubDhEMkUuH3
         ZnRL5yFHS3nkwG11zWldZZ3E85R2bQ7yF6PXQPwXJgGVyg/BkV+NOegkJIzv1IKrqwjE
         eK5ZZFhhaA8++G25nh93u/MchBD7CQ2z+NcQUs9nabYZsAV3snK3CnsyHKzR0s5PpI4F
         yxz/qEpsK12jIz4WRncg0MBGCfZPP2dthJp4cNwRZ2T3ap/GhbGKMyR4JM6iFLK/IHsd
         +GXKavkLNs5+kBW+bF/oqt4JMJlEqXuMeb9t1GMRGS+n0tb2ThNxXHCZJMMDCtUR3B3A
         7CXw==
X-Gm-Message-State: AO0yUKV1QvCUsNrfZ6PFRm4snOt9GQcgiRA9fhzzHhJCq6vsGJsXJ2d8
        Qa5VhNJz3JG6g1+wXYYhVo8=
X-Google-Smtp-Source: AK7set8y04Am9bgTDpF230YHO4fZBC/NWwiYPgRaq5ZpmP+2o5Hvbb4VmgDrCNm1Cfb820nnSYw7OQ==
X-Received: by 2002:a4a:4194:0:b0:517:4b63:8e48 with SMTP id x142-20020a4a4194000000b005174b638e48mr5316841ooa.1.1675444708505;
        Fri, 03 Feb 2023 09:18:28 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v32-20020a4a9763000000b004f73632d096sm1198293ooi.6.2023.02.03.09.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 09:18:27 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 3 Feb 2023 09:18:26 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Eric Biggers <ebiggers@kernel.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc1 review
Message-ID: <20230203171826.GA1500930@roeck-us.net>
References: <20230203101023.832083974@linuxfoundation.org>
 <20230203155619.GA3176223@roeck-us.net>
 <Y906Hz3UWYxoxYdD@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y906Hz3UWYxoxYdD@kroah.com>
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

On Fri, Feb 03, 2023 at 05:45:19PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Feb 03, 2023 at 07:56:19AM -0800, Guenter Roeck wrote:
> > On Fri, Feb 03, 2023 at 11:11:45AM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.4.231 release.
> > > There are 134 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Building ia64:defconfig ... failed
> > --------------
> > Error log:
> > <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
> > arch/ia64/kernel/mca_drv.c: In function 'mca_handler_bh':
> > arch/ia64/kernel/mca_drv.c:179:9: error: implicit declaration of function 'make_task_dead'
> > 
> > Caused by "exit: Add and use make_task_dead.". Did that really have to be backported ?
> 
> Yup, it does!
> 
> Eric, any help with this?
> 

Adding "#include <linux/sched/task.h>" to the affected file would probably
be the easy fix. I did a quick check, and it works.

Note that the same problem is seen in v4.14.y and v4.19.y. Later
kernels don't have the problem.

Guenter

> thanks,
> 
> greg k-h
