Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C7253D833
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 20:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbiFDSzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 14:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239717AbiFDSzR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 14:55:17 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECBE4DF75;
        Sat,  4 Jun 2022 11:55:16 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-f3381207a5so14542950fac.4;
        Sat, 04 Jun 2022 11:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TdAiHLo9JGYWZtKBrXC/E9LV17ciRDNP17ydyYqbhss=;
        b=D8a90oSsnOijwAC0Fr9kkGkMCnWBDa27DXXqpp+Sdady7EjoHl6XmbIfZOOwtxz8+L
         IBFW+fg/pD5eXb1MuRaFspcK9ib4CF1rNSQ+2p7WDGvrJY1ZXKIn/LKOMbDthH8l8sRD
         HFyR9ke0R6mfOVeCtuh51HAFstMWIhbd48P76C+HNDZKxW4H8GW48qmR0f4/iUQjQvPA
         xjoMMP3P2XopauEQSBxIedl+LB14Jbyx6hVQNgv1XdiAA47i9WfieyxoXJ1U/p3ZpRIn
         uanIggD8bryJCiYcWNWGL8yoJNkBm5Fimx0oQ3D4Uc2j2r/tyFDGB41dncxnml3SuG4q
         fjag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=TdAiHLo9JGYWZtKBrXC/E9LV17ciRDNP17ydyYqbhss=;
        b=vT2InTn+34vH8/f1X6snjMOZQcxJz+ATMk54wia9dFUTC4soBDCnMbJcVTW6rsk+Ug
         BaaBIufFqg57+6SQuja31WR4tpPGR9H61fwd/Jxu9Bx+xorvPMmr+4ISX5PytYbCHByZ
         rg5xoNMtltGqq/CQ9Fk7V8T+57n8KxAHB9iOSFr/l1vgVPJ5bQ3qfPKT14ShN6vGS1R3
         sBmalCGfHg83O3hwpsSjGM3r7+dZgLuNNVIcKJsoQNSInd9n656aDAkyiXnJ2/Q5NFnU
         1Wk6iQzMVR0LQm9xheSH7C6siev6RVTijQGOLhn4lN6+mBqcaTVtfXhtaN0KTTSEoPBZ
         K8+w==
X-Gm-Message-State: AOAM531TtRzviUsjGQIFzGzwhIfxjJQCfJ3bbOQfYpxH8MWxNRxrZjns
        lvt4h5FZBAsxuIxJ8yWBbLM=
X-Google-Smtp-Source: ABdhPJxNynmO1CeKlVl+JpBTC6ie74ouEBhpOZTuc9NU1wqQ7Z4Hmjk1P8N+XjL6/eGVXne0DuASTw==
X-Received: by 2002:a05:6870:46ac:b0:f3:43f9:709d with SMTP id a44-20020a05687046ac00b000f343f9709dmr17625502oap.105.1654368915337;
        Sat, 04 Jun 2022 11:55:15 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z6-20020a9d71c6000000b0060affecb2a5sm5538035otj.17.2022.06.04.11.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 11:55:14 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 4 Jun 2022 11:55:13 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/53] 5.10.120-rc1 review
Message-ID: <20220604185513.GE3955081@roeck-us.net>
References: <20220603173818.716010877@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603173818.716010877@linuxfoundation.org>
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

On Fri, Jun 03, 2022 at 07:42:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.120 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
