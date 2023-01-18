Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06AD9671040
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 02:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjARBlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 20:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjARBli (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 20:41:38 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD755421B;
        Tue, 17 Jan 2023 17:40:08 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id r132so16945176oif.10;
        Tue, 17 Jan 2023 17:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kxxd3xqe9c7nfQjsQfb2u+lISPgW9CFdGJBHNXsa12I=;
        b=lhrPFZ+V7iW7YE5t9PVcYLfGAYbd4HlJC6RK4v5DwsEVjKldo2M6wZF1Kj07hRl/Il
         dzQDvfIcBpCihnxGnrSYVDeigAKFHM4jA3NYx7ZKMbA2+QV45aEUVFCOyPaY0ast/J3y
         zKKL5ZQsZ1qrl2pabTYSxRR/u2KB3biuoKxwRa8r5U72bubq0ddmCyvuG6sKwrlRkY6Y
         cmPfmaL8qkTYnbqPhNG8ZHkM3Feug6IM/SV/4KqucOMxYBq1jSUtImQcnxN9O4oapKTD
         U/AdBVYgr7qjsQ5gLn5dSCb8tstqjY/UQ6Px2YUha/i/W3eDTtvy3WtmHSnTm1rtuQ1M
         xP4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kxxd3xqe9c7nfQjsQfb2u+lISPgW9CFdGJBHNXsa12I=;
        b=a6QUQTNombSXABjQiiIVoYhKVShOIAUQynnhMaBEwrmK0GPS2/FqLHDQBCLXjN8L8S
         1/pNp8h0CMNQVBqhFBz/CruILK4LxRBVV7m+YWamUe5zBk+5OJ3A/lKHb7F8ObwIAwWy
         w//JGGV/lcTq8XwSWDg0qVRqpQloUJAqPsn1yC6EPEP3PY7Sx5BbNV8jDp26dhvTg4ui
         FRsGN/sZjccWwcCYboSFIKCRL39P0dlCYP1T03buQFsTPbD2qLding9e4oHsDbxXR384
         QYWWfsZnmfE2ToAm9JY8tLhehHIHUvC2OrDl6ZUVl+eIIV6knfiacPdqzjtCS9pfocMp
         VbYA==
X-Gm-Message-State: AFqh2kpZ7yK68v3Shk6mqXgZ8+yBXZ3ccmMBx6LDSloqvcuxMS9032EP
        m4y9f8vgmeD5aE2RvBwYEHg=
X-Google-Smtp-Source: AMrXdXv4dCHXlEiFmxGcr2aZsuMqf9K2MlzBM9YjNQEgyRzmhETdhQGuVjBWFv/jm+ZJiFRl74sFwQ==
X-Received: by 2002:a05:6808:8db:b0:364:e248:1d70 with SMTP id k27-20020a05680808db00b00364e2481d70mr5564435oij.1.1674006003968;
        Tue, 17 Jan 2023 17:40:03 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bk33-20020a0568081a2100b0035a2f3e423esm15351850oib.32.2023.01.17.17.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 17:40:03 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 17 Jan 2023 17:40:02 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/176] 6.1.7-rc2 review
Message-ID: <20230118014002.GF1727121@roeck-us.net>
References: <20230117124546.116438951@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117124546.116438951@linuxfoundation.org>
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

On Tue, Jan 17, 2023 at 01:48:13PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 502 pass: 502 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
