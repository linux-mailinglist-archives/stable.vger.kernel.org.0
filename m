Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACBD2206C5
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 10:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729569AbgGOIJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 04:09:22 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:36017 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727871AbgGOIJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 04:09:22 -0400
Received: by mail-il1-f196.google.com with SMTP id x9so1235871ila.3;
        Wed, 15 Jul 2020 01:09:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7GqAsqCXaN6ZfFXKDdHixXpcIHkuyc+NEgmoh8fdZz8=;
        b=MwoLRGQHki8I70p8PY1fC5Eu9GHm/9QCavVUWsZwhbY0dW1a3POgmR4FkJ/L4R5YMY
         ZeByr0S8ujpQsa5LdyaC1IrLpdRg+7ANU/o8Zu+Ilryn1rNWzutcj+FZadNorEUqQ8eB
         JiSB14RZ3enGv46nrXApTCY9X0GjbjQiQtKy7aUOEVheYplxUON1ZhXRIu4ARb8Hyz4n
         ieBHMSZ1yG1dA4VB3fmUZqtcMwWHzQ6+oJEdv6KP5Kkzol3P5L6zi4H1ugGPFT2KtChB
         dBtC95QLiSYjXmXRaQHbTBdER4uNVraeHtbvbgLNGBUEQHAV9YY6hA4PKmxvholB0OG+
         jv3Q==
X-Gm-Message-State: AOAM532lmT+LoDnVkKpsCBDMo9a+puV8StV5NSHemIhTsTzKd6XAlk3S
        4u4aoEGg6dxM4Z3N9dbUWN/lheZlayUlZ8YFlUE=
X-Google-Smtp-Source: ABdhPJzqSQf+tjLQ6NhcA9CTBoOtkRZPoTX/7p73ixJyP/w1wKQ/vZG/+2ertGRZN/JjVhw51KcAwtPSAhtfWGIBH5g=
X-Received: by 2002:a92:d204:: with SMTP id y4mr3899253ily.147.1594800561490;
 Wed, 15 Jul 2020 01:09:21 -0700 (PDT)
MIME-Version: 1.0
References: <1594791329-20563-1-git-send-email-chenhc@lemote.com> <32525b2d-6a5d-1064-788c-96233a375d1d@cogentembedded.com>
In-Reply-To: <32525b2d-6a5d-1064-788c-96233a375d1d@cogentembedded.com>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Wed, 15 Jul 2020 16:09:09 +0800
Message-ID: <CAAhV-H5Ubx+tRm1+tVifyHyF-Ef=zH+0j_9A2GmkRMR+JyFs-A@mail.gmail.com>
Subject: Re: [PATCH] MIPS: CPU#0 is not hotpluggable
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Sergei,

On Wed, Jul 15, 2020 at 3:56 PM Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
>
> Hello!
>
> On 15.07.2020 8:35, Huacai Chen wrote:
>
> > Now CPU#0 is not hotpluggable on MIPS, so prevent to create /sys/devices
> > /system/cpu/cpu0/online which confusing some user-space tools.
>
>     Confuses?
Yes, this is my fault.

>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> [...]
>
> MBR, Sergei
