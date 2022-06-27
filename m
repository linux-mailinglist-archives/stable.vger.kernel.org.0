Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2DA555C72F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239204AbiF0XlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 19:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237688AbiF0XlJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 19:41:09 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0C511477;
        Mon, 27 Jun 2022 16:41:09 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id v126so6350143pgv.11;
        Mon, 27 Jun 2022 16:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c2AsnlqyBedBc6ike3im6nsmoF1Jg4udaADlkpm0hsk=;
        b=Vx0JzRZHH34WAembHVy1iLfqFQfeohVMWTC0g86jqMz0AmvavdDmsCiwE3Cl06grXy
         VnB/O76J2k2WpMd6ihYuAj8JOLd7tVp/9gOXYc/kwbG0I0e9IDxIghOTAjkX7gsvf5N6
         GKLm9eHW+D7km2Khm/L9FUDwqbJgz78fjWW42VR/T2tSZT10XQQriqpIuwP8fdCrF5rY
         whjw5fIIEb1KAD7snaKc12epdw/Fw7yyuDJbNc5jTQK33LayuJgW0SsTC0AZdglAnom4
         LICwFnt0ujT8XRoEVPWNBbN62PGq9NHPHZbnwbX9P8QeZ7TiMuIfup9NoH1YJP+VfLdp
         b7pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=c2AsnlqyBedBc6ike3im6nsmoF1Jg4udaADlkpm0hsk=;
        b=5hXCY5wFRnFG0tLQusVwg3BV6yFrGJ+Teg1ObDOtbsiQhQ0iv6sSjX1tZyJXKpvTsd
         8pbkf1tLHuPlpsPTvtzmUZnQ7pxtE/4xDNXV3fNqgKZa8Ft1pt88xBXSmiJeqhq06LA9
         bIWewSJPS2UAgb1WK352tgolCYJ588KBlCrbQJKlghh3OtZKG27IZw680vXL+4oL7DVS
         4OY3ZUZHsrQ/yrbu44HODX4msvhA79dXqyODNMqDRMjbtrx7ThpmLmMX70IiivwKRkAl
         mGc38YU570W5SpzGxV4CK59O55d3SZ41JWMgLFpyGpCmY/8b2dTOZcKyvXrsDnpDoKdf
         CFAQ==
X-Gm-Message-State: AJIora8mMhlYyP1ShP2Jl181EBAE9V7zTYWvWJ5e9THKSvCcgDU5GScE
        gjD8jzRv/AZ9cqV2TzGvuvU=
X-Google-Smtp-Source: AGRyM1sn5puqP4eCv/v80mOV4bZ/w21KWD2/9AcnXW4OIv/Ous4C0wIr716UOmRBHDe7cCV91JJ50g==
X-Received: by 2002:a05:6a00:138b:b0:525:1f0b:3121 with SMTP id t11-20020a056a00138b00b005251f0b3121mr561268pfg.8.1656373268562;
        Mon, 27 Jun 2022 16:41:08 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y6-20020a17090a2b4600b001ed3696d2cbsm6109718pjc.30.2022.06.27.16.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 16:41:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 27 Jun 2022 16:41:05 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/60] 5.4.202-rc1 review
Message-ID: <20220627234105.GA2980567@roeck-us.net>
References: <20220627111927.641837068@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627111927.641837068@linuxfoundation.org>
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

On Mon, Jun 27, 2022 at 01:21:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.202 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
