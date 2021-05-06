Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1440374D3C
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 04:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhEFCDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 22:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbhEFCDJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 22:03:09 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA62DC061574;
        Wed,  5 May 2021 19:02:10 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id g15-20020a9d128f0000b02902a7d7a7bb6eso3548545otg.9;
        Wed, 05 May 2021 19:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KR+Zt8gatAmFm5zUbDUeqsKRamrBGMznhlklBB2oTek=;
        b=jWaEWsBkDYTQ0h6VtG/MoIVUEv8KAgY2F6RWWO0V8i//l3OrFxvSXENkY/Gw5J9Hh8
         fMm7SjHLr9gpCne6NF6fsBwo9RUpWs3B05GxLGN3IiTq4timkOiIjfDJ4BjBtXSvUW1G
         UExAOBBkjYVdrRQocZou8b2rIXTbO9MPB3SwQQHgojw7GX7/vdoT0dULvSmgzQf8ysdf
         pSTfTz/9oxbpHVTzSi1U1G5GHAftFPgCbMSdu5N3nefBhQgUkP3qaKl6+emC8PRVfxaG
         GQ0YViUNPWRGetBjy4132TLPrtt2ooidPl/uE1Dtx1JhpYYeXpfgmZq0vAjfuq4hj0+x
         54fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=KR+Zt8gatAmFm5zUbDUeqsKRamrBGMznhlklBB2oTek=;
        b=uJJB9QrXj0WgwDGYunqz+tR53w3u6yvGLME1+MfWfNq9FUc3/dcAuA0rGs5pBin5/u
         Z0/Gl9SJ2KJ9Hn4+pA6+00H/i4Ihxy/No1v4xWC0Kgg7794/msiTTDq1BIDgeO5K6bpM
         3UtqY29Ze+5ObC+QcbOvZRLeKHQk1LQtLa0lgIoYISDRh1R/RFwBvPDHqh54Zfq3wvDl
         QWtfC280r0OmQQ1Ehw1zFvxoPsN8qDY4za1DBNyvSA5sfWcS52t1SVkE4xFiBoEAT038
         XUpwJHOPqC7Iko8GJhd+bJMRYzf5sG2gZYCiVwaONRs2u8iiJKrcl+PvUO+CdNaMLWN5
         6BIw==
X-Gm-Message-State: AOAM5323LYoqEhpu6Ohzt+QN/W4PV9CghoSLiuapy5enrnredPbCxozy
        p8PYemYBDydhqsuI9DZUw+E=
X-Google-Smtp-Source: ABdhPJwYF5Y4G+gpm3NKLL1CetgXScObMtBAgDJEswnglyUNOlYH9jchaVImJa3amGcoCnkuKtgTmQ==
X-Received: by 2002:a9d:7f19:: with SMTP id j25mr1385414otq.319.1620266530276;
        Wed, 05 May 2021 19:02:10 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r9sm254444ool.3.2021.05.05.19.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 19:02:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 5 May 2021 19:02:08 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/15] 4.19.190-rc1 review
Message-ID: <20210506020208.GA732733@roeck-us.net>
References: <20210505120503.781531508@linuxfoundation.org>
 <20210506014741.GB731872@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506014741.GB731872@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 05, 2021 at 06:47:43PM -0700, Guenter Roeck wrote:
> On Wed, May 05, 2021 at 02:05:05PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.190 release.
> > There are 15 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 07 May 2021 12:04:54 +0000.
> > Anything received after that time might be too late.
> > 
[ ... ]
> > 
> > Shengjiu Wang <shengjiu.wang@nxp.com>
> >     ASoC: ak5558: Add MODULE_DEVICE_TABLE
> > 
> > Shengjiu Wang <shengjiu.wang@nxp.com>
> >     ASoC: ak4458: Add MODULE_DEVICE_TABLE
> > 
> Wait, this also has the double commit. Can you please remove the bad one ?
> 
Actually, both need to be removed because they are already in the tree:

$ git describe
v4.19.189-16-g5a3ba2f90f87
$ git log --oneline v4.19.. sound/soc/codecs/ak4458.c sound/soc/codecs/ak5558.c
e32ee6f6fbcd ASoC: ak5558: Add MODULE_DEVICE_TABLE
5d0fe4839d63 ASoC: ak4458: Add MODULE_DEVICE_TABLE
04bb225a4824 ASoC: ak5558: Add MODULE_DEVICE_TABLE
25a09f4aad56 ASoC: ak4458: Add MODULE_DEVICE_TABLE
3f8d3c9506a5 ASoC: ak4458: rstn_control - return a non-zero on error only
4c31b4b4ba65 ASoC: ak4458: add return value for ak4458_probe

This applies to all branches.

Thanks,
Guenter
