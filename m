Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF814F8917
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 00:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbiDGVuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 17:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiDGVuV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 17:50:21 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2538EDEAC;
        Thu,  7 Apr 2022 14:48:19 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id v75so7064454oie.1;
        Thu, 07 Apr 2022 14:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8xVx/BGataQ2oY/EMcrQDWJod7xrCYkVtpReRuFJXwU=;
        b=ScPoCPLGaAojSVMiQ+pbTBD8QuMI2QuWv2sH2MAaDnY8nOtHSMiylF8uxyYzd6Rjin
         +04PUkr7id/7qB4QBFUKKt6f1B2b4lfuPmWzl8/lrMqArus1YrwRTa/1Ydwq0D7Dnme0
         YDIFaBfG0YXgR5oylt5IikooLcehut0myAmk7skWMI7PIVgMgruDxGUCZf3vuXIjnxut
         C2BUzFesjuApmLSPv6RHY/Pwn8tUsMfYkprdNrIrS4mQz6NEVPBiiYrnZqBdG7gHnuCs
         0r81WCZT5ebWQg4aA8gf6UM1pwQytBPgJeT0xp7tZuBnM3LkpG3qSTUMgtDyYsMziQSC
         uN5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=8xVx/BGataQ2oY/EMcrQDWJod7xrCYkVtpReRuFJXwU=;
        b=uBGKTnYF0zGqwRmv/EPQhG0BQrPXDUrQ4rrqo+CP0pEseIga0DuXc5EXUIAQqRu28c
         5WHD73jTWVyq7lOtWgzzzPRa2FI/0GaeMgtXmwm4+kwUAj00VSkJM7m3jsqy1tR/b53j
         4Okw6INaic/JEFkclFo9m+CFwMl/8/Odg/72kIe+EP5PS5bdx/7g9TDM6paz5a0AJKF/
         1hJueLF/whQbo9qQ88y5iwSMHZPlT14O4snGuk3k4ljMwYYyo7PDlr+drdNg/6MIFjQ/
         ruG8dDTsEuRDOWLroMAlfSpHwf/8ot2ZofEEl8X8zPU+pQCA9TNigdfz91NZ+u7nMZrI
         Ufuw==
X-Gm-Message-State: AOAM531RiknsIUemIs/puUfOyKLoMxPPoY52ufawVImXSPV373rFubi+
        kVLufSHcFaRQMMtp2mwhqjk=
X-Google-Smtp-Source: ABdhPJyiUF6nXAbqGXLT8uOD9+FBR5BEeAfDYIhSWr7+gexbUduKHEOffprHHKIAawvv6h6gnytjcg==
X-Received: by 2002:a05:6808:d4c:b0:2f8:d0d2:d06c with SMTP id w12-20020a0568080d4c00b002f8d0d2d06cmr6789543oik.285.1649368098470;
        Thu, 07 Apr 2022 14:48:18 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o64-20020acad743000000b002ef3b249b9esm7959140oig.58.2022.04.07.14.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 14:48:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 7 Apr 2022 14:48:16 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/597] 5.10.110-rc3 review
Message-ID: <20220407214816.GA186606@roeck-us.net>
References: <20220407183749.142181327@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407183749.142181327@linuxfoundation.org>
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

On Thu, Apr 07, 2022 at 08:45:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 597 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Apr 2022 18:35:00 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
