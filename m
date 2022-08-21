Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6146159B117
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 02:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbiHUA4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 20:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiHUA4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 20:56:49 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A761EAF0;
        Sat, 20 Aug 2022 17:56:49 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id s3-20020a17090a2f0300b001facfc6fdbcso7464991pjd.1;
        Sat, 20 Aug 2022 17:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=VrettuZWxV9MPoi+uzLfxQ8TggzpHQYQk9ZSW05d/ww=;
        b=TMkQn8yz836iK/3mAKk9/amy1tZzqkfH7cjQ6Qhfk2Ziac1Us6QmRPHKxwKvBUlMFp
         J1lHRNoIrNvOUtHtAq1K8abuMsEQU4wxWvsWBXb0RUwYG8H2/jWzG2o1gSPhccq2CsnX
         MB8fCUQmlx0BpWBJ3vBitFA/h1lJTQ7pjuKNhys3FPi7TuxtOF374UEPBBl0eNbzY+dJ
         Kk5ko56crLCfQ5QkhjyQB5E3pwmqcS3RzMWT/shOz3vgyW2xn5neiJd/OJv2yqLRWhrj
         OA9ysvjzAgNUi6CA52867ZbNCucCby8Tod9Njb3scM1KLRlynre6NE0YClFP67ntMgrL
         Et1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=VrettuZWxV9MPoi+uzLfxQ8TggzpHQYQk9ZSW05d/ww=;
        b=m/qKKO/j3gDxtj7H+F9lnDy7vab1NOMAvnWFXWwLRCywHvhu6bXTwAOzyv0IAsNzRT
         FLaefiBdp8L3YB5GvvZ5ZRQcOmJt3N83zvx+T0mHSjqiz58TR4BgMxf6SQUTC6ITIoUO
         5zBppHh/DlNt73oFV+31uhROvECXjXcaVorctKpg/gkak8hu43P7EVq1A74KGxZODbe4
         k7tTMkeID2GoHqMpb4L5cSsOTqfgK8x5SpuGBNtOeSngx73o9E4PpvolYzax636l56bV
         zebMiKbclmqQnKZNHY81j9c/9SZBg99fhHHbqbX6QgdfHeOP1G3yzy0nvlraHrwHBZUc
         JmTw==
X-Gm-Message-State: ACgBeo0JHYmn4Gbo47N4k5MZN64E30TJRq/1A/qRfXGJA5HohhBEQJke
        Ywg8O5epbfXvHJvn3/Og9Wg=
X-Google-Smtp-Source: AA6agR5CqOUJPq7c4mbydqP67y/QxLV4rgZJlJHRsLnqoAQGzv5LZLjYvN5JmTONRCzsLTpXBHabdg==
X-Received: by 2002:a17:90a:39c9:b0:1fa:c50d:11f4 with SMTP id k9-20020a17090a39c900b001fac50d11f4mr15965616pjf.166.1661043408686;
        Sat, 20 Aug 2022 17:56:48 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902d2c300b001713af9e85dsm5510347plc.180.2022.08.20.17.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Aug 2022 17:56:48 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 20 Aug 2022 17:56:47 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/14] 5.15.62-rc1 review
Message-ID: <20220821005647.GA990331@roeck-us.net>
References: <20220819153711.658766010@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819153711.658766010@linuxfoundation.org>
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

On Fri, Aug 19, 2022 at 05:40:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.62 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 157 fail: 2
Failed builds:
	s390:defconfig
	s390:allmodconfig
Qemu test results:
	total: 470 pass: 465 fail: 5
Failed tests:
	s390:defconfig:nolocktests:smp2:net,default:initrd
	s390:defconfig:nolocktests:smp2:virtio-blk-ccw:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:smp2:scsi[virtio-ccw]:net,default:rootfs
	s390:defconfig:nolocktests:virtio-pci:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:scsi[virtio-pci]:net,default:rootfs

This has been reported already, so I won't go into details.

Note that I did not get this e-mail, even though I am listed in Cc:.
I had to copy it from lore.kernel.org/stable.

Guenter
