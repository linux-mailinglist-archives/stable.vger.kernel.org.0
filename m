Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9CF759EE4A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 23:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiHWViH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 17:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiHWViG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 17:38:06 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B838C80F4D;
        Tue, 23 Aug 2022 14:38:05 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id p185so203082pfb.13;
        Tue, 23 Aug 2022 14:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=suVFZUiH+3jPS7TxFttlvvIx/tSdJhHFOZyoNEZStBs=;
        b=IpgID6Q56dQ9xzFm+VkQaGxOI7+kNAdFg5/rGlg1HZH6UOqme6NOixn2Tk0jKLjrnr
         wi+cFRci+ToRKQWGS5jhzpfXntVWjBGQJ0sjyZEXYlxodG7tfgpRNDMuNBKkTZtlgbtP
         pFDjowUxm2wn27dBaYZBvUeQwM+3FfGUE5E8B4Z68KLrJLc8G6uqLZsJUmZWIEydRMK0
         UqpCf/3pAUd81jfBbOPVQdKelILf7wVjEqbgt6GZRUUho6RayIQtyRwDH5H8SYaSJYtc
         foJWVkm2X7EsyMAhMoGNSWQHworXAZJt72CS265IRAsDv42ivPlN/2JBKs7U3zzGlris
         xiXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=suVFZUiH+3jPS7TxFttlvvIx/tSdJhHFOZyoNEZStBs=;
        b=dVv46UnaBNom5mAS/ALEpSjRfousLPpp7wb2q0kfkcIkz/Gt5dIBbVGFEoyw8HtWYT
         08kCmsdYHLwf8YeeIgIS4A50Xr+XDk63GxSmUhdNCD4eJQBcE9tfE5LPMTDtJmFzAGFr
         khv2F1W70wzi4W72mvOCQzHoZRfFTgTqF+dwwV0XfphmThbaT6IGELzaCJlDSL7Qrimk
         AX/5xSHsBrZEnywu77UoITBIgCH7JrEYDIYe0TCCQLd8DkdvJTlo1RIqVgnrTkVa8JJd
         tPhJgxY51XZCYEpusXWuCvs/aHDy/oUZLfb8CJW44lBEFVzMCQ9ntl2ljjrMOA9E+ton
         MD7Q==
X-Gm-Message-State: ACgBeo1jyzhn05w+ft0HqXn2iQ3huxUW8yyWgB+SOt3kFOubMrnLppcO
        mVqglmgx8rECwadQZr6Avy0=
X-Google-Smtp-Source: AA6agR4XbLuiEWAoG3mwSUn2b47KbLdv+9WetxY4EF4al0r89Bk/bx66tBpPf+nQXpKehI/c5WwldQ==
X-Received: by 2002:a63:5f92:0:b0:41d:f447:76f1 with SMTP id t140-20020a635f92000000b0041df44776f1mr22156959pgb.456.1661290685149;
        Tue, 23 Aug 2022 14:38:05 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r143-20020a632b95000000b0040d1eb90d67sm9619746pgr.93.2022.08.23.14.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 14:38:04 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 23 Aug 2022 14:38:03 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/159] 5.10.138-rc2 review
Message-ID: <20220823213803.GD2439282@roeck-us.net>
References: <20220823083146.854628728@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823083146.854628728@linuxfoundation.org>
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

On Tue, Aug 23, 2022 at 10:32:19AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.138 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Aug 2022 08:31:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 162 fail: 1
Failed builds:
	um:defconfig
Qemu test results:
	total: 474 pass: 474 fail: 0

Building um:defconfig ... failed
--------------
Error log:
arch/um/kernel/um_arch.c:370:6: error: redefinition of 'apply_returns'

Guenter
