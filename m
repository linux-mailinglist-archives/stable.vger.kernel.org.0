Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAB1616F12
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 21:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiKBUrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 16:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiKBUrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 16:47:01 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8C565C7;
        Wed,  2 Nov 2022 13:47:00 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id b124so7957653oia.4;
        Wed, 02 Nov 2022 13:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WKmJ5JoLpFYgfLKKODG9Gk/9YmXzCQzISYWongoE+Tg=;
        b=GR9qGaj/MLz0QuQRws0IUsP3GFTSmuKM7NEQtpDjwanNTgaaW/zgS8MET60K+q6w8y
         BgMh7YnLqG1ZQy7DT27g2itFX2dvZ1nnCis44LgM7RQtav041lPEFV7QtLWAlh0BnxGr
         hws1NA6q6WKvqWOIpnvCCESlED18WgTURnPLouERAVcV6suu1USw140amxq/OroauquZ
         Ff5GXL71bmCQoHjcGMEumJjcAyYzdlT36kDCEQhdgAMb85m9dBiDmFmanLn6/3WswUlH
         gGI+0TxwtbXXdDuWyBWeBUD3VsCOPnBo680Dlp5QqFAXar+ay/BgJMDk9qqJDFmbIgf9
         Ji4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WKmJ5JoLpFYgfLKKODG9Gk/9YmXzCQzISYWongoE+Tg=;
        b=hjHK56XW0KCCjY7o3pDO/lEtrYn4giLi/3qfSHByUhDHAC16nmvTC251uQDGAkE9YU
         EyqKmUlDFqBwGE7XLBKn1oOK+6JnuFIvcUYM9rgJn3x91o/BK90kY2YMDC1S/jRTZKYV
         rqhcZpzQC0re7bIVrCTQDRN0H50+RZlW2YjbocchilgW5qWoQTrpbpgG9D271JcqcugL
         XZ6sydrjTGlQJRVAKg0V0EkGnJSgNE03BU3jzodgFR5IoDos44KOywqTa7+2Oj0AUcN8
         riIW91X/0LLzqhDjrXXebrtugdn8mWPP5OaXznltyalxtnKjy66cgjhDidqGlUY/hs9F
         FtgQ==
X-Gm-Message-State: ACrzQf0BJpLvZPVzYuIwOKJqInn8B/B3P1K85zV4PSt8kBWhxbTPJtje
        r1byUbwGWiqVtKetP0wEOAw=
X-Google-Smtp-Source: AMsMyM6aabmxrj8ZX75MzJo1eGe0aehlB8J6xM9nm1A/XSvH8losngnBLyELYGUL2ixfYHMvcivWLQ==
X-Received: by 2002:a05:6808:16ac:b0:353:b7d7:5fef with SMTP id bb44-20020a05680816ac00b00353b7d75fefmr14901190oib.293.1667422019788;
        Wed, 02 Nov 2022 13:46:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b11-20020a056870390b00b0013cd709659dsm5576705oap.52.2022.11.02.13.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 13:46:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 2 Nov 2022 13:46:58 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.10 00/91] 5.10.153-rc1 review
Message-ID: <20221102204658.GF2089083@roeck-us.net>
References: <20221102022055.039689234@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 02, 2022 at 03:32:43AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.153 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
