Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39FDD6B5808
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 04:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjCKD0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 22:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCKD0H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 22:26:07 -0500
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11110125B2;
        Fri, 10 Mar 2023 19:26:06 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-17671fb717cso8057659fac.8;
        Fri, 10 Mar 2023 19:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678505165;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a1d+aTzTfWqQxMINC6x7hmYNy31/HuKFz4m7E2MSLTI=;
        b=YFQaZQYk2EIHMOKxIa0JSHjrCX2GXQ3n0ojkOS7626CYN34/ZDgbo+qIMHebPAaRHw
         eR6Y0FDF+gJsxTPXQ2TGYVapIudODipeXJvbV1zgP3yMx6ky65xF83n4rI225Y84JInl
         eIRFeVDR8omY888LtXDFSeDHbI+oy7foZuvwYPL49wh2yyJwk/8Z1IUtQQYqro25oDM+
         z3uNDV0Kicc6N3hCSuHfFVdFg62kDvEEzMPhZQm20pSi4CNoLGebS5EFetKRzatsVsCd
         qYtHTW8f1J/Go6REo7OqRI5NZN2LpvA/Q+T1giemxrsjWRNfOVvPj4RR146QI/dRRXeb
         trmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678505165;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a1d+aTzTfWqQxMINC6x7hmYNy31/HuKFz4m7E2MSLTI=;
        b=QGlaEQyKkuee8kfr7DuC77gSL9lvZDvI2O7sjf2e+XOvessU5M0q5xPoYT290D2/tA
         ITssUy8ah4AsgjubTNqdejXEnohBoO6Db+dST49BjqEWxTVGNTAza9JQWMJ8I4pvx4cx
         eFNgqldpx5T4kgiUy28fI/KK69mjD52YY44RheCsclDL62enhqEZoO03A9t3tX34ucVv
         GgqNc+Zvg5zHtNGCeUUf4NXQiNcQV+5wg5oj31uU9sFlHy70c65avrT5tl8FEwwxjEHg
         uv8cjvJrXJbuBFBonUOwiojK8KMVxjiidDGn+eF7jPS/Wb9HHr7ucCXkZa2ws4ZDpo8R
         RUrg==
X-Gm-Message-State: AO0yUKUALrNPQ2KPpms/ptAqqa7EC8TYvHm8mOClkerHiBEghaF5Kws4
        yuwkXelalkk0s7wu93iQvJs=
X-Google-Smtp-Source: AK7set/Dfpz2eEs+b/bX1VAjto7NdIuHoTziayLm5r7wRYYMzuJ25E5kbLo/1N47fZrzc0xdfoheUg==
X-Received: by 2002:a05:6870:b14c:b0:176:2145:5e21 with SMTP id a12-20020a056870b14c00b0017621455e21mr17513482oal.46.1678505165332;
        Fri, 10 Mar 2023 19:26:05 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id zh28-20020a0568716b9c00b001777dbe75f0sm618651oab.41.2023.03.10.19.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 19:26:04 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 10 Mar 2023 19:26:02 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 000/193] 4.14.308-rc1 review
Message-ID: <d2a7679f-88d2-44ba-a8d7-a610e6e2cef2@roeck-us.net>
References: <20230310133710.926811681@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
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

On Fri, Mar 10, 2023 at 02:36:22PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.308 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 165 fail: 3
Failed builds:
	s390:defconfig
	s390:allmodconfig
	s390:performance_defconfig
Qemu test results:
	total: 430 pass: 425 fail: 5
Failed tests:
	s390:defconfig:nolocktests:smp2:net,default:initrd
	s390:defconfig:nolocktests:smp2:virtio-blk-ccw:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:smp2:scsi[virtio-ccw]:net,default:rootfs
	s390:defconfig:nolocktests:virtio-pci:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:scsi[virtio-pci]:net,default:rootfs

Failures as already reported.

Guenter
