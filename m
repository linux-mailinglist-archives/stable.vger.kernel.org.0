Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 829A76E87D9
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 04:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbjDTCKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 22:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbjDTCKh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 22:10:37 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AEDE1BF0;
        Wed, 19 Apr 2023 19:10:37 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-63b57c49c4cso485242b3a.3;
        Wed, 19 Apr 2023 19:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681956636; x=1684548636;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OgvSLySd2lyqPfN3zgTP6Mv+w9DzPKKYJMRZtxRrQ5I=;
        b=pnrESEu4umBVw/pjispzWFe3C4BcCqnCrIjdyCnKhpnoZzttxmtUxP3fiG8gAuT0Mz
         byJmMOfWt51PVX8/8IuQr6ZsA6OgVN3XNmhfD6j3IzG3AnspodnH0FAuEHMtiIXwl8yr
         psE+aVksC1B0gZFWCcah2jj7zWeTz96pu5+iVLj8Dwqzxki7SE5aE1CTSEUitzomY2xO
         vdkTKLOZtdHVt1PkHOHJ5ODaraiMWErxMujS8U7ANnCsVMklE5wi7mUD61yFjhadMoYn
         U4SH2dG4uUwU+BqKPmhivymJyGXWMqUxOdnX6p0NSe0MMCvf/jjw20vE1fOVXQCA70fT
         Dnvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681956636; x=1684548636;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OgvSLySd2lyqPfN3zgTP6Mv+w9DzPKKYJMRZtxRrQ5I=;
        b=dnPn3NP7ohpaSBSXKaffRPIrlYpA70FG8Ctqrv98jqOUFBMARz5r1TEzB4Bdf6jBBL
         Oy/gnECHNcmL+J7HKJy9wHvYatiz55O6vTAiyfBHtwnuxXjz0yLJTwDSHeZ+sWowMKAL
         /Ms7OFS6/mfSaZYy0/FKWLrB60OllmRkiqTCZX2ppGHLBUrmC6p8zzaKmw9AJ7IqvCie
         uGriCTN+3D+76TmCmrAY4MKUGkp1qyNccNuFiEpuQ3Bcpg76OHi9e99oj4Ak5ESy5QT3
         ZdR5tTRL+nNTN+6OZtHi4qgDIJeVTaL8nYyFnyZkwONutg8255D7NUNQ+Ec6OwTv1DvX
         OwsQ==
X-Gm-Message-State: AAQBX9dT/cafplNp9kpK9A404DBFzJmJUav501DIshJUGewfwO/xQdyS
        qXhmUc4337rV5diuKbikQDM=
X-Google-Smtp-Source: AKy350bE5qL43cUsB/ObNnf6cOr6fLWFRm4WzLW66l8/O7TNR7kGfLvcx7/+OXjmLsAm64E5CnkY1A==
X-Received: by 2002:a05:6a00:98d:b0:63b:5496:7afa with SMTP id u13-20020a056a00098d00b0063b54967afamr6572852pfg.11.1681956636462;
        Wed, 19 Apr 2023 19:10:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p10-20020a056a000a0a00b0062d8e79ea22sm69106pfh.40.2023.04.19.19.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 19:10:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 19 Apr 2023 19:10:34 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/135] 6.2.12-rc3 review
Message-ID: <bcb4c9bc-b74c-4a00-b1d3-a87200bfd344@roeck-us.net>
References: <20230419132054.228391649@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419132054.228391649@linuxfoundation.org>
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

On Wed, Apr 19, 2023 at 03:22:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.12 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Apr 2023 13:20:25 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
