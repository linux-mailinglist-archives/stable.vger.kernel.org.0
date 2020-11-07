Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E7F2AA27F
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 06:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgKGFT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 00:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbgKGFT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 00:19:26 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4089C0613CF;
        Fri,  6 Nov 2020 21:19:25 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id t18so1882751plo.0;
        Fri, 06 Nov 2020 21:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=40tSGR0L07eV7FgNupJnGa5tVth9pVcaErV5JQ7dHsE=;
        b=D2R1RHULTkKJ68pnKPlBs5ivkB4oIvaPcRqV32DBQYJXKZmb/9qMGjpzhJpagqI0Hf
         u9FCV7dNLtTrnryS2hQUh+CXFiX3aAHD6bbggY2ucq6ndG3F6sW8m/ebXKdYoLMdLzox
         vH7QV5yyAHtyB4LutwfdaFEfOkv640I/54ao17ItpQqiHN9fiBbNeasfCULA7fk/LYxb
         q6ceyyLbgBeFzfAEkbEkSV6rhAM+KoASu3F4gFwN2osm7/NHlwoMjerjN1FGJtjMk3hB
         jvB5oFTXt46T7qoN1zai5zEIA7UrOSNg8SgKjoNVP/zUxpA2b1RGbpvTWJci4p52oGds
         kk3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=40tSGR0L07eV7FgNupJnGa5tVth9pVcaErV5JQ7dHsE=;
        b=I63dK3BpYMysfzllCN/O+TzFPZ4bEBBw/jsFt9AXXG6RsGWyWjUJsVJE7zL02z62tL
         jYrsE5WpnCXMSLisLiIWqwwxwmSaNKApgCeI6wtMKfMQnHJoZusfGe15NXWpj69DbIrp
         MWoIhXpITs9ViqrEEqiJxtBsCYwtQDFw/YAZdLkKZvfrZ8nOj0TvoyvfK32PhB5BwKd7
         TOkY4SlZDiU3CdUWxIYWZMYlJQKoAnWpcjvKwvk7MKtsOwlF/Zd0bPNElxKdDqeDcrjA
         lykupMiIiM3y1yQnm4kyRZ01fjqcFZi6zef9P6HKlxvRffiLMouA+bPft4VEJdyihP5d
         nzkg==
X-Gm-Message-State: AOAM533bRvk3epdZKvhu+0mBucwjUORw9nL2ZZXeOC2o+1+sPPvtEpMP
        B+Ok7MBHgAkOv0jXQdKPFA==
X-Google-Smtp-Source: ABdhPJw/7ZW18AQGyT803zxBjP5W75zA0GQMiFMbZ+gTQm7HQJdTCcGeRvniW6VP6ZdZ505GkfLqIw==
X-Received: by 2002:a17:902:328:b029:d7:cc2d:1ee7 with SMTP id 37-20020a1709020328b02900d7cc2d1ee7mr1567935pld.10.1604726365081;
        Fri, 06 Nov 2020 21:19:25 -0800 (PST)
Received: from PWN (59-125-13-244.HINET-IP.hinet.net. [59.125.13.244])
        by smtp.gmail.com with ESMTPSA id e3sm4275574pjt.33.2020.11.06.21.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 21:19:24 -0800 (PST)
Date:   Sat, 7 Nov 2020 00:19:18 -0500
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] Fonts: Replace discarded const qualifier
Message-ID: <20201107051918.GA2209915@PWN>
References: <20201030181822.570402-1-lee.jones@linaro.org>
 <20201102183242.2031659-1-yepeilin.cs@gmail.com>
 <20201103085324.GL4488@dell>
 <CAKMK7uGV10+TEWWMJod1-MRD1jkLqvOGUu4Qk9S84WJAUaB7Mg@mail.gmail.com>
 <20201103091538.GA2663113@kroah.com>
 <20201103095239.GW401619@phenom.ffwll.local>
 <20201103105523.GO4488@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103105523.GO4488@dell>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

On Tue, Nov 03, 2020 at 10:55:23AM +0000, Lee Jones wrote:
> Would you be kind enough to let us know when this lands in Mainline
> please?  We'll need to back-port it to start fixing up our Stable
> kernels ASAP.

Patch is in mainline now:

9522750c66c689b739e151fcdf895420dc81efc0 Fonts: Replace discarded const qualifier

Thank you,
Peilin Ye

