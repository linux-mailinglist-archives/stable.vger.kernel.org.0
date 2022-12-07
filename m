Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25EA645C7B
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 15:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiLGO0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 09:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiLGO0M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 09:26:12 -0500
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C303E5FBAA;
        Wed,  7 Dec 2022 06:25:56 -0800 (PST)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-14455716674so15309100fac.7;
        Wed, 07 Dec 2022 06:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O93lLrD1x6MXcIcHOa9v26dA58mHpl0QtGy6Q1Hk4B0=;
        b=RjQiZPtLYLjR8WvR6BZZynNUe+O6sMQvEBEsJRFObvjzXnUwTGjf1IqyNo6LlEYnQs
         ylDhLoI+SVfZEHUcYahwDIgP6cfeNeLBoXlmtsuRtp8B50ojHURj048MnYyug1NWV47p
         3sFAP7MuDVkL6IxjEx32gafFg7Kmcz4Vp9QowHnWiRnCwG52kWmYTwOp1A9JUF5YO0ka
         rclDE9Na97tvcy8EN2gEZ2uA5/gy04W5+w0+I4vq6lSQ8KTc8bQQerkS3OQhxEJ9B7g2
         8oOKYWAACaNyXJlGgQ4yjmNe1xFzcuSL54IFr7Lxs7NvXMCtdNn3to9JSvDAA/txCkSA
         yYwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O93lLrD1x6MXcIcHOa9v26dA58mHpl0QtGy6Q1Hk4B0=;
        b=Al3I+ncvmX5gB+44tXtLF++XLHpA+AEPCmcaTxLCT7ZqfDeAPsERJWBYPz2/kjg8au
         NbZRtNy66p6jCwIFcvFxq1cC0+HL+TxpPWiPFf9frTdgWhH0AQhlP4nFKTw06gWIRgsK
         IXBzqioZc4KhTGsRmLPvdbHWgoIWW2kAYbstiQ4SJDakBxhQ33McxAxmXQyapNSvq1Ca
         bkZipbbBuWqxfhN4eo/nc4wkRL044H+Ty6buRYnV928R2tyqLx+yDouvwQWhAq9M6s2x
         +LpjiDAKGHWG/suRVI4HSY9sbFMxK5QgqQ6vKqsYrfD4VyshVYpV8dbFASLWB5kNnUdG
         V6VQ==
X-Gm-Message-State: ANoB5pk3YpPm3RY7vWQTc8eZRf5xNMlQBlMg7V1+UWsutS0b5e5VdOfa
        pO/ALYwpNWsE3Xyx9TR0Tu0=
X-Google-Smtp-Source: AA0mqf6UuYKo3rR36FALPKbHMXBqBGduYO0s9pUckxb+YmPg2Fc76scI2i1Bla4oTbRb2+RjhlP9RA==
X-Received: by 2002:a05:6870:c98a:b0:142:eed5:efdd with SMTP id hi10-20020a056870c98a00b00142eed5efddmr43097342oab.129.1670423156133;
        Wed, 07 Dec 2022 06:25:56 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r41-20020a05687017a900b0014378df87cfsm12233909oae.33.2022.12.07.06.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 06:25:55 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 7 Dec 2022 06:25:54 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 000/110] 4.19.268-rc2 review
Message-ID: <20221207142554.GC319836@roeck-us.net>
References: <20221206124049.108349681@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206124049.108349681@linuxfoundation.org>
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

On Tue, Dec 06, 2022 at 01:42:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.268 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
