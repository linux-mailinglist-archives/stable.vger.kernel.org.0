Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6E755A4E8
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 01:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbiFXXgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 19:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbiFXXgX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 19:36:23 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81278AC0B;
        Fri, 24 Jun 2022 16:36:22 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id s185so3746074pgs.3;
        Fri, 24 Jun 2022 16:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b2S97eVYRroNOAB/R8EB/GHToGVW4moMWDJX2lWrYd4=;
        b=Yqp3035S3nr3UIHBvvfPb10O/BdLFargiPIcFrLgw0AkWXs8FlaUzOKIXBOSZC93Xo
         ymdLJdPlJBSLxy1GLZo9GYPFPqtE6aaPEdD5vnVm1cyRi+RbwN7nW4LlP53kZOtNfP4c
         iP1uIEYO/0Z/ezlK3typ0TgSWxS9IGBrBXyrSohl/tpKv/QlrTihn9iEx8+sAHw1NMPz
         m5mqRbQFk0rXCx1uzBE4Cc0JpCetnTvW0S4C/wesuZfqPYGPZ0Za31xoceclaW2gDwLI
         5K4/YE4MTFmlQIU1R9vIHp2FXMYvkTeP2cEQr+Zj9SsvExn300L/YHCuIYDUinQLPESl
         B77g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=b2S97eVYRroNOAB/R8EB/GHToGVW4moMWDJX2lWrYd4=;
        b=N3fLpk+L/0pDlKBPy/rKxSzrqa+7Nqem3yapA15RMLTwtTqox7ICPkNfSd3MUQqttg
         lvr8I95FG3bJT0OXVHJoRPX5RUTew1Np9QdDLVQJH3NEO4gTvZWbh9Nik0zZ0OglCGLF
         lWFl4kWUJtqrAqPavT4iagbAId3zY20ePmlabdeYWgueY70y9Hq8PC+4BCpnkXRlnriv
         a5F+A4xoqTu/dl5oxlEJbORfrceEVmy5YaYhgaxbeRhkDfFtduj3xtnOdnwh4ZbyFG8W
         r0cMI9YIemfJELjOk4SgrrJ3833PkkdLDxd+G+ujL7w8xfgcR/vAnS/wRayzYhuouVA9
         GX1g==
X-Gm-Message-State: AJIora/6N3qhJJp3AbWj0YzHVq5BDD7qJCNJQI0TBzYP4BKtPlABt6Az
        nC/nBGGQSyXPA2p5hUli2aGYpIzC4kc=
X-Google-Smtp-Source: AGRyM1v650ydJuG1KuEA4zVg9OFq5GUXbPY687Rdsl3S39NVSIOo+UJpQWAM0KePnewZ36+oOxiFMg==
X-Received: by 2002:a05:6a00:4211:b0:51c:45e:532b with SMTP id cd17-20020a056a00421100b0051c045e532bmr1673650pfb.10.1656113782257;
        Fri, 24 Jun 2022 16:36:22 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o17-20020a170902779100b0015e8d4eb218sm2354560pll.98.2022.06.24.16.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 16:36:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 24 Jun 2022 16:36:20 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/11] 5.18.7-rc1 review
Message-ID: <20220624233620.GG3341529@roeck-us.net>
References: <20220623164322.315085512@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623164322.315085512@linuxfoundation.org>
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

On Thu, Jun 23, 2022 at 06:45:12PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.7 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
