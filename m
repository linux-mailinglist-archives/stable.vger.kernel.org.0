Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3947F54A2F3
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 01:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236280AbiFMX41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 19:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiFMX40 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 19:56:26 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE07240BD;
        Mon, 13 Jun 2022 16:56:26 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so5640008pjl.5;
        Mon, 13 Jun 2022 16:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=av1Qql/QJmWdDsxNlc7eunRq5EIEERupbrQpWpPmxs4=;
        b=a72zkW6by3rhqpPjP2xb86FumLMneo4rgl+NkuvgM0Xa3+TVtMMOsbbCQjxNpL5HFl
         FsSBAmcQ7mdWTjpZik5UL6f6BBTM+56sA8Ok03SsLJK6fDB7gpG3GZNItyb6SAsvjqMJ
         MjEcTsIuE2VzV+WtClNthQ9/bEO/g8YW7mL+UeJQjs/L7JA4RAMEyy6CBtGi+vyQyD/R
         8pd/NN/Es6d9mzF5tSiW86gX91hGZ7HZDra92HofDJnOe0c9U34Zaq6V52+GfdTR6gXG
         eucG7bqYuRCzQmnhmOBcklkEn4OQftPkvLDwBB45fbgXm47RewX3xAun/k1dMfS4UNWx
         oTfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=av1Qql/QJmWdDsxNlc7eunRq5EIEERupbrQpWpPmxs4=;
        b=uFxLkCALtfBXTqTWwx5QCHIFZZaRf6zVYkJA03hzHZ9Cys4m1IEMXtpPT14N/lapF9
         ainIAMZJ9F7sONuOHkbo1wPmwXu1frAH48Os2r+7whGdJZg4TuJP5Go/82DJk91DZ3lr
         SIcJJI7LvacBDykMjjL6ZF/NvjMux++I15V18mdXcC5Vv2YBgisIzjZ7UkvJGKzbbqNM
         QmOsLWZkKKar1OtZDxkCS0SFvJZgWDKWMMllv3Dzx1tRXjAF6GCJTlFdopnEPI4ngnOs
         t9e2DBV816ko9zjUDpqK5YSZQNhJCdpPbZM7fAp1DuKw9YxUcH+iuQsouHtqEpoPgrqo
         AxJQ==
X-Gm-Message-State: AJIora8DCoWHpTnOj58hSZ3UiuEm32v/Q7XXarfO+kw+clvs+WmeoYC9
        eIFfxQTZR8FsLNSHQT0DY5RVi+M9f3A=
X-Google-Smtp-Source: ABdhPJymRVv3v4JC4z2bWYfW+oF4XzlJR38/elCrx487MOBtEyumKyByskj0NfTZ3RHjbpiYcn+jug==
X-Received: by 2002:a17:902:ea85:b0:168:c6b2:e258 with SMTP id x5-20020a170902ea8500b00168c6b2e258mr1637164plb.58.1655164585511;
        Mon, 13 Jun 2022 16:56:25 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v11-20020a1709028d8b00b001616e19537esm5664139plo.213.2022.06.13.16.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 16:56:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 13 Jun 2022 16:56:23 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 000/167] 4.9.318-rc1 review
Message-ID: <20220613235623.GA1666524@roeck-us.net>
References: <20220613094840.720778945@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
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

On Mon, Jun 13, 2022 at 12:07:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.318 release.
> There are 167 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 09:47:08 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 164 pass: 164 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
