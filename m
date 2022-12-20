Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD5B6652311
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 15:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbiLTOti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 09:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbiLTOtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 09:49:03 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6F91C914;
        Tue, 20 Dec 2022 06:49:02 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id i26-20020a9d68da000000b00672301a1664so7280084oto.6;
        Tue, 20 Dec 2022 06:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kU0qpDCF5riG3lUKLpgQ+p9wqeopjuwXlJUExZoUcco=;
        b=geWLdArBPTaA/RN7P/IOgW9ZIdxGg90pVUksdUfAoL/TrZnPzu6z0jRc5tKSW7cPAX
         QiR3FpF/MLGgmUVTNugRXbDE9zOx9XPDtJ81dXQOJfOUNqG98rb1PVBXZ6vJvNUc69Je
         vtdm7lMXQ76ITsjFnH0wn4Rre3UtiajbGjc+AuP4vHTSIf9ZLRvnV2h4VMQ0HdywUjdY
         Uct5e3CkSxGU6H0m3ivEghsL3y2E8BRvJhRsNZzQVAWfg5JVql9BiZo6rLyckcgwsyim
         /m7ntsKWzFre98T2H4+bq5FBkZTOj7RIcotl+V4BvzDLxiaOtgHiBwj2JNSJwpGnI2uc
         RL5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kU0qpDCF5riG3lUKLpgQ+p9wqeopjuwXlJUExZoUcco=;
        b=j0bFTHIoSmq9YrtuzjZM461GIZO+ZLtyJDq7fumI7ms4rzaxYc75301CFIqZK43Bp7
         2XED/1ZDXeus8p8Q/mITnLj7vidpBDNHm858IXRuFmfKOZo5bPW096M5sjp/1y+44ywM
         eszeYf9DkFiCw1/A9IWhc8eM0H2w/wTfeMopPW3Q+O9tKCVDoRwsSmQb7f0Zpp8fKyQ+
         qKEdxy3cSEOr/tTduPX67oh+srTljFu8mNgxpyiJotuifoZVTczTJdP85XlFBEvKujMW
         Mh9j28bc3TLNnpup88yQ3V3oKf1uPj3ySzJAZ7OCTOW19S5Z4JApR72vuvtiEzGLztNP
         fbDw==
X-Gm-Message-State: AFqh2kpsx+ekHIWCDExu3H7hDQKrF/lygSuT12Kkzq/lWqTUugAdPF1x
        tEXDxoRAazJY6DDY5BG4pSM=
X-Google-Smtp-Source: AMrXdXs6tA8IH6SIio8ED/97cPJpONxFQ/q2TZ0VbuDgsaqasyRHAr5PVqqRfae/+GrFb9OdSg6reg==
X-Received: by 2002:a9d:7dd0:0:b0:670:64af:1a4b with SMTP id k16-20020a9d7dd0000000b0067064af1a4bmr6153716otn.16.1671547741942;
        Tue, 20 Dec 2022 06:49:01 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y15-20020a056830108f00b006708a6274afsm5720175oto.25.2022.12.20.06.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 06:49:01 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 20 Dec 2022 06:49:00 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/28] 6.0.15-rc1 review
Message-ID: <20221220144900.GD3748047@roeck-us.net>
References: <20221219182944.179389009@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
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

On Mon, Dec 19, 2022 at 08:22:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.15 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
