Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7A76CF58B
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 23:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjC2Vrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 17:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC2Vrv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 17:47:51 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE8F4ED3;
        Wed, 29 Mar 2023 14:47:40 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id m16so888773ybk.0;
        Wed, 29 Mar 2023 14:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680126460;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x6b7CKS209zMdBnHZLVLNcY2yh2aKCBJcpnImw7wREA=;
        b=mSIAhN7r6i6Pj6ULQWJFhhCnun70kb9gj9b28YPMUFWFjWGYiQTu/NgVd87w4HzoRW
         hBJ3P+RcIQHliRw7bzO+JkytRkCg7MNbHxrjv7LEMn0vRzazN9OOR/NBBpjthleHDXnt
         pPrafHRYASGiLndJ4pDlQiawr2omphfuoJZuZofNiBQPvilumt7VmD3e+5qIyI4/OAqO
         BEzlnBf05oxQqSW4UOr/T/lTFdDETrk8NCZX2oQfbdwLpHeXSJYu9dXyDkpeCfSjWrex
         W+v4f+hKJluJZ+tyEoI4CbbOUkGXyPe563wQYoml1qm3M6pkcAUgAvAY+cUpsEhIVvDu
         b01Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680126460;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x6b7CKS209zMdBnHZLVLNcY2yh2aKCBJcpnImw7wREA=;
        b=1SZs/4Oi/BZn1p+CyLWj/h8+GgIbhbV3E58wJ82+jyoPDzShU59alWqYRXTOn3smlp
         oRdq8q8H+b+N65j9h7Dgf6kq2mvpEyUFBYM6FI88jzgZDlMktlpMhXGQl9wxsD5yTC3m
         Aju/3aKte2suhA0vvUORA5YlNFpgBZF4vITwiunITst8tdiMsuCfRzv6fs5tu9i+YjXj
         IylpCfouj8z4Jxn3CBBx8Xv50t5Cq5tICtGxJ4oro78MpDco1nvhqgiIPxu+Am5HLpx3
         Bl0qxv9xjbQiYQ1CtNyuo2l7VqS+tNUfccqLBWUQ3xK4QScUzS0vtAiDGjVwcbSNRtE8
         tfqg==
X-Gm-Message-State: AAQBX9dFdqzgFn9if0NHQkeVmGX/W34YlvyGIPZWhd3ysoogAMw1Kus/
        jPxJtNAin767kMEFnnhj69k=
X-Google-Smtp-Source: AKy350YN/zLVsUee9gX7Mk1DBoxF7uvlpor0UeqiZPvZV8sbKueE7xlvN6nBCQRF3tVJuowwep3Q1Q==
X-Received: by 2002:a25:1f87:0:b0:b73:bdc5:948f with SMTP id f129-20020a251f87000000b00b73bdc5948fmr18919680ybf.15.1680126460112;
        Wed, 29 Mar 2023 14:47:40 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 79-20020a250452000000b00b7767ca748asm3716520ybe.39.2023.03.29.14.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 14:47:39 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 29 Mar 2023 14:47:38 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/146] 5.15.105-rc1 review
Message-ID: <d8a7a58f-cb32-4bdf-b2f6-507be8ac09ab@roeck-us.net>
References: <20230328142602.660084725@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 28, 2023 at 04:41:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.105 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
