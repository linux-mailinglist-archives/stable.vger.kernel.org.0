Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9982269E46B
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 17:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbjBUQV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 11:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjBUQV0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 11:21:26 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996441E1D1;
        Tue, 21 Feb 2023 08:21:11 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id m8so1875965ilh.5;
        Tue, 21 Feb 2023 08:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i2i/jAqwjgsuWUOKAfeQRlEsJLm83e1Xmss5CtgBBT0=;
        b=fX0nexs9ZFCJ+0VCPpdqUZh/6rasexiyS4uGVofty6aOOikbBBPaJtuFLkxNDZYcZm
         QRw9M4ORohtKRzqfuSCJIk+aX3cdf9bCWpqCpGf/Z0NYk2EfKlON1V2MgB+uafyhVxe/
         V1d59B+FdFe6ElMakSgiiiBI9UO+6ke9YfKXdNhFN6pYzrJtJ7FW9JG8sub7PdXFLhzI
         U2xJ408QPZBaYD3dModaqh3bKx5v5zNwStj6lTywvzfqD/LyBEhjN3HNtdhC/w2n//nX
         pkW+7ioqpU/OPn3N5cXfnZAjeY9vXh9Lu8CuEddisXAT+xUiPFbXwJFThneYNehiAQbT
         VMyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i2i/jAqwjgsuWUOKAfeQRlEsJLm83e1Xmss5CtgBBT0=;
        b=8GG7WAWcFgWRPyM6Ik1fdiq+MhJwKuiHVOk6IZ/OBj7JVQX+bpFtRXcFGheubc559W
         pXe8y/M4lDvXbFbKK34I/Lt1dokPolrNQix7aR7X+TmnHIm89QHdPBjVEnKGa/KJ9lFZ
         ugyqL7K9o/XmcOLp6KdmPB4pptUJzdetCUIXqdMMDyRIrvp4cMJf5A/WfSY/8J2pbXpn
         KsgCXJ4CwMUVIP2/9DRMCHZnqRKlOPF2DY/Jct0ksmkeuk9UK/Ch1cGlo6s3Q6jzYJcz
         baDId9GqhD4eCasJmTem9mkCpvis+fYe5dVOOyfCd1cOf6kAwIcc4lq7JI2bNM3KKfhO
         Gugw==
X-Gm-Message-State: AO0yUKVs23loJB9KKM35f0CgUSG5nx3j8GWAJqqgp1g/ZGL1vT5jWYW7
        lNoANXSGOvRXPcD/uAc9iOI=
X-Google-Smtp-Source: AK7set+66DYIzoLZiINqpxFCms5YEvKzW1W8IQ50Y5Ob2c8+1U0DH+jflJS4v61xMadnC0IIXgACLw==
X-Received: by 2002:a05:6e02:188d:b0:316:d82f:58b9 with SMTP id o13-20020a056e02188d00b00316d82f58b9mr3112399ilu.0.1676996471011;
        Tue, 21 Feb 2023 08:21:11 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p8-20020a02c808000000b003c514731e6csm1697425jao.143.2023.02.21.08.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 08:21:10 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Feb 2023 08:21:09 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/57] 5.10.169-rc1 review
Message-ID: <20230221162109.GD1588041@roeck-us.net>
References: <20230220133549.360169435@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
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

On Mon, Feb 20, 2023 at 02:36:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.169 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 478 pass: 478 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
