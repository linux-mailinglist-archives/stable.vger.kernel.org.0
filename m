Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B4F510A04
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 22:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351657AbiDZUQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 16:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354823AbiDZUQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 16:16:15 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9DF1A431D;
        Tue, 26 Apr 2022 13:12:58 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id t6-20020a056830224600b00605491a5cd7so13798408otd.13;
        Tue, 26 Apr 2022 13:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dCRro8EfpsMFEeRGwGDgepP2GovQSBq60+GxZajvyQg=;
        b=djo9fzAQ1Lq5FJ7pXdZb1pwjodfHQJ6gvTVmJnZTDrhLzvzfhCQOmhy+0BU+gMZj7Q
         7MnPj6q7tdJx4CLWJuvYvoSvK8T9THCCCTPaWrPanEUPKD8BK6Qltvz0eiT0/bjUenfe
         tbbtoC+IL0rMP2IGWDDaClMwWR8lwfH9uEXQ7xgGlPLNJsS7KgmCstsYs0Py2dornsGy
         AKMN6FWIaaoUAMjCf/ESOEBHgFjRim3t/c+27I/9uMHZjeHznRqQhzKqYxNNmk/9FIXf
         bQjAxnvbl3PzB7QC/wll9zri9vpx3C0yER69eQt8CHKPU3jETDvT0s2AzmVGus/3Dhwa
         +aKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=dCRro8EfpsMFEeRGwGDgepP2GovQSBq60+GxZajvyQg=;
        b=Q3f7qoIcUCNuccbuUHcJDxhk4IbNwb3UaSRxaLy9RAA06ui2JpmzxOe7dABKNSKyqS
         qU5EVYYUM9kkz3LLE5ldyiJ4EFygpNMLm/HO9ZtLKjg7idtBT2SCqlrUwgk7a41XhTWV
         uVSbe9gBRYa5Shdzzk5NNj6VT5Ceig/+mQLNdA9RcuFaKA9guiAOdukrWYdZvB4XKiqD
         u7y+nBbENsFYuKrG0stIftC8Nppw/uJoK99X81pFCF3NW1Iri/1Z9vZeVofbBzcbmzH0
         5dizoIoG1fPL6LwIJKRRag1vgYaM7Hl45o7kQbgTvmRw/M9JDa+JCLltKvDCWpH8WWQk
         eRGA==
X-Gm-Message-State: AOAM530GKpbPSFIjLg/GJ+CDewzQy3wAMkQHillpeifKGSL977Ye3o83
        6oOKP/bbaWWDuoCGJijNexQ=
X-Google-Smtp-Source: ABdhPJwh2YmeTCPG8aWvtv2/51Gu5mz5cxRWlrPaK0k7SVZCKj+kFiTkJhqCUkPevh8snAbUfWVmgQ==
X-Received: by 2002:a05:6830:616:b0:605:46c5:8356 with SMTP id w22-20020a056830061600b0060546c58356mr8948807oti.81.1651003977592;
        Tue, 26 Apr 2022 13:12:57 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j25-20020a9d7d99000000b00605d50d6f84sm626176otn.40.2022.04.26.13.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 13:12:56 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 26 Apr 2022 13:12:55 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/86] 5.10.113-rc1 review
Message-ID: <20220426201255.GE4093517@roeck-us.net>
References: <20220426081741.202366502@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 10:20:28AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.113 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
