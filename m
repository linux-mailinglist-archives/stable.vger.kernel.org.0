Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A02257B474
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 22:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbfG3Um6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 16:42:58 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42811 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727461AbfG3Um6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 16:42:58 -0400
Received: by mail-lj1-f194.google.com with SMTP id t28so63384797lje.9
        for <stable@vger.kernel.org>; Tue, 30 Jul 2019 13:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lv9xmyxG6IGQjvUZ86rphL4nIe1jnAFhb/zH3aGbb60=;
        b=XqytTsE8uyrmeLssSTef+p0jCEwc53nd2nhSJTqkB9hNAVar3QvDbiEsGd7lo1w2Vd
         +28uE5nAIbIiP9QJ8f2a66B9NCZBQh3Vp+FoohG2CFuIKycie4266tT7mqpUSqzF/ZS2
         GW/6C0dS9rlnTb0s5o4dXZ9YS7tjds0M2BRB3KWJRAxmBbl2RRu96xETQNomt42IYXJy
         KLqBoJm7drhwnvtHMwXFZ3SKompaDRhGyvI9KnUpI8oBXiWyi0Fgo+jO83g0C2xWa1PC
         oSNwitZ0h4Ps3AFw6onhr4KvNjMSdX9nfdmO311dBkGFNMN3UoatGYiZlUiOxb/Frb3T
         b+MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lv9xmyxG6IGQjvUZ86rphL4nIe1jnAFhb/zH3aGbb60=;
        b=gLG0/gnMGrhwonNwPqeeNdHP9Hjq6LFH15m62oMWaskHQflbH4atOyFSNi349l6QzZ
         qa/iwVqC7JJXAH5W5bsR/qMBue2BKAF4fkZbq0d7a932qS6G5gZKRsnWT77mZHxQdw6o
         yLie+aoMW4ak71eLCZTSg6R+J8PgCGz8WFdllKA8W/vpzEBEGU66CvTHZDsf3ZNsbCpR
         oZIZVGHdb+o5TGxuLsFarnemb9yv+rx3ZRYp9pJ+90yOkVc2xX92CpDpb4Q/okn9Z+Sb
         DG9ySN72GM3IWfp/8tiirXEw1Es6RlDiG3GFEqCJVisUYIXHbrWhPqN4AHsIXvOz10Rn
         8pAg==
X-Gm-Message-State: APjAAAWotWs9NG5kgZtsqOmdLcicgJcl7M8esuKs7ifR0j6ZkCzSUZ0k
        CWJT+bMK5EKs4jvLyydxipdEbGQ6HeQBF22fa+0=
X-Google-Smtp-Source: APXvYqypNwP6Gp5aYCmc2W/UgTB6fmRlqYFduRHmjhP6g3OHwPmnwzUDPtAMVuRNgoD2hDjI9fPcI/KvUHHZPuZQi9M=
X-Received: by 2002:a2e:87d0:: with SMTP id v16mr3521523ljj.24.1564519376593;
 Tue, 30 Jul 2019 13:42:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190717223451.2595-1-dhinakaran.pandiyan@intel.com> <20190719004526.B0CC521850@mail.kernel.org>
In-Reply-To: <20190719004526.B0CC521850@mail.kernel.org>
From:   Rodrigo Vivi <rodrigo.vivi@gmail.com>
Date:   Tue, 30 Jul 2019 13:42:45 -0700
Message-ID: <CABVU7+sbS8mw+4O1Ct8EY_5cj+fnmNFzyd6_=v2_RmCgBRA13g@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/vbt: Fix VBT parsing for the PSR section
To:     Sasha Levin <sashal@kernel.org>
Cc:     Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Thu, Jul 18, 2019 at 5:45 PM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi,
>
> [This is an automated email]

Where did you get this patch from? Since stable needs patches merged
on Linus tree,
shouldn't your scripts run to try backporting only patches from there?

Thanks,
Rodrigo.

>
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 88a0d9606aff drm/i915/vbt: Parse and use the new field with PSR2 TP2/3 wakeup time.
>
> The bot has tested the following trees: v5.2.1.
> v5.2.1: Failed to apply! Possible dependencies:
>     231dcffc234f ("drm/i915/bios: add BDB block comments before definitions")
>     843444ed1301 ("drm/i915/bios: sort BDB block definitions using block ID")
>     f87f6599c843 ("drm/i915/bios: reserve struct bdb_ prefix for BDB blocks")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?
>
> --
> Thanks,
> Sasha
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx



-- 
Rodrigo Vivi
Blog: http://blog.vivi.eng.br
