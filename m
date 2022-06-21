Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024E35529C9
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 05:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242106AbiFUD32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 23:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236585AbiFUD31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 23:29:27 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E83C0D;
        Mon, 20 Jun 2022 20:29:24 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 73-20020a17090a0fcf00b001eaee69f600so12039773pjz.1;
        Mon, 20 Jun 2022 20:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=01kfdT8VhX9fZeOdUph2r75J3bo1wqhueoWm263xMZw=;
        b=edxKPW7HtIaWtqawvjHKcyfU+Jki5bjcA8RSYkfHEogh7RfpdBOdR8gsPW8AKArYfG
         pH0GOfMrYO1P75nhR2n2zi3qwSSvbN9CuLJtMrQHaD+bd61s2fI+w3tUN5bI7qbULBta
         7gsdBDeQLYqZbR/kIU0Y0K91dn936tGiyu2XaTOpiXtDk8rljTaWaANWFgI23lNkMDKt
         quDGi+c4vDdTYN1UsX87Z47gvEGIQ6j/VmXv9HuRFy/M9k4JzxiirscjfxQixE+rSEiC
         s5xBdVI/HDBdW2n3FjmxKGcD/jsEKh8FZJAWWqDdPpTNksIliLgJh6SsbuBDgYMYvJsp
         Vc3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=01kfdT8VhX9fZeOdUph2r75J3bo1wqhueoWm263xMZw=;
        b=e5IO4N9cgDZUK8FYHWeT6KQ+8VGeIhbsSaUPpf6/HF72UqVcnlSWp+cn4gaR/kbdgq
         /btck4FXbzqnlAVh3mwBsX5iP3NFoJesm66c/VzyaJmtcg7CW9taBFNRnJcI6+17Y8I4
         n8bCI7EtkQJBRRN3LxnM2V2DDzRXaaMFEE8p+utDMWM+fgoM+LFUsL31ZSyumXywnRWQ
         wSmPEIJwdthxtJA1zIuFk/PcWDSVPj0SujlrzQaM6NkWc04aC+TfrpdRBXR3Y/3B4jVs
         3x7nXuOldrevc0fNM+dPJt4lYSGPGEsQ2JK7ogdO+UefQKzpcGmpQhRotgNc9DQONsWa
         9ZUw==
X-Gm-Message-State: AJIora+M/N7lT56voef2h/lj5ib5mEWlJiAXfL48h1uOgaAvYbEGk6xS
        29MF+nMWHObLTfOaqMOpd+8=
X-Google-Smtp-Source: AGRyM1sTe2jFdFfQeCq32PiysHcb8FbKPawNpenySXf1cLBds2xEv8Ovx5nBev0zhZgEaSSBRuVpTg==
X-Received: by 2002:a17:90b:1a86:b0:1e8:2b80:5e07 with SMTP id ng6-20020a17090b1a8600b001e82b805e07mr30518286pjb.31.1655782163726;
        Mon, 20 Jun 2022 20:29:23 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-25.three.co.id. [180.214.232.25])
        by smtp.gmail.com with ESMTPSA id jh21-20020a170903329500b0016a109c7606sm5480275plb.259.2022.06.20.20.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 20:29:22 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id F00C3103829; Tue, 21 Jun 2022 10:29:18 +0700 (WIB)
Date:   Tue, 21 Jun 2022 10:29:18 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/106] 5.15.49-rc1 review
Message-ID: <YrE7DvlRvHxzCWT5@debian.me>
References: <20220620124724.380838401@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 20, 2022 at 02:50:19PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.49 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm (multi_v7_defconfig, GCC 12.1.0,
armv7 with neon FPU) and arm64 (bcm2711_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
