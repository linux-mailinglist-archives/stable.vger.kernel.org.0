Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7854857B0EF
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 08:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239501AbiGTGSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 02:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239553AbiGTGSs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 02:18:48 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4B262A5B;
        Tue, 19 Jul 2022 23:18:48 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id o12so15668023pfp.5;
        Tue, 19 Jul 2022 23:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3EzP2A0r8ZZK6aHTYoO1TLT9+zGPnVJFxqVatBauUy4=;
        b=cDa/PGe49dvQiWflMd5B4X7KfjSPl37NOd70p95FPkyoHKgBGq75wL08FwwwgD5P4g
         9UaeQ6Gl0u1Y/kHNP2ErMmobwoPofvz3t3lNmpmXNRzsa1NyZXc0jP4cqTL5LvQ/Qo5W
         dOmMF2Wm6HwjY4gWyG2TRqHmO0L4nxBocZw17iyDL2XCRScEvH/gTrCXcRZC1CRjkWmN
         +jTRO6Wsm2X/U/xA0Stm5v3NYMJdFa++G+cABF9T3utwtG72k8svKVbCyZu07E4JaRxI
         7VC2fosrsTtiXBYeKWFNUZUH4VUjItaLfXGjSYvLI5qwTiG1RFAuQSD3d2m+H/TBJ1qc
         wQBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=3EzP2A0r8ZZK6aHTYoO1TLT9+zGPnVJFxqVatBauUy4=;
        b=ReCFpLPvbOUyfyTtzXpxqqf7r+v9WOhExJaKUrmPeR45LZPqGAnoepfpyiQdMMItS5
         sPSgawKF1IX68iufh+VjXgamjSdPTfprMu695rtzkWjnuZ6C1fjJFgtYZBmlM5oFjdfA
         NXNyk1WFnR9C+L8ZjF1pr50iz2v7fReIgz47nfbGpwHzU7i9Gkj2ju6faN1DLFpS1Cvk
         e3lGADelH2r4N+rQZtLm4TfIG20A8vXkp8keJZUq0ZUuMt95AGfM1x7oH4Sc3oHJo0Yj
         dr3rKj7lgevF7BskIzH33uRdTeMNbVichkRbihNxD7dM30Ubzj0ALsUfFKCJ1rqfnGiD
         Zyuw==
X-Gm-Message-State: AJIora+EseAjSbn36YYnhBl7m4hfsJGlNMzJFGODpI8ztomTppQNkzOU
        EGqJqulZ4DWUygO+CWmJ0g3PDnPZ17OKcw==
X-Google-Smtp-Source: AGRyM1vn40CWa9oKpIE73riVnPhJw5DISU6mrQTKTOrxgMO5oLTvhZiWRY4dIqa72Q96WHRUel5u1g==
X-Received: by 2002:a63:8743:0:b0:41a:6f6b:db7b with SMTP id i64-20020a638743000000b0041a6f6bdb7bmr85042pge.594.1658297927516;
        Tue, 19 Jul 2022 23:18:47 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d3-20020a17090a6a4300b001e31fea8c85sm664117pjm.14.2022.07.19.23.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 23:18:41 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 19 Jul 2022 23:18:40 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/71] 5.4.207-rc1 review
Message-ID: <20220720061840.GD4107175@roeck-us.net>
References: <20220719114552.477018590@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719114552.477018590@linuxfoundation.org>
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

On Tue, Jul 19, 2022 at 01:53:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.207 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
