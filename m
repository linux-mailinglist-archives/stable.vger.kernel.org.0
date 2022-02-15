Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFD3C4B603A
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 02:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbiBOBwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 20:52:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiBOBwg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 20:52:36 -0500
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B779D557F;
        Mon, 14 Feb 2022 17:52:28 -0800 (PST)
Received: by mail-oo1-xc2d.google.com with SMTP id o192-20020a4a2cc9000000b00300af40d795so21511865ooo.13;
        Mon, 14 Feb 2022 17:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lzABjmLa5uOh3u3OZJQYH+o6ilvxMW8Cvn4GHSn8Nfg=;
        b=GNDm3XYdWRLsyYUSawshiUx6lzUZZtrcVfOJNEHdK7zTRKnOA4fdzh0t5tth+aWwXK
         CpBLCc89Z3usTihP4NijhBpUnvbl7pij8e86CdmFDRlnb8HV622Ntjqz11ELh9NpXJTz
         KAxlKdIQ022PA2zU8EVgK+1qqLVMn8Anha5CZzcTM3+clamsTSVKvbaG5sLqDhoZpfdP
         4YD6dwqG9paZ5J7rAYOWvGQgzDga8YENCPOmjkeLKa5YRnG1SMijD3iWHuA/jwOEBE4G
         c7pgvcOflTAGjAsJ4p1DeitxcqKB7x5y1oNT/mMp3aZQNDCENZahBFUSUbUlQPf80tjb
         7aUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=lzABjmLa5uOh3u3OZJQYH+o6ilvxMW8Cvn4GHSn8Nfg=;
        b=Yrap16GJ2nPD43XMw6RfAjTqsGawBa88TvJNVaas9W7dkrZkvrVu9T0DXsX0aJOZZl
         ceOeRmGSVEZPc0KepeznPJoe/aA+ejsTuQTkwacY3lLIu2cUIiCIAiMb8TOcAboQPTpD
         gDQREF9RnjjvWoEccElE/bZXliWG0uNHNHDnXluTU0ddxM1/Z893QwlOTugoDja4r15e
         zJBJfXjhVoatSy5LZsXVpP/uENWQisJ9N0LbJ1DLz7FN+wU/OlFla3etIznEMyoZYRny
         IUpDPAf3uZwwVC4BIphAEjYVEXpEjqkaeMlbWZEc++jv7MPXOGtzGxAjqYbO8jNb4Ceg
         3gRQ==
X-Gm-Message-State: AOAM530mnjQD9wXlN8pfwiY6biyzJFo6LhezTCwTVWce09iShO2VAbMh
        F6OSuvmGJPoCeGABNfkGMjo=
X-Google-Smtp-Source: ABdhPJyIIhq6/O84RKP5i0aPCdbZCYZIu57Tr1aB3EIsqpKdLz+VKTjMqVXcGoLZkQlZaU+6HDSGCQ==
X-Received: by 2002:a05:6870:d8af:: with SMTP id dv47mr646910oab.28.1644889947567;
        Mon, 14 Feb 2022 17:52:27 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h2sm13165557ots.51.2022.02.14.17.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 17:52:26 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 14 Feb 2022 17:52:25 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/116] 5.10.101-rc1 review
Message-ID: <20220215015225.GE432640@roeck-us.net>
References: <20220214092458.668376521@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
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

On Mon, Feb 14, 2022 at 10:24:59AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.101 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
