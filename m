Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB496B5C60
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 14:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjCKNoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 08:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjCKNoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 08:44:54 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56950124EA7;
        Sat, 11 Mar 2023 05:44:51 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id bg11so6397672oib.5;
        Sat, 11 Mar 2023 05:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678542290;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pMo24R2nEA7iChoM7QuGjDsI1h1/AgEIEbWkCIWJOSg=;
        b=TnNs0bN5v4rus3tzKno2B4iiF0cq+FS2t4T3ALDl8ZmabCT/z4Fl7WLc65a+1tKyTY
         /nBW2dwRG+7CwLbQ0e2NZrOl73vjOe23fXtgivkLYk0e7ikJJRXdWMD0KGK3l4ka7UNL
         WF8nyn2HDoZKINJhDZFMxi2YU7qgcrJ7VpN6hzbwZeCe7sfh328GsFvVZxFnVDV2PEhs
         sVz0UHh82agpbHQ0AlJxPmNo6mV+7NTYZJv47c0cqZKDPht1Uc+pyec5QnCf1hwE6rvL
         QSI+JeCz2vRDOreRriGPEr0l48r9e0AZb+FGvca8ecZMERDfc24XLcOfcUKFm5peYrWu
         Fang==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678542290;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pMo24R2nEA7iChoM7QuGjDsI1h1/AgEIEbWkCIWJOSg=;
        b=gQXNfbG+PKqqzszZLxNSQ3TDdcry01pZ1feAhjzeJGoh6tEqZui6JrTSuKLNnnCu+I
         OpqAnbWqTBfxtlvjVCrYU3+nH4ohP43UM3yQ0XYdaB9A1XmoNld1j3eqOxxL4o4EqR7q
         U58Qq2iIEf1wylzl/zYJSBUrHcR9dAswQej+sPRQsitxR8G1EybqKr7y3x/RAymZLWBE
         IsYQGRjZBq5yBQ14sFXP3+oFZadrVuRsPla1izjDgXJpRTLAFAtR7qLBjgGhNTjEj27P
         f3yXfeifhL9hQfkoBEpqAFFe2zMV8EO8VbVuxRvjuGdoS76Wa8lDyypcpPZYcC2js6T4
         75zQ==
X-Gm-Message-State: AO0yUKVCh+mZQyDag/1w7tw3DyCj0OUTrKjykrloFQyBdZVhsEQvvYub
        odhWqPQFzJTqZgtHJcY1D4LVnJypxbU=
X-Google-Smtp-Source: AK7set+DYhICjt3TNWVNa5fvqrKJXtq79yCcLEWdrU13G2XpO1ODOg9F/Ddb70ZolkDqYpSYEL3DuA==
X-Received: by 2002:aca:f0f:0:b0:37b:385b:c965 with SMTP id 15-20020aca0f0f000000b0037b385bc965mr11852112oip.2.1678542290417;
        Sat, 11 Mar 2023 05:44:50 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f3-20020a05680807c300b00383e12bedebsm1051140oij.9.2023.03.11.05.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 05:44:50 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 11 Mar 2023 05:44:49 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/356] 5.4.235-rc2 review
Message-ID: <84feb33c-55ac-4c86-8121-e528069ba44a@roeck-us.net>
References: <20230311091806.500513126@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230311091806.500513126@linuxfoundation.org>
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

On Sat, Mar 11, 2023 at 10:20:37AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.235 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Mar 2023 09:17:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
