Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22BB780098
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 21:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390452AbfHBTCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 15:02:24 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41430 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729829AbfHBTCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 15:02:22 -0400
Received: by mail-qt1-f195.google.com with SMTP id d17so74858204qtj.8;
        Fri, 02 Aug 2019 12:02:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jVHcrIOlueNUgiRUEbVxVOxtBfe1PbfNn1B6D1oGgso=;
        b=sTQmVTXYT2p5lwnmgVdX2E2SGFl3JqiHIIauPiLaXFNd02qnFP34Kb7k/0wG3zeaeJ
         JlKhRN+Rl42tXLZ0PHeo0d3xrtNnVFk/YF44ooeGHTxR1gKjrGpKO5Q/ar4Gl8Txm6v9
         rOBseON1krgDlyGoxJC8CIQGnZ+ua9q3D5oJ+WUEjZKGNAxAOnTYbioHQF8BaXDZ/0s9
         ExCd6kBVlpruA77rW2TmZANpsInF4cKODnqn2mFSkKbwzypZfNEk6W/TUEqrx2KXfDNo
         mIsfvYnCgnE1JYGzwB1c1SreFwEgQWtxomk0tMuyW4n+PfakSBtcUsYE7g0taTSDcIPs
         xV5Q==
X-Gm-Message-State: APjAAAUOP3wO6hOLXQFqkKOWQ/vLQcW8e0BbeIIiulQR2IAB7khU/uOo
        9etWfrfCtLIQZ4KLm0T5vh8Zpz96RRfS6ACtaK9GM41d
X-Google-Smtp-Source: APXvYqxIKCsuebCSwiv0TZ47ClRp7Xl0PFuNdzFysUd/9Fn+FeFhdE4F/VDmb7j920MdKK1Y3/lV9RPhVoNboRcnhBo=
X-Received: by 2002:aed:3363:: with SMTP id u90mr96532135qtd.7.1564772540708;
 Fri, 02 Aug 2019 12:02:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190802132635.14885-1-sashal@kernel.org> <20190802132635.14885-13-sashal@kernel.org>
In-Reply-To: <20190802132635.14885-13-sashal@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 2 Aug 2019 21:02:04 +0200
Message-ID: <CAK8P3a1_6GVO-n-twFbagVq4ALMLDbHAgf0CzMGhhrwra-S4zw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.4 13/17] ARM: davinci: fix sleep.S build error
 on ARMv4
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 2, 2019 at 3:27 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> [ Upstream commit d64b212ea960db4276a1d8372bd98cb861dfcbb0 ]
>
> When building a multiplatform kernel that includes armv4 support,
> the default target CPU does not support the blx instruction,
> which leads to a build failure:
>
> arch/arm/mach-davinci/sleep.S: Assembler messages:
> arch/arm/mach-davinci/sleep.S:56: Error: selected processor does not support `blx ip' in ARM mode
>
> Add a .arch statement in the sources to make this file build.
>
> Link: https://lore.kernel.org/r/20190722145211.1154785-1-arnd@arndb.de
> Acked-by: Sekhar Nori <nsekhar@ti.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This patch is actually never needed on any stable kernels, but it is also
harmless.

      Arnd
