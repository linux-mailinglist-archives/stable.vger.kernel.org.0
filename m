Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C10A754D422
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 00:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350245AbiFOWB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 18:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350243AbiFOWBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 18:01:54 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E715856232;
        Wed, 15 Jun 2022 15:01:53 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id r1so11510798plo.10;
        Wed, 15 Jun 2022 15:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LdrIZ4iMnUUYL89V6oxh1FZpJ4qOnn+bpJAvz85AHGQ=;
        b=QHjZoS02t3PZt1aXfOc1DArtnEuR1dfQAl+sVIoM0BMkN/YjG+v5v78tt/gYSMJJ4O
         q0Qxa1zLAXL6p1jmKATDMaZYkgAvEo5nPabj53j+VND/IcIYm8E1Un+mOPN0z7k/j6ss
         wfHNwoFdIsu+qxi/Jdn6kvmvRf9PWLWxQUp0GXvtrtaX+sCccQs15OsMbWo7BeC4HVBI
         tpVOeKAYArl2dqV2opv4Ba2MRG4HLeXBqpZBuPmajc8GYyar8xBEsI32mgp1HOMd65E8
         R6HnjNcbap+w5/E+ekBVjNgSslpexmOXXEmom1N1Ut4TFVoF0xdFpHKZya6Tc4JWGmFH
         1NoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=LdrIZ4iMnUUYL89V6oxh1FZpJ4qOnn+bpJAvz85AHGQ=;
        b=zOau3oUvxfQAcfyH22dP9JXAotBVY8VcHXY0f7QZVx3wxFjjmUczEFppeIsNJKqldS
         dMCJABlWTQXZaUzwl9GOy7DBxQZrwEGKpLthnhzkDS2C0zhuRU2yqXmycSU7/J8m4tiv
         kSH3wDYVNOdjY8b6itUaRQI27rDeidQ22YpFhv7XxbM1HnJmVhLhoskVJyYLUkKpnSDv
         lh9tO79Uj/IO4QmllhWfAKWqVFt859rL0E1Neuz52caJZDJ6HHv3W9DkAZlYqW9bNR4q
         fHhdu2qhQPaV265qUTs/PEY2NGRQ8p9cijtkkmEkSl2urGMHMYrmxFMEpgiqGUwji16L
         bHDw==
X-Gm-Message-State: AJIora/LvmzaUD5HEy2a+o849aMtxKP69rtWWhUNudkt99nVMQbBsN/N
        fYWn31fu0vSaSAnUQbyoOAY=
X-Google-Smtp-Source: AGRyM1uAawkjkKWXExk7RRzHck1At6okHekjVrsLfZ5FJRi/UUSiHSAIYO5MbfRuvUDDU4jlG83m2A==
X-Received: by 2002:a17:902:d904:b0:163:dd91:87 with SMTP id c4-20020a170902d90400b00163dd910087mr1615418plz.34.1655330513011;
        Wed, 15 Jun 2022 15:01:53 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p3-20020a170902780300b0015e8d4eb26esm103485pll.184.2022.06.15.15.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 15:01:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 15 Jun 2022 15:01:51 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 00/20] 4.14.284-rc1 review
Message-ID: <20220615220151.GB1229939@roeck-us.net>
References: <20220614183723.328825625@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614183723.328825625@linuxfoundation.org>
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

On Tue, Jun 14, 2022 at 08:39:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.284 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
