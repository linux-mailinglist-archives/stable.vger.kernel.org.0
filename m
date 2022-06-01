Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1E5539E30
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 09:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348774AbiFAH1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 03:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344886AbiFAH1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 03:27:47 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6995E174;
        Wed,  1 Jun 2022 00:27:46 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c196so1201764pfb.1;
        Wed, 01 Jun 2022 00:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eMeA/fqvYZU6vrSiCnNJA0sstC2+T/rmbcmFof3BR34=;
        b=Ve/MDQjVQ36HEHc3RKBr36SX9I68T1b4706XRvOHxHRgDsEzn3JOnjpOjtHXaFBlaE
         5sKBR5xf0pwoFavEKOjpPGC+XjnBihHNbZG+Shi+XCMgIzx6OXcZAAqI9y/pFOAv6OJk
         TYwI4uyqOG/3HWq0jJQ3LeYVHTfwsp/ylK+2Fvn9+AQTOFCCVboUB2IldBbynyw5F+68
         1Lkz3GjBIqDCp2v04ZbG9Eh5biTPgCosHS2Kv3LvfXxCabp2AxUB60JM3j6HTz4UhJpd
         B9Tq8YCUVg0SaKQI9UeErLNPGiL7bjX8DaO9Yp5sDidUQ+RsNOytfGbCqOD90Zi8gCk+
         /ovg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eMeA/fqvYZU6vrSiCnNJA0sstC2+T/rmbcmFof3BR34=;
        b=HYrEk30N/RNCZERlsTzh4oWloZH5ykH8XWqyRUUjInDZD4fZQBkEl1TMdS+KRS167k
         mw9QNvW3QSxVMqie6OOPZZ9y9/g9Z0dqy+CdhfT7VtWNl4X9+5ufujjIcvhunjjFmqza
         RrHcD24OGgPzDx0eGH5gc1AQxOVE5kzvaE2ReJNxnCIFqrho1NCkxTj+gk8EJUSRA7vV
         trBjWEi3oZmwQuxyrwzOXYr2FODVfDTgMUtCWp95BTh7X9QmsYtUQZON+y5+C7osolZd
         xW8xC5kYb3wAiO2A5WLFubaDJEzDq+ZE9ko8eJPMog1EwfUO5U0/HfPwZDXa6yqjyH+n
         VbGA==
X-Gm-Message-State: AOAM532WMBjx9qx4iiZZkOG0by0I12iQzEx64DrS69pu8M5Cgmv4Cv7a
        PtyjPPJDOooTsy/veUsMsY9yVZwvwIUPxA==
X-Google-Smtp-Source: ABdhPJzncNVm9JEdvzWZ/WJX8rZD6Uc3eyRjjE+e9aLdBHmlkh2N+ra6ix7Phl7ZYouz3tV5tJAaCQ==
X-Received: by 2002:a05:6a00:1d8e:b0:518:87e7:db00 with SMTP id z14-20020a056a001d8e00b0051887e7db00mr52648703pfw.84.1654068465543;
        Wed, 01 Jun 2022 00:27:45 -0700 (PDT)
Received: from localhost (subs02-180-214-232-26.three.co.id. [180.214.232.26])
        by smtp.gmail.com with ESMTPSA id gn1-20020a17090ac78100b001df82551cf2sm650434pjb.44.2022.06.01.00.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 00:27:44 -0700 (PDT)
Date:   Wed, 1 Jun 2022 14:27:42 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-doc@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Nikolai Kondrashov <spbnick@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        =?utf-8?B?Sm9zw6kgRXhww7NzaXRv?= <jose.exposito89@gmail.com>,
        llvm@lists.linux.dev, stable@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] HID: uclogic: properly format kernel-doc comment for
 hid_dbg() wrappers
Message-ID: <YpcU7qeOtShFx8xR@debian.me>
References: <20220531092817.13894-1-bagasdotme@gmail.com>
 <3995c3d8-395a-bd39-eebc-370bd1fca09c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3995c3d8-395a-bd39-eebc-370bd1fca09c@infradead.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> One note (nit) below:
> 
> >  drivers/hid/hid-uclogic-params.c | 24 ++++++++++++++----------
> >  1 file changed, 14 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/hid/hid-uclogic-params.c b/drivers/hid/hid-uclogic-params.c
> > index db838f16282d64..647bbd3e000e2f 100644
> > --- a/drivers/hid/hid-uclogic-params.c
> > +++ b/drivers/hid/hid-uclogic-params.c
> > @@ -23,11 +23,11 @@
> >  /**
> >   * uclogic_params_pen_inrange_to_str() - Convert a pen in-range reporting type
> >   *                                       to a string.
> > - *
> >   * @inrange:	The in-range reporting type to convert.
> >   *
> > - * Returns:
> > - *	The string representing the type, or NULL if the type is unknown.
> > + * Return:
> > + * * The string representing the type, or
> > + * * NULL if the type is unknown.
> 
>         %NULL
> would be better here, but not required.
> 

Hi Randy,

I don't see %NULL in Documentation/ (I git-grep-ed it but none found).
What should I do when I have to explain NULL in Return: section of
kernel-doc comment?

-- 
An old man doll... just what I always wanted! - Clara
