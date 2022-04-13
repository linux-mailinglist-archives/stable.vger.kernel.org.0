Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2BD4FF95D
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 16:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbiDMOvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 10:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236284AbiDMOvC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 10:51:02 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32012644FC;
        Wed, 13 Apr 2022 07:48:41 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-d6ca46da48so2204348fac.12;
        Wed, 13 Apr 2022 07:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FxHwhdm9btSdYvaFRpF89WZ11d+DUJSyuwpXyhUrySg=;
        b=ph+CLcb2D6lORM6IJIyfthmCeyks76RTfVxrWHNcwulXigGAcv6oo10iABgrk6Wx0U
         6y+yK+Yxye7o07A9VjWY6yixw7XvrL1kMnBvAIzyzh/quWtmavCXmozqGbT2LJLsa3UH
         TqVS2A2Fh3IQSIVu9pbOp/p8qw8nwtVyGs+ypYdjgKJc+SwLzLuzCuRowFj/LD/+Ab6M
         KAa32cWZK0KazOyqnpd4cgi9dhgp5QOPRkdy5ByAbCYlU41ZEmHb0f8R6EVHg2IH6X8z
         eY0etUQFEO+BrOXfV+HUnISWlPM45kODNGYo9CKkQl29CdNDVX886mUw5cl1TkxYbpvm
         zFjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=FxHwhdm9btSdYvaFRpF89WZ11d+DUJSyuwpXyhUrySg=;
        b=v2e44qVWa0UInGl5KffpWq1Tn8nVTJK6b8Cq81QealIg8cFuhiTHrZwvXmmXn9VKYK
         BR0thZzI5lGgb6JD1vfcmFneVNuR6j3H9zA27Md6TgADvwWmVu7Lj8CZFmo7DHRDvxMc
         34DG04Q4GSmDqSyCnPKiunojVws/42nLinWLmDDLXyB7wbRndFwBWFxq7qjCX8zA7BOu
         80gr1hT73m98ZN4PT4J5pm9z1mJnMU+TiSA3FFf8KaARPusXoXpvhh0ch2X/2TUZU02E
         d/PoxwUDZhYowvcWeUGsT2vryx4r3QF+EqRofvy0F8ecEX3Fa6Vq190iD25Ncc72gGFT
         nUgA==
X-Gm-Message-State: AOAM533Ht1BFBBsOrK51noaC3H84OCpF49zLZKYiBLS7hC+JxuI5Ok1W
        xOxubEXRWe5GYHhN3500pMAUHPnz4IY=
X-Google-Smtp-Source: ABdhPJxxhlIyEawQLcU+LCbKgBzlX+AYJPer6EsJupaiTYA+lM8oT/PGy3PKD5ptIAM99efoX6njtA==
X-Received: by 2002:a05:6870:5712:b0:de:2cbd:c39b with SMTP id k18-20020a056870571200b000de2cbdc39bmr4452829oap.180.1649861320527;
        Wed, 13 Apr 2022 07:48:40 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 190-20020a4a0dc7000000b003244ae0bbd5sm13715802oob.7.2022.04.13.07.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 07:48:38 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 13 Apr 2022 07:48:37 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/277] 5.15.34-rc2 review
Message-ID: <20220413144837.GA2401071@roeck-us.net>
References: <20220412173836.126811734@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412173836.126811734@linuxfoundation.org>
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

On Tue, Apr 12, 2022 at 07:47:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.34 release.
> There are 277 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Apr 2022 17:37:56 +0000.
> Anything received after that time might be too late.

Build results:
	total: 156 pass: 155 fail: 1
Failed builds:
	nds32:allmodconfig
Qemu test results:
	total: 488 pass: 488 fail: 0

Building nds32:allmodconfig ... failed
--------------
Error log:
net/core/lwtunnel.o: in function `lwtunnel_fill_encap':
(.text+0x4d6): relocation truncated to fit: R_NDS32_9_PCREL_RELA against `.text'

I have no idea what causes the problem. Given that nds32 has been removed
from mainline, we should probably not bother. I may stop test building it
if the problem is persistent over multiple stable releases. 

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
