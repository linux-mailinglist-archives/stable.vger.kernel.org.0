Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8997A6C3E5A
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 00:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjCUXOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 19:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCUXOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 19:14:12 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25E71ABE2;
        Tue, 21 Mar 2023 16:14:11 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id s4so7693002ioj.11;
        Tue, 21 Mar 2023 16:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679440451;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MssNP+dR5aGnqdDwyUxjGvQlcjhJTe1cfgpWPQPKmKE=;
        b=oTDyKNsA4gcLP9kaM36zvaR9lCb9PNFw9gWI5no6FllpkFWjGigPHEonxIOFTQmMsO
         wXXO9FJN6mquB9NG6n+KGsdCOULEJCO5Y6YmKEAfFxfUU0yyea5tYz9flDRW906pYGXy
         gGfmG9YsJTTMgYU80rP/JynBV8zZuJlzi0nkJdFBRy5Kg63UIG+sV87mpCWzL5sOLEpR
         m1CqznT64rtjjDN0GuK+1xmzLwGVrDxW0mdxAtAb6UwMVQUyZtGCaOLg5dimGwpb8cUm
         VGqkr7ALTBrIx9ZCOF60GS17cNBlcLayaAhUI0gAWZx4scF2tLLjfAr6gz3AZabHmswv
         UwfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679440451;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MssNP+dR5aGnqdDwyUxjGvQlcjhJTe1cfgpWPQPKmKE=;
        b=CVhkAlZu7e1r2gJ0v+jPQwXwKEM5KER1hvDU6THq7eC8fTb7k4VxVcZCt0otNbLJ6H
         mOzrvkCxRHUMuz8r1u45EehlZBOq++D2F5cs8h6KjSAZg9JjOR9FizYIVULgelJPzCa+
         CEq6vdqx6UIzShYCCGyUfc3PrWKAMjRgumqgf70pDbXOd1KlUtoalqZv8M3CtC+upzrg
         koibAcWSBKNM1wGog15GPVBvssZ0c1GZMKUtQgZED8JtFBcsYIUbI6AYkYKqA038YEki
         G9avINz9xZVspjYY6KHGw9AHVk0vzBt/vvsKr5LZL2qWy8VRTbxUsdCvnv3jAcc7SRa1
         6w2A==
X-Gm-Message-State: AO0yUKWipECQIis/oLljAzjjdM36oOMZWKskDmiKv2yT/mg3/Fy4qgB2
        9ZeWWFoOrxSZ6qcQMEm7EWk=
X-Google-Smtp-Source: AK7set9ggclAWMp0o/BqHHDsiwpRuErvu6iFmkFJ+F0Ha7GZpOpmie6EHyy1YVxUDxQWmbyXiCkvwg==
X-Received: by 2002:a05:6602:200e:b0:74c:bb78:25da with SMTP id y14-20020a056602200e00b0074cbb7825damr3364359iod.0.1679440451275;
        Tue, 21 Mar 2023 16:14:11 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z20-20020a027a54000000b004064cc1c601sm3839204jad.75.2023.03.21.16.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 16:14:11 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Mar 2023 16:14:09 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/99] 5.10.176-rc1 review
Message-ID: <7eae087a-f88d-4506-a593-4e37e1ac2d14@roeck-us.net>
References: <20230320145443.333824603@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 20, 2023 at 03:53:38PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.176 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
