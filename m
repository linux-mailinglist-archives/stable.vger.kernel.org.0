Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55AA66002FE
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 21:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiJPTT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 15:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiJPTT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 15:19:26 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141515F8F;
        Sun, 16 Oct 2022 12:19:24 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id o64so10155718oib.12;
        Sun, 16 Oct 2022 12:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bqWvqr6kIka5rpt5GTVCukPBPdguLNvEkO1HuKyugFM=;
        b=LrYEr35DAHPOjMd9fbnqPMU2bR83qtDdUspEv/+ZSuuYasHDBuVpde9UGDKiwbfwBW
         6ZvMclr1gJgYUBe1qB2lcgTiYm/ede3QrhihbJ92coArms6xk12F2clCcuYZ1jUA/WwF
         nGfqjlsijDDroNtu/HM5/8VAy8V2UjHlrd81/L+F/8/7x0ORK/fPQUBeyXuipClmMP77
         8Qsx2iasGzh+dWX/H66AEDv3P026n+A8dfY/G8WskNuhZjY8nE+ya+TeGZEPv8RNvRAx
         b3MZUxAbcJIujnE7Zl1qlgVUYnS4M9o6oxjFn8WT8Xqc+ki+ZjmfLJlfWxJTJKw8dLtf
         w4xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bqWvqr6kIka5rpt5GTVCukPBPdguLNvEkO1HuKyugFM=;
        b=x/2bEOe/SRDOEcwjJkx1ZUSZoqggQG6IUSQ1UVSpQu1+9JxxJyMTpou6n1HQeGZZoi
         1yjvSVy9ApbpgzboB0QpH00ndcfzVG84qZ/d6wRhSbg8oVpkRzltscWGRp4ex4giGpN2
         MlmPt4VhJmUTmSxlRQ088MvMaCoqFafM673/U1Clon9Uii8PZzgNi/QZG6CBI77OcRbn
         x+NKTMFT6GF54+83gFACAnBQ2njN3MzBbsn8A5XA2U5Svt3FOcmn6islHZn/q4xKCmmR
         RlgRSKL6bY8Gd4HDMe2KDmm+cNirLSX382PiJRPQL/COd/Kp4HS+dglubONHIHLiJO75
         7Lcg==
X-Gm-Message-State: ACrzQf1fVMHG4ziWUHwkw6EqWcSmttNTnFkuj2xRnWgX5ka2o4xbBMm2
        YVzWHWRHDaqt+WbL+p3fC9A=
X-Google-Smtp-Source: AMsMyM7c/zJqIIQcdxYnu9IdYSjjlxVxEbUiN8eiViy8HUeUGrEr5+BhzkaR3XnitJrSDYWsDIT81A==
X-Received: by 2002:a54:4e86:0:b0:354:f16:8c7e with SMTP id c6-20020a544e86000000b003540f168c7emr11966818oiy.296.1665947964205;
        Sun, 16 Oct 2022 12:19:24 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z18-20020a4a3052000000b00425806a20f5sm3233030ooz.3.2022.10.16.12.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 12:19:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sun, 16 Oct 2022 12:19:21 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.4 0/4] 5.4.219-rc1 review
Message-ID: <20221016191921.GA1277641@roeck-us.net>
References: <20221016064454.327821011@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221016064454.327821011@linuxfoundation.org>
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

On Sun, Oct 16, 2022 at 08:46:22AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.219 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 18 Oct 2022 06:44:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 447 pass: 447 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
