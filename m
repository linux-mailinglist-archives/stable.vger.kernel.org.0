Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 470656B5810
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 04:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjCKD2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 22:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjCKD2D (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 22:28:03 -0500
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E7D1167C;
        Fri, 10 Mar 2023 19:27:59 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id e12-20020a4ae0cc000000b00525034ca5e9so1094215oot.0;
        Fri, 10 Mar 2023 19:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678505278;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=73ltC76ja99SXS0x3lMZJ2kFcQpVMIC8+o6DWphx0as=;
        b=WAE1M2osG3fr3u4cGgm8Cir0jz9AXvwKp9V6C24VF9BjrIjP50T/2Y8KVzjT6kaDFc
         0cpyud3g2DeCqmMLz3LeitTcOcUTJJ0hzeZyiiPN06eRtQoxlfptZemulqtESlCWs+q+
         /Fxyyy8Hb+ksitfSS7CRrFVm04+zE2lkWK3nXXcbBYULLmMWsATyvoRfCAhG2QMvhGFk
         NQiHPJ6z9AHW3VvQOGlH+RUnt16otESpgeDdfBi5Xv+xZe/GjtkeJ4RGkVlYHN0is/Cy
         jU35Q4ywXngSzLQYxIG8H5/SgyOqKCbltZl7ogJ+0iWCu04Ntvw7f4zB6ASMbSM/fj5E
         eawg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678505278;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=73ltC76ja99SXS0x3lMZJ2kFcQpVMIC8+o6DWphx0as=;
        b=QVm197XB/hM0QylSS6l1SZ4bMzBYYjki48XzWnTz5a3pVjKNU74ca/kT9KVVupywJL
         TXjQBqFMGfQWfdBGdO8WFnNHPiuT2u4ytmRSBAoWCg1n2OsYOvtIMVA6HQ5ukQKwsOLR
         P0QkzLASQfXNQOG61yyfSu/P2aISqcter3f49OCYMBQgE9woO4Q46zcZT7jeFm84M3eL
         vNLHfiHawra5eHvaaIHpa4pwG0A99AU4r8Od39rqk46SgrcwSnnBQoEOjNN/XdPEo4Ym
         /Xa+kd7+9uDYLt9YwMvJ+JfpZGn2AZ97wopsOF/Zx3nw0aLTAS+iPtpOnA4Kb7mi0LeJ
         P2nw==
X-Gm-Message-State: AO0yUKWXYcQ0dCy/sRV4uUy9iePbghZF1Rwn5HXypP9crkrqG1E15vup
        QLpNR6ZScgMuwVnQr8+Frrc=
X-Google-Smtp-Source: AK7set9c3q+RzEuGRYuQANxke5HaEFi5TpCYYva6K2yjPctqBNX063vhkn+p6ncwehZezLQ/lkCfdg==
X-Received: by 2002:a05:6820:1048:b0:525:d9c:b1bb with SMTP id x8-20020a056820104800b005250d9cb1bbmr12535468oot.2.1678505278347;
        Fri, 10 Mar 2023 19:27:58 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r28-20020a056830081c00b00690d0daa17esm779242ots.3.2023.03.10.19.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 19:27:58 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 10 Mar 2023 19:27:56 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/529] 5.10.173-rc1 review
Message-ID: <4dbaeddd-65c8-4646-96f0-581f48386639@roeck-us.net>
References: <20230310133804.978589368@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
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

On Fri, Mar 10, 2023 at 02:32:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.173 release.
> There are 529 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 160 fail: 2
Failed builds:
	s390:defconfig
	s390:allmodconfig
Qemu test results:
	total: 485 pass: 480 fail: 5
Failed tests:
	s390:defconfig:nolocktests:smp2:net,default:initrd
	s390:defconfig:nolocktests:smp2:virtio-blk-ccw:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:smp2:scsi[virtio-ccw]:net,default:rootfs
	s390:defconfig:nolocktests:virtio-pci:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:scsi[virtio-pci]:net,default:rootfs

Failures as already reported.

Guenter
