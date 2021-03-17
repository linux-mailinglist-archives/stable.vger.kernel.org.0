Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E468733E755
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 04:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhCQDCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 23:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhCQDBn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 23:01:43 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F373C06174A;
        Tue, 16 Mar 2021 20:01:43 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id 81so39469902iou.11;
        Tue, 16 Mar 2021 20:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Cuv/dlbqOCOUQd0WbCXjHc+FhwYyTUMSsBjCfLSUDkE=;
        b=p4VDBWyFHv4gnhN8ERRL0w+YIcfUFo1h0hHphwPd38epUaco5g15TbBewj4PLcMlii
         7yolyYMTKSdwB5E5CMOLTONlAjCM2PriAfCVKQrv/JPN9RYIhsiQsk3aKXISF85F/Zp+
         i3EjpAcQsS1J10eZJolzrp7leegz1B4wvWZWNIBiUUw2sjew3hVlcUQC6LhgUPgTpDeW
         RHHfNG+pjjhe2tVO3pHmA2vGEyp5sxvvLuBQSVrV3dRWMEIuxSwJTSqVf2IlYZZfwc7R
         da7CCgQUhgfNWt94yJJ14OIjtx0RSCfSQ5jLiWZkhy2LslJ9A01+6bjNS8IOlsNFTYXo
         262Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Cuv/dlbqOCOUQd0WbCXjHc+FhwYyTUMSsBjCfLSUDkE=;
        b=JL0EfP82HoYvTfXXwZFFmqoyx44kO1kCPfIbF7TvAGt31IERGp2Uwn+AkWPIi/eGcL
         7L0t7wRCtFLl2CItoOr6ZKVg9qp+Sp+RL+oIgrqckysVlWm3+Xe0Vaz1wbu9qro/VnS+
         Fn3fVgldrPl+EStjgqq8Us2gZg6+TFC+AaQBfOLo4oTBR2Q1WiOSYNbMdesYpwwvfRYC
         B00TDEU2Df3Wy60JrPBv19C2defoV5HQvd0CIUjf8X9awO2XmJj9c2XCiPZa8A4npztR
         KZZCUp64Ahbbc2fFMr02ClAFt1LPW7rkK5cGtZ+CqirDFUZkzDSIxPhtoLLDly11OlY+
         3GSQ==
X-Gm-Message-State: AOAM5327lk9eBk8r9/NwvWn8ZpEYVHQ89jec5q4sRZ6ufuaXWBeRg8JT
        G3ZPDWnpW4F+ItXalygyIo4=
X-Google-Smtp-Source: ABdhPJzhjPpGi9IPdaZUdRR9ZUoEVS/LsJPgIU4xdMsn4fSWUYm1BxQHuZ3hv4m+l5kncJ85OttXGQ==
X-Received: by 2002:a02:a796:: with SMTP id e22mr1272542jaj.93.1615950102595;
        Tue, 16 Mar 2021 20:01:42 -0700 (PDT)
Received: from book ([2601:445:8200:6c90::4210])
        by smtp.gmail.com with ESMTPSA id r18sm10448291ilj.86.2021.03.16.20.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 20:01:42 -0700 (PDT)
Date:   Tue, 16 Mar 2021 22:01:40 -0500
From:   Ross Schmidt <ross.schm.dev@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/290] 5.10.24-rc1 review
Message-ID: <20210317030140.GC6466@book>
References: <20210315135541.921894249@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 02:51:33PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.10.24 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>

Compiled and booted with no regressions on x86_64.

Tested-by: Ross Schmidt <ross.schm.dev@gmail.com>


thanks,

Ross
