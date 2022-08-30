Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD745A588A
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 02:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiH3AsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 20:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiH3AsT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 20:48:19 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940DA8277C;
        Mon, 29 Aug 2022 17:48:18 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o4so9600900pjp.4;
        Mon, 29 Aug 2022 17:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=0rOU+HDWCWdAXd/6VhBt9glJzZEGGLscF69qifaijiY=;
        b=m4iZvzrE1ypjQoFTPwS7J/+pWo14SJtjudIaHUooPvVfJRCJ3369KZWHqShzlG5x6T
         VPJJhPLryb9gjcaWUitht7pKfa67yX2/p3DTvqkz0AOOm9f0F9h9mvVO4mrEcUJxMv7+
         WzL4Wb2cZwEWr6O2VEoXZv5nbUJ3MA9eJR7Zl5uESTlBc4kuOBlBsezKDcws/6ncI0BQ
         c5NJQ8B6IUsvyBn5/t2ddKFHFwTaV7hDw1IeGaeOE2oO4G+or2LM2JUrfSBaWuRmCuwc
         hoTTT1U3BkJCN4UXTlWQmSYMZm5SfEMZ448NTKEB0hX8/bnlqzLwit//R32TEtHIHNu2
         8ikA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=0rOU+HDWCWdAXd/6VhBt9glJzZEGGLscF69qifaijiY=;
        b=Q9JDw+u42+AYchS6DZNpKPPIors3ZEldGQJX10H+fp4Lezcpj0hHztJf5c302Ocl++
         acSfKI1CrBfncI0OSAfP4loQFABaE2oHCBUSIoYCgJc6qb8FuzwRWcyfDjd4GQQFgSzc
         Pd8SmLfuzBIEl7IEMig94dL5DSCUCgj1fLcnxzvmxCQpEhotOWIwTMiCTaBPx+PAFRdx
         6o9rzYlzCxD57RbSXUN8j/kktO1dpdB8zPNANKhvkrR0g2ZV+p7DFxL0bFdAhPl6xv0A
         fDT58PAvK+iTwMNsILf2ozB8svb1azinib4qevWZNRbfyMXD+Mb9rzYasU5xIIbjHwUY
         WWKA==
X-Gm-Message-State: ACgBeo1OSSyrco0l6e5+00cCSz10PeZWmEunZIPU9xGN7jET8Pz+xQrw
        vvyyI3iITTWppT6Wb1Z0LGg=
X-Google-Smtp-Source: AA6agR5bLChBL/HlABZ7+DfzuqybN7raHsCqAUpEH8ghPi8f2HyKi+uhBshf1IA17SJa+unVLSGWyA==
X-Received: by 2002:a17:902:708b:b0:174:edf3:381f with SMTP id z11-20020a170902708b00b00174edf3381fmr4496628plk.90.1661820498179;
        Mon, 29 Aug 2022 17:48:18 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z15-20020aa7958f000000b00536aa488062sm3823977pfj.163.2022.08.29.17.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 17:48:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 29 Aug 2022 17:48:16 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/136] 5.15.64-rc1 review
Message-ID: <20220830004816.GB3337218@roeck-us.net>
References: <20220829105804.609007228@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
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

On Mon, Aug 29, 2022 at 12:57:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.64 release.
> There are 136 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
