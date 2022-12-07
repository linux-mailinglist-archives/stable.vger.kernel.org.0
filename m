Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA421645C85
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 15:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiLGO1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 09:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbiLGO1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 09:27:08 -0500
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF40860B5A;
        Wed,  7 Dec 2022 06:26:46 -0800 (PST)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-14455716674so15311860fac.7;
        Wed, 07 Dec 2022 06:26:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TZKo5xO8WIl4oGvaEmRGqMfk5H6mgyCctKN9hJmv1CY=;
        b=BoG1WB2FajwvV60vaIW2rUvrU5pXrzMfEfjM7SJVHYc5YXVAFHhb2ww0ShYPurNh+l
         0oeFrmezDcOzrY1KjzYqznUe43acMWJkaf2C6yMH+oY7OO5hcELSxQ+vWTkq+sneGtLl
         MtsVqGhtFsya3ruMHeFDGUGaEm9XL1AHi1OB0bwHQEyZFsnHXNCb2ItvDN+IH/xAi/vM
         2ZaD8s8q+q78B3BbC2LRkFoOCoqhH7unxB0XqTOabYtT7JacYg6L6xC0RNmDPNY3j2tH
         rPn/MpoqtHGGoXwsA13o8R0lHGqRZqWbE/1vYGDZgJFXn6KI/mL9/a0bqL42EWoKNzI8
         kxnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TZKo5xO8WIl4oGvaEmRGqMfk5H6mgyCctKN9hJmv1CY=;
        b=gsgFdiZerAuEEjLQGTT6TDeofZ2aIigtX2RilSVtaWfmxPKcfaxmcWPHvoWBQKyBNg
         NLf1aGf66FYB614/avwv6hHT63SS/PliGaBRKO6pK3q3HC85imhWSVZ++hcnpT0ILXV9
         s8sIODwiUFdiPMOt/XXaTbZftlR3Pb62IE5bYDuwlOJ3FgUu4FbvDHs+ItJh51/yMnK6
         ac7qhiR7mMdrc4AcMkEiLescgj503V5uFmb8epdelEfoWsQ1QI8XHrbPFIqllvHWLvIW
         8O+GKzq7g2a+BuhOAFm3pIL/SOETwB7oio7xXb/Z0knJD5UxLiO82t8gBnJVHgLTg8MH
         277g==
X-Gm-Message-State: ANoB5pm44jW3XU3UnPnTegt9g3FkB3HXJnnDGZLYBbAUZjFAJGBSlnlC
        het1IM6VRowYnhWXCUHpQJ4=
X-Google-Smtp-Source: AA0mqf7Aj68x0HUh8BgD3XGGHsQgkMjY0E5h6Ke6Dch/AM0Zu1fPvnM26olu03RYiD8JhaeRDzh1Fw==
X-Received: by 2002:a05:6870:bf0f:b0:13b:b20d:5c72 with SMTP id qh15-20020a056870bf0f00b0013bb20d5c72mr41857101oab.200.1670423206124;
        Wed, 07 Dec 2022 06:26:46 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m22-20020a056870059600b0013c8ae74a14sm12213112oap.42.2022.12.07.06.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 06:26:45 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 7 Dec 2022 06:26:44 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/96] 5.10.158-rc2 review
Message-ID: <20221207142644.GE319836@roeck-us.net>
References: <20221206124048.850573317@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206124048.850573317@linuxfoundation.org>
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

On Tue, Dec 06, 2022 at 01:42:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.158 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
