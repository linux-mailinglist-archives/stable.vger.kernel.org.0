Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F55167103E
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 02:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjARBlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 20:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbjARBkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 20:40:52 -0500
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B0153B22;
        Tue, 17 Jan 2023 17:39:39 -0800 (PST)
Received: by mail-oo1-xc2d.google.com with SMTP id j10-20020a4aa64a000000b004f9b746ee29so688063oom.0;
        Tue, 17 Jan 2023 17:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bN8e9VcYrQuqVqjQ+f+mGITMg1hr725vXgqqgBJYPOY=;
        b=WEof6l8KUfX79/EsXXGLExfqIaK4eaJ6i2xNi9hNc0l89b5SbdO41Ppgl62iexlVBS
         p9La2pGcTUmzJErzwutk0uoyFKdnMxIrU2QLYegch6mtBRaGuoKBP882c5vkzKPxJOQH
         IXcqvp6FvE/H9RnpQnwgiCiw+JWm9UmiD/t1kzBd3JxICeT7Z+2rkmH3Xte5K5x/nGgo
         z7HtWAmmYThTxZxFtvgzdJ7KnuvNG33GQdCS9WNqWUnUZ+u9lr50q5VSKze842B+aekq
         sVcjT7tqrU1cIgt6/qJnAHCCIP6FZNbb+faGSOuay1qbhuDS2zavyr5TB3abJDjPdjDT
         qnIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bN8e9VcYrQuqVqjQ+f+mGITMg1hr725vXgqqgBJYPOY=;
        b=2LU2rO3fcOGMniJI8xI764TBkt3Bk0OcXBx7ZREw2u5g95T3CuR4ETU4UmHdq2aXaP
         UWMRaxIeAzccB/WP77YCNLsZb1SExmGnEJO4ySuCUh9Zxp0W8zAljBwJ4u0BzNez/6h7
         7of9bGaZ9//3gM9ErUu9sTgZ3HNAaa1LXGS10kBUW8ETnxWVWZj58wsOmfuUKX1CoJYE
         uB+6BueDJ4WeUt9uM2sc/Bfk6ynd6HVP7Jiifh5N4RzkzOhqqgqBu9hC3GGGlZYlj6B2
         bi2271wUzv73SxtLmaucqhzmI5DAsZi7jRzOofjLIlSKfPr3uoOP5POnPjy3KxAo74N5
         BV2Q==
X-Gm-Message-State: AFqh2krDZGicVDFWGGshvkekJmLVS4Dzo3Nts3fjtNj6XJTi7fVi72CN
        Vphl7kl2RfqnaEFlDaz85sE=
X-Google-Smtp-Source: AMrXdXuzKckJKM1nwEcIinQYWBgqY3hm9EYEKEZgfkz5Cu+cRYcWDDIQtRDzW35PjlVafsqvI3kxFQ==
X-Received: by 2002:a05:6820:1390:b0:4e7:5d43:a654 with SMTP id i16-20020a056820139000b004e75d43a654mr2531992oow.0.1674005978431;
        Tue, 17 Jan 2023 17:39:38 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m22-20020a4ac696000000b0049bfbf7c5a8sm15690774ooq.38.2023.01.17.17.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 17:39:38 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 17 Jan 2023 17:39:36 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/86] 5.15.89-rc1 review
Message-ID: <20230118013936.GE1727121@roeck-us.net>
References: <20230116154747.036911298@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
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

On Mon, Jan 16, 2023 at 04:50:34PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.89 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 491 pass: 491 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
