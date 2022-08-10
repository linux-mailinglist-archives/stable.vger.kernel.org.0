Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C663958ED49
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 15:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiHJNbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 09:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232785AbiHJNbT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 09:31:19 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD0C2ED73;
        Wed, 10 Aug 2022 06:31:19 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id b133so13727013pfb.6;
        Wed, 10 Aug 2022 06:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=nLK8prBHut9PQC601ZWlvRrR9Lvd36em00kj1huNqV8=;
        b=buj3J12BZEhjwENZi1rPT6Nj2CsPMlx0s+9r3fIURn3NgukCmJ3wKy5R1GM2Wlg71u
         4AtowXRRIKPEmf/pO9hjKwVxM/f9vycCxeVOwLJHHTGCWEg8ZAEEXr4WMp9FzLKpVJn6
         B4tWvuS8dizYvLyccTKeTaPbnht0Kl8nPv2fF99QNL/UPeVtEy2PsSscjZaF+PDhLr3Q
         8zKceGfkBsfJRaA4jAi53fW98dtoCBVjIn/rjg3Ya239wy3Prdt4PiPsfzhj3zyMtFqV
         DSa8es+RwO+MXe7gxf9mNqDyKzfcLbycuEpgfqR0tHmSg4gOcaIQrRWhmkISfzRsbOL5
         TZ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=nLK8prBHut9PQC601ZWlvRrR9Lvd36em00kj1huNqV8=;
        b=RJe7wmHutX2SI/NZ8R2fgJ9dVyz3TrzWAZFHC0lQ2NqaB1X2WzpODfE+pwWEsNVSwV
         QvKSZTSxwZthSCOaoS3MNkIg5JunuCm3cRedc1a0Bm8wR9g8idg9K8Idasoj/QN+32n8
         KmFrA4c7AZImSIxKn2VDpQUOcd3jgKJ2/VlJ/7/3FogSWvaGkv1zBcSqybnzVH0Tb0mc
         bN2Aeb+2SvykguhAgYnfTT64cIiu5mZH9/jLfZu0A/IXmJ4BPZXGrnuW8HYzPZ0nwdDA
         FlFzh2OrxaLuVQY6FFhQdj7Vfc6ugr+0pPBTiv4Xnz5y8gPlAU3p8XXTc9uq1cmm21Ts
         adhw==
X-Gm-Message-State: ACgBeo2d6x+wRyKx9qA9mQda4R7Enqj3LXpAHcHI7NZ1m+aAwpb6ecx4
        A2u1NU/EQAEfuQBNFmhGcSe4MuR4Wdo=
X-Google-Smtp-Source: AA6agR7VvZdIVXYu4hQhgqcnHfYZlQyqob5jHngf9j0Bkd6N0CLFp7K/mpecEmPgHEYvx/U9V4+b9Q==
X-Received: by 2002:aa7:88cf:0:b0:52f:fdad:9e0 with SMTP id k15-20020aa788cf000000b0052ffdad09e0mr3192530pff.74.1660138278802;
        Wed, 10 Aug 2022 06:31:18 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id iw18-20020a170903045200b0016d6d1b610fsm12848620plb.98.2022.08.10.06.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 06:31:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 10 Aug 2022 06:31:16 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/32] 4.19.255-rc1 review
Message-ID: <20220810133116.GC274220@roeck-us.net>
References: <20220809175513.082573955@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809175513.082573955@linuxfoundation.org>
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

On Tue, Aug 09, 2022 at 07:59:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.255 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
