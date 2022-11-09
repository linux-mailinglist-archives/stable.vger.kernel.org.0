Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B79622CEA
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 14:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiKINyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 08:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiKINyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 08:54:45 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9418F26E;
        Wed,  9 Nov 2022 05:54:44 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id w26-20020a056830061a00b0066c320f5b49so10134794oti.5;
        Wed, 09 Nov 2022 05:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/epm3ScqC4GWlKhg/7VA05KC4J41B1cVP/6AFUBS4Gc=;
        b=qo9wSUPViGxLQKEbvd5RAvF0I6z7z04d65jczEDXkDIx+Q4obVhH7Qn2+D89yKtsRz
         l4QAG5uIGwivFHV82R7vL6dv+DaogThXunFvJMoO+yCBIeglSUnP7coobgCmWSEUvzRa
         /aBRqSy7fnY680ku9o7i9Jjw015Ql/4mtc7AfOPdCQl5N2tbNbKiM3RPeAP2HRsDPcVY
         OyNOmMpTMxW/a+92V5+GcDXfz7ZF78X5QVFnc4UL+O1kcnBSCQ3iuSp9vcXzBTpMauHz
         jIMHZ7XxH37rkxHM6KbfHLaTKYXrZi1JteR+JNLJUlMZS3jinoutympHFoFUpKuAUXO4
         hekw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/epm3ScqC4GWlKhg/7VA05KC4J41B1cVP/6AFUBS4Gc=;
        b=dXLhuXoorH1+29YpwqpE3qEJwfzICLW2mwkFFzk8VHe8g5Jmrp/M+ljDGJZGYuHSlx
         h8Xw/dFxirWmBADeU9AbkmE/9dZqXDFCMigGa3Yg3Tg5IyFIWtD3Ikjhdd6hVYtQzLVB
         H19ApRo5wjaMfe2Itt/9lYoLVwLtntrvfmWSF76iF9Fjn3rsn8NGLWYSKjGS+u6E/Apu
         XyAC5lYHgYUqG4RdCqYLck18FeBB3vq8MxowzR5bNDkLVYoN3mS49Wsjo/ihKzJEPrBk
         hPX8DVs9T93DmdtYx4vnxQp30OGyAMJiTEtgQyak0ZRO6DGqc/We+glU711Sinu3fSDB
         kwWQ==
X-Gm-Message-State: ACrzQf3wZJr8Mfn0wJSL/X/2/OomCAjqJfV3vhSyYNl4MmGLy+iqPxFG
        ZqSRB7wtnSdQZMu7WNOiKJQ=
X-Google-Smtp-Source: AMsMyM5nE1GK0w1aYEymkAlj7IHJoTlVFC6/S43Rz/6kXC01MX7zpjLZWrFbdy1bDV+sm0WhzH9Vfw==
X-Received: by 2002:a05:6830:2901:b0:66c:3305:4ced with SMTP id z1-20020a056830290100b0066c33054cedmr28489108otu.300.1668002083915;
        Wed, 09 Nov 2022 05:54:43 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f15-20020a056870210f00b0013ae5246449sm6084549oae.22.2022.11.09.05.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 05:54:43 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 9 Nov 2022 05:54:42 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.10 000/117] 5.10.154-rc2 review
Message-ID: <20221109135442.GB3538893@roeck-us.net>
References: <20221109082223.141145957@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109082223.141145957@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 09, 2022 at 09:26:53AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.154 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Nov 2022 08:21:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
