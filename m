Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9723D9496
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 19:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbhG1RwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 13:52:15 -0400
Received: from mo1.intermailgate.com ([91.203.103.210]:41710 "EHLO
        mo1.intermailgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhG1RwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 13:52:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by mo1.intermailgate.com (Postfix) with ESMTP id DCBB681081
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 19:52:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=bof.de; s=20180522;
        t=1627494732; bh=5bGJsXBGg9eBp/sF/Tf2AlcQl9aqIYuM09bV826wIM8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc;
        b=e1Bo/6FDkVp0LCIzm/ItGzzpW+P34CidTjhlzF7UKUvU8Hfdzyzu6n5FT2ihmTTWf
         rS3rZMHBi79oluXoo5BHXV35J3AWH1IdUKAOudNotbX+XjiImPMGrOzVTDIc8cGcD3
         QJ57ISISus505TZtxp2Z/wte25LgflrmCO/1nTy4=
Received: from mail-lf1-f47.google.com (unknown [162.158.183.120])
        by mo1.intermailgate.com (Postfix) with ESMTPSA id 9202681A57
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 19:52:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=bof.de; s=20180522;
        t=1627494732; bh=5bGJsXBGg9eBp/sF/Tf2AlcQl9aqIYuM09bV826wIM8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc;
        b=e1Bo/6FDkVp0LCIzm/ItGzzpW+P34CidTjhlzF7UKUvU8Hfdzyzu6n5FT2ihmTTWf
         rS3rZMHBi79oluXoo5BHXV35J3AWH1IdUKAOudNotbX+XjiImPMGrOzVTDIc8cGcD3
         QJ57ISISus505TZtxp2Z/wte25LgflrmCO/1nTy4=
Received: by mail-lf1-f47.google.com with SMTP id d17so5628835lfv.0
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 10:52:12 -0700 (PDT)
X-Gm-Message-State: AOAM5306B3SGFO9dxIGxBmwxJt0oqMkEytv1dC+vzvOZApKkf+ZbpaXQ
        Jg2jEudP2xw9c7ymL/UhhGvDJSC3xSlTeZ+IG1M=
X-Google-Smtp-Source: ABdhPJzHXR0WEPz1Rv5D5/vceG3HPZ4Tj4qIJQ3a0lPbIIm3aJpP4AiiDT9WWuASR0AXdSPzkQza2NUEV7ZAB7sO4X8=
X-Received: by 2002:ac2:5e28:: with SMTP id o8mr517051lfg.209.1627494731965;
 Wed, 28 Jul 2021 10:52:11 -0700 (PDT)
MIME-Version: 1.0
References: <61018d93.xsvXcO161PFLQFCX%bof@bof.de> <YQGXyiMb1IntqacG@kroah.com>
In-Reply-To: <YQGXyiMb1IntqacG@kroah.com>
From:   Patrick Schaaf <bof@bof.de>
Date:   Wed, 28 Jul 2021 19:51:59 +0200
X-Gmail-Original-Message-ID: <CAJ26g5Rtu+LwCctckwWUHTSidpav5_RHgx9o5T_ZLbBzsLLOKQ@mail.gmail.com>
Message-ID: <CAJ26g5Rtu+LwCctckwWUHTSidpav5_RHgx9o5T_ZLbBzsLLOKQ@mail.gmail.com>
Subject: Re: stable 5.4.135 REGRESSION / once-a-day WARNING: at kthread_is_per_cpu+0x1c/0x20
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Patrick Schaaf <bof@bof.de>, stable@vger.kernel.org,
        regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 28, 2021 at 7:45 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> > to roll out 5.4.135 on a few of the hosts, and encounter a rare "WARNING: CPU ... PID ... at kthread_is_per_cpu+0x1c/0x20" splat (see full dmesg below)
> >
> > Previous kernel I was running there, never seeing that, was 5.4.114
>
> Can you narrow this down to a specific commit using 'git bisect'?

Not set up for it, but can try - I normally build from .tar.xz's.
Given the WARNING seems to take a day to happen, it'll take a while to
bisect that by commits.

I'll try to revert that one 5.4.118 change in kernel/sched/fair.c, in parallel.

best regards
  Patrick
