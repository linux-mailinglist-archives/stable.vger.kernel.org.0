Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858D53CAE82
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 23:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhGOVaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 17:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhGOVaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 17:30:16 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FBDC06175F;
        Thu, 15 Jul 2021 14:27:22 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id g19so11382034ybe.11;
        Thu, 15 Jul 2021 14:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c98vhhNmKtU2Kf1jFJWnICXcNHRkmdN6D5Ms8wKrmDU=;
        b=UkOUCFvJbddIOTZRtNAtWd13HzJiClk3JT0PtfRSI9CA4ZuXxuiViA5nHkXIvJq/oe
         Sb1x9ktraTyuHuXzVnUz8XJEJbec/W7m8Hq04GdaxWpvbpIheF16rVvYa411S1EJX3JB
         hb2IEC9NkZxfHUnpc5OuNJNhog/SmgyaNc83fBN0IPv73pTGcLhQlx0hAzOF3REbfahD
         93oLCwk9ivbXXZYeEBo6/n5McT69kw249QrAhlOIlVkxy7F4XNQGVc6VXa15wkutLuHi
         BPtOO9cmPKt/iM0zgxa4sdGZR+k0fU3XZI4msaZrVFIY17cexTRj/IM4RJCN+npl/MNk
         GeBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c98vhhNmKtU2Kf1jFJWnICXcNHRkmdN6D5Ms8wKrmDU=;
        b=liBXOvREolZ38niPJ/PaGNmPFhs1xIAvorUk0GGyg5NelOF+8hnYaTriXKm4zbc8RR
         wlKaECnSzNoXKZYp5TReHVMZStlJsFo2kfe0DzJcUgXMN2Gk5yhmtCl1EVXs5CuuWMX4
         ITzbt6p/iWeFXMay8vf684NRCHXUyuP0NvrvXYkgiCpBbVCFAiVRFYfpayfIndMT87nv
         pzJjSqFuOBu2V2v1okLr3qd0CcDnachGQY+QAv7sEYKaIdBtU33T9mo74qa3R0gfNqz8
         qqmPASUfJRWOjksBlZZWG+kqSWyXYFh/6+C8lb4M8jDJwQTYY2AIwaO9caJogV9m3Vfv
         LhIw==
X-Gm-Message-State: AOAM531tKXs+3cvTWitGyGuWEpyC7e0oNnE5e97wjCMvAtPxTHetTzCZ
        FGfJMqpUmLfbBb1FBoqdnx+acK4nz+ISQkvo8k0=
X-Google-Smtp-Source: ABdhPJw+YqIIKU6JwmT8OARrN01JrszZCBRo1u/RRedtLG8bHhcnQKrziA+gcD5WfdvSWIyHSSvKxx92J4hRwDagDeI=
X-Received: by 2002:a25:5807:: with SMTP id m7mr8008303ybb.127.1626384441429;
 Thu, 15 Jul 2021 14:27:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210715182448.393443551@linuxfoundation.org> <20210715182456.876823976@linuxfoundation.org>
In-Reply-To: <20210715182456.876823976@linuxfoundation.org>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Thu, 15 Jul 2021 22:26:45 +0100
Message-ID: <CADVatmNj+HSarEpuYdKsZaNyrOgyXfJw7u9LJxa2RSBf8iXnHQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 031/122] net: moxa: Use devm_platform_get_and_ioremap_resource()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Jul 15, 2021 at 7:44 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Yang Yingliang <yangyingliang@huawei.com>
>
> [ Upstream commit 35cba15a504bf4f585bb9d78f47b22b28a1a06b2 ]

arm moxart_defconfig build fails with the error:
drivers/net/ethernet/moxa/moxart_ether.c:483:22: error: implicit
declaration of function 'devm_platform_get_and_ioremap_resource'; did
you mean 'devm_platform_ioremap_resource'?
[-Werror=implicit-function-declaration]

Reverting this patch fixes the build.


-- 
Regards
Sudip
