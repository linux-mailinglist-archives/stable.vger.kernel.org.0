Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB115972DB
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 17:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239184AbiHQPY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 11:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237833AbiHQPYx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 11:24:53 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04ADB5B7A8;
        Wed, 17 Aug 2022 08:24:51 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id r14-20020a17090a4dce00b001faa76931beso2132720pjl.1;
        Wed, 17 Aug 2022 08:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=cNb+wPFqXTTnrEsiIhlvkm/VTYFYCj1lwrBVxwMNlw4=;
        b=g7JiuZ0QYzHlhR63PM427qbq83vL3iY1FyydWZTdX7t2rTDrisImuHcjYkAlFFyOi6
         SGdJxZgsWGwEhrp4ov+egzakW1EigtK/EvafkvLPpMgoGnaxUx6QmX71qMKDGcQU1AKI
         bGB9w7JGQur33yZjYUaVo2m6R/Ow9KjNFny5kLH3ntn9CC39OeqB9hb6GsmKF5TFzw2B
         MAcn+oNcqypAzShKdeFXwc8RtaOR/nHNrv2djVN/o49MiyUPf6yn1rJ4rKFHOqvjI4IK
         DQ2TsKlcFNtyjr0QonuMxFZm1sO2oxb7ceFolzuAnVZzfhPV9FGizh4+DVE8BK98BsuH
         T+qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=cNb+wPFqXTTnrEsiIhlvkm/VTYFYCj1lwrBVxwMNlw4=;
        b=a44p15AJLpTrnJmJ/fu5MpOLVmQ0vGqLYbuUAQ+YZVdxiA/ArE0XLHtL+I1tWfkWaa
         /ibyQZ+HmQjOoAlOMzkuKZJPYHPR0ypXryikSkIKEKZ8qcnnuH35n1x+DCm8wH9iE9eT
         BwUCU0Y1GZmXsd644tMtroRFG9NjemrXi/V6gm08v8+w71252p9TYnu76l8mGmQrgSTi
         yBCveqr8UHguj+L35sG6/nx0nSFn+kt5houvWNsNiXbuAIDI/33mC9TbQPy/Z8cc+hjz
         cgkPTfDVyt1S4adY4EsLJxfeC6dHJ6yy/zKOgwP1JIr/g7qzFoPtMONB/h4lMq6assPn
         ZEeA==
X-Gm-Message-State: ACgBeo3AXWVD1e5lvc1eQY3GUZFXgUhN1wTj/5SdVGfYriN3D5W0qJUQ
        Uswv32SppFpjrndJmdEfMIM=
X-Google-Smtp-Source: AA6agR6VSz5H7jgK9fm8v7D0017rD9IG0++yPEfFL63RpX/MelmrPDQlCF6+5CwHOs7r17eAOr89dA==
X-Received: by 2002:a17:90b:17c5:b0:1f4:f55d:24f3 with SMTP id me5-20020a17090b17c500b001f4f55d24f3mr4284181pjb.109.1660749890494;
        Wed, 17 Aug 2022 08:24:50 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o14-20020a62f90e000000b005353a676757sm3551135pfh.120.2022.08.17.08.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 08:24:48 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 17 Aug 2022 08:24:46 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 0000/1094] 5.18.18-rc2 review
Message-ID: <20220817152446.GA1205420@roeck-us.net>
References: <20220816124604.978842485@linuxfoundation.org>
 <20220817042445.GC1880847@roeck-us.net>
 <YvzuUdrBqGlW880H@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvzuUdrBqGlW880H@kroah.com>
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

On Wed, Aug 17, 2022 at 03:34:09PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Aug 16, 2022 at 09:24:45PM -0700, Guenter Roeck wrote:
> > On Tue, Aug 16, 2022 at 02:59:27PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.18.18 release.
> > > There are 1094 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 18 Aug 2022 12:43:14 +0000.
> > > Anything received after that time might be too late.
> > > 
> > Build results:
> > 	total: 154 pass: 154 fail: 0
> > Qemu test results:
> > 	total: 481 pass: 480 fail: 1
> > Failed tests:
> > 	arm:bletchley-bmc:aspeed_g5_defconfig:notests:usb0:net,nic:aspeed-bmc-facebook-bletchley:rootfs
> > 
> > The failing boot test is new and not a concern. I'll see if I can figure
> > out why it fails. If it is too difficult to fix (for example because 5.18
> > simply doesn't support usb on bletchley-bmc), I'll just skip it next time.
> > 
> > Tested-by: Guenter Roeck <linux@roeck-us.net>
> 
> 5.18 is only going to be alive for one more week at most, so I wouldn't
> worry too much about this.
> 

Ok, I'll just leave it alone.

Thanks,
Guenter
