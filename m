Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257356E719E
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 05:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjDSDdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 23:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbjDSDdv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 23:33:51 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1173540DB;
        Tue, 18 Apr 2023 20:33:47 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-517c57386f6so2101828a12.2;
        Tue, 18 Apr 2023 20:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681875226; x=1684467226;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=heM6ssmmB4xuI+BlJTR79VPhsXkajs4Jpo7EPp48a7g=;
        b=GLIJJ3NBuLc9ERDqndxYGZ0w1y6puZEAS+FQUK+8kgaRZANKbrPB6kw8mn4Rujbj2s
         DMj1t/LXAblZOXVwxR0VkP8ReMJTDpVwbcgpftGhuPKYRhBPBMx/x+IwKpZK34shN3QH
         cp3Eb3TqB+tVI3oHMGkz8M8MD9CDZxiVPCfVP58XaROa2BKF+zA4tg80TOr8OtpzvZsH
         CW1SE8dQ6BYabVGBObhJ7L3GbagjVVPWUQv3aIfD2kS6B96XwXTHpwMUN0WS76bVNtL5
         fEaJ0tGfKEdDn9F3BUMFCefoyctL7//+AQ+GFjU3y8aA79lQns300BiQ8/v3YWzxUfHt
         HcEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681875226; x=1684467226;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=heM6ssmmB4xuI+BlJTR79VPhsXkajs4Jpo7EPp48a7g=;
        b=gh1b8IYLa7KND12qNK6OewzycR+Eu++4gQBl0BdUsHtj4A8FatowKtwxRD1lmQvc3G
         vSyXXBylR2MrhydsPcU5/oFO7imCKrFXpXgsTexdOKk/AI/8JPapnvhL2889KQUZjG+A
         ttLM/cOAuPorZqbOTdG02bqcaFN3Bt+ZnyubAry6Ak+L+kjbASs+5BBPayWMwYlkb7x9
         vqAb9/DJYUrZ/PctGUE55YMTCVThk8XXP//v1NVRQg620I6QScs6T9hH1EaprS22QX82
         hBLxPNLJTexUiF9pIrrAMiM9tCS2ZHIW33ebKO0c29J3lHScvXTi3kL8Rd/m/GiQ4w/L
         s8yg==
X-Gm-Message-State: AAQBX9fU/u2tlNK8B/N9Ax0G4UAIpEjtOAjGNwTnRKyNAar4D2wsCY2R
        o9Ymz8HnyL73ASawrcLBbeE=
X-Google-Smtp-Source: AKy350YFq59fm5M8vGnfbK9/4AE4ZjZKN0HQTcbHz0cRxqQu4fQlwjqJGHSTLRejeYp53qmB5OLkjg==
X-Received: by 2002:a17:90a:fe07:b0:247:3c8e:dc1f with SMTP id ck7-20020a17090afe0700b002473c8edc1fmr1620292pjb.19.1681875226463;
        Tue, 18 Apr 2023 20:33:46 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id md18-20020a17090b23d200b0024684c6db19sm324482pjb.21.2023.04.18.20.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 20:33:46 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 18 Apr 2023 20:33:45 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/57] 4.19.281-rc1 review
Message-ID: <afb75215-5a62-4904-9baa-e0246bed63e6@roeck-us.net>
References: <20230418120258.713853188@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
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

On Tue, Apr 18, 2023 at 02:21:00PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.281 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
