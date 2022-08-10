Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F45258ED63
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 15:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiHJNeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 09:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232803AbiHJNdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 09:33:39 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9A155096;
        Wed, 10 Aug 2022 06:33:34 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id q19so13727087pfg.8;
        Wed, 10 Aug 2022 06:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=TjF2fZFy/XDzTKOYy+Uz6ill65TCTIKHorvBe55dom4=;
        b=fhSm8apONKK2++lSmJKnmwl0FE5SBBiyrhnS+NYAI4pilEO100H3fTA2C7Y47Sf7iQ
         2v2aaFiHsrKRNACSgRWj28Uj3x6yb+GhtXDySwJGPFJRy/cw0r+mNz9jOhWWbjnxUs4u
         DX7Q2KmQ0N3DSBuGpYHQ8gMt3dmLjOnyRgHEpBc2DOnb6e2uDX2EJ1jJsJM17jGG2RiV
         yidyntrYlXy7MFd2EZl6AIlTJ2AIh3sqqK0eT6XRkv8aSsSu+Y2GRCqxb9u4dvr4xQYm
         bOlpOtFjMnfHh1pcdHk+7P8Ju94hQgCkXkkrBxWLB1vJSb2f2K0DRCSt7RU4fMvWDKpY
         GTww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=TjF2fZFy/XDzTKOYy+Uz6ill65TCTIKHorvBe55dom4=;
        b=Q7sLTPg9Juq4BbpRFiPZCoWTvPv8r4atVgCcRS3mJ9btT6k19QDMLsH5e/eELfYJ4q
         PvGhZJQk5cByvfd5T88gdzF7ShICiA1SQQdwpES3mYorHsqc9u4kZZZUZexw/+Ujq6Pl
         mHHAPUmRG+XR1BBLq0ovhshZFcKIYPQ6r+ZOE+0gJUbJNJElLadxQJrNfk1Y107+aKFv
         2Rit5pBrDnjo8SJI8MHTNiEWNASzs2+KDlhQ1LZhN/8Qj2qFWTye1Nuv/enOzka5e8vo
         OJupdsELzsuq+nFBot3D9OlBbFk607oEjqGin+GeI32Puu08gHm0GQPGWPSBbKuRi5AR
         3LQw==
X-Gm-Message-State: ACgBeo3/A2pxCF8RG0FIaOooQrURFDDnhDCJseG6r0oRdCQB4M5d72wF
        DpG1lhWLI6FZTNn8iIXJxx8=
X-Google-Smtp-Source: AA6agR4ZWGniJ+403WC4xToOF06y87qiAnxpwdrvlOpuCju3wGyAfYCM4Fl4FIwf5CN0oV6PZgOzyg==
X-Received: by 2002:a05:6a00:189d:b0:52d:d4ae:d9f7 with SMTP id x29-20020a056a00189d00b0052dd4aed9f7mr27524253pfh.18.1660138414187;
        Wed, 10 Aug 2022 06:33:34 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u125-20020a626083000000b0052c7ff2ac74sm2020545pfb.17.2022.08.10.06.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 06:33:33 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 10 Aug 2022 06:33:32 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 00/21] 5.19.1-rc1 review
Message-ID: <20220810133332.GH274220@roeck-us.net>
References: <20220809175513.345597655@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809175513.345597655@linuxfoundation.org>
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

On Tue, Aug 09, 2022 at 08:00:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.1 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 150 pass: 150 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
