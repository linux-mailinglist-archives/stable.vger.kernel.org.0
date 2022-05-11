Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C32B5228C5
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 03:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbiEKBMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 21:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiEKBMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 21:12:35 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E2F17B60D;
        Tue, 10 May 2022 18:12:34 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id e189so989913oia.8;
        Tue, 10 May 2022 18:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uhDfHP6cSzfYcuj8ypchoS67Wa7DPYlYj9JyYRIRKCo=;
        b=UA7erEXdheFYqln1nc+0ZiFejHjEZwV8TZkq9b6NosegpHUpEB+Xf5B37sMknOHDZ9
         KQzK9sA3BbiCU3yJjv+A5tvZ4LF0RNPL3Z2z56j97TM2Cv04Jv3Dm7LU4/ZJwxqJaRhL
         z92TvOMtDxgO37SCg0UeOzXP3OfHwikdsKl/zhh3kFoTkAl6NzS/km2mcAScQ6F1e74A
         7X7QC7BxQkFkRtktW3viCADa4NYNc5HQoUZn7ok9daiz+6goM7OtiEXchQT5gKcu6Hje
         Hi/ShgikV612zG3YSpvAlvTL81aFJVsw2rVouF3zc89kRdbvAzYRUJascKGaBFKOP/FC
         rvgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=uhDfHP6cSzfYcuj8ypchoS67Wa7DPYlYj9JyYRIRKCo=;
        b=Bl0iVp7S3ZnxyWT95BesBLAXKgiLAvRwNwKhz2owkrzypd+DkWmbHqq2vwBv0wTVSs
         3ssThJlecyNKs2iBNT7WjNCzHUABmN621nY9EPK7glu1PaHnsk2S1x/l3DsCe7pBowVa
         tr+1bJthYgZzdDdd9Z7tpMVqwSrl7cY0xjXfCSvjou4mynH5XeXEleRYJsb6bg8wmBfT
         9ItXd2adK9TI4B2EB+ifSZfawm2oRcdjvIy4+XDsYxkEI4wHBfvfcB2LL1A2V5hurTsu
         3IlDuDHMpTIGsPjyJOqCkfLrvvbeZNATbmxCbaaS9qIJWEKswA0drXhE0xfMNhp8c91Q
         pauw==
X-Gm-Message-State: AOAM5302WNkrqVSfgoFhx5J7d3coriS1FFO3Nr83PHeeeelpD45T93j2
        ZBr702yqIX6lcd3bVPkYsW0=
X-Google-Smtp-Source: ABdhPJwR8wfFNP3fIbUV7eJT+rqeK1PvCDQ12FqQ6ZqLgNrU7aS+dEVMYozQWnnZCYcZkj64iKfMmQ==
X-Received: by 2002:a05:6808:11d0:b0:2fa:78ea:5cc5 with SMTP id p16-20020a05680811d000b002fa78ea5cc5mr1343129oiv.229.1652231554322;
        Tue, 10 May 2022 18:12:34 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 20-20020aca0914000000b00325cda1ffa8sm224603oij.39.2022.05.10.18.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 18:12:33 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 10 May 2022 18:12:32 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/135] 5.15.39-rc1 review
Message-ID: <20220511011232.GF2315160@roeck-us.net>
References: <20220510130740.392653815@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
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

On Tue, May 10, 2022 at 03:06:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.39 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
