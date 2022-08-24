Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D41859F835
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 12:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236189AbiHXKx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 06:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234115AbiHXKx5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 06:53:57 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B223D59B;
        Wed, 24 Aug 2022 03:53:56 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id y4so15339103plb.2;
        Wed, 24 Aug 2022 03:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=KgFV3e5vXq3+ij7enQ64VujlULz+GJAURwvCalzDnrA=;
        b=V2rNdPmXjcwmCJyqt9VuXc06BRVMsw3YBR9ps5RZtDEvTkSMIRoV9f0Y2P+ZlCs7zS
         d0WWyfFzvA35qWRUeUcnpe67ItPK6vaXkHKrV72kcvEEAQUyNghibi/kMcuwrJL7AHS7
         qrK5ht4/wT/ffDxQ0HVs5Z5UN3H3kKuaHr1HZeELaTI6w02H3sFi9v395kDEk/mYGNnX
         LIpgLBQu6nbYiWvLtf/EGuF1uLgX19uo/K0VSmGosEF03RoCDC+hf80R9MT9vFU3yHdA
         5Qe9gXg4XYtwCc/kIhEC2eHEBVKYBuf6wsAnOH7PH4yJfXZAKD5ezsX/uyYuU9Q7TwOT
         I61g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=KgFV3e5vXq3+ij7enQ64VujlULz+GJAURwvCalzDnrA=;
        b=DLk71+3DdnrkFF0uBoegcrEcFsILHQjin4kS6Ev4X09cfOTDj2Jm2HhPR4mCJetXep
         IPPHblRJ5vBQLF6BJM9pVr2j0XT0fFVHGLgLa18iAn6S/GzbDe/vUcy8wc/bWsnT6mPT
         x71KFXTPKjwQrdzVvYaIdm8ZwQBu+3akGwPuCOSdZHDSm+YaY0cSyGwvhpVrdCEmHtAK
         7nJgkFkCnnW/yd+KtcAhmrtOqm+GE1Jxm9bdYmOl49VAw8zw2Q/FNtEdCnnieUWI9u77
         dkOQistPogpDnuPNSdP2K/SXbuLFBOmagkaxHfEK/XTAaSaLdrz9cL6gH/7HrUpM9f9q
         SNhQ==
X-Gm-Message-State: ACgBeo0ZzKK8k/NJaNiX0T/e8Bw9ir1iQbmjrCiyRkWMLr/kNQE/FDFL
        Cgdqk4uxQRBOD+Olau5j/l8=
X-Google-Smtp-Source: AA6agR7CavhF7aRf+1jPxZJxKAbi/kcq3ys2LwVFgEk88xO6U4Tb7ktle04vpiGiq4WQtxDm0/3mQw==
X-Received: by 2002:a17:90b:1c0c:b0:1fb:6b2c:ca9f with SMTP id oc12-20020a17090b1c0c00b001fb6b2cca9fmr6572310pjb.90.1661338435829;
        Wed, 24 Aug 2022 03:53:55 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a82-20020a621a55000000b005367c28fd32sm7064209pfa.185.2022.08.24.03.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 03:53:54 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 24 Aug 2022 03:53:54 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/362] 5.19.4-rc2 review
Message-ID: <20220824105354.GB13261@roeck-us.net>
References: <20220824065936.861377531@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824065936.861377531@linuxfoundation.org>
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

On Wed, Aug 24, 2022 at 09:01:14AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.4 release.
> There are 362 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Aug 2022 06:58:34 +0000.
> Anything received after that time might be too late.
> 

Now I get this build error:

Building s390:allmodconfig ... failed
--------------
Error log:
In file included from include/linux/string.h:253,
                 from include/linux/bitmap.h:11,
                 from include/linux/cpumask.h:12,
                 from include/linux/smp.h:13,
                 from include/linux/lockdep.h:14,
                 from include/linux/spinlock.h:62,
                 from include/linux/mmzone.h:8,
                 from include/linux/gfp.h:6,
                 from include/linux/slab.h:15,
                 from kernel/fork.c:16:
In function 'fortify_memcpy_chk',
    inlined from 'copy_signal' at kernel/fork.c:1716:2:
include/linux/fortify-string.h:344:25: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
  344 |                         __write_overflow_field(p_size_field, size);

This is with gcc 11.3.0.

Builds are not complete, so there may be more failures.

Guenter
