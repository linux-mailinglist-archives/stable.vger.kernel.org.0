Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A2A6E000E
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 22:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjDLUmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 16:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjDLUmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 16:42:23 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10F655A6;
        Wed, 12 Apr 2023 13:42:21 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id c3so13869731pjg.1;
        Wed, 12 Apr 2023 13:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681332141; x=1683924141;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hrGdj/3WbwRLbkahszebFkZlQTjkcJtsMISJZ10lO4w=;
        b=cI1zi8A14YQhBRaOoL4hsaR2csmTkaOcqorFKK2MiPllgQu5VIwM69VCTz+NxEh/Mv
         +yYVs1mbA/CVhfsqs5bKoeC6Ma5tJJBZ+j4bXXPdeELSgfKWZKNoslgV5B1IUhHkZlGy
         R2zLUsNtELIsKxDDsObALptH+ZsPEitP5XkTpgZ0jJVfviAl8BYGjat+JBYZjjOLEHwR
         LDcCY/JW2vGAgjUprFZTEbALE3QqteuBZN7oNqzx8D7A99R3Cz2St1upI283weaGpfPb
         8wV978F5BEPSmOm+MZMz1jufd+9rIvogCPte9yG5wxws2AayY4QaO7bdllLwKbMGMnfj
         QtLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681332141; x=1683924141;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hrGdj/3WbwRLbkahszebFkZlQTjkcJtsMISJZ10lO4w=;
        b=LSPG8w1tti0034w5tGLTdz2ulno3VmE1OJons4bEslx3glX5derMXt5BqhU/6+72zj
         UuQi/piZMIGBVYO7GSBiNezFoUcec90iv6wWb160YnezPuFIcAEq8KKQy4ecmNJw1T1b
         G0BH4rSNTyl8p++uE58VAjAxKlIUW4RimAn7MVMnPR3JMhvNptnH0rnSl77mifZaQw7m
         8hlITvZ0QH0wFflhATTXaQ8O7IZRhDB++eyZDfCkIQ7jz/d220E3qVGzJlOkHusJke95
         HayrAaAYQkcZD1IBkz+J+I+U5ePCTfKf0jDePRa7oEboMbmRdV8sXhXVZcbP29rsh0qu
         hxCg==
X-Gm-Message-State: AAQBX9dME6I+13hNjWLfoJHmhc1J7b6nWWxf6RAMRtplGW38+2rBqK8J
        bW75tb9IEtsSZBb1P3t36mA=
X-Google-Smtp-Source: AKy350ZKPSULNZM3xD2rdhPgTNbPI3QhcErrtJTRgC9ofaaVn1+XtfOUou156nrG0Vkr5ZDiyEHbOA==
X-Received: by 2002:a17:902:d709:b0:1a1:b174:836c with SMTP id w9-20020a170902d70900b001a1b174836cmr151120ply.16.1681332141012;
        Wed, 12 Apr 2023 13:42:21 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p19-20020a170902a41300b0019a87ede846sm11941622plq.285.2023.04.12.13.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 13:42:20 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 12 Apr 2023 13:42:19 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/173] 6.2.11-rc1 review
Message-ID: <f04fab6f-3381-46e1-a9f6-f0d9fbf84f63@roeck-us.net>
References: <20230412082838.125271466@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
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

On Wed, Apr 12, 2023 at 10:32:06AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.11 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
