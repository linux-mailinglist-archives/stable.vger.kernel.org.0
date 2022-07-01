Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B41C15629DA
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 05:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbiGADvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 23:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbiGADvw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 23:51:52 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF7865D74;
        Thu, 30 Jun 2022 20:51:51 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d5so1167929plo.12;
        Thu, 30 Jun 2022 20:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kbHNoy/D3cNiXfyNj8YldC8JHJVzaByF82iFcVVNbwc=;
        b=GLcr3gfP8Qcbse+eIjfHA5BEjjuWwZ2xMNlfYk0SPDVfb0To+K0o2n8aHCrTc/r9mM
         SAqwhvvJNa1pLN21Et9RIWM5uzuvjoF+DOnILDmk25/UzO14c0vmbzJXRGXNw2vRfYuh
         A9qFU/ztCY680GxLVbFVsHDRW6qb6WJKlbxiCeZTBVuu1g1HzycpvbOo8C+1n9mhG2Uq
         SbNvCxEoTEIVhEEiGH1QUL3oNKLlYUpUAJxFHEnPpK96qXPDhOIeFjep7K35IrnegA+7
         UJjFT7Zjm+OrcQmbgfPX1VqCeceT5WAvh1MtSsF1BLrt/NEFI9SJDev8yLhiYtbahCGH
         X/nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kbHNoy/D3cNiXfyNj8YldC8JHJVzaByF82iFcVVNbwc=;
        b=7NKAzTWqwJzQnUETbXoPJjQJYETbM2Af8eI1Kznte23QwW5MqAk58XOBtJ0YiZRE9+
         +t4/ftaO8R7t318LeJ9c0585ze7gdO0kLHKcM8yN8OOm9taBkiNDdjTDAlrFpEB2lRFu
         +IDCuBdQFVEP91gsiGTlrTd96YguujX5PbhANKV6n9OklD2l1Qp8YZ62tMbE2DYMvZ8E
         l+pi/XTtTMDkBa3GVcMi4FXYxod7kzjfkGDxW59BvrkVMf41eRrGQaBMYupQoNWiI9RN
         e/Ru8DB4QZjzxIlVzD8LvqWNjWroMOe0snb1jOtJ4AFflBhR8IDRM0FyFYPTTa4eUNRu
         Hi7w==
X-Gm-Message-State: AJIora8la+RmYTmnNxSXYxtjyfjxjI4ei5Q9spsXa+PkRuYkFwD8wUv/
        DjBQo5CfA8SAUYnk5Ss0VDA=
X-Google-Smtp-Source: AGRyM1vby6V9va2wYN3IhEcFFyfeIozhUXpiwFJiqDBM5YerqCL10fUuAGkozbnIrksOg/jQXafXlw==
X-Received: by 2002:a17:902:aa4b:b0:164:11ad:af0f with SMTP id c11-20020a170902aa4b00b0016411adaf0fmr19017670plr.54.1656647511480;
        Thu, 30 Jun 2022 20:51:51 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-70.three.co.id. [180.214.233.70])
        by smtp.gmail.com with ESMTPSA id cq13-20020a17090af98d00b001eeeb40092fsm5338799pjb.21.2022.06.30.20.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 20:51:50 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 05178102D1B; Fri,  1 Jul 2022 10:51:46 +0700 (WIB)
Date:   Fri, 1 Jul 2022 10:51:46 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 5.15 00/28] 5.15.52-rc1 review
Message-ID: <Yr5vUlg+8cr3MTIQ@debian.me>
References: <20220630133232.926711493@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220630133232.926711493@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 30, 2022 at 03:46:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.52 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 12.1.0)
and powerpc (ps3_defconfig, GCC 12.1.0).

I get two warnings on powerpc build (vdso related):

  VDSO32L arch/powerpc/kernel/vdso32/vdso32.so.dbg
<prefix>/lib/gcc/powerpc64-unknown-linux-gnu/12.1.0/../../../../powerpc64-unknown-linux-gnu/bin/ld: warning: cannot find entry symbol nable-trivial-auto-var-init-zero-knowing-it-will-be-removed-from-clang; not setting start address
  VDSO64L arch/powerpc/kernel/vdso64/vdso64.so.dbg
<prefix>/lib/gcc/powerpc64-unknown-linux-gnu/12.1.0/../../../../powerpc64-unknown-linux-gnu/bin/ld: warning: cannot find entry symbol nable-trivial-auto-var-init-zero-knowing-it-will-be-removed-from-clang; not setting start address

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
