Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3143D6D6ED5
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 23:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236381AbjDDVVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 17:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236176AbjDDVVh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 17:21:37 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D664691;
        Tue,  4 Apr 2023 14:21:37 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id l18so25249856oic.13;
        Tue, 04 Apr 2023 14:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680643296;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eP4BMC4T665hzA4eSCHbf5yPiTELBpn2jLQP8DfWLC8=;
        b=NEXI+BkZt1Tr8a03bk8Ot+WCl7yXj/vTyyUBb6J1JgCyXeJHaoC2E7BnKg4Q7PC89B
         mFEI255oufVGX6b40Td3e3aD2CNjJYNJAtlnQ+dThakqfhx888WXdf7n+UOi9MYzZLvu
         qfC0wd4y5kPdP5ASo526H2KqfKbVmxi+r4QfEd9kHaI9J2imQSuRMjYPwJi4n35avi+g
         Rf/l/l0WXp2/1QNyRcEzW9wm9u5XuCIFcgaJmI6tcuLrqHQwC9XhsjI15OZJDqJyLPA2
         8uEZgbSYaHrSZzRCjWYRswMQT7CcQqkqP0Tb3g9bdg+4ltUk8oBDshwlhBq5VHdigIKo
         GaiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680643296;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eP4BMC4T665hzA4eSCHbf5yPiTELBpn2jLQP8DfWLC8=;
        b=lB9ZIS92X5I4fssLped7Obd9aITwmMi8b5GaAG+bVgYWFMc9CaBcIopI8ftEeul+Xz
         81ythVjuI5x03pKdCWhPcrf7DMULDPon2BsfKwminhQFrTXJ3IMIDRnHURG3bFkdkN1/
         NBG1h2or/ggS30tZAI1+zfkhqJmK0SVAE+KHgx7B0L+gQ0cnqTr11FpAWklMBFhB7Jrt
         cuttI0laD66aY1YscNqFvehmCL3Y+r1gogmdbdrE3S6o8Nv2+XScgRUiL9XzOuWYhgsG
         P1b4ZXX7RSvHb06aETQ/2QX4CjjKdBxD83GWc0DLSp5VfJtBdyoT/aS7MxU/2o5772zS
         i1/w==
X-Gm-Message-State: AAQBX9fT3M17p5WawDyFE4xKMCzwn+jYO54K+U5a5aU4dDl2xmeUYQMp
        M1YIvPK2ECYpGlkum8rT2eg=
X-Google-Smtp-Source: AKy350YpM7yruTDmEqu/zN2TFlzy9hOmTlj7NaWwK1DzcszbxolbvQq6UmpH71fCNDN/Mf6CTNcW+w==
X-Received: by 2002:a05:6808:14c4:b0:386:e851:71fd with SMTP id f4-20020a05680814c400b00386e85171fdmr1758177oiw.42.1680643296488;
        Tue, 04 Apr 2023 14:21:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k125-20020acaba83000000b003876369bd0asm5625629oif.19.2023.04.04.14.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 14:21:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 4 Apr 2023 14:21:35 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/99] 5.15.106-rc1 review
Message-ID: <e92bc7e9-86b8-4838-9149-196acf6ed599@roeck-us.net>
References: <20230403140356.079638751@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 03, 2023 at 04:08:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.106 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
