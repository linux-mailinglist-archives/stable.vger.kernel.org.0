Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16575627E5
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 02:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiGAA5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 20:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbiGAA5X (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 20:57:23 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D0857263;
        Thu, 30 Jun 2022 17:57:20 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id a11-20020a17090acb8b00b001eca0041455so4029312pju.1;
        Thu, 30 Jun 2022 17:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aJzBTo09jg+mYgSmE3CBw1+vidzi0TTjgEHoy98jje4=;
        b=fatBXzShgJ87XaHnERY7wKP0E12xp9f0F75RhPYSTBdG1X8C5h7nSDdJSfEWNbcUk2
         xRJPAjEwxxtp/s8tikLx2dHwZASTLgpPTzYG4549Mtknqf8qK6YOZBK9M8tFqviuL/q2
         zGoNfnb9ifJls2a+CbRiYIneDIOXcanpmei5Sl3e/e3bEmh2MLBrZ28/zeIVVwm+OZiB
         CoCg2g7P2O0yzjAosAkkoMrlx/NNx5O1VwKhpuoqWd7cKXHzls/p7QVKb+EfpQbIB0qN
         tS3ek8YR24adgEN/CUvsGIRwxmkfJM1Qmc6lhZm9a53NgJd0qU0ruhyBvvgCLDR6qYTq
         n63Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=aJzBTo09jg+mYgSmE3CBw1+vidzi0TTjgEHoy98jje4=;
        b=vb/5rOpxLGyxfFObsovI4IUcIvCluNJOMWiHodJfSVjBpqah6JzrJz4vwlYLtCyq16
         ApQjheuKNwYdkTmEBVNd4sWxJHwgczjw2uB+DVEw7Dx49VlEr06k9GNYMmdhoLdPvdP1
         EOHOmTCG5Vuj16eLuRpd6NSTPi2bCrxRwhz68basylow3FfJ3PVKw9Hj0SGehkcMmcQT
         Xm9F2gW+HOxe9IuNS3M7kmrbWASmJYpyGggYh4wu5xLSRLI0atXsSMRcdPxKQcjEx1UF
         pqBVV2tqyhgN3LczNLzMGrvj6d9ewVIoWBag+LlpOpaG1wygQK3oDjRLKFCEhm8LFxEA
         v0Sg==
X-Gm-Message-State: AJIora8zhsNGm0FLe5CT6FsoNGybxEc0kNvuGB+7n0xdkIijuvntcigN
        Eu1ZPHYfAG2MT9HZa/IoFxc=
X-Google-Smtp-Source: AGRyM1tQCamnEMwyGbYGWXbiDeS4oQmQoJqTeElmEihtep80ysYmrkkeU58xb5KyYPHbkEq2k7mkCw==
X-Received: by 2002:a17:902:e887:b0:16a:5446:6dae with SMTP id w7-20020a170902e88700b0016a54466daemr17082949plg.75.1656637039914;
        Thu, 30 Jun 2022 17:57:19 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f11-20020a170902f38b00b0016a1e2d1491sm14077157ple.59.2022.06.30.17.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 17:57:18 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 30 Jun 2022 17:57:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/16] 5.4.203-rc1 review
Message-ID: <20220701005717.GD3104033@roeck-us.net>
References: <20220630133230.936488203@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630133230.936488203@linuxfoundation.org>
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

On Thu, Jun 30, 2022 at 03:46:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.203 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
