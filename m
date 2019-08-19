Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 828B194B42
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 19:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfHSRGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 13:06:44 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:37379 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbfHSRGn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 13:06:43 -0400
Received: by mail-yb1-f195.google.com with SMTP id t5so669850ybt.4;
        Mon, 19 Aug 2019 10:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=csGSFDEdSWqw3dz2PgL0VnXwJ2fZOjcWs1UiwIbpOh8=;
        b=BExNnfSwIIIYOd2fPFOYG/vCFL2tOZqPG9oCAekHhn6/qBPnYcBCfFYgHijbOFgSIV
         3DGpD6Gy4Yxe5tJ0y7ZDtPSbwdLfyXB8xV8HKV3QZokspTWK+H60PPr6tNBa71zjvjEq
         rDkPhzkM4GFacH7LMMWGfYsPXnbNLm8sYSaEGxEVpju8hAy7aMBTE3SSceq9PIT7WuWh
         sTzuvvnJCkLo1WwK+2CpqagEBM4t3E1OIt3MnqcTZn83/B1PR4Re9UMl/PdTgYf/ZlH4
         UzWl4h+JNq8bi9ol4GaYY7DF3EHEeft6IC54G7JgHD9K3vmdEpTW1LySlpoqUoXgI+qN
         Gn9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=csGSFDEdSWqw3dz2PgL0VnXwJ2fZOjcWs1UiwIbpOh8=;
        b=sHU7cJs4W01jLZ0Vqdu7E06NeiO0018UAP+x1maSxwZPnYo8v+j1bHsVnBueq63jyF
         gJpnW+v/hlFq4tdWPvkET6pmFWM8NzP0TbeUbY05BPP3ZLwKh3S7MmGMc7JvkmayQbBA
         rPj8oDYQrTU0q1ierW1KEeC2o9b2zU7qjdjuH0JRccE+vL+LAK258JlYgPneI1hXyKTF
         MuTolEkTkZJ8qRhKcRktGN0trtVzJfqvv2/KqTdbSGc2wnLAUpMZMF1vOpb0yInaQg1W
         w7CUjHlc3awr1pYo1JaA6jnno3/vVq1X/2r+deSDT1fTk59O0wmRLzoaWd4LoSArnnxS
         Zr8w==
X-Gm-Message-State: APjAAAXXGecFJDHpXfeFkbu1HaljbJvRLiI7e1cS1PbO4RmaBp1FRATm
        D9+htx5EjTHSfczWdcKSgaRWeC/YFD+KLlPJMRQ=
X-Google-Smtp-Source: APXvYqwQA66V3JZQ8sRo/iPqtTGs+feQWRX34c7uh9WJv+pUv2pSCy/Tkk/vsf3jr7t3twT4WPViCaVg1rYVma41ndA=
X-Received: by 2002:a25:ed0e:: with SMTP id k14mr17889604ybh.286.1566234402617;
 Mon, 19 Aug 2019 10:06:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190806213749.20689-1-sashal@kernel.org> <35579e00d27344b853cafea0b29b13c5aaf9e1fc.camel@codethink.co.uk>
In-Reply-To: <35579e00d27344b853cafea0b29b13c5aaf9e1fc.camel@codethink.co.uk>
From:   Max Filippov <jcmvbkbc@gmail.com>
Date:   Mon, 19 Aug 2019 10:06:32 -0700
Message-ID: <CAMo8Bf+g68JemdWzc2DQ43JCdO125EzpT9r42WWA48OYAcksag@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.4 01/14] xtensa: fix build for cores with coprocessors
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <sashal@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        "open list:TENSILICA XTENSA PORT (xtensa)" 
        <linux-xtensa@linux-xtensa.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 19, 2019 at 9:53 AM Ben Hutchings
<ben.hutchings@codethink.co.uk> wrote:
>
> On Tue, 2019-08-06 at 17:37 -0400, Sasha Levin wrote:
> > From: Max Filippov <jcmvbkbc@gmail.com>
> >
> > [ Upstream commit e3cacb73e626d885b8cf24103fed0ae26518e3c4 ]
> >
> > Assembly entry/return abstraction change didn't add asmmacro.h include
> > statement to coprocessor.S, resulting in references to undefined macros
> > abi_entry and abi_ret on cores that define XTENSA_HAVE_COPROCESSORS.
> > Fix that by including asm/asmmacro.h from the coprocessor.S.
> [...]
>
> This seems to be fixing commit d6d5f19e21d9 "xtensa: abstract 'entry'
> and 'retw' in assembly code" so it wouldn't be needed for any stable
> branches.

That's correct.

-- 
Thanks.
-- Max
