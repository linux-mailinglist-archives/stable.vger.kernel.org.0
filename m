Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD734657A6F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbiL1PLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233734AbiL1PLD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:11:03 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8718713E08;
        Wed, 28 Dec 2022 07:11:02 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id e17-20020a9d7311000000b00678202573f1so9990783otk.8;
        Wed, 28 Dec 2022 07:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BEi2X8IqqjxNARHjcUaUwyHSrSwQ2u3CkgJ6q6RIUNQ=;
        b=EoezPrGxjN3BbswTSuUUGvmgpJSYbca9QQWKmY41lEUb8vU0J8a5JhBbLmJcLsYxTM
         MDKHc/wC7yxtlfWcZMv5NYT6pZmGfSWSlv3zMpJiC6d1CUM//lrN+wK5xNveFjb6rOgI
         h78F+NeWLFoH4wDzgnCS9RlrKoYgHUBiTRWMGcIWqRGMiQdghy96F6z4wKmonsKBryrC
         MvlKESd7HhQspVoQcDS7oaRTKUBcdxHlYRK+qW81hflJtQhqTVV8luu9yOCXJBzYI/6l
         02gga2dLLM4boYP0+LAxZUd9LUaFr0bU1I/lBTJlaYukEq2DKWgpLcvsNJuPdBRjdlKz
         J3kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BEi2X8IqqjxNARHjcUaUwyHSrSwQ2u3CkgJ6q6RIUNQ=;
        b=DLdqknmDARWEq+DaoKgBGCbRd/EUE3WKqLsBlw2JYhf7E1/PxTE5CpnOS5eVIuAKQ0
         YjraBBKDotTMOpvvqyGsYydkbRqltwPyaM6LRX7TS+egJ6lUKE0V8cUBK9Y0By2nGdAn
         fCB9eDqzPrU6kZdhbim+VKIL0NFZYtClQrJwPKHoepu2fTWfs4EnTFZlUtc4SvSQyRhD
         nSDUqQ0TdSRmri+N30VdCJdtHVi1l3Tn2jsd1NJGiqEi28yckaFSTXMdstc7Uc28LGsi
         fNqtHDMX5+hJ8iHKXBBCmiVn6BGF+OyEBfOKXYY4SU3UmS9VsMi4HncBobBD90GzqJ07
         TlMw==
X-Gm-Message-State: AFqh2koPcN99i/XfaiNIycDN/hFngQtnFkJYe//IO6BE55G6CRPreEHC
        1BoAX8V4ckzsKacLDbrxv90=
X-Google-Smtp-Source: AMrXdXvFx2Y6Snk+TpNsxxKH5WFlAffqZKHDWNvb2TMTuqkduNKnzjfIvlKAMzDqrXI4ZjIbpz8E+g==
X-Received: by 2002:a9d:694b:0:b0:66c:5797:5c22 with SMTP id p11-20020a9d694b000000b0066c57975c22mr12439741oto.14.1672240261839;
        Wed, 28 Dec 2022 07:11:01 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id db6-20020a0568306b0600b00683e4084740sm4066034otb.10.2022.12.28.07.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 07:11:01 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 28 Dec 2022 07:10:59 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
Message-ID: <20221228151059.GA2565317@roeck-us.net>
References: <20221228144330.180012208@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
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

On Wed, Dec 28, 2022 at 03:25:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:29 +0000.
> Anything received after that time might be too late.
> 

Building arm:allmodconfig ... failed
Building arm64:allmodconfig ... failed
--------------
Error log:
drivers/mfd/qcom_rpm.c: In function 'qcom_rpm_remove':
drivers/mfd/qcom_rpm.c:680:26: error: unused variable 'rpm' [-Werror=unused-variable]
  680 |         struct qcom_rpm *rpm = dev_get_drvdata(&pdev->dev);

36579aca877a ("mfd: qcom_rpm: Fix an error handling path in qcom_rpm_probe()")
was applied without e48dee960462 ("mfd: qcom_rpm: Use
devm_of_platform_populate() to simplify code") which fixes the problem
without saying that it does.

The problem affects v5.15.y and v6.0.y as well.

Guenter
