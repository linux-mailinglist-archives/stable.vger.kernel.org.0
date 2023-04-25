Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86016ED987
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 03:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbjDYBF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 21:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233075AbjDYBFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 21:05:15 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40846B45C;
        Mon, 24 Apr 2023 18:05:06 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-51b661097bfso4061316a12.0;
        Mon, 24 Apr 2023 18:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682384696; x=1684976696;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RrH16ZZyQmRjRRZjXjY81PGVGTn9lxMco03Ts+muwbs=;
        b=kZur4X0MVAHsbQQhlnQsmT6UpIoxeXRJdeilF3AeoK9FZqVBmGDj2QUh6VfrJtouE7
         UQ8G763+X9L4A3hEHj0Wgf7E76CqggVBNuUdlptDY8fv1EnqYeSRmd7kv1Qq7oFneZcn
         77E4la+GBSJz+1gvTujeei3pgH4tFmQHSJbe3/aNFfIOqT4DrwNLZ7nqhs5jKlF1yHui
         hIRWnX76qrUbvcmT6GYfL2heBOqu46aYsAg3whDB/0XG9SXcW15hK8kY31lwoly6JqU7
         U8dWTw8klEMkmwy/ONoedYDT+vyk1StLakuoxDFDU2jovs7eIhF8kSoLaia+nkLxEHvt
         0NDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682384696; x=1684976696;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RrH16ZZyQmRjRRZjXjY81PGVGTn9lxMco03Ts+muwbs=;
        b=E0BuhjM84S6M8QWZO/wNV3Z5hVSOeBL+MX2cWxIW3l6Ps7XkjO/4KO6/hbmkcVukMV
         +mDYtcnfWUts40+CanjmudNeIie+LEGTAqGKFFjH34Q5zSf2431TfDaLmnKC+9h9oqFi
         j/GvZc3/XVRQnPwrNjU+824KumGp0fuweS+8u11CPMIziJa9+kUIOIXlNZeveBxhdVac
         hR+QVb9yim4ShOQ1NocN793iU944BMVV56iWoXNCNL8k4KArI0BhTMoqeF2yiwGv7Q9k
         D1sZju8X9Tl0jNq+dhC2xBuoBhzma9FR5hRXpGJ4JAav1Ehp2a+RG3/KnOoMlLotUCkx
         i0tQ==
X-Gm-Message-State: AAQBX9cPk9zfWRA/FMO7xenM6wOBEqZ+FXNu2/hl3iAE30BZzA+73Wju
        L5GpgngQbLvCvaFjSzsb8qc=
X-Google-Smtp-Source: AKy350ayqzJrx1r2NhqUtF3O5c0bef9JndvmvbeJVyu2Ak14rCrOwQ0DAqmjVPFBv+Gc9qQVtavBPA==
X-Received: by 2002:a17:90b:1117:b0:247:25d6:b849 with SMTP id gi23-20020a17090b111700b0024725d6b849mr15643534pjb.8.1682384696239;
        Mon, 24 Apr 2023 18:04:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z22-20020a17090abd9600b002340d317f3esm6893161pjr.52.2023.04.24.18.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 18:04:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 24 Apr 2023 18:04:54 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/68] 5.10.179-rc1 review
Message-ID: <71512b75-ccd2-4959-bb05-445c7f1f56cf@roeck-us.net>
References: <20230424131127.653885914@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
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

On Mon, Apr 24, 2023 at 03:17:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.179 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
