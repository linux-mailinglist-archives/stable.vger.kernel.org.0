Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7DB66B5818
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 04:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjCKDjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 22:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjCKDjf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 22:39:35 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A479F11AB9A;
        Fri, 10 Mar 2023 19:39:34 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id a4-20020a056830008400b0069432af1380so4004851oto.13;
        Fri, 10 Mar 2023 19:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678505974;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZvG0fhpZYyqoSE8gxi/ypMj2Bt0f69C0fDXhG9bXUlU=;
        b=mqy3zdXzEccpTUHXzl1xGiCbl4+PMZAIxCaFoQSxpBHZBH1TvLeltI/0TE8hmJBbZv
         JpZDLLmQBjqWXT41O+ExYFWP5fpu5ecXW6YAY90Kxi5MwA58WtbEka4ruY2PFfO3RZgD
         yIxlCK+2EpnLRx4FN1gH9gF09bx9Lldht8u/sVZdEdR9wOZ+1k67m8xtJ9F+W6dpA8uO
         OhJM0Vm+gaa9MU9P/BbmSHlVpuIYe9T/UL9Y7HBdiMUc1y8Wwyd0CA7ByRNwYBOSHa+1
         +B6BlQTEEw+FfhCJZ5yG5mpt/W4m55Gj/s4LIJksQGoZKvClB5E1stRs2L7M4kAEtNSp
         AGuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678505974;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZvG0fhpZYyqoSE8gxi/ypMj2Bt0f69C0fDXhG9bXUlU=;
        b=OnleBuIz8S6YFYMFs8oKtG6mWefBIkMYUlibXT27D4Cf84kdTYK5TUTS6dTzesr8ei
         X847GPVp7rEW5i8UQHUF26tpJiOrRt+pe1gUiZxF/sH1H2xhQV378UlEaF/4xuTiOb4G
         0a530L0PvqoGvE3L1CteNdMS0fc5sUdiPBXx3YOUgaBpK1h8iYUToqex3b8a2YapUwqe
         VMxcveZY6NZFKTRSZN4t0oXg99lG0HAHhGs0i06WcD2nqUXxn8thWhi30x9IoWY5Gc1V
         9Z5+YabKv1YtYEwnE4MumQNqsmYFP6VPaAYW4/pmBiqMOV181v4Yw4qf2Th1nLtazfbE
         i+Cg==
X-Gm-Message-State: AO0yUKVrAgDp4lOepwiNF1DuJQ4Vp7ivo84p9Dm/LeALaa6Fz/2ox3Pt
        tkB5SR9yiWsJQmKATR/WdOM=
X-Google-Smtp-Source: AK7set9cU7DqEJRaba4YNUbGH+3H4wrWnLIIwhCcgT6i2BfUfQAvtSNE19Bzrz9MW95r0C2kZlbbyw==
X-Received: by 2002:a05:6830:438e:b0:68d:b394:458f with SMTP id s14-20020a056830438e00b0068db394458fmr14820314otv.17.1678505974030;
        Fri, 10 Mar 2023 19:39:34 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i6-20020a4aa6c6000000b00524f47b4682sm670656oom.10.2023.03.10.19.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 19:39:33 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 10 Mar 2023 19:39:32 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/200] 6.1.17-rc1 review
Message-ID: <277fbe49-d6b3-4bfe-a769-a172f09d06d0@roeck-us.net>
References: <20230310133717.050159289@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
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

On Fri, Mar 10, 2023 at 02:36:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.17 release.
> There are 200 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 516 pass: 516 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
