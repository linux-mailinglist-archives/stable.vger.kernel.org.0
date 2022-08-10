Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5C758ED53
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 15:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbiHJNb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 09:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232795AbiHJNbp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 09:31:45 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5A328734;
        Wed, 10 Aug 2022 06:31:44 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id p8so14203792plq.13;
        Wed, 10 Aug 2022 06:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=7qGe3fyC/aPZu5DqJ4F8I5tCZf+Y2qRqDhOcUaohBKw=;
        b=N0sACE4snSXLz9oOdeox6qO4602oEEbGP3pgGfNGoo9uWaCoKdilUHdFshlFNIj5fr
         JAb3jPXqZd/6z2zl0JFyCRLtTD8No3WJbSIl3YujP3Ar66WAVs7hvLl1x3EBVeVe0xjW
         1J45gJA6SsxsVfmkcbkkr/HBYjUQDVrcoxXKd2h1AsLwlsErLTnD2dNGsnn7ziWqQdYM
         QZWjHq1gJSEBRwrZxPckHPrxRs4ZS4TqMKWVAlVlPJrG+UX0+hAoqZtw8tZZ41F/pE8u
         PpxBF5q7wPJCZyZ0Y/E+p4LtozSgxnRcY4uqgGA1Wz2mfLLObWfY/L8y38+k2yhjpjeL
         zztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=7qGe3fyC/aPZu5DqJ4F8I5tCZf+Y2qRqDhOcUaohBKw=;
        b=WywXCmW9mpAQhx7POtFPpZPrTST1F99KH2uuSEWNzijmliQfYZWuIdo2ynFAfA1l15
         Ian3FoZWLAzKt2GgAxc34Sm5CO9bUeJuGHcKtvl2Ibob6c7EpYJmkM9IHNrsDGPeepk9
         gkv9CGiDglyat+6e4Mzj3K0/o2X3l3MxHAnZBUsDfSQ0g5/IPk4Nlhj78ClhFX2dTRaG
         +QPjU0cdGimN/0af1gw4HcCNSmjHT6IgSbNnzd7WCp9kBrlo17uhRsITwzD0N4w8Yd8w
         H8UCge9sA7ViObLGdFq94ikV3MgfPSE38RNvk6YiO+6w94mKynIDzm7+MaDlWAzd1w8h
         F+Gg==
X-Gm-Message-State: ACgBeo0f2SzL7kGpTtObUE9FZweFUyW2HEmqk8o1lB3N6yu69uQ7kwmJ
        QtV8LRvS0hHSXcG1HH+9z3o=
X-Google-Smtp-Source: AA6agR6BTs8G9q0/wbPgLnYCjHQeXxRE2Tmbjdn+wWQh5v9O7Jkay2URStTizt3gXPokScJDWczvyA==
X-Received: by 2002:a17:902:7b85:b0:16d:2976:42e1 with SMTP id w5-20020a1709027b8500b0016d297642e1mr27885182pll.141.1660138304392;
        Wed, 10 Aug 2022 06:31:44 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p14-20020a17090a2c4e00b001f754cd508dsm1616327pjm.35.2022.08.10.06.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 06:31:43 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 10 Aug 2022 06:31:42 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/15] 5.4.210-rc1 review
Message-ID: <20220810133142.GD274220@roeck-us.net>
References: <20220809175510.312431319@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809175510.312431319@linuxfoundation.org>
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

On Tue, Aug 09, 2022 at 08:00:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.210 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
