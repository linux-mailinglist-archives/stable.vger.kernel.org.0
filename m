Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 919A14BEC62
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 22:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234485AbiBUVSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 16:18:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234530AbiBUVSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 16:18:01 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05ED52AF8;
        Mon, 21 Feb 2022 13:17:36 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id a19so35288169qvm.4;
        Mon, 21 Feb 2022 13:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5TpTQBkv4fguz8jFBE2x2ddXPc8z7BUgg9F6BEb7AOA=;
        b=aoNHLqhdEb1Lx17KAZ1FI/tcxG0u33vYQvfietBbPVQL4smnuak0mAx7lHUmMoVymh
         iOkXTnA1Ggka/Ok4M//1qFR4suS8ucxJNAbxeOeemTnWItnasXW/rQ7GoXLrSISYgi0o
         4LDpT7E++uLzTW5VawGtXJRLYLn3F82vVxsUPqhRtg02fbKAUNufg1xG0rboPexM7QRP
         fsJPnGJ+QX+2zIPfX4OYMP7gt6mo5qpEe4ynox7n3kHAmbOQr+xC9jYmr2AMLofGWNQb
         afJYRvSUxLwlAOSm4EqhLHs0yZVdYKYadopFYtcrr9vARJrFo7dzihtKqvcIzfMTMIiA
         ipJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=5TpTQBkv4fguz8jFBE2x2ddXPc8z7BUgg9F6BEb7AOA=;
        b=mpElRTeWhT2kUVYcnUh4WJnBhEqpPIkUt+lhOQdPJGMB5WWxPLEa+uKbK4zJuBn5bf
         CzbWRNDt27vbwyjZ+Lb4WtxuriZ89bk/rURpp358dR6tHJXQQyhkz8roVYibl01EBOtc
         JB0+3l0K8vaYZcmWWEVb/mFaRvSi5DpVoJWI8yzQaIl9L7Wq+1r2nNC8dZgEy5tB6W9m
         FIQ/IkkXKVQNWRsUBHBp9KFCsfWM5dSPv+gq7IOPt1aLVjeylkhBOjFfNsDgAOpzDJo4
         ZI/TtJuqk63yMCoKwVHNbtnVqqIOkLMaajEkzsndmmIxvYgLFt9+pme2EpBWTcA9cXA5
         v1Vw==
X-Gm-Message-State: AOAM532xul8MmPsChByKzFcGsuw7OzvI96zct0BvnRWaCt4up1BqrFBY
        EK7c+k2wiyKZaqnSiGpVQmaXb/3XsiHJZw==
X-Google-Smtp-Source: ABdhPJxELvJN/5iPjIO1cDDepkCEJH6fn/7Icu+2FG+rJOab14zbDpChNh8sGK4Dvo1KniXPAMyi/A==
X-Received: by 2002:a05:6214:21ae:b0:42b:e96b:38b2 with SMTP id t14-20020a05621421ae00b0042be96b38b2mr17092041qvc.14.1645478255243;
        Mon, 21 Feb 2022 13:17:35 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g12sm1265787qko.124.2022.02.21.13.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 13:17:34 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 21 Feb 2022 13:17:33 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 00/45] 4.14.268-rc1 review
Message-ID: <20220221211733.GB42906@roeck-us.net>
References: <20220221084910.454824160@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221084910.454824160@linuxfoundation.org>
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

On Mon, Feb 21, 2022 at 09:48:51AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.268 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
