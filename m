Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8B95528AD
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 02:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbiFUAqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 20:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiFUAqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 20:46:37 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6003511165;
        Mon, 20 Jun 2022 17:46:36 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id r1so11112671plo.10;
        Mon, 20 Jun 2022 17:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kfW4jPhuSgL94gvC3yRJRQn2UmXzlt8h4GK6K6xG86M=;
        b=UbYWE8WLqjqk73ZyugA2RHs6BaQuRMX56bnjmET6XxE1T3kLCjtuVckAYo9DTWckJS
         02phKdJRyGaTLNEPXKAgx4jwrbKxdc8ZgCC2SQCcDSma3n5N8/fdtOc27iW7K0UPyiow
         XboFp/DXT4W35hHSOkO2rmMUYF0tbPeKFqmZwfSAeqeWBpXPMqqSkCAFrK63k51uBwqd
         2Pk4D3qyctnAy5BSFZYwiP7Ji/DakE8TeRTB+9XivXVIpjLSdNVY3G8lpmPlcryQCak7
         R2hIWKcC9sfcJjQu21N7Ae7Oj//6EZ0Bs7x8jigTOhWP5Mi3BAAwhDp+E/SFUUs3nL9A
         sePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=kfW4jPhuSgL94gvC3yRJRQn2UmXzlt8h4GK6K6xG86M=;
        b=PATkzMphA8Jq+myzSP3KR/W4KTmljpAxb39nTWrnAc/9BOmODP8LQbhOU2i0MRcBHu
         d0W+G87Bxs38yGHagaIbUIdBD0spz0kzBzLqGQQHCyamsxzuGBdGATQjphpVU+poFYrM
         VkHwLN3xX6191KjjwFelmItOumh5XK8zX06/DZCewM9WrIPIuguyqlpIN74bKS4iQbEq
         UU5d9mshYCgkDDaL57p8rRUOyqxQX83dHu6Y4ETxOir9dwGq6RYBPg6BIhI/mUCpjwex
         6yQd7c6MMGfeAKgot4wOFP4fXTS21ZO7ZJdCmYY7zJFtmEVcyiNg6UulkQRzEzrCOD6k
         bzDQ==
X-Gm-Message-State: AJIora8g0tWjM5H+b/iDa9j0cTY+6GxwYcP+5KhDKcOKhLLTTRqtQygv
        axrSR9tmcf45OyW79kXu/ys=
X-Google-Smtp-Source: AGRyM1sheycciPkiXSsF6a+Q19JGWJUii3if430vKfmQ21m60EDcLuuxjrftxTTlW/BiUceiv9+pbw==
X-Received: by 2002:a17:90b:2246:b0:1ec:aa2c:8edc with SMTP id hk6-20020a17090b224600b001ecaa2c8edcmr8314467pjb.14.1655772395845;
        Mon, 20 Jun 2022 17:46:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bg17-20020a056a001f9100b00518b4cfbbe0sm9542850pfb.203.2022.06.20.17.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 17:46:35 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 20 Jun 2022 17:46:34 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 000/240] 5.4.200-rc1 review
Message-ID: <20220621004634.GA2242037@roeck-us.net>
References: <20220620124737.799371052@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
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

On Mon, Jun 20, 2022 at 02:48:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.200 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
