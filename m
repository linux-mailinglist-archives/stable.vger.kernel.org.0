Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC405AFB67
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 06:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiIGEpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 00:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiIGEpA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 00:45:00 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938C72F009;
        Tue,  6 Sep 2022 21:44:59 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 65so3206140pfx.0;
        Tue, 06 Sep 2022 21:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=tCsLKpHUjhedulQuD1T/V2oVWQAQiT17tYLq8whAQkE=;
        b=QMNc4qS3+yWto7BCVMNIFNSFjXqME2H5ycOBtnNLL6/3oaDUGJbuJ5IuAu3RgKWOSQ
         lKjBFgz7op0Tr8bDbSRRtS97QQIBU4MNXzt9mdLSHrh7xfBKJz7XgtXbky5y6DFZGKeP
         Pa6M4XclkOe7qIyCU4/TMWW/gn4xYlrNvY/1F56jNI6w4hy76tqW2cztghTv3M3wXFAV
         MRZKO8aUT5dmp1kOnCen9dbZV/ga04WDYtfKTRZ/+V/vir/mEGH495GuwQRydVEKpmzo
         LaSVNJ02A+bslp6wQRClso+UfvDswc7YPFJHKueOazZex58K53y89zD2BeZGgP37zmMy
         gnxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=tCsLKpHUjhedulQuD1T/V2oVWQAQiT17tYLq8whAQkE=;
        b=ZXev8a3r5qaXQGojv528KOGaf/kCTdDIwbLDjQm0WMpGYJfcegRu/W/tMHXoiBbC52
         N+uZTyj0k+mmw295FlEyBpOOUImycmqrF0pUrgyjrGzoflM1gtYAuYt0e55JO5AEZmKQ
         x8QlHedrz6cfr50SVtWlrAmIAWelfsOZUtbSFTKHgvGtEm8ceXjYT7VmTX8tGAOZjjRr
         I4dcoQOS2ytWFLFmx1DI10+A7mQCJlnGvXvg9pL2zPlEJdAMPcY0UNMVuKdkK2lFwbIm
         N7Hd0J8JH5diIXDLSF4NJQPr8iPEpcPyvGbzrQgeUcAPnjYNmZMKTWSlttuFo2VvK47L
         Zr1g==
X-Gm-Message-State: ACgBeo22TUCnFbeWcWM4q0U9CZK9LxvBn5ST6OJy1H6GYzSJNnHlmaMD
        2uPRSHxVCRASJsh+PGZZjfQ=
X-Google-Smtp-Source: AA6agR6XqzjwkFLfMkKYBRwLgsZWxitw0ZjTafdTXklPFg2FH2/pYcpbcLpaLnlpxwIz/isD+Jp/Xg==
X-Received: by 2002:a05:6a00:3406:b0:535:f76f:c971 with SMTP id cn6-20020a056a00340600b00535f76fc971mr1846704pfb.5.1662525899128;
        Tue, 06 Sep 2022 21:44:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d62-20020a623641000000b0052d98fbf8f3sm11310937pfa.56.2022.09.06.21.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 21:44:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 6 Sep 2022 21:44:56 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/155] 5.19.8-rc1 review
Message-ID: <20220907044456.GA854933@roeck-us.net>
References: <20220906132829.417117002@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
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

On Tue, Sep 06, 2022 at 03:29:08PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.8 release.
> There are 155 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 150 pass: 150 fail: 0
Qemu test results:
	total: 490 pass: 490 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
