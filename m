Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E32994B602E
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 02:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiBOBvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 20:51:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiBOBvC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 20:51:02 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434E01405D2;
        Mon, 14 Feb 2022 17:50:54 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id r19so343640oic.5;
        Mon, 14 Feb 2022 17:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GNrVhclLI4K6ndYWxPepdXje9XShe7LUmBKrMvwIegY=;
        b=Fz8II636L+gAYqDwbg4AWzjpTdAAS33GZos/JqOAFRAl0cDyJ66mRsaNatEX2CoxLr
         JzmOPZ7bO0dTJ2Cxp6k4ykP9VKJS+Tns654vMq8KlVfUALsD/Oi5FSXoNHb/agMzWEDp
         rqa+Vs1Z7gZPHZZVQpyRZXSCP9Q74zeHywr30Ym0eawhqQVd56daCl6PgPmyJTotfYX+
         a6pdGWs7IVOHUGowJq1t8otK0qhc0VsbwMv2bf6fUcjrPiHDvULVt0/lm/qlnAU3vrLj
         G1kQKBfRM9bAwMg0PEFEq6QxiJ8OPip56xZAAbt9EyoU2tLgciAIVtq8Ar6uJ5La3eVs
         hRaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=GNrVhclLI4K6ndYWxPepdXje9XShe7LUmBKrMvwIegY=;
        b=XRzwCCU0AW6Q2YlyLDiVD4/GXr76q4OTz+rf1drocZ3X64bOpvygUVkWQzNFnBIO3N
         QKJ5qwyUsRwRV18hP3v2nb4q5cner/oWZz1pgXittqLDuSvte16Q08mlXJBHZXtDvMnG
         3EoLEe+zn0FrfFJC00shFuby0dkqXbm755TTzTeodVapqNY8kMYbMcffHS9Uncbdm25s
         u3Tn8t/gLXp1SqH6f3+dIrqfEqOo04dwt5aeyPUsEN+ctcOTJb72Sdjp7JV/cWIdfGIE
         ndW3MdyN9AlQAp7Hm/MY8kB72Tb4K9F1o2joSkP44kybY4/HaS4K3iqQCHnz9v1nSSB2
         lAaA==
X-Gm-Message-State: AOAM530UV3PKjcxFbBM58VNEq+2DNVsvSY66QPWAHsVO/rxxsgI0AjSm
        7nTmkJi5ileVeZ9B362R72k=
X-Google-Smtp-Source: ABdhPJza0khJ/fI4xsARio6D/7lBZ9Fvn1xTAiH2YozG/xdrosmbLXVGeYod+4Pq6O4qVHaDB84S4g==
X-Received: by 2002:a05:6808:300b:b0:2d0:a492:e489 with SMTP id ay11-20020a056808300b00b002d0a492e489mr686411oib.171.1644889853694;
        Mon, 14 Feb 2022 17:50:53 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w7sm13329981oou.13.2022.02.14.17.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 17:50:53 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 14 Feb 2022 17:50:51 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 00/44] 4.14.267-rc1 review
Message-ID: <20220215015051.GB432640@roeck-us.net>
References: <20220214092447.897544753@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214092447.897544753@linuxfoundation.org>
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

On Mon, Feb 14, 2022 at 10:25:23AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.267 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
