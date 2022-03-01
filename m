Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 870D74C9414
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 20:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbiCATPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 14:15:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiCATPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 14:15:53 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF584B859;
        Tue,  1 Mar 2022 11:15:12 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id 6-20020a4a0906000000b0031d7eb98d31so8114486ooa.10;
        Tue, 01 Mar 2022 11:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=T7DUOEIhLQ3sAKoqb6ZeCuMYwo2mAAmkHjIh+lPJjuo=;
        b=Iy32m+GjK9avtV9OfxfeYp39pEH/kN5vRRkYC9MMcoqutADxP+ehQtJHgiw0A3Le3Y
         DteBGYo7JDxqUPOMvxw2RU3NzNShVdVG/VC2/X0vmOCvFyftLdbaoL/yChz3i7ipR4+y
         moknc8UCbMSt4eor3lWgesA8yFCugF+Ta6IMu41JcBGcVohL6NjGl6dmUofRPD9cJUtF
         8NAyj5/4ob+HvnHdaejILzS5/VOEu8yGcAaGW4f6nf8DrXmQRoww6F39gsLUIzxrFhLr
         q/pV4Y7fggxOGwPYZTcOS/NyQ2zYL3iQcLHIGSVCib/y1xPYT1gU5PQsm69PXd1IVtlw
         RZyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=T7DUOEIhLQ3sAKoqb6ZeCuMYwo2mAAmkHjIh+lPJjuo=;
        b=vbIga2YZP4CrB3nbHJpDB88icKB/gYl231P5a+/Uu2vxXJ60ZLgtDns74YfjWj9+Ap
         BVAc5vV4TxeqmGGvEtSfMicnNo/GgKg/TopUihweJjV04wDjCq3qpE5fRYCweK8tUs1r
         zYF6pULLNt8PZLHRm79jK55NpFh19WvrMR8K/rWh/2skNYdF0RRGCQ3vq3wnUed0RVmF
         3idDh6Q1mZgQHskmiSKj9om5+t0AamW5Mc2ieqbP4rhSrUJo14GpQIIhugbeD8EmPNdg
         3hsuCs71IranxZNyxsUkJAg2CJgLNTK84mFQ7sAI28p15mgxyK//XJhrzPXHAJMJPH1t
         OpeA==
X-Gm-Message-State: AOAM533neudCA53n4GQPsmlhANHUL0cQ4C9mgiC0feiZcbiUDDzJTntm
        Snqrkp5t1pteFxcGqMCUsRA=
X-Google-Smtp-Source: ABdhPJytRBBoRdTItjmIGdy6cCjzHZyALQPTB1nCz7tUFMKrT8JnE/2Al43v3iOUGhJtHsKMdw3Skg==
X-Received: by 2002:a05:6870:c05:b0:d6:fa9f:bcd1 with SMTP id le5-20020a0568700c0500b000d6fa9fbcd1mr5186915oab.108.1646162112300;
        Tue, 01 Mar 2022 11:15:12 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a27-20020a4ae93b000000b0031be7c7d2d3sm6704355ooe.0.2022.03.01.11.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 11:15:11 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 1 Mar 2022 11:15:10 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 000/164] 5.16.12-rc1 review
Message-ID: <20220301191510.GD607121@roeck-us.net>
References: <20220228172359.567256961@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
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

On Mon, Feb 28, 2022 at 06:22:42PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.12 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
