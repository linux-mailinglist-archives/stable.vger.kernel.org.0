Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C9955DA11
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240748AbiF0Vo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 17:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238580AbiF0VoZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 17:44:25 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4470C4A
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 14:44:23 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id m14-20020a17090a668e00b001ee6ece8368so4542976pjj.3
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 14:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2DM7O+xeJYoNrNXSTSzJHmAYrPinlDaSA++1ejz3ymc=;
        b=F0YFq63p5i7NOuMN/IasvD8XOPzYJWBWKgQD0KZsqA7hfLt3woM6a1j57oEmR5stEt
         8YxScgF6Bl1U8snTuYEpupD24OX77NttFzS8u9OYtNXZ37I+uFLpwW0MEonnQNlXCjA+
         mzOQLIyfYF108r5GDlMilhA9ke1TRnqMzRS7w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2DM7O+xeJYoNrNXSTSzJHmAYrPinlDaSA++1ejz3ymc=;
        b=6S5Wl/E5aHRuIv7GQugXijOfJ6kE0sk7bvjjxEQWWuJaHpntnogqeYfFs+hF5ugoQZ
         ZzbT8LaKWpad5mOjXkA4619Z/lOPhXmByJsRUFHM89yvkn861wPr+5il3I7dkaaQVd0H
         HA/RbwUyzzdTjIdreCGEtgliOdqUD8uRxCmtF6vGUSDfi/i8fxqF3SAU4NkcGYlM2o4S
         13TUdyy4Mz1MNz8dgSpnZXQTfGMmpS8fdcGkeGOY5PjlDw4paPQhfRS0AJDhdb2f7+YI
         XMrxW2NG+gOCsxQwKNIcRTwKBmuQE48I9iHspc0TmT/FP0pz0ookzRjiGETeGqlipPD4
         2KXA==
X-Gm-Message-State: AJIora8ERwm+LaBNAPnIxtMsyNGASFI92xBFPLC2ZjZtsBYiPDmButNH
        ejvzOxrcRzQlsFMjUlChaF9a+Q==
X-Google-Smtp-Source: AGRyM1shwHswGVWhkjtx56cLBZ+RvsKlBRm1kWfZ8Avt5R2j/EcZ5F4FsYvL4b13OTLcXKN2vNAMsw==
X-Received: by 2002:a17:90b:46ca:b0:1ec:9a27:f706 with SMTP id jx10-20020a17090b46ca00b001ec9a27f706mr18709602pjb.12.1656366263326;
        Mon, 27 Jun 2022 14:44:23 -0700 (PDT)
Received: from fff6dc920c55 ([203.220.223.63])
        by smtp.gmail.com with ESMTPSA id x15-20020a170902a38f00b0016b8b5b0aa0sm574323pla.86.2022.06.27.14.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 14:44:22 -0700 (PDT)
Date:   Mon, 27 Jun 2022 21:44:14 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/181] 5.18.8-rc1 review
Message-ID: <20220627214414.GA8@fff6dc920c55>
References: <20220627111944.553492442@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 01:19:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.8 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.18.8-rc1 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Tiger Lake x86_64 (nuc11 i7-1165G7)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
