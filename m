Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B6653D82B
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 20:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239605AbiFDSxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 14:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237694AbiFDSxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 14:53:37 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBD043AEB;
        Sat,  4 Jun 2022 11:53:35 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id h188so14532119oia.2;
        Sat, 04 Jun 2022 11:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=608aEyNhxcKaLk1HnCXfwe3spH7omzGe+fl2Besa/uc=;
        b=jIJ2/FJHTteZmJ9hBTmGO0i02icmOunQYrQhCmMoh8Fz/LoVNaTgO73HFe8YRD7ygA
         AHXIsNdPeuYHam9VnvHNtwQIl0xw4WPfV82oGs/8l5Y/4tNOKWwyL4F4XQl6dPkG2OC0
         fDBIt8k2qdGefyiQG0VNytDM4QURt3ENGZfj9Ysl9YZUihBaMftWyC9kcwfVUmNtaeok
         pslomee3egw1U5oeIMQTWT6eHbYJ01GzPD5G0GOaCjmkZCIgmanRDeXusUIvp2pM50uM
         szKHVtyzPsNjpPF18pbNzlef1hTzmjhGxM91+lrIZoNlqLSmtLTmnszCBKqtvYpR+7QU
         CMBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=608aEyNhxcKaLk1HnCXfwe3spH7omzGe+fl2Besa/uc=;
        b=1OMS8XyJC9dSDWyCZtrPgiM5JFT4+cTLZIS8jxVyao0URZoMeD5z9ZEtaIEsFxdOSc
         wmxYJu5AgSngQG2wk+Zy0H/9lpS0w8CHSOvLWZliMylkXxqdpteN4lO+827xo0feyQH8
         t96sKuhYkSzaVcucbRQPJDGuGpol0Er/KiWJ2PoN/FM+sw5nQ+cEu01ODfuGYkc7Ow7E
         tRzwzlOt0gT+ujJKuXFXG5oiEq8TRdzAec5Vm04+yhU9WaEclUTXY2KDXK1IeXqpUNC0
         /RKyBElrIfdDoiLHGA+C2vv29z0dfuiX5pOS6E6BU+VF+fIqVk8n0t9iSufZn9axs4q8
         wBdA==
X-Gm-Message-State: AOAM532xhHUZfXlyLYD4AOo0I9fHz850OXsBBCXLhsJFSK/cPlhB/JCG
        lH3e18L7FhjE1b4y+cwOHaI=
X-Google-Smtp-Source: ABdhPJxmyot/HfoxHR76pOkAoMy/Lgia6Kz6hnDANQmpKvwFW4h5pkS5XwVzDNYumD/6ztJ0tVZ5mw==
X-Received: by 2002:a05:6808:1914:b0:32b:3398:138c with SMTP id bf20-20020a056808191400b0032b3398138cmr9467324oib.146.1654368814847;
        Sat, 04 Jun 2022 11:53:34 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 68-20020a9d064a000000b0060603221276sm5426700otn.70.2022.06.04.11.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 11:53:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 4 Jun 2022 11:53:32 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/12] 4.9.317-rc1 review
Message-ID: <20220604185332.GA3955081@roeck-us.net>
References: <20220603173812.524184588@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603173812.524184588@linuxfoundation.org>
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

On Fri, Jun 03, 2022 at 07:39:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.317 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
