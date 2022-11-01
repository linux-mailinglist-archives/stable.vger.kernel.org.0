Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94FBA614B21
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 13:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiKAMvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 08:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiKAMvY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 08:51:24 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F8F1B1F5;
        Tue,  1 Nov 2022 05:51:23 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-13bd19c3b68so16637835fac.7;
        Tue, 01 Nov 2022 05:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zd8ew0Fcdtt+vn+WPQkyqr+cTA4/IsSUe1qVBtpnWNs=;
        b=JHsIdYCmoCKt/QIf+2xLn+VWR97YHma4Q6woPQpTOHVKnzSBq8fkOjBkQfmjJBtVkv
         8PIEvdObggiLjsfcAUfHlM1wrm8G7J/LZD12b4DXGnslFEUDNndQXjPhZqPoFPZgYTUn
         5degH08BD/HwLMMYsNlJA0uRF8sWOMI1z7eI+M2nrofZ6IYF5DU7rn4ZBPdOmXoazqGz
         Z4U+26mwqu4bqVFKRsSixpkXNky9cFQ/fBmztzCj6KvXOWwURtB0l0CvZSkXcn3959sE
         FlOaUhFtHFm5xjNsvWzATT9+F0wn4Xs1m3e1NPFjcN7QrwLlHMkhLf6fmyYanvUXx5G4
         8d4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zd8ew0Fcdtt+vn+WPQkyqr+cTA4/IsSUe1qVBtpnWNs=;
        b=OXmI4NfCGEDMfGtulAJ0PxTNOrQFE6qkTxuv0MykBKDLYPCN6GAUib95yu3xcOTtaG
         gboBMHbGsvwt/sF4DCCeEi8LtbAKperY5ZMKZ9U9nN6eVJqfxVORIATPU1dEfWzzXqZn
         Fd/r4iUcs7DqPKDyvea1MFHUMXFBeHX0exvXyKhymiep4XyzBdpHBVvNZ9WENQuIPpUg
         uJHZ2+I+hI12Da3+DAnOppC1Mlp4kAULUxQ1UR7SrT6JaX+O547OjA6mdPNPK3LHU03y
         AKGOXjVhaEylMCSlgd44iH3pGu2B5Xm8hASPm+cS863lM5jwpWjmz5mkNA8mmLQecbWq
         gRog==
X-Gm-Message-State: ACrzQf0xDTyZAIdVnH8Yw1d6mvTgj8qAytTNEC2g6Ly5ARoIA8DNAzvC
        BZjfuP0B295gVJIfYpau0PU=
X-Google-Smtp-Source: AMsMyM7h6iyk9rwLta5eEEXTz4x0HYN4lg7IfIg6vG8jwGcPHAov4FPbiA23wf0jno+Q4MVSs0QT3A==
X-Received: by 2002:a05:6871:207:b0:13b:92ee:89da with SMTP id t7-20020a056871020700b0013b92ee89damr10529640oad.233.1667307082366;
        Tue, 01 Nov 2022 05:51:22 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r24-20020a056870179800b00132f141ef2dsm4368963oae.56.2022.11.01.05.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 05:51:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 1 Nov 2022 05:51:19 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 4.14 00/34] 4.14.297-rc1 review
Message-ID: <20221101125119.GA1310060@roeck-us.net>
References: <20221031070140.108124105@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031070140.108124105@linuxfoundation.org>
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

On Mon, Oct 31, 2022 at 08:02:33AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.297 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Nov 2022 07:01:32 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
