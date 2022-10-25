Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83CFE60D0A6
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 17:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbiJYPcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 11:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbiJYPcU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 11:32:20 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47BD05AC44;
        Tue, 25 Oct 2022 08:32:19 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id g10so14619634oif.10;
        Tue, 25 Oct 2022 08:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5BZw+Ko52tSVgQGtiIuRdHioVrOpwaQYrUCrv7C2UG4=;
        b=Cu+FA0IrmzilWjAVokAmnGBR+YYAatTUaSx87z7jqh/Heya2gUeONRmQ8d+yo9AAVz
         9GEQU1PUSerA7uwDc0LrNg0/jZS9plWvyZin389pREChEhbcyYSJu03WEvY2LFF+vw51
         bUW4H2WLSU5fcIp9TG/BMMtfzrOWN6xJ6nsSwxs78B1sC7tI1NSvZV7Nv9co4i9ekS9k
         WUpy4KYND3E9DtR5zOyT+kSDFP6KNgIwyRELKBNxb/2QgJvYXwy13l7Xm1suqkh6bB2+
         xOi4rmFD9C6pNGpwPEbBmyQgQij0Tg9UGvKhc8VqexB9PiTAUc94Bmp6wqHnWOSuuGIh
         QLzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5BZw+Ko52tSVgQGtiIuRdHioVrOpwaQYrUCrv7C2UG4=;
        b=2vOnaXruqv+PLkkl6hULvPUWbVaglPs5HsDmYbfWNOemswVpRWXTnc+s86FJjgbX6O
         omy04BLj0bztiGRfAqFi8l5hMBs30Caeq3aAJibyEjLNfhKG3dTmI8OO+MJqFdzDMsWM
         HwDXBZAbhej4Z7OG424EtiCzsOeKZdeX6yNYtzlJTSv5MhhpF9dqm3LllCKBs6UuNDWE
         L204PNnOoWvBnQAbvBG0sdazbw6bBoHPf+mowhbj5TM+5JHclxT3uTR5gQ/3BrwlLokb
         vqVSYaL6/klkI69F86d+nexYssNVK5bpcuMxXGg9ytIR3L71YdBGeoWiSNR264aSsFLQ
         VJng==
X-Gm-Message-State: ACrzQf10XnynLPzz5VQhnLsJ1QwuanBNaqSwXl2fSRZhCPkoQHbzHk3h
        +o5vQPj+VpWFfe8OWWZuX8k=
X-Google-Smtp-Source: AMsMyM7Z/iDiPMhP5BVVzZeV8KKgQesOBsGjBq7hsfEojthlWuccSu1Ir36jLoztbrAqyHttk9/GPQ==
X-Received: by 2002:a05:6808:120f:b0:351:98b4:a86f with SMTP id a15-20020a056808120f00b0035198b4a86fmr32948433oil.189.1666711938512;
        Tue, 25 Oct 2022 08:32:18 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n5-20020a9d64c5000000b0066210467fb1sm1152952otl.41.2022.10.25.08.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 08:32:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 25 Oct 2022 08:32:16 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/20] 6.0.4-rc1 review
Message-ID: <20221025153216.GA968059@roeck-us.net>
References: <20221024112934.415391158@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024112934.415391158@linuxfoundation.org>
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

On Mon, Oct 24, 2022 at 01:31:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.4 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
> 

Teest results are for 6.0.3-22-gd4150c7.

Build results:
	total: 152 pass: 152 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
