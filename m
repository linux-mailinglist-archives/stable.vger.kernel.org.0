Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3D23B65ED
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237232AbhF1Poy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236840AbhF1PoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Jun 2021 11:44:04 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DA2C0527D9;
        Mon, 28 Jun 2021 08:01:58 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id v12so10166952vsg.10;
        Mon, 28 Jun 2021 08:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sdMl/1OJLnnTo+EUbTvGj/r/oum5522THEOlxxDHOLE=;
        b=XsQrrgMwHXsom864s4VwaXx5bKdtHcc7g2oRdxHLXcPAnjCt0xq6AhFP+lhYJocbd5
         /obwVRF9+N1wlvMuJBR0knCX+GbhQsF17N3oNOr/7HoHtXxp2Tj9SGycUM3R07ueFnCc
         JAY+V1pvtYy8fFe15kiekIK9k6Ms7HqsGysdQ2V+wcfRgNmDOb4zxvcVvqaQOhIk2t1p
         UZEKYkbXMU8IgPtXBP+ykkoMEeBBUO2UzhI2TZeQkED4+9J/C6DhUm3rVDF5mku0ILzA
         dKLGW23AKzI79jJtTt1QPQMATlqIgFUmwBt4T8B5uLYJvNLzeSS6Nnakb4Qe3aYb+CxR
         nkLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sdMl/1OJLnnTo+EUbTvGj/r/oum5522THEOlxxDHOLE=;
        b=aeApArzwhCUjILQaohPFj+xfwKjSXMHje7m4xBlpIJn0koPajSS3ZYDOB3S6XusPZb
         Weu2oFpjNEHOLYiFbgcYfrAWj0MiAxtJsB1JFndVZDjbV/cJ6jtCMtAFfWViZDdzRmF4
         Jkiiw2NUjRs8km9H5EPheL0tbNobe8kjsoQR1Rzm9MSqPsLwRgvT3fnZOJ8IFND3o2RD
         868hRUOM47zyVtL8C45riZza6wfVhjOKGGm82lvobBYRGRckG5A4yHFnd4IqUsDe9Exx
         s3SQVX0y5q+JDOYpdpPo0mmGqYJ5UhE4s6Ou8EupB027jGRcwrw+/yO+BRaK6dBUIfYQ
         /90g==
X-Gm-Message-State: AOAM533RyPDPrT52D5n4VQjOlvwBdbXnO33BhNh8cn3J3MZq7t+wV1wz
        58DTEIIl9uGfV36qxyb8MARHhiobA9AERmRhcFo=
X-Google-Smtp-Source: ABdhPJzSmDlMQXfSvX9SRLQHuAWraJXYiwI84JNlpUmHs3E2iC2rfroji+5EVJ3FBkmlh2bxL5R37mfvVAaS1VUYOTM=
X-Received: by 2002:a67:e00b:: with SMTP id c11mr18727093vsl.22.1624892517243;
 Mon, 28 Jun 2021 08:01:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210628141828.31757-1-sashal@kernel.org> <20210628141828.31757-5-sashal@kernel.org>
In-Reply-To: <20210628141828.31757-5-sashal@kernel.org>
From:   Emil Velikov <emil.l.velikov@gmail.com>
Date:   Mon, 28 Jun 2021 16:01:46 +0100
Message-ID: <CACvgo50q9NLRjo3XMN63wQJywiZ_Z=yUoQLuVfy-Ht1URYdO-A@mail.gmail.com>
Subject: Re: [PATCH 5.12 004/110] drm: add a locked version of drm_is_current_master
To:     Sasha Levin <sashal@kernel.org>
Cc:     "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "# 3.13+" <stable@vger.kernel.org>,
        Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha, Greg,

On Mon, 28 Jun 2021 at 15:18, Sasha Levin <sashal@kernel.org> wrote:
>
> From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
>
> commit 1815d9c86e3090477fbde066ff314a7e9721ee0f upstream.
>

Please drop this patch from all stable trees. See following drm-misc
revert for details:
https://cgit.freedesktop.org/drm/drm-misc/commit/?h=drm-misc-fixes&id=f54b3ca7ea1e5e02f481cf4ca54568e57bd66086

-Emil
