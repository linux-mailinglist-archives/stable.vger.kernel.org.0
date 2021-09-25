Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04AE84180D2
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 11:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235512AbhIYJgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 05:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhIYJgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Sep 2021 05:36:32 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191C6C061570
        for <stable@vger.kernel.org>; Sat, 25 Sep 2021 02:34:58 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id t18so34885716wrb.0
        for <stable@vger.kernel.org>; Sat, 25 Sep 2021 02:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:content-transfer-encoding:date:message-id:cc:subject
         :from:to:references:in-reply-to;
        bh=E9VZvuypCKKa0kVD0aiDreJfpoj+4GgRIXr6zNF5NkQ=;
        b=n5/1zVQkaV/URwP7/3ff5DNA0qyZK62ih69BYgtxEte3vQ2IiEx7S4MNsB4k7SKjAv
         gTBxLRG/4RojDEzRg/aAjvpGC8cUJMC5oeKZcnnGYTVGmnn+r0xJ7cJdLgZMxchsOWvi
         khe4rt8yBt7PB5ZuILPnWFJD+96wfomeiYva6CtdxkIDHxuyeGZdqU03I0tFbxb+2ysp
         dAlDfEpI+zGZAz5luSWTNvI6/cXIDC1QPEQFzLu6LCC3Fjt74n8945JcJTIJM/78S5LV
         Mm3budv38CFFZ+ujSiBcMWdsaNPIixQy+31EKGiThtyZD0lNfDeRKgbISV2afvtqfvzB
         vdTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:content-transfer-encoding:date
         :message-id:cc:subject:from:to:references:in-reply-to;
        bh=E9VZvuypCKKa0kVD0aiDreJfpoj+4GgRIXr6zNF5NkQ=;
        b=rdLJ0pNU9+EHks0bWnTMVtQ9wdevh44rvU2mQjkkajm1iA/09GZeODGvmnpliiCQsW
         llEu4jXtZDdNuDKsvf4WWZI9ftY3xV/bJtYAq4+JdTduermrlqm807A+9kxQ7gUmUDD0
         t35N2LJq3o8KMaZ3O32Icaq3VqmKbnPzn9P2T1SvyvpoJWtWtRfN1vIq9/+hg4K4VBgr
         E4fR5jy1qSrIwf2psZIFUeCNy2J1dv4EILminznRQ5XoLZ/cH2xRskK2eizunzCOFsmk
         xCk9HoVjnoL8bbf/HXy7BE3azqFPreOvHwloRw6Uz8sNdi4mU7Mm+znqDFneR8D0F86T
         U5rA==
X-Gm-Message-State: AOAM531lr2uZCs+ClW/xMfx+Bk6SAoQC9dXikiwiRS3IpBcYCWlh6+II
        OjITHD0AsSO+um/ORS0fXwcWuA==
X-Google-Smtp-Source: ABdhPJwRESZEF7H5Amvn2IEzk7c0W3RmQQsX79PW/DmDad5B7N4J+wIH7WwHNeMUGcMf3CZx0qy35Q==
X-Received: by 2002:a05:6000:18ab:: with SMTP id b11mr16629557wri.131.1632562496638;
        Sat, 25 Sep 2021 02:34:56 -0700 (PDT)
Received: from localhost (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id 5sm11128597wmb.37.2021.09.25.02.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 02:34:56 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Sat, 25 Sep 2021 10:34:55 +0100
Message-Id: <CEIV3SMWQ4Z7.1V01734EC2SA0@arch-thunder>
Cc:     <stable@vger.kernel.org>
Subject: Re: [PATCH 2/3] usb: isp1760: do not sleep in field register poll
From:   "Rui Miguel Silva" <rui.silva@linaro.org>
To:     "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <20210727100516.4190681-1-rui.silva@linaro.org>
 <20210727100516.4190681-3-rui.silva@linaro.org>
 <CEI85GUCGPFO.2GIJLZMWZCXBJ@arch-thunder> <YU32aMGCGY9GZKlx@kroah.com>
In-Reply-To: <YU32aMGCGY9GZKlx@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Greg,
On Fri Sep 24, 2021 at 5:01 PM WEST, Greg Kroah-Hartman wrote:

> On Fri, Sep 24, 2021 at 04:35:40PM +0100, Rui Miguel Silva wrote:
> > Hi Greg,
> > forgot to ask you, can you please merge this one to stable #5.14.y?
> > At the time I was not sure if it was getting in final 5.14 or not.
> >=20
> > It applies clean on top of 5.14.7.
> > And without it, it triggers BUG sleep in atomic checks.
> >=20
> > upstream commit:
> > 41f673183862a1 usb: isp1760: do not sleep in field register poll
> > https://lore.kernel.org/r/20210727100516.4190681-3-rui.silva@linaro.org
> >=20
> > fixes tag:
> > Fixes: 1da9e1c06873 ("usb: isp1760: move to regmap for register access"=
)
>
> Sure, will queue it up after this next round of stable kernels are
> released in a few days.

Thanks a lot.

------
Cheers,
     Rui
