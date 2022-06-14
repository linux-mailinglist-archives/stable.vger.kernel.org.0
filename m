Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D4754AA84
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 09:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354086AbiFNHX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 03:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354644AbiFNHXh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 03:23:37 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B1A3CA56;
        Tue, 14 Jun 2022 00:23:34 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id o17so7070263pla.6;
        Tue, 14 Jun 2022 00:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uXSamoUp6MeZ/46qZXQdg656MMVfUNs/18XCR1U3fiw=;
        b=EKQjsmVZozA/XvJq1p2xbZEJN0A0H5Q7RkhuSZl0UuYnPOidEvO4nk+Bdudkwz3DnL
         YDM8qbjd0TCrqYKlVeQvodxgeXHXsW4fdnxss1pIPgvh538ECSxHcEpcesRZdVeYwvie
         5hgjrPWHRBoOtok+VY2Bu4X3LXpAA27/oRuhi3tpZMUGMrbwX2Elcal3h7X9iJCDWmuz
         Kwafy9hK5BLoYhE1C8AcNgeUiGlccVIUFG8cXxgKWVOOpAq0DjkD3kp4FJ5WxWkQyuY4
         JTmLikgP7zx7JNUPo+xYvx/jf6UJSFba2KEHNMhzz6ySe+PiY+ij/3PEAve3BqLrjePy
         AYAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uXSamoUp6MeZ/46qZXQdg656MMVfUNs/18XCR1U3fiw=;
        b=CL2atQWPHlV6C4V+FCXC1HNKRhvycm5qm+BkrZxd/qgKxTtFBSTcXho1Iz8b7foAqF
         wlrI8lGvH5+nNOmFr75wSQaeHv5DkcfLqGlcXfpPCGubIld+O0JBSVmf/x1ofCZnsZJ0
         jzD4HL2mRoOPIE6BWjEwbzOq8IZBzkYMkukbnqIBsUTFoFJz5I7pkR6seGPIM/aarN2Z
         Wt0iwN2yFkuAQk9d2lSkGrAstBk+DG7Bs4futFTJpBBEG3cUN2S8IkQVu9Q4Ct58csw6
         NFTYY5//lxhneNABKut0Bqwb2N/D7bDVsTosNl7gjcpelbBzYoclhiFLAuh7tiHglen5
         Qq/w==
X-Gm-Message-State: AJIora+P3W5mkMG8uBRwlS5wE/XRi1ugOKx+F5t/OMNSWVUpiqj9A5HL
        wRuYAjaF7BbvT5LxIoiXxb4=
X-Google-Smtp-Source: AGRyM1t4U0AtFhCET949Kol0aCHYqnQE/e0mHhbltZ+mlhDE+zKbIpvtwtedoqZ5IQS7PUZPtucmTQ==
X-Received: by 2002:a17:902:76c1:b0:167:6ef7:dab4 with SMTP id j1-20020a17090276c100b001676ef7dab4mr3240028plt.146.1655191413875;
        Tue, 14 Jun 2022 00:23:33 -0700 (PDT)
Received: from localhost (subs32-116-206-28-37.three.co.id. [116.206.28.37])
        by smtp.gmail.com with ESMTPSA id ja21-20020a170902efd500b0016632179ecfsm6365167plb.264.2022.06.14.00.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 00:23:33 -0700 (PDT)
Date:   Tue, 14 Jun 2022 14:23:30 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/339] 5.18.4-rc1 review
Message-ID: <Yqg3cnnE70gS6cI2@debian.me>
References: <20220613094926.497929857@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 13, 2022 at 12:07:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.4 release.
> There are 339 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm (multi_v7_defconfig, GCC 12.1.0,
ARMv7 with neon FPU) and arm64 (bcm2711_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
