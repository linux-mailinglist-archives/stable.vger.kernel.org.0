Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D198264F329
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 22:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiLPVaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 16:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLPVaO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 16:30:14 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD7261D68;
        Fri, 16 Dec 2022 13:30:13 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id v70so3080769oie.3;
        Fri, 16 Dec 2022 13:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S/Qk70x5TBPU2i02XgnzB2ttW0o6WKxWCkbaWFneW+E=;
        b=mDxU4nhX4L3zB6DkGwLxZIMYfQAbquZWl35hMWG7xmAb41/uxw31B/GruPQb3Rcmj/
         DQJwM9/NlqrI2KoyR/J9ooyD+SFRlDOlU0mlR+IwfVo0olU+CJFFzBq8KEE1yMkEMxz4
         IPGl9BnN05MWQuMR16fVavM+0V6YKm4x4cOub4XPx9A4QL/CEi+ke12d7tbJqyovsVCe
         mpOomTC8z/dNawmjoWS1VTdR2nBzMV5nIwH5PhpsbASdOfV5DorbBFARiyiIYS1ZqCUh
         Ct02dPur0wrBdMBCcRsNCiZqmg9MpVWf2ngxuIr/u90Wadx5UTJ0YJsVeuUx9GUsrfP6
         BSqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S/Qk70x5TBPU2i02XgnzB2ttW0o6WKxWCkbaWFneW+E=;
        b=j5J0TXNk35S31yxNxOPC/C5FIKjA7B/XHqUC5HANd0p3IBAayWiIU1jhk3xFPUWHOX
         2ewunFbq2lUqJM5kOQueyGUoW921jOJCg4+IqOKPQiFIOkLS6ZYsbnO4BdhqwB1xcmGU
         /hBHnTEflK8pVb40NQUUWev+oxcGFfSse5hNFRnodApiGgZ39ApSR+z9TARBr6sPET11
         PdDyhDBFEDLfDUAWEG/4PejNoFMGL3uL3FfUuR+BEWzZpWa0PrsurSV4uZ3waGERn6u+
         YcnkamQ8Bq84myu0rfLeXs8oqBas5DeAZqKpVBb7EYYOPt3dHK8wnGfcm4y/d1eNAsI5
         4xSw==
X-Gm-Message-State: ANoB5pl6vZqkRGGRu73NVYLACKgUyD1m2UOF5hrwPcPeDj39p17fgiKc
        JVOyEDjVpYaytdjJb3L+HlC++8iDtMg=
X-Google-Smtp-Source: AA0mqf6+1stzUnnU5rBCMAkM4zhg8NpnztKeFuZ0iPNbi7iJpsoaCNne1BmOjY2g37gDcBdaqpVPtw==
X-Received: by 2002:a05:6808:d49:b0:355:1dec:321b with SMTP id w9-20020a0568080d4900b003551dec321bmr20159429oik.31.1671226213283;
        Fri, 16 Dec 2022 13:30:13 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l20-20020aca1914000000b0035173c2fddasm1212502oii.51.2022.12.16.13.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 13:30:12 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 16 Dec 2022 13:30:11 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 0/9] 5.4.228-rc1 review
Message-ID: <20221216213011.GA4067594@roeck-us.net>
References: <20221215172905.468656378@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215172905.468656378@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 15, 2022 at 07:10:27PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.228 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 447 pass: 447 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
