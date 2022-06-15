Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1D854D428
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 00:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350302AbiFOWCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 18:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349805AbiFOWCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 18:02:24 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E90356210;
        Wed, 15 Jun 2022 15:02:23 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id u18so11548844plb.3;
        Wed, 15 Jun 2022 15:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hA54oHS4ibUAVsh9Orjp6uv2s8+Tgoc4ekw3i9GroB0=;
        b=aCpZjMNMgILRt7/LROKzMkJZFPhvLVhWWWWh5S9vmcHkpvboivE4+Vo6yghwaqfLsf
         j4kqRWtnf0+us5qDLEcZZfmyPbgXjHLVu9rvM88jzpzURqQkyPcbeM4NmDqunNm+E8Rr
         8VW+/qRO70hpBA058ZAGXoWQFHb20ERWd6HCdNG7hg33h070DVzvtNAdN7vR9fNfL2Yr
         bZgbp5uMDmvsnXnk3UcRaP1IJ3Scce1Ea11lhoK3EBM8EWaLkY+bo01t4wBn8Y9v9W8C
         EQAiUj0+b43POxxnaOi65eYx6UgiiWNYanVD1mwoYX5CQkrxJvgUih+wWCwVqtdrbwhd
         zkMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=hA54oHS4ibUAVsh9Orjp6uv2s8+Tgoc4ekw3i9GroB0=;
        b=oct29ikB1eIkWuq+6vJ/u/gk6qAB6W8vePBuVKPYg+wSZIeEoD5eX9SVQqXqAv1V1Q
         aePtdpy5kLYdIkdzoexghejK8lgpsP4peJ7/fOwZwQZfAyoWiNFV3u0iZCcjDuQq6LxK
         0gyM3me3yY13zPmE62kB1dUVgkJ/DIHdtHYCO2PMFj8vtQVzyZk4/mkPLwfndbeqzeVi
         89l2W75m+CxbVZwG3HxylgvvUAxv6MLobkUThfl8aEY5xMUN4oVY+n3WvlXRhzvaGeLt
         A0oDDBtY8SaDT6BIO/RfUgGnYX2ooWDAuYxUETTcvmV9OzUwiSLFY4F61Gs3sEm52N/0
         PcRQ==
X-Gm-Message-State: AJIora95CE/S8m9GvE404AXwzzea68iFrUxTrFhxfSBaBYb/gDNwDXLO
        hQFQEx0wWoPhMbIww4ZJOCg=
X-Google-Smtp-Source: AGRyM1ukDV/BPCEK376GH7T8W8ZWzaqiCN7t1t3LyaOBG1YJ13jWiGd4VQ2XJZsUNpj4vNPR7FP5PA==
X-Received: by 2002:a17:902:8e8b:b0:168:a135:d636 with SMTP id bg11-20020a1709028e8b00b00168a135d636mr1368992plb.140.1655330543184;
        Wed, 15 Jun 2022 15:02:23 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i12-20020a63b30c000000b004087f361074sm73885pgf.43.2022.06.15.15.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 15:02:22 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 15 Jun 2022 15:02:21 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/16] 4.19.248-rc1 review
Message-ID: <20220615220221.GC1229939@roeck-us.net>
References: <20220614183720.928818645@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614183720.928818645@linuxfoundation.org>
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

On Tue, Jun 14, 2022 at 08:40:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.248 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
