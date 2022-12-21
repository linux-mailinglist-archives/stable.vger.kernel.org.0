Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6328D652AB6
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 02:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiLUBIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 20:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLUBH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 20:07:58 -0500
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457E1165AB;
        Tue, 20 Dec 2022 17:07:56 -0800 (PST)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-143ffc8c2b2so17553545fac.2;
        Tue, 20 Dec 2022 17:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SA7wPis3qfy2mAWSDnJYGuGWdIgrAcp0Jn1gFSZFKIg=;
        b=m3NG5wkj/m7kkFKRhSMlP1JND+8MdIIGHEYBzxjoSqZYzVFd7KEVnfkvEch6PmjnRb
         i/b7L7frHtBLoOlumMAZhQz0pobwBxl3cOTXxqJ8Kto/Q2LOe01Oxv2mOLi37e+76ym2
         fC7hB3P92Nv8KZDLFutXoiJ4cJ/JG3f1Vgyemx9cseeNTtsGcZIVP1PqMk7bsOiCFz4P
         qyytWi1QmCNQXNa8HxGm6uitXW1zYAfxFzgHQeWoicCV76H5vk2pPjIkvyq5s44w3JkY
         Kr/oZOlZltX8ljNauhwdeISVUKM9apfonea/8T0ZKaLku0uOesz03FVV5aQx1s2MFp/N
         VSOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SA7wPis3qfy2mAWSDnJYGuGWdIgrAcp0Jn1gFSZFKIg=;
        b=3OzO3It8PLy4kkUgPgqcAD4qVY8DZR+wjGzPTjdtulsyFLJYkREpcnMBot9Guu1Gk/
         iqCSsWDK1hwVaPhSxO0saLoka7RwQJirtBtD0RYaBxHojD+gQ0QTt7hLkTbpdKx3M40K
         C/gmFsesCbFEF3kDZ4qpJWOdhqR/NoIu7awaJ62uCTGMoPOUCGVvINAXeJBwPgQOdWfn
         CZsFCtWwgg2CUdRQWcFW+u0pdJ3n9ZVeqNrZPpjlMg2K0AheaiFioahC7mAkm8euym60
         Nu4rs7sCu330UQ4v2lZrX+2o2KZ4XSCaqUkJiSirf9FJVIO00ToeongvKHhFe5hYDoXr
         Uv6A==
X-Gm-Message-State: AFqh2kpzjXcQkyqdWo22dFy6ip8OciOzFisDHZjtghaEbLAdEoyW3r89
        aVutP1pbKr4n58Iqa6t3Hx+MR5PdgX4=
X-Google-Smtp-Source: AMrXdXtWoE9P9QibiVW9qIOny6LTxFjK29vK9WVgIiBvgohFEoMFmzx8osi6URBhEsG0FRcCFydeiA==
X-Received: by 2002:a05:6870:bac5:b0:143:fca2:e03f with SMTP id js5-20020a056870bac500b00143fca2e03fmr6943142oab.11.1671584875576;
        Tue, 20 Dec 2022 17:07:55 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j23-20020a4adf57000000b004a3543fbfbbsm5647721oou.14.2022.12.20.17.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 17:07:55 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 20 Dec 2022 17:07:53 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/28] 6.0.15-rc1 review
Message-ID: <20221221010753.GA1319848@roeck-us.net>
References: <20221219182944.179389009@linuxfoundation.org>
 <20221220144900.GD3748047@roeck-us.net>
 <20221220153302.GA907923@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220153302.GA907923@roeck-us.net>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 20, 2022 at 07:33:03AM -0800, Guenter Roeck wrote:
> On Tue, Dec 20, 2022 at 06:49:02AM -0800, Guenter Roeck wrote:
> > On Mon, Dec 19, 2022 at 08:22:47PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.0.15 release.
> > > There are 28 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Build results:
> > 	total: 155 pass: 155 fail: 0
> > Qemu test results:
> > 	total: 500 pass: 500 fail: 0
> > 
> > Tested-by: Guenter Roeck <linux@roeck-us.net>
> > 
> 
> Wrong results, sorry. I'll resend once I have real ones. 
> 

Here are the real test results:

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 498 fail: 2
Failed tests:
	arm:xilinx-zynq-a9:multi_v7_defconfig:usb0:mem128:net,default:zynq-zc702:rootfs
	arm:xilinx-zynq-a9:multi_v7_defconfig:usb0:mem128:zynq-zed:rootfs

The arm:xilinx-zynq-a9 test failures are seen all the way to v4.19.y.

Guenter

