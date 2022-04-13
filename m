Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E874FECD6
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 04:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiDMC0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 22:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiDMC0G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 22:26:06 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2872529E;
        Tue, 12 Apr 2022 19:23:47 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-dacc470e03so671143fac.5;
        Tue, 12 Apr 2022 19:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KYtg3uKrUsoqYWo9xp4A7/rMTX7gHQILFzl3W4jdzVc=;
        b=Bk/uvQSP3VpUNST/o/cUFK8dh37pAeKHVs3WXuPkWShiHuHeEChxIjBqezCxGNWChD
         S9EtVauxZChjP3Ef//s+I42bVJOSiWyr1GUFPLfwMM2AH0iP/cU5arpgrxqPV7K8BL5O
         GwASQA4qrrWnBfbEOyKcj/uouHqzSUfcefQUsIWrPRF+zFKBWkpxdtGf8FkpFmV3hKzl
         BT5hgN8SEZCznGzHHCmEhRCSL8CikD3ymuyDPGRLLxpsWenYtofLWM68UX4RgIVZct7A
         yU8E9trn+sDGRn0DjAdYADHv3b5s6KYkjLQWarZ03kH5xtkJ6i6/ui8obUw4myTxnSk2
         08eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=KYtg3uKrUsoqYWo9xp4A7/rMTX7gHQILFzl3W4jdzVc=;
        b=g8YjImo5XQ1Zh1AfJL8QRcrYlGvEJWh2CxpowoKv2UjQCj0rFUKSu/3cxj8mwZqzwE
         Tb8GHUy2LnnF7QbX/fQyKT+14q0JCfAC6Y2AYvz3o2oqRM91mX3oIl8QOJoOHcfU5Bsy
         MT0CIglVK9OgbCpieragxNx9ubnkI95MK9ItFTV+SPjqTkdOdS8UD+xfJxeNUfvo6QP0
         sB6hFyFmd+PP3F6CwcdWDGFOy2b6OSQNfGJsYFPocHIx3XEFAt7dlAxDjZqhn37objfx
         n4TDrKkun7eZMVh7gX6MPaA4CKXwiIaVLv1g90s0pNRD73bgssrlEv2l0S/E0LPIdrRX
         dTMg==
X-Gm-Message-State: AOAM533FZLbpoKvXxAzKi1RQGgJUTxEUesWFMBtuhw7psGmusaDj6imZ
        Ah/Kif2tiTiMOu65M2zs7/+SQkMDy50=
X-Google-Smtp-Source: ABdhPJy+CjyV32RET9fiO0Lr3zznO/tJdmIe2UQWuNjergc8SqA3DAvABgjfb09S1Uvk+9qrjObszg==
X-Received: by 2002:a05:6870:f697:b0:d7:5679:8fc8 with SMTP id el23-20020a056870f69700b000d756798fc8mr3408804oab.172.1649816626572;
        Tue, 12 Apr 2022 19:23:46 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w133-20020acadf8b000000b002ef9fa2ba84sm13291319oig.12.2022.04.12.19.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 19:23:45 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 12 Apr 2022 19:23:43 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 000/285] 5.16.20-rc1 review
Message-ID: <20220413022343.GA2128171@roeck-us.net>
References: <20220412062943.670770901@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
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

On Tue, Apr 12, 2022 at 08:27:37AM +0200, Greg Kroah-Hartman wrote:
> ----------------------
> Note, this will be the LAST 5.16.y kernel to be released.  Please move
> to the 5.17.y tree at this time.
> ----------------------
> 
> This is the start of the stable review cycle for the 5.16.20 release.
> There are 285 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Apr 2022 06:28:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
