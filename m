Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A2662A07E
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 18:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiKORil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 12:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiKORij (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 12:38:39 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E063CE28;
        Tue, 15 Nov 2022 09:38:37 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id r61-20020a17090a43c300b00212f4e9cccdso17564915pjg.5;
        Tue, 15 Nov 2022 09:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hr10hVmH0SZZiPSTFzm9CmtdLQ9RfJlPIxO5e9YpwfI=;
        b=UNKP2RkAVGDlHnDZoOcFnU1ELL1ZljvXcRyRWEvW4Pa2xO1+JuE4Y80dhKO/avIFj4
         AgqRte38rN1Oqtb32nvfovh5gjvjakbuPpYmLbaWO/ksT6XVi8Lw2nKvyPsYRNs8X/6M
         /ZAO3zu8j6MizsFETYok22irmmNabxzhyRifBiPxd+QpMzANKOU0XaufWicGPS7WulZv
         K5UXkXvPvmM/BLE2hMiVwGFb8ydfAsVO6gHHniI6zXuVRXxqL6NMW1EIXQf02VS/mE/r
         vL4Z3u6H9bkT24qWYujdc+Hgx5fH66px0FrYqcfcicXLzyv399z104sTDSAfiWR80GKj
         JxRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hr10hVmH0SZZiPSTFzm9CmtdLQ9RfJlPIxO5e9YpwfI=;
        b=CDCuyfJaFelRmGTc+d3NkR/qSmlK+oGJhkcWqrvmPplasFBCEWUqqA2gt/wZaZR15W
         ztO7z6/1uES3piETQ2MJSswMWq2FDsWvW3Qtb43BnOW1A+nyzJJJggR8UHvRzTDLFivk
         4p+VwrKaHU0OMOrtjZaoK1TwohWpSKuIE7tycZnLbhoEyQwhTk8j1iwmt0KE+SHb6huM
         AwsRP4ZoCPq0AyPmN9DMKcIp/GSlG9qx1gQC1XakkqstKv/6Ok8/1zZsoTTxAoDbqfDY
         ts1X0d4lpMGeZLOWS7iXn9QO8XvS7Kozh8XJUwWNMMeli2WX1Tz2bWAQALbp016NIs83
         FU0Q==
X-Gm-Message-State: ANoB5plK91WEdDXFcoqXpZPE0OiKOkp3/Fybt8QhyUT4j4QBs+Yvnbm2
        T7WboVgtKWVobGh6VPoIOkw9GMxYrVk=
X-Google-Smtp-Source: AA0mqf7Dd7OgsKYtEAB5kD9abR2MesHSaWgpP0A3teyjE05VmXTu8sOsFuG+55b2G33Xmi7lXBgwVw==
X-Received: by 2002:a17:902:b081:b0:187:3932:6422 with SMTP id p1-20020a170902b08100b0018739326422mr4962043plr.135.1668533917258;
        Tue, 15 Nov 2022 09:38:37 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 12-20020a630c4c000000b0047063eb4098sm8039892pgm.37.2022.11.15.09.38.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 09:38:36 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 15 Nov 2022 09:38:35 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/130] 5.15.79-rc2 review
Message-ID: <20221115172511.GA105157@roeck-us.net>
References: <20221115140300.534663914@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115140300.534663914@linuxfoundation.org>
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

On Tue, Nov 15, 2022 at 03:04:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.79 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Nov 2022 14:02:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
