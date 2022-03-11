Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E7B4D5F33
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 11:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347755AbiCKKM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 05:12:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347740AbiCKKMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 05:12:52 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEC51BF928;
        Fri, 11 Mar 2022 02:11:49 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id l10so4856687wmb.0;
        Fri, 11 Mar 2022 02:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XWWog9ZrcbURy+En9U1Yp9z2N+ClQ0Jz7PvXhWlINPA=;
        b=bR3WTCIoI2i/HXjv3iIT1VuPIwABYlp7o/7/SLe7quhaN9Cz/Km9RWnf/FQ4Dj7ED8
         wq0OCPOfhmYGlf7hMWwznJ8noHvxvWNsmerSLjR/Y8GQyNbt8DdSiN+SsrJD3tMNRiX7
         Ni8kcuuHUGQkXmLfE9xxlmZeRDT5+nlUwZzv1JVSzxk0lVV/0lVJu8nT/Kvhk2EYXBF8
         AGvS8g5FdGXaqZvIoSeqs0jQrK1JMlwe8Ly2PK3JUirXD1liL9N5Qfky+nBff42G61+o
         5unoDDsFQkaJM9xgOlwnx04eCz4umbzt8NZyZiZGAnSwNUcC0K1MaELFDeQeUQ1iIQvD
         8Uhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XWWog9ZrcbURy+En9U1Yp9z2N+ClQ0Jz7PvXhWlINPA=;
        b=vsA+EKDjD4v762WDmAWbwxgA9IS6sbKf40MZ1z91NzPkwNQwyLIyZ3I5a4NJN/jnhq
         7ZOV1sAQA2MNeSM6aVBBlBDd35LraevpQaYIoZCwBNvvML+5HjtCgyhqrdwG+U8RID9e
         DHAR+n3H+gfoHdeCM8K7LcJqePCUetCPUNaiXAWzNOYIj8aMVJqNdMoEEGCyP1FYJOIV
         OiNoxQZIaSeJp7ZBw2nY5bvp0kWkfQ+keFpO5IQSEeU7nSzRkkuk4mdz5j2beOgriyf+
         mzA5BJgOyw3SAAL0PmyGQde6/W0gY1tg5O7QsJmfJ7Tfw8NeCqKWpNrekz7h3zDCNQmY
         xeUg==
X-Gm-Message-State: AOAM530zS3Huvj3H+ZKTDwvdWA+bj3fJu499Bgq1CmWykMZDxnHHAAu5
        12YHKVly0CRR+2aMOSARdqM=
X-Google-Smtp-Source: ABdhPJwoLQwf10MjQ3fNJUd75Kn+U5Htx3BCjBMXK/s5yTthUALNOUzfisPvQD2+EPEbPNbOUAGr+Q==
X-Received: by 2002:a05:600c:1c88:b0:389:bede:34d0 with SMTP id k8-20020a05600c1c8800b00389bede34d0mr15225444wms.62.1646993507804;
        Fri, 11 Mar 2022 02:11:47 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id y10-20020adfee0a000000b001f0639001ffsm9297617wrn.9.2022.03.11.02.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 02:11:47 -0800 (PST)
Date:   Fri, 11 Mar 2022 10:11:45 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/58] 5.10.105-rc2 review
Message-ID: <YisgYcR0hDPM+ToD@debian>
References: <20220310140812.869208747@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310140812.869208747@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Mar 10, 2022 at 03:18:20PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.105 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220301): 63 configs -> no new failure
arm (gcc version 11.2.1 20220301): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20220301): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220301): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/862
[2]. https://openqa.qa.codethink.co.uk/tests/867


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

