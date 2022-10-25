Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D50060C2A6
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 06:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiJYEax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 00:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiJYEau (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 00:30:50 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE013BC46;
        Mon, 24 Oct 2022 21:30:39 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-1324e7a1284so14254374fac.10;
        Mon, 24 Oct 2022 21:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pNe9jGhI7yJ9itiEOQeUaoWMQ/9VSr623ieA1UsTgog=;
        b=O//96iAcjXVNTjoit4F4EYsxZuYjFz1hZ57G64/Rvl9OKxx/nUlFLX3Xf/vrWbGFkO
         tKEzce3TXXsdNexKN2el4d9saJJcNTgNTKGu4cP8d3F7oPwE/nT0ys+bXCJsVtvSUXOj
         5kDpYtKQCybfeZZ1LNoAipADNXSvyJbY1d8iKyhVqiUqe7hqecbwtbKwX5V80DWw/R65
         2WgjBOnFUiVGn+HcOGZzozmOO++l+MXf4+JzJqudG+ktm7SdB1nC+00wG8hfSJX9KXsc
         OLajV/uc/oSpTeVz/wuPpDVhc5XRaTeqmIa1dRtbAWpJppKWHYJbM2VfRprEsAkJL6ir
         E5YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pNe9jGhI7yJ9itiEOQeUaoWMQ/9VSr623ieA1UsTgog=;
        b=M9VS4VeLsgln+m7RUgkw0leE9WywO5wIjn572aop2S77814Y5Gdo+YnHG0k3eAPSW4
         OfJvHjP5QHK6Qktx1kqLhMaO/gCMYX4yHObLWGJmJLe5Xz7VgQ6sSRXEWclyrz6IIp5V
         BwK/uP5r16mEXvGu1DbtH5APNKZGneUmw5tUmqex97cxWnL+eF8Zbx9aTe7WaY22NQqB
         OaCH4fnE3X/LtxMaQp3rDPACfo043o0sGVFwdSBRzQxFVpcrcZMwn2qqQf+Id1mRisgJ
         B4bid30GJrwBae2xweiH7VvvbDyyOWOv+7A8MjFuM2kI5Qtfr5IMUONYx2BSxt2zqLzF
         0Kuw==
X-Gm-Message-State: ACrzQf2J0XIfx50nzPkXAP94XrJj6wg9Br/F+iK9R3a72YKXi1G5/nJw
        KZ5I8xkEQvH/M/zamz/gdZA=
X-Google-Smtp-Source: AMsMyM7ek8ET6l1IgTzqjxvzF0vCC6vWHUoAzvQ8KKc9O7YX6w+Dg/9J/xQy8hb/Ujl+LLUv1+Vv7w==
X-Received: by 2002:a05:6870:3321:b0:13b:1794:220b with SMTP id x33-20020a056870332100b0013b1794220bmr13448645oae.131.1666672238427;
        Mon, 24 Oct 2022 21:30:38 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x35-20020a056870b42300b0012752d3212fsm985818oap.53.2022.10.24.21.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 21:30:38 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 24 Oct 2022 21:30:36 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.4 000/255] 5.4.220-rc1 review
Message-ID: <20221025043036.GD4152986@roeck-us.net>
References: <20221024113002.471093005@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
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

On Mon, Oct 24, 2022 at 01:28:30PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.220 release.
> There are 255 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 447 pass: 447 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
