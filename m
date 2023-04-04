Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290E46D6EDB
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 23:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236358AbjDDVXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 17:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236143AbjDDVXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 17:23:19 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3081019BE;
        Tue,  4 Apr 2023 14:23:19 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-17aaa51a911so36205030fac.5;
        Tue, 04 Apr 2023 14:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680643398;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M4HDAQLxCV64quuxVRbO0mmi1IW8Im9RB/8o5GYuqDc=;
        b=JZPRAhpHmUZQIQZ3jxNY0S7j5eAxdxa8wciV3T0/xIrHOiu/DHGI/zjGy1pPd9ttMC
         FjTWZ+V8i2CxEt7Jgq3UDQ76tOWBhPw9YYNAK1q8YF1oNa2aVhz6HMpim5j6ZPN1scrt
         rjIvGp2Xkc+IRzueCCjgNq4l//Mbh+DPU7dClPVCacL6Ea2xXZgOE1/qHcArPo/neNrO
         qHTujyDYG0Jjiz69kC/WLEAWwnZl/+Mtqh9g/1IcGwJYpcl+9AwsrWXbMJfhLqNyAYZo
         f8Kvc3SZ/BZ0G0oE2aZr/BPr9LJ/xZQkB5uqzEctHzfIn3GgSh4ZGNss7QDzvxmeVTg6
         04lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680643398;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M4HDAQLxCV64quuxVRbO0mmi1IW8Im9RB/8o5GYuqDc=;
        b=TCUWbyXHvhwdlHh3vEjp6cTBvuotknNabv3RkrFb6Sm/gmAApas2HzNHOzfpPko6mv
         FfRxhYrfVAvNiCsDPQDi6gDLmq1rKXxcuVooNeMjB/lMdmKwx0SNk346S4F7J5OG5J7H
         Dr4hZhSIBjfbaGyZKI/Sg261+Bn6hoeBKyCes8JNJak9es2qKSlUyyZk6kJsSh7c3aj0
         96oL6N+j3VB65RSBLyRFBknELq2hRKXhnCD8llZ334Ugb1ijjMOTDKPrNKxsSYJcY9Mi
         KrLI/h1UJcK5q1WUsvOkP5YhhOo9s1zjjyAfHhgQabv1KwRPrJONawc8Xe7KAKk6cV6b
         AiSw==
X-Gm-Message-State: AAQBX9cB+6JTv3ceZbjBjil6Sc6y/Nq8iLPj7QlDNKz7ZmWoPyWut/wo
        yme5MjP4uruDch6fgYXsXj8=
X-Google-Smtp-Source: AKy350bSdPzwRwUrZRCs/Fry6tr2SlqbFV9okJHWz30oT9AT7+0YH20XOqyLKzCvoKtgk4TB3pqOxA==
X-Received: by 2002:a05:6870:b48c:b0:17f:5b32:c492 with SMTP id y12-20020a056870b48c00b0017f5b32c492mr3092693oap.43.1680643398564;
        Tue, 04 Apr 2023 14:23:18 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l11-20020a056870218b00b001777244e3f9sm5286273oae.8.2023.04.04.14.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 14:23:18 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 4 Apr 2023 14:23:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/181] 6.1.23-rc1 review
Message-ID: <23e8a91c-21f5-49e4-ab51-43a2f9c07604@roeck-us.net>
References: <20230403140415.090615502@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 03, 2023 at 04:07:15PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 

FWIW, this is for -rc1:

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 519 pass: 519 fail: 0

I'll test -rc2 tonight.

Guenter
