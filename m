Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25CA452ABFF
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 21:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352763AbiEQTcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 15:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352740AbiEQTcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 15:32:10 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A031D0F1;
        Tue, 17 May 2022 12:32:09 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id q10so22583oia.9;
        Tue, 17 May 2022 12:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aDsLP5DrPQ5D8Re1lpUJfh1V/Vsoo4LM0Yku+ABKaWE=;
        b=ol/RfS0eZo5ZlVviKTCX1S86ex03ivVcbv3PZYdhaaWa+6SUIeMAZqAFcWIUUAzjB0
         3a2k7gVLdE8ajDrUdIE9z7ZgeLP520z2LsOJcCpLUj5BNaBccipCgKFPRWJHU6jqCNtj
         NUhb/nLADfcxDrnbiXtXyGgDgNx1677Cfigp68fXfVAhHxcP+z94NeGLod8kfEX/Wdvl
         59Qzu7T5RvVsR29vQnJgiiSeDoRoWV6vqF8Mjn2w4Koq0IU6kEN0RQ8UswtKzknmUzYX
         lh6Py0pVzlA0uFaTmRnd2Gg1Njl3g52S1rgFM63ddT1vAEi+X2Nuqx8dSPhdRHSEsnzt
         kAFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=aDsLP5DrPQ5D8Re1lpUJfh1V/Vsoo4LM0Yku+ABKaWE=;
        b=45HkaGE2kEajuWjbYag1lV2SAXqc/m6/1+wK+5ZZW1PhUxjrNmtLbwvDGjzL7AgGGG
         Yuiz2/gi5yCrG96bc1O9vwaXB8qKeZWbvNjHAAOyMlTkAqnMNPWG27HI3QyHgWC56jrN
         JgyAVv/WMMdJ/gQ/DDR1K2kHQ5uQrcb1dw+sWny67Oxw23zhyh46tTI4G4BhRS7Jy1yW
         Yei7w1Sf11ZTG0qDKEBNMAfBvUdEY3DRLplqF14JiDtCkfzJEPQcQVCYsek/jm6kpgGc
         vdPPk4lxehcYhdfAaUzvBRA8zE9mNQ8pIgrnstvRZzPW3MWQFPkNbwMgxvhqDGxsm8Dw
         TkkQ==
X-Gm-Message-State: AOAM531dUAamdx11d/faWydfg+zxmhKioQ11ZdRfannfdQ9f+q7INoMo
        jsMTwazmE67nqy7GYHxb04g=
X-Google-Smtp-Source: ABdhPJyG7TwUdkltiglRyLHX1c4ijLZKcEtK/g0Ynt+uZhry986gBZcJ6KOWXaF7FnHNKWuUGrvtNA==
X-Received: by 2002:a05:6808:bc6:b0:326:cf94:db25 with SMTP id o6-20020a0568080bc600b00326cf94db25mr11338288oik.297.1652815928440;
        Tue, 17 May 2022 12:32:08 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c14-20020a9d784e000000b0060626a8e5a4sm72678otm.74.2022.05.17.12.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 12:32:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 17 May 2022 12:32:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 000/114] 5.17.9-rc1 review
Message-ID: <20220517193206.GG1013289@roeck-us.net>
References: <20220516193625.489108457@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
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

On Mon, May 16, 2022 at 09:35:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.9 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
