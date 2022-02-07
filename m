Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCF34ACC05
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 23:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244369AbiBGWWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 17:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244351AbiBGWWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 17:22:10 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B11C061355;
        Mon,  7 Feb 2022 14:22:09 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id j38-20020a9d1926000000b0059fa6de6c71so11941567ota.10;
        Mon, 07 Feb 2022 14:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FzDl41NUaunvh4cpsq3ygZwFGO0YvmHveHC2s1RkiKc=;
        b=lxdmdqyYvwvXuYw+2qwANyztoOr1l3+ppaR5hQWJm0X9QvGmQiBP9+QIeSaO34LtdO
         cdlBk/Naj3Lelc+0LyuGuRrKa9HX3J+PR0daXu2juCcFRYx2nwE6XQFk1i8MoYpdlrqe
         F949A4W6D27+hpT5NoZ9CMMKtPHrJOWS58obcElOzeAA46b6U9641alm4bhfuELLw4oy
         DoCGfRYOyrxzwK1ztCXxzf2xuXRP6s6weCdVRpTQwYJhSmnkw2XF+t/dTGOzMDRF+/t2
         cdGTBTmrlZwW6xn92xEk3vde2cTjqXxk/tzN8pGi8KBx2OQjMoCoWeVcpT5keGk0mNMH
         KhlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=FzDl41NUaunvh4cpsq3ygZwFGO0YvmHveHC2s1RkiKc=;
        b=7FTQ0dVje+9/reGw1wYBQklvukosnVewhXpH0WShLTfSVB9os9Ed4j8961KPxXSdaI
         OXtSf+5+7PnGyNGXbluYFT5+PniMR7Ae06dfKDVwIuFhzIJDeqrSHe6lvkY/62CtghkJ
         qFQyY8uW3nesKHjEsWH5jFbpycmfTHa+zhjsiGfRr6GbYKHGhWcLx2XdzfrTegZ5NlyE
         FeJbBVqZfkSKscqBEje1PjmLwZHmScoxRm3nbpI553x6hS4jUCMXJ6htEf7QCTtqxY9O
         AkrGya31Zz0B4eYRhIzeGlfmKRxzGB5n21UazdhOj9cD3uBB54KIPsb6ijfC6gxSkTA0
         T+mQ==
X-Gm-Message-State: AOAM532cMWM8RFyBev6e3mQXRiB9Jpr9WCDIx9Ofrq7qWwIU/uuQeeQt
        BaLoBzrWFsw863cN82E+P5U=
X-Google-Smtp-Source: ABdhPJzEMjxooMdy4Uk/VU6y3JpefDGKaaVqb8Nqagke/RVAneM2zXIXc0EbZfrPfQcN7SkT6dEzSA==
X-Received: by 2002:a05:6830:1d98:: with SMTP id y24mr766275oti.161.1644272528950;
        Mon, 07 Feb 2022 14:22:08 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 2sm3200358oaz.24.2022.02.07.14.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 14:22:08 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 7 Feb 2022 14:22:07 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 000/127] 5.16.8-rc2 review
Message-ID: <20220207222207.GF3388316@roeck-us.net>
References: <20220207133856.644483064@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207133856.644483064@linuxfoundation.org>
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

On Mon, Feb 07, 2022 at 03:04:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.8 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 13:38:34 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
