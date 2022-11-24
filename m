Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1FC637083
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 03:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiKXChX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 21:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiKXChW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 21:37:22 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B36E5E3C6;
        Wed, 23 Nov 2022 18:37:21 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id r76so298892oie.13;
        Wed, 23 Nov 2022 18:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dOr7hS6kCz8bfDkfaoa3RQ9RQBpOFJbxgrrQiNWeWfQ=;
        b=ce1V6RurKafMdFGURc9GX8hSOEQfJHbwfrf5SyqVr3rk9vFSja3VMjVCPT7UV8TDyd
         zfXDARhJZ+T3kFQXjcOQXjTkia5oKA/FV+KaLHEMX6jzIuqHcmTXQRpdaS3D0EWyeeHE
         6Q8J+sqAhmM0Uo6k4wOehNEOf+k429gBciDIeKHtG18k7UHmf4SzFBU4Rg1ZHp09fGQA
         vH4bS4xawCkVtwcRaD6qCA5KNLXaBYblzt5RL0+irw+AqUzZAoeNIRyu8iBmRs9Fvg4b
         zJr49WOttx3gZJXsjjORcfqYMpePy+9yu62NbM3s81TAkC1mcheHi+UA/QrF8ljvsDct
         byFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dOr7hS6kCz8bfDkfaoa3RQ9RQBpOFJbxgrrQiNWeWfQ=;
        b=glyZjl254IlUbmCi7WLluMDht+l8UJkdcm7I2eV+y+VjQA7ZHiRYIhg/r6eMcdHVo3
         T3xTbmpVkVtWgb3NDJlVR53FkxBpjU1rzFR1t+JhHNcbp1ZkZLB/t2R7U7SsneI28ZGz
         JQaoZq1bYwCBi/rPOLepiNRQ/5Zlp48k7ditR0y/UcLk4LhTFmhJbuhlg2uxJTKgdzMO
         ojALH9GgGDDwXn/9gSlzovWWn0ZYubJ4GBYY0F+ql9BKbB0aSW5Cu6hL/HsDeuyrkSkT
         6Il/j/Jum4u5QXPHuQ/Mu4Vbw4Mw7r80qHUCCZyd0JuDDktOiEyLoJbt1oRoPXPzDSN1
         b9Pg==
X-Gm-Message-State: ANoB5pkb4hsAdKG3co4/mJMS7vb+i8Fn/azG8bs1GnC20SK8kB8jUAq6
        zOxTGhlOxBUvGeCVn0uItuY=
X-Google-Smtp-Source: AA0mqf726kfRM60ypC4Yhn3kXbY9mMqf7W58ljcoLHyQDZnURHFng7fkTSAomOc8hXcfNObMshegpQ==
X-Received: by 2002:a05:6808:f8e:b0:35a:6005:3d90 with SMTP id o14-20020a0568080f8e00b0035a60053d90mr5400422oiw.127.1669257440790;
        Wed, 23 Nov 2022 18:37:20 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q11-20020a9d630b000000b0066da36d2c45sm8101067otk.22.2022.11.23.18.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 18:37:20 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 23 Nov 2022 18:37:19 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/149] 5.10.156-rc1 review
Message-ID: <20221124023719.GE2576375@roeck-us.net>
References: <20221123084557.945845710@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 23, 2022 at 09:49:43AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.156 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
