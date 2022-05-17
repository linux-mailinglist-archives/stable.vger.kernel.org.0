Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1983552ABF4
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 21:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343851AbiEQTa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 15:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352685AbiEQTa0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 15:30:26 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B0B506F6;
        Tue, 17 May 2022 12:30:26 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-e656032735so25548642fac.0;
        Tue, 17 May 2022 12:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E+OwoncZlvSL586U6ESqP0O//bmF1J/nv/ry4q4Z0nI=;
        b=U4tF6V81k82nwY67egoQBZ00LKbJpJoFIWFztWpmZBcmDhZGNhQDVe9m+DFlql7mNQ
         1GZ8AO4n7oFvSWme5hX/E18ra/tGttfGco5akNB3aaLYX6HVdbRTAn+jFleRPgEJh0HS
         bSqpQb4e/O4aJjz+aVgZNQkKlXCzSs1VlrLe5EvP5Q5XmLjHbvyrT52Od6uUi073k+C2
         LcfY16zj/qrPLo1YOU6LoC/e3W7ur/CyoLACYIRtdNe9HhGEPv8fALp7ApBJuDcVdRAp
         1kkfKh6kj3RLLiCMmra7Ak8N4rhrzspWEBfdx5cef/EBDhBAXhrnCvyGrSqQ6DnDLR+R
         Xwgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=E+OwoncZlvSL586U6ESqP0O//bmF1J/nv/ry4q4Z0nI=;
        b=DehH6fg6E2DZNmgwh6Pd0iYJ36/WYYxpVFME7mihV0NnaEu4jvWDkiT8qNt9uliiZi
         gx8akwdOP7jO2vYHr/us6j2doNm5JqlC+5NZRztOrxIKX56i+MELW5QRPgOU6OJ2KYJh
         fBHesD5dac9Fd+8HPX3v/6cNJAwEcy1qLNWO6nCjtfuZyi0LTgfDXLP0m/Z01ocN6r0P
         6dOn4QoNVZGdq0fITvTRWrnIR6jtslqA080TegFitCWHazXcv1apLw/me805ZwcRhSJ5
         /BZckyY+L3/YajFx4sXNTxMJk/cYOO4f3VIgvXwpTJAyM5Ib5xt31NTme5RB/VO4tspU
         IIjQ==
X-Gm-Message-State: AOAM532VnpZNBHrwYmOJ7MR02e5QSNbCkuiMVoGJhpTlhbaHugcn5RoX
        NOG0RiLoEU0s05eTxKmlB/4=
X-Google-Smtp-Source: ABdhPJx+yS2HjEJyRCHdbrRpBiINmC0uky4mPSu5BV9rfH07hE066YLSzP5S4a0Px9Cq22pVIGHECA==
X-Received: by 2002:a05:6870:b60e:b0:e9:35aa:3cb8 with SMTP id cm14-20020a056870b60e00b000e935aa3cb8mr12443637oab.249.1652815825419;
        Tue, 17 May 2022 12:30:25 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bd15-20020a056870d78f00b000e686d1389esm102599oab.56.2022.05.17.12.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 12:30:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 17 May 2022 12:30:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/32] 4.19.244-rc1 review
Message-ID: <20220517193022.GC1013289@roeck-us.net>
References: <20220516193614.773450018@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516193614.773450018@linuxfoundation.org>
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

On Mon, May 16, 2022 at 09:36:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.244 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
