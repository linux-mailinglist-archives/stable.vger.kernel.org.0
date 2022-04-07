Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14224F8671
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 19:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbiDGRpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 13:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbiDGRpv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 13:45:51 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20116228D02;
        Thu,  7 Apr 2022 10:43:51 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id n19-20020a9d7113000000b005cd9cff76c3so4409985otj.1;
        Thu, 07 Apr 2022 10:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7uylGoEN/WjfoitwSg44wMSSGG8JmU4FflcYxKclOC0=;
        b=m5S6kWzO2XCvc/Nl2Ws37hFaaRPbbL/Ck7TIJpb+Ux1sfcHa/7nrTzQVvxntMxtZNn
         mTo/J4ZBZaxoIHXPLA68zDKDaxgNQgPY3e45HCYwRn9IVB48yINbVzS5A/SBhScevMSy
         IPiNoGnUXQxz8CN3HBjByEodjQtHSenqUw6fVufR71KgbF19XQQqWIDR6tV13Y92bGLf
         Qe8grWK2opZXfkkt7sSse5RF5hnS29YeHM6ybkOc33a6LBrTGy4PyvTK9cVx8pnsQxq+
         7SMx0BzWUGClCjaDyajGfhoJ2dQDsjKGACV2taayrmQ1UkQQZPpKVGQ7Tma3Jocj3iyY
         t60Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=7uylGoEN/WjfoitwSg44wMSSGG8JmU4FflcYxKclOC0=;
        b=plxNsgoIDZlFO5h7LN1TWRcUWnuo9PP+louwp2l+gfw/DYKZetC/0fjH4d5uy/YRu8
         hReK32oe7VNSRpFm8bZ8rpRrcoTP12Fc0LFpRF7NgnixG5kozdGZa+bZPks87dKjPz/X
         FyNU6Sc/fYIr5gVYwsYmguw56zNESYAXuwTTsXFoBNbmDInoC02P+pY4vErWcSo1WSPA
         vzqXRumScF9WTUpkCcgkWWyN+qEKi0NBPCK7B1JVxEBAgOqFjhs7bfGz3XGUV9yx3Dgj
         F96WADsHuS33UBvcPcexOy6ECZflDPZB6V3nmFaZLclNkhRgZqVnBI2iOINwjHGycBUa
         7qHg==
X-Gm-Message-State: AOAM5325deF0p3AyxqGOjzr9HIinHmrT94a7FxgqddZtS7XYC8D/Ufmv
        AusloQPy7LtYFVvfHHsX9bo=
X-Google-Smtp-Source: ABdhPJzAIZXf1BpWw/IrbyQ3UuLbNZQwIPOs5JPMl/818+6Q73/fnHrnRLNcigqutXnl7v9H/VEXEg==
X-Received: by 2002:a9d:4709:0:b0:5cd:9619:890f with SMTP id a9-20020a9d4709000000b005cd9619890fmr5029851otf.118.1649353430423;
        Thu, 07 Apr 2022 10:43:50 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p18-20020a056830131200b005ccf8ac6207sm8183535otq.80.2022.04.07.10.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 10:43:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 7 Apr 2022 10:43:48 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/911] 5.15.33-rc2 review
Message-ID: <20220407174348.GA1827081@roeck-us.net>
References: <20220406133055.820319940@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406133055.820319940@linuxfoundation.org>
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

On Wed, Apr 06, 2022 at 03:44:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.33 release.
> There are 911 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
