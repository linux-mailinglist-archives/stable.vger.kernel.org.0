Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F008759EE0B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 23:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiHWVQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 17:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiHWVQY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 17:16:24 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DCF65839;
        Tue, 23 Aug 2022 14:16:22 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id s36-20020a17090a69a700b001faad0a7a34so18425561pjj.4;
        Tue, 23 Aug 2022 14:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=OLFdo+AOu+1cpUt6Rn5I7DT9bkClcUV6o0XMR+nALRA=;
        b=jlX83RIRyiOPjrPyX57abUBe9OwslBTclzHQhjRZuxrSN5tbfnQ4xN2gK5Db0Gb4VL
         dSYA1cTtALIzQWFANgOD4kw3K41LfGe7DNw6zlitpIIeA0T8OhZWbYIpk1Zy0Fimwq/7
         xcpHY66gOG2RFHMmhpsa+xA/2imn7YyZIaWxFpuoukYgqPISVov21NgrieYCzcwNFD/7
         vW6tavKHjIBXmj/RH3+l4sLKBAnFwg3pntsVHOSmpCngtcebtdgQhZvTYb5dgE6JafBV
         7M2bg8m7neDpOFB/IgztRoV/a+xktXwYjg9245bgrShcPiVPelQX2MdcDY8FF2oT1RcM
         Vzuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=OLFdo+AOu+1cpUt6Rn5I7DT9bkClcUV6o0XMR+nALRA=;
        b=skO91ss0wtf2xP6Tm8DPsQMv6hhdEfX8qfiHopJajUR48Z/vDimv7Q7AYECfuf2hb9
         tO5KTfsDvmn2Bfs042aoyDuQq+wrg0EfwL/Ov92nCX/FFLjG7mik7bFF+WhZLEXi1Gza
         lyihx8ImFyZ/zDCRnfIUrJzhEQ5VQm0/Fz1jcnezvl8kTPBruPUdayqwFZ//+TypxNmy
         Mwx4Av1gEUyzCDwiCiXJKqxLoL8reZq2+dScayhSrm87nLAFMYDGAnQiC1D+dU8rChuG
         awqRso4dd4mNt+s8UYBQcX9X+lcK/v/Mfqty78K54IbklV5v7OhbzLetmqKlrE6pGxrr
         SCaQ==
X-Gm-Message-State: ACgBeo3KpxxJm7TPR0s4YenfYvQ5VbqSNrphs8bZKpsZwp1893EY2Vnl
        eCZ3RGeJxoFAN90+J6Kzetw=
X-Google-Smtp-Source: AA6agR60BPc9x2SMOcqjn8YgSY/Wmb4YTjiyTrFAo3YQbuDdzpCbQBMkHlmhwrveyAADBhl58JRasw==
X-Received: by 2002:a17:903:2345:b0:16f:1f3:1ade with SMTP id c5-20020a170903234500b0016f01f31ademr27005049plh.106.1661289382077;
        Tue, 23 Aug 2022 14:16:22 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s6-20020aa78bc6000000b005366dbc4cf4sm6155939pfd.216.2022.08.23.14.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 14:16:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 23 Aug 2022 14:16:20 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/365] 5.19.4-rc1 review
Message-ID: <20220823211620.GA2439282@roeck-us.net>
References: <20220823080118.128342613@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
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

On Tue, Aug 23, 2022 at 09:58:21AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.4 release.
> There are 365 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Aug 2022 08:00:15 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 150 pass: 149 fail: 1
Failed builds:
	um:defconfig
Qemu test results:
	total: 489 pass: 489 fail: 0

arch/um/kernel/um_arch.c:447:6: error: redefinition of 'apply_returns'

I don't see the point of commit 89164a58fdc9 ("um: Add missing
apply_returns()") because it results in two sets of apply_returns()
functions.

Guenter
