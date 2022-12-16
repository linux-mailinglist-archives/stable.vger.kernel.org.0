Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F1C64F40B
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 23:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiLPWYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 17:24:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLPWYu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 17:24:50 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37EA28704;
        Fri, 16 Dec 2022 14:24:48 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id p24-20020a0568301d5800b0066e6dc09be5so2199940oth.8;
        Fri, 16 Dec 2022 14:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YYit2c2jkPTrVbVdrstlPkLC+5NweBeML4Ph4fLR/gM=;
        b=bpXekg32yy+5yfgTWmHPlH7BIoMCxlTwyDV9EX8GwGlAkfN2nHsUy8FW8dsU4bRr02
         vOqOny21fNUns7idHCoVAFlq0ZSOclRxe9hM8P9CJkalsAqC4u2hkg+Jkhg5WAQfaEgM
         juUO7DYhzZZk911NrZrUate4wCCbejstmeYtX4biljNBcQFc9FFfgXqBNy/Bsp7T54GZ
         Qbl9LFB1f3x7JriCsOO+MmRNvsVo69B5B+tJkx9Ajt7pps1ZXFANDYydwlYKvo8WDSK+
         y3rft9+VBUzSlCDFCCEBXRIzDaCT+c/9awf23H4oj/D9DScs7hntDmtsas3i1FsiUP5Q
         Hkhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YYit2c2jkPTrVbVdrstlPkLC+5NweBeML4Ph4fLR/gM=;
        b=EZug3SKcWFLezgXgqqZLphYGG+0NOWnqDmdWTaH7DTkozFkNO3vt4Nlgsly/wTDuOS
         7OduHb1rs8xbBoncy45EZsFZan6p9y/XxOSUWbo4YuFAl+7YTHOnLgf/I7ScTekXViVw
         tZ1ND9xYdhoR7HPtRFN6IfH3G5LPxwjuLVMOV5kFOsz636cEgD2vWtVxIKmCvHvsfP4u
         1kxWCpAUZgpsq2mRmdZpn+DpuA+SqU+hYAGC+X4WBC3X/QP0k9WQcxtLuP8QRg5F3JmD
         ciJyYMUvx2UVi2ppmN6ww8Bp2uBWy5IcGbwLhdrXGeCIQelub8tmJPZp/cAWZ+Ig8hk2
         uT2A==
X-Gm-Message-State: ANoB5pmOBoQNIN04N/GRlwgUzSntH8qrqlYkyM1VDsH5lHXoQ4Sm6rFq
        BFzApPCgMZvHhFZFjdYhbkI=
X-Google-Smtp-Source: AA0mqf5oYROIxEhb5ZDap0hW5Paj3ULGJFVZ92lTc0ewMnYuzYiZVz9U4HZ9kmzbDYBjT2wNgNMLQQ==
X-Received: by 2002:a9d:7cc7:0:b0:670:5d89:b1d4 with SMTP id r7-20020a9d7cc7000000b006705d89b1d4mr17179706otn.35.1671229488024;
        Fri, 16 Dec 2022 14:24:48 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id cr27-20020a056830671b00b006393ea22c1csm1400225otb.16.2022.12.16.14.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 14:24:47 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 16 Dec 2022 14:24:46 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/16] 6.0.14-rc1 review
Message-ID: <20221216222446.GA4070447@roeck-us.net>
References: <20221215172908.162858817@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215172908.162858817@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 15, 2022 at 07:10:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.14 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
