Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6455B4AA195
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 22:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240326AbiBDVI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 16:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiBDVI2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 16:08:28 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79E3C061714;
        Fri,  4 Feb 2022 13:08:27 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id l12-20020a0568302b0c00b005a4856ff4ceso6000021otv.13;
        Fri, 04 Feb 2022 13:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZQSV3mgD6g7mCSVRsGXe9346On/Yc+0XDK08ZkL/So8=;
        b=av2AP3ZF+wt8uo5AegnevVtsSmcPK+HCEyEwRUUnqPVRHblRws8ttv0T12mamZQuE+
         0pj3E/4NYAtQnpWa4M9oAASVDgG9X7eOkS+DTeZIBRfh45OwD4CX2fNyhE+3aJ3pcqlw
         ohwobgop7m70bYbWas6x00CmfLuYxH47yW1pdCL4egmS6r/AnerUZd0N73Gwg9HWIkX4
         tfRVUVAqV5FsK/RnKIbQERn9LrgAiH+RYu872N3ZWebmOavsDR7Hh3ZButGJ/tXJmA8P
         431RmAyVXNodPm7EjATFBEFZ/FKsL2iC8isfj+tcxFirjaIBx0/+1gA66+IPFx9xVd1H
         Cgcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ZQSV3mgD6g7mCSVRsGXe9346On/Yc+0XDK08ZkL/So8=;
        b=5mCtFmw4Se++9Ozkf9B9B4NsUsE3+q0oJPvo6Ni+yC2rqVqclCSV8v8Z+yE4SpmwaR
         /fySgkqLXE7AVueB65l7a/cURLiV+aQC0M9kAamMAprVA08EFRsQPjK2nygDJhlA2E4P
         4AbO/29iuOl3Hw6C4fd5QIW5mkevTH2q3RY2gAI6NXZWhk6Mu4RBzBFXCs6VV9iVkPO1
         zQXwrxAcnUodDsTHAcDqikwkU6KjDjZPaEcspiBHKNAIUJbAX5K7vdixXnOFu344NuOM
         6IPkaRo0ydfVSKSRAVMDrIGj29SPJyOsHmOcdxFzOw5x4AjvaFdu2oLF52HKnLRlT8ZX
         21rg==
X-Gm-Message-State: AOAM533h4CCpVo2kUCu5mxzoZ2IcJUbBsTuU/5QlsWffNR2IdxRJBqKc
        FrjZZPmICtFgph7aSWm4UMc=
X-Google-Smtp-Source: ABdhPJz/ZOouyFKumHrtFS7iuvR/B7+jKeKiGK9IQNumvVnjDNbt4d5MFn1/ncqgI70XRJEi7QcVsQ==
X-Received: by 2002:a9d:30c2:: with SMTP id r2mr354439otg.62.1644008907206;
        Fri, 04 Feb 2022 13:08:27 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h27sm1168376ote.57.2022.02.04.13.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 13:08:26 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 4 Feb 2022 13:08:25 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/25] 5.10.97-rc1 review
Message-ID: <20220204210825.GB685902@roeck-us.net>
References: <20220204091914.280602669@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204091914.280602669@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 04, 2022 at 10:20:07AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.97 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
