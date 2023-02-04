Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D298668A7A1
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 02:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbjBDBsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 20:48:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233319AbjBDBsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 20:48:42 -0500
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AEF91E5D7;
        Fri,  3 Feb 2023 17:48:39 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id t24-20020a4a8258000000b005170b789faaso678611oog.5;
        Fri, 03 Feb 2023 17:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9W/qk0n/CPhDpra9Z2blMDuqhiMKXk82qamoSsWubKk=;
        b=H1Snbxx+lr32UlIiWM9csNOvM9VWm4O3vDUNTNdzKVOLys1M27TF2f9LYlkcjELfZ+
         6ZBN8pTqyWAaD/d3TyRZjNe4cILDlFimkGT97L26o+X8RJdm+ZaYbpL1Pc9iqfMj4VC5
         b1wAe5oLd7DGBnTsEokLG3EpGElZiNpIRGp3/BaJLoYijMXfUKFRxTXderNM5FJC9ccE
         5i0xm5QFPuxs0ZEQlqWWYqEABt+97Cj3CIc/z6GbS3PSPJPna/6LGhNuWYZHCyzzYsBa
         l1PdfXp2Dw6t3JsLXx6eHiZSsMdYGIV8eT2TMvux0HIuNA/PdOMAL0ssXIUrSain8yw/
         V+eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9W/qk0n/CPhDpra9Z2blMDuqhiMKXk82qamoSsWubKk=;
        b=e00/rLptqetcdSesGN5TW9hjgti3HN06IQrQ4FM2Myx2xC6lxg0dYLEawNNoOLNbBn
         r2WeHDmnfCHDPbzw+CrV6HgxZYTpxWMUNddBWob3J7sAo97y/LscwOWJwNjc1ImZtdaq
         B5cT+hw4Ip4mRcLATryRWXU8wvpjXrYLd8+I4VaRsQ0hs1toC6duvr1dHGj1zSqGSw/S
         h7JkDlb8nZI38Ix8aPyH7dOsKNSUAnZoLYxPt0i4qGTYkXBx3qov0sJzATxvPgY47KXW
         uI4n4lR/986lFGO8EDR+D9gdr5ij/aIfvsIPAgUbqdwn1AjYHIbaNmgyu+O0U11aOodn
         qY0Q==
X-Gm-Message-State: AO0yUKWTE8fXB4CgVQ6rEx5JcY0dvmcv9TLZbwj839Q7RW7C0ygz/lSp
        xkq5TCzusvsGIxxR5oSMz2rw9F4kfuM=
X-Google-Smtp-Source: AK7set8gqlr7FWMhAyZFBDLub7uhKpdVOKB3YOGmesWRAaxUOH/qmAHmIyXi47Rjig9AVbhN0iHQvg==
X-Received: by 2002:a4a:3346:0:b0:4fa:325e:ebb0 with SMTP id q67-20020a4a3346000000b004fa325eebb0mr6994130ooq.5.1675475318462;
        Fri, 03 Feb 2023 17:48:38 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l12-20020a4ac60c000000b00517587f8817sm1604408ooq.19.2023.02.03.17.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 17:48:37 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 3 Feb 2023 17:48:36 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/62] 4.14.305-rc1 review
Message-ID: <20230204014836.GA3089769@roeck-us.net>
References: <20230203101012.959398849@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
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

On Fri, Feb 03, 2023 at 11:11:56AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.305 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 167 fail: 1
Failed builds:
	ia64:defconfig
Qemu test results:
	total: 425 pass: 425 fail: 0

ia64 build error as reported separately.

Guenter
