Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187F75109E5
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 22:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354724AbiDZUOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 16:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354731AbiDZUOu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 16:14:50 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7D71869D7;
        Tue, 26 Apr 2022 13:11:25 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-e2fa360f6dso20586411fac.2;
        Tue, 26 Apr 2022 13:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nEXCIa4iZUEowx7R5mPru9BClJaJCl/UZPH5Sd9YczU=;
        b=eAxeY4viKx0qIp4jG69P5MynVMeh+ZaamuhK1QbTxfmBmLKUlp8R0ctgw4Ik5TlX1x
         PU6V2ufuJ1OnQHKC9ViGu3U+FBxa+wbov3qWW4vawkEtOwaWNogSs04AvxjJPvkbbVXv
         LEWE3NBcRN5d5p3hXL1ks6uQT5OtMuJhUwFgesH4OuMEB01pVtcrCme2wlDtJN06IH+1
         2bAab8pxLBCVzA/Lm1O9RWeR5uMFqeUpBWuBWyo8uNGlL9ejpW9N83njuDxdlFL9LChJ
         AxdguzNrsAjRK1ZVzuSIbJmuMuWfxtiJywIwvig1szOaXUkIyeBX7Fd/MuqZQNo/3t3u
         eAHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=nEXCIa4iZUEowx7R5mPru9BClJaJCl/UZPH5Sd9YczU=;
        b=H3fVj6UB4rg4gNX8KqWpDeMThl+/NWRQeNzl1Lq/vnFcZGb+brd2/5iieyo2hFKtr0
         RW6H9KHyhDXCqFLiekOWEfX1rFJFnL49EWH04j0mOr7ruB4DXE7QcgRPqBIqTS39lids
         Nrf03PmU3sC/7dmZDvoGgta3ypRo7SwJXm4++5DFju5+zTKnOyKuL82MKSJzyDYJwGj/
         3omggTjmT6Vib3dibLMcEU2awCSPKgQIU2XQ/zGjq1c8LtmQVMuL5GVPw10b1q9WvkN/
         LrLd2ttJZFYl+lSifF5UN5vq0B7e2aRa3O7S4pDIN2mR5c+J5hS1ZmHYbMa9ezRJKxpd
         ULpA==
X-Gm-Message-State: AOAM531eE0qoaUO7vu7EbUntyvUSt17H36Q3AL22212DE/Kd1rqo421K
        a+MBq/4FXoJDh2hNQPSzhhY=
X-Google-Smtp-Source: ABdhPJwlz1dzvJUmszxcYFWV4yYOQOo4Qb2XnCvv/wLBQPyay8YjQa5hki5keh6pV0oP2GfEzSXykQ==
X-Received: by 2002:a05:6870:65a0:b0:e9:629d:aee with SMTP id fp32-20020a05687065a000b000e9629d0aeemr2554706oab.195.1651003884830;
        Tue, 26 Apr 2022 13:11:24 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id du43-20020a0568703a2b00b000e686d1389csm1166367oab.54.2022.04.26.13.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 13:11:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 26 Apr 2022 13:11:21 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/24] 4.9.312-rc1 review
Message-ID: <20220426201121.GA4093517@roeck-us.net>
References: <20220426081731.370823950@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426081731.370823950@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 10:20:54AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.312 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
