Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9A751865E
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 16:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236899AbiECOUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 10:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236925AbiECOU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 10:20:29 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8765227B3E;
        Tue,  3 May 2022 07:16:56 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-e5ca5c580fso17291505fac.3;
        Tue, 03 May 2022 07:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3HRUrvbLyxunbi1IJN8exKz8c9db2kvSSetlT+6Ztvk=;
        b=je+ywItHD9rn8l04sfrDiyjm9945lT18pvVl4jAjlX3Mxz1vVN6rgHHo3gyFjiS9EG
         dsfgChlVzqtNXKncGjpRfK58IfQY/MEUOG1B+QktZF3Sn/1ZuPp5/ayB/7DLukJIevFu
         wWv8CloBehhOOiCILzuw7OkGouOGRrk7xf5Gp2iPCDMy8bNMp7hpmgT43B28JulxMUcp
         ERJefgDccKADODWPW8LBh0K7RvJ9oSsXnI5o8Xt/Ae1AYIzjOrujE98RKyVLlxpgkmrL
         rcd2jZBPsI0JHObcDh3I6By4h+hnvaDVMTDEb5BC2tIP9D36PAGH85NVFQYiUS6VG90Y
         rJgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=3HRUrvbLyxunbi1IJN8exKz8c9db2kvSSetlT+6Ztvk=;
        b=WP3C55NT18uV8rqUEMDov7lafXY7Kvu4/piPLpXbebOxTen4YpWjItJL3RhtoSij8P
         4ACThQlHN0gsIaNDDWAl1ntPGz3PScWDimJ6wiP8xFNDjnq6bTkEVy8+9L2sbjV7FDNM
         Z9rpJOCmfONn026/BT6mmK6WptBM0zRzT8u83j2T7ddSXmjrk8valv+4ZApCEKWkLLH4
         6smGpRyk2Br8LMD6Tv13JWQc6QirmbWuNyVNKRD16FSa9ZbaNz2LQkG1uIRbBd3TvCC1
         KXqT9FWcmmUPmSqFOlV7KTRrFgfp40Sj4h/rwulYflev6vrKSExUvwFJsjJ1PvMc8aou
         5rEA==
X-Gm-Message-State: AOAM533zv9MqnJZJ6epIBKFDjguWW9n58iKzhVOnA7R95+Y0h6UHyEkd
        opa3skilP9ejHfFnZrMgJbROn5aWrKDWjw==
X-Google-Smtp-Source: ABdhPJyI+k5zA0FTobMTFI62D5PLbF8ZnxIsgVL6MsqnAjAOUwgBGJ/PWBbNek49PULQ3pwv7Wu0BQ==
X-Received: by 2002:a05:6870:41c6:b0:da:b3f:2b8a with SMTP id z6-20020a05687041c600b000da0b3f2b8amr1786454oac.297.1651587415305;
        Tue, 03 May 2022 07:16:55 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z13-20020a056808028d00b00325cda1ff90sm3358026oic.15.2022.05.03.07.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 07:16:54 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 3 May 2022 07:16:52 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/12] 4.19.241-rc1 review
Message-ID: <20220503141652.GA3698419@roeck-us.net>
References: <20220429104048.459089941@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220429104048.459089941@linuxfoundation.org>
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

On Fri, Apr 29, 2022 at 12:41:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.241 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 May 2022 10:40:41 +0000.
> Anything received after that time might be too late.
> 

No cc this time ?

Anyway,

Building arm:allmodconfig ... failed
Building arm:multi_v5_defconfig ... failed
Building arm:at91_dt_defconfig ... failed

Error: arch/arm/boot/dts/at91sam9g20ek_common.dtsi:223.19-20 syntax error
FATAL ERROR: Unable to parse input tree

... because a define used in the patch isn't available in v4.19.y.

Guenter
