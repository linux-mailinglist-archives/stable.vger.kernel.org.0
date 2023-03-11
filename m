Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 459066B5C5C
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 14:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjCKNnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 08:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjCKNny (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 08:43:54 -0500
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73E9117593;
        Sat, 11 Mar 2023 05:43:53 -0800 (PST)
Received: by mail-oo1-xc30.google.com with SMTP id bd3-20020a4aee03000000b00517affa07c0so1208689oob.7;
        Sat, 11 Mar 2023 05:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678542233;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WLG7dP/z9Cy/qo78TWfKaT1KoQNzr3rxi1FvEN8TnLc=;
        b=i7hA0tDeAJST5O9n9vjdRPx1ocGbY30oJTosaptm6PghdRnM3d7u3b6CcKCcsdwBca
         IgvylvzkzQVbnyBehEAEWvqyytyUPPwFvzVfnNX8sutOVzlr9KiSNjZaUuLFzn4uPIGD
         hO3sG0joP1pKpefP/JJvlSlNZ+zxG4XLZsYtvjAW1ksp6/tEIiiqystb7RHJpKGhSzJo
         31rKh4bW4GN4Ukz1QYXN4RTQFx6OjTjifzpuq2FVC4gufrnwebEECO0ZXFi1A2pUubk5
         XNAaQ9MMZFIdl+3//tXWo5r0FF6Occ9iwzVqjQ2U535FZMgVU93WsxgdEL90gUf4ZpwI
         8Zwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678542233;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WLG7dP/z9Cy/qo78TWfKaT1KoQNzr3rxi1FvEN8TnLc=;
        b=YdzU7GpxfMXayE2a6iQiFBpyzPlzr6Xg6zUP7RMuVtuHpGyfezhkvzAa+vzGua/kR+
         PDqZquHru7ifAmTZLjziErShVk+ZbCrAELUM78f72nE3O9Jv33WKG9m1Us39Pf8pIDwF
         Xy4UnAKAO5pmvKgLqKEEHgvOxhC619CfSmrTEKMG5WCHOpaKekk3jGmC4Ie5WstO9T4j
         hZUvPvivKDB0rVn3Hvn0+K0mgC/Aawv5aZ0H9Qrn1SDSAOuKul6EXiZ86kU+09cvBHgm
         ND+aq1qdfHN/Vco75x1CTfllJMB7AaQLGIG01dwjejo0mFCIl7roIegqG0OxOyHIYexD
         BGTg==
X-Gm-Message-State: AO0yUKU2eDoiOE3EwLzzzxKZ9s0FAp9FooZuOqkUgnAcdJq1ynJgdJLl
        SyeQbSATYSVDUXlylsnUyJxBHH99W10=
X-Google-Smtp-Source: AK7set8PeqocgC/Go2haHvrHnEJoBIuN6xgMGzU1vK2uMSRz0hfTX7PXhguQy0FVK01gLcZ3FV/SxA==
X-Received: by 2002:a4a:6f05:0:b0:524:a1a9:f2b3 with SMTP id h5-20020a4a6f05000000b00524a1a9f2b3mr11874336ooc.8.1678542233165;
        Sat, 11 Mar 2023 05:43:53 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r17-20020a056830237100b00684bcc9e204sm1144847oth.78.2023.03.11.05.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 05:43:52 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 11 Mar 2023 05:43:51 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 000/192] 4.14.308-rc2 review
Message-ID: <8c29b19c-e0b2-410d-b501-b6d8ddb77470@roeck-us.net>
References: <20230311092102.206109890@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230311092102.206109890@linuxfoundation.org>
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

On Sat, Mar 11, 2023 at 10:40:14AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.308 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Mar 2023 09:20:28 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
