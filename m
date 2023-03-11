Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 401706B580C
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 04:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjCKD1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 22:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjCKD1P (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 22:27:15 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284F312B012;
        Fri, 10 Mar 2023 19:27:14 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id h18-20020a4abb92000000b00525397f569fso1090299oop.3;
        Fri, 10 Mar 2023 19:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678505233;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IRQjTFtZ94OO6AEc5izEppuaCdMJD6xuPyl+zIKdfW0=;
        b=qZ3+51ZkMcXkaOHg75zJzQUFCG2CdbVufZt+1EzJOKfWIsabcrq10X+BVt3yOmD+rL
         bZLwRSBwwHca7UYHRve/fBHPpMKi8wpsnmZd4RfEa0Up9Mx5tWO9IIAHs0zbRlc5UCPf
         Cyt30eYc559eRwiOgPBrpA6I8gfZTqNwbdmbdtiJMX8TV2Y+WxhEne1z0wjwjV9iJhqA
         EIwDHuyfJSpRCWkBDUqyXPI+2BZu8j6UmaTEzPXQr+CI4jEoBi7HWIrJqLVglg3WDLyS
         H02B0e9VK0N1bRLCdTrw++7klmC7M61fEXcvek3EixfB04ut+3iOdkEVOzLWWSE7ZtQq
         4lAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678505233;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IRQjTFtZ94OO6AEc5izEppuaCdMJD6xuPyl+zIKdfW0=;
        b=gGQBQ+LIlGo9qWxRbLi9C9RtGSgSbnNdCKsHXyfuNOpSqqDqJZGjqnNS+k3Xmei7Gn
         JF/JBD+KxmaZlN9i90Ps1zbU4e/5FjV829lSlBBECswooPqZphi/e1p5dDZjoYLkL3VQ
         +4Rk24TMRyJPOLakk7Gc05q+PmI0285nQc1Rqoye1ywELFMkjzoK8Dp7DumqxpVyDGcW
         NtRC5QTtmKw3zN4/H3q8gFhQ2qPuAdAtGfLGndcF2aiAV14UnM/IwpzW/gJrqe7y2w/P
         5gINkDKzT90+JAFJAwrTF1cqO81YOAvNUV2uzKkrMs//5U1/Wm7t3aSUh6YVA2sZh9p1
         3IiA==
X-Gm-Message-State: AO0yUKVxP0LRxhxPIAXMDvpiCUcyEBcVmO51x7ZoB9JFRph09GfdPVXb
        FV4G0k478BjR+hAITNiqSgw=
X-Google-Smtp-Source: AK7set/b/h7yPTGgW+JptrAuYIikQROxM33Mewn9h4AMhQ77jAlxlj5swvFy36v1sw4RTl5ZJUDivQ==
X-Received: by 2002:a05:6820:123:b0:525:2e75:a615 with SMTP id i3-20020a056820012300b005252e75a615mr11455263ood.8.1678505233488;
        Fri, 10 Mar 2023 19:27:13 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c26-20020a4ad8da000000b004c60069d1fbsm663982oov.11.2023.03.10.19.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 19:27:13 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 10 Mar 2023 19:27:12 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/357] 5.4.235-rc1 review
Message-ID: <69d8df8c-4da3-481d-8731-09320882a75a@roeck-us.net>
References: <20230310133733.973883071@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
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

On Fri, Mar 10, 2023 at 02:34:49PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.235 release.
> There are 357 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 157 fail: 2
Failed builds:
	s390:defconfig
	s390:allmodconfig
Qemu test results:
	total: 455 pass: 450 fail: 5
Failed tests:
	s390:defconfig:nolocktests:smp2:net,default:initrd
	s390:defconfig:nolocktests:smp2:virtio-blk-ccw:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:smp2:scsi[virtio-ccw]:net,default:rootfs
	s390:defconfig:nolocktests:virtio-pci:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:scsi[virtio-pci]:net,default:rootfs

Failures as already reported.

Guenter
