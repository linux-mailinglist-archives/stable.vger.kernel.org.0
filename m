Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4634F645C6E
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 15:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiLGOZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 09:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiLGOZi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 09:25:38 -0500
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA2D655F;
        Wed,  7 Dec 2022 06:25:07 -0800 (PST)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-143ffc8c2b2so21479624fac.2;
        Wed, 07 Dec 2022 06:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uDfmnsUDrRmvoJ44ZW+Wa85W+2jPcnTz0pwrUAcG47A=;
        b=LK4eBH89YOT81+ZlE7wxPsUW6yDjuJh73QiyK9kUxcYY48yFwO7LGXQKlVrTBkV/qK
         Nw1kV+zWDLtmrjCDX3Q4tGXIdaK7VLs2A6ZHrTtjQH2RCc/9WnsKjPFbx4566k/BtuLQ
         ZSvVB2ysa9SDShXOhozmJ0ZU0NXwd8kM1qQWd4XnoSj+ePP/SCSzi9XC/JcCaqzXItgv
         sY+OBrF14xqwSV9D7NS7sI4CxPkYpBI2ShrkUuk4RBOcKEyMB0ts8AhFj42puycx3u3G
         BFw4pdxHLheRD7g8jP0l41IjHrMOS+pm0rsFoOf/ZZRmegBDfqrFfJBjd4XZfFsci4em
         xbqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uDfmnsUDrRmvoJ44ZW+Wa85W+2jPcnTz0pwrUAcG47A=;
        b=rWRMxldpTlu0iPpRKfQn6v9E5nkDQ844Kkh3mUuE7ySZ/w4JGd2y7/XfyfEDXcchuk
         JdAdgILde4vAbvZM6lnmgV+Osks4nyrYs0Fjs8Cqj6TqYUuyX6m75b8okMlOTTk8GS6a
         GZ84cCo4moSWlbiJtgocBxoCOzOhAe89Yi4LOc9WklDO6/mUU7ImWA96FLfe4dPIemDJ
         wNFl+duXg0sm0nb2uk1UsIo9PpG5+v00AOAZ/n+YN7DUj329KIW2uA41oQEcV4jwSeVE
         mL1K7RY0YvHMjpPPWsSvH5yXd3psdX0D1DRcLkWa6iRo3vEwbNe+0aoiZgnQHWYAZ3dU
         +sog==
X-Gm-Message-State: ANoB5plZaTUZLfXg8yMQryh4k7wjBT1nvIc+WOLRM9PM7rkPZ2jXY7RP
        zlAayUu+yfmDy8RSLOgglQc=
X-Google-Smtp-Source: AA0mqf7O04/CYdX/qS11Ka2YDzp8AeHmWzDZHThDsey6PlXhRelgkrLtFJxi2da8ym65gG3NdmuCEA==
X-Received: by 2002:a05:6870:7988:b0:13c:84e6:96d2 with SMTP id he8-20020a056870798800b0013c84e696d2mr8216326oab.72.1670423107037;
        Wed, 07 Dec 2022 06:25:07 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n189-20020aca59c6000000b0035a64076e0bsm9464839oib.37.2022.12.07.06.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 06:25:06 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 7 Dec 2022 06:25:05 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.9 00/63] 4.9.335-rc2 review
Message-ID: <20221207142505.GA319836@roeck-us.net>
References: <20221206124043.386388226@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206124043.386388226@linuxfoundation.org>
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

On Tue, Dec 06, 2022 at 01:41:45PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.335 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 395 pass: 395 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
