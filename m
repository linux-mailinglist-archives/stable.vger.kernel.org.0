Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94EA6B580A
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 04:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjCKD0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 22:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjCKD0d (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 22:26:33 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FB712A4D6;
        Fri, 10 Mar 2023 19:26:32 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id 32-20020a9d0323000000b0069426a71d79so3999783otv.10;
        Fri, 10 Mar 2023 19:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678505192;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pC9WYJ0DayXmpMOoglpBp7yOZSkpByqHsAA3CKpSObU=;
        b=Qvd7j5zO67M2VNYTb/KmuGq8+/jeCw4l+uy40mLeIDBiT2MhOc6Y18vRvrL0keCbgK
         srCEt98zB0dD1NA4KcvcDBvDXFP2EVRYQzBZm63KCO7raytU3q3qPSyHSB+SIyVepLMJ
         5tLs9dldzpZySCyc8EruLUK635s8b+3UcFMDuXmPX554o/sQcIGG6MUAku760xLaTJmp
         KEyOQluNIWqdvErK6cwaW1sm20cyOxTCjPWQyPVoUKWwvfr5ug+bPWTHWlJLW0vH+R0g
         gYMN1hnlP9MbDbBNlX5yNuM3UAcddZxyEwegeDEmfigsjdajLfc9S+u89VB3fds8rwBY
         J+bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678505192;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pC9WYJ0DayXmpMOoglpBp7yOZSkpByqHsAA3CKpSObU=;
        b=Me+TgyoyZB3hJVg0DDMmKPuyuOlJ+Pa2C3ZRupK1j9UbhgSfELII+fr/56DNVo0gQF
         eUsJYXFq64oXNU88DjnTAWib5JsBEzY8f/8vulTnwv5geuxBMXvChvFRtqCPhV2ngI7j
         RsThvx2gWRf1Kn//9Bi/5TzLi1mLDoO5fvQeByRLgiQkhsrUe0L0BcXzsp+96hOhIMTd
         xSdSmtOE27NtmZe1Ufu1KgfIDTn4TB2ybA17NaqGsVyVG6L2kCkLIIQ+MV8Gz+1lCuFp
         z7Qzb3HIqRGfYgWjKhCXfPfHlXldEmU44wSkGeyNNvMr1XQcmzMxdNPiAbDxGb/NRD+L
         fhxw==
X-Gm-Message-State: AO0yUKVjJboRYpahYhHG64L3Wn/90XVT74bWe/jqtQBgH1U8/epas74q
        46vZml3HirbUm/WansZ0weA=
X-Google-Smtp-Source: AK7set8n5pAfWb5mjc6QGNNXuLWyD1frY89Malp1mtKiNryBTpiJysPLQWXQPYBJstAZlkpzeQgaLQ==
X-Received: by 2002:a9d:310:0:b0:688:4c9c:d45f with SMTP id 16-20020a9d0310000000b006884c9cd45fmr13856448otv.20.1678505192399;
        Fri, 10 Mar 2023 19:26:32 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o4-20020a9d7644000000b00693c9f984b4sm758278otl.70.2023.03.10.19.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 19:26:32 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 10 Mar 2023 19:26:30 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 000/252] 4.19.276-rc1 review
Message-ID: <9fb78cff-b92a-4ad8-a1f8-4c1e096d52db@roeck-us.net>
References: <20230310133718.803482157@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
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

On Fri, Mar 10, 2023 at 02:36:10PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.276 release.
> There are 252 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
