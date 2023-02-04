Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B7C68A7AB
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 02:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbjBDBu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 20:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbjBDBu4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 20:50:56 -0500
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D47D19F0A;
        Fri,  3 Feb 2023 17:50:55 -0800 (PST)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-15f97c478a8so8729471fac.13;
        Fri, 03 Feb 2023 17:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kgDBzDEdhA9Rukgr923OpczSXtScR2mYWzeNG7Bc+uw=;
        b=BkRkwrOqwzC8ibdWyI5Omrdj5RxqQfQoak+TvfBKEhAbI8Kb9ToMA9qqWo27A5gh02
         TZWUeePjQ4slyUACLuSM4c0JhyMyuya0bqqtt4a5uXBK+v5uN+VRQD9mVX7F6j/44IZ6
         VqU1ApzWUV2yjJBbi+7KOGZ0zUefboG6mgDnLuiZbH1GrsR92OOnlG8A5dezZHR6qV32
         OuGMtAE3vX0VPmZyrC40XIyNwNU9loW64qWA0p36QUOk70B2j5btn4g0xUbzILlolz5C
         S9CygSJC15ntvCnRm1iOJTVzj7y7UPoJADjI0+K0Mr3qwzDKawNwogjFietn5EXtqUOP
         mx1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kgDBzDEdhA9Rukgr923OpczSXtScR2mYWzeNG7Bc+uw=;
        b=qsLoT701hvRO9vbfFOoKzvJrIGhRhkO9QWlH/7NhooM44u+UFq28O4aWdI+bbZiX9/
         CD55UywRHbShcaJUOZoK1ZLuWPVDSpyfcf+dH30dpmJrO8g7znmqb0GbCYRfg/xjJ5k9
         wwPVG6fHlXbLB4O4zKqh1gsGFjUBN+Lc/pwxWi/o47dYHjhK4Ur9iGFgz3KhOxn1y3cr
         I07t41pK2SiFsu8vtvRTobo/aB3khjjPLTZJBSJLMlgoK41hWcb4jYCjm/CtF7spwQUl
         DhOmpe1eWhd19ld21UZ9rgqtJw4S4iUisTUUfkm9uqeeODvQq4leMdaJ6GMzVIGEfb8S
         Rq4w==
X-Gm-Message-State: AO0yUKVuVsyPxYJoIEd9x+la8x/vsuYvdf8ai7K4XPulg0h/yLtkNk4X
        uHNlYB5wO++Kbgf15/FXJ30=
X-Google-Smtp-Source: AK7set87pblL4yU2ujeIWb5utCQl0NqR2vIEES3GW+8DxwfRymMhGyv+Rmht07aXwjqRiT8VreRLyQ==
X-Received: by 2002:a05:6870:c89b:b0:163:7812:a0e6 with SMTP id er27-20020a056870c89b00b001637812a0e6mr5959559oab.57.1675475454123;
        Fri, 03 Feb 2023 17:50:54 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w1-20020a4aa981000000b0051763fef75fsm1594736oom.37.2023.02.03.17.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 17:50:53 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 3 Feb 2023 17:50:52 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/20] 5.15.92-rc1 review
Message-ID: <20230204015052.GE3089769@roeck-us.net>
References: <20230203101007.985835823@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203101007.985835823@linuxfoundation.org>
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

On Fri, Feb 03, 2023 at 11:13:27AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.92 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 492 pass: 492 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
