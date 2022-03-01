Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 524C24C93F2
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 20:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiCATKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 14:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiCATKN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 14:10:13 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10E863BEC;
        Tue,  1 Mar 2022 11:09:31 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id p12-20020a05683019cc00b005af1442c9e9so12980496otp.13;
        Tue, 01 Mar 2022 11:09:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HHwqSUwOoKmT2ai+hrugwxutacscqRhisHZ4AUtP+5k=;
        b=mAa11V+QeM7TA7MB0coioMcHc5Qr4MqBYfsva1qnrGOfrrwOJj2St2qmW1oHNmQJJN
         wpauTwWgXhPKzIdYSaXyzPy54Phj7X3tlu+78oXck6zeheMLj8+q5BPBy8SgLeXeBh6z
         vt0i2/c3qFZobkT1mfQKB1cix+jCfJLIXEgBfnV3fVqzhPY6FTc5ZhkhJDmi8CrmR4Ze
         tuVMWYZDVS36FLhYUFrg8hgIZkHyqGGh616UpiXVjQcnLLn0vjx2tQgAE96AZXUDOmxo
         +jU93JaWYQWFyJCihD4PsSCzCne2dKnrF0C4WnOB8zaaZXGAqJIM0gT7vB0LqNAPlaP8
         /J7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=HHwqSUwOoKmT2ai+hrugwxutacscqRhisHZ4AUtP+5k=;
        b=xQ2cV/1BNNlzTeyRh127/tc6KGoSsn5f+HmV0MElD7uxtlJ1bjbo6KiEe1cHkhekAi
         ecVN20vVxYMkd4PL7Xu4fNC5ahEDMXllopo2AStauA3NYnbC7yAFM/n02gm+S7ePt3NT
         DCMbOh6Zbd+oCW7WFqt8ZCZljgq/KNjt4/Bi3B7jEQyncpOY0Vn5gsu+7AWk47OfGXOr
         gg7F6SNeRKnPYu7oG2fdX/+ZbaxqBn7EkMUpXDvpvUOC8sYJ/E/JG2UEHfxqO5i8DfWy
         Z3ogLUlW2O+VWIuZ5420pK2aCFprukE17+mpIeJDoTEkk2vtjzwB4dGfaUbR6Sh3Cstq
         lWkw==
X-Gm-Message-State: AOAM533A4x+S0Udx04rg1nJ/aQdtc/Nxe78d22DVupOAHmnI4QO1TCqK
        xX7Ag+U3GplACeCjoswNCNc=
X-Google-Smtp-Source: ABdhPJwJIKS7fBa6phmes3+MYqySa4y7i96YyeAThjDkc3HiJjM+BDoXcTM450I4RTdoB5PxpTRgWQ==
X-Received: by 2002:a05:6830:3110:b0:5af:faf7:6b10 with SMTP id b16-20020a056830311000b005affaf76b10mr8607627ots.221.1646161771267;
        Tue, 01 Mar 2022 11:09:31 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m7-20020a9d6447000000b005acf7e4c507sm6723445otl.20.2022.03.01.11.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 11:09:30 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 1 Mar 2022 11:09:29 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/29] 4.9.304-rc1 review
Message-ID: <20220301190929.GA563901@roeck-us.net>
References: <20220228172141.744228435@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228172141.744228435@linuxfoundation.org>
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

On Mon, Feb 28, 2022 at 06:23:27PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.304 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 397 pass: 397 fail:

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
