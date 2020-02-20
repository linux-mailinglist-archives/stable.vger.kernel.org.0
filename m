Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66C181667FB
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 21:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbgBTUIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 15:08:30 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37899 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728770AbgBTUIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 15:08:30 -0500
Received: by mail-wm1-f65.google.com with SMTP id a9so3415464wmj.3;
        Thu, 20 Feb 2020 12:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kBIhuNzrd9/ICrWDQr4DVMV2/B2/59BRqjR58cRFSa8=;
        b=mLjP5rCdAC6xFhQp9dOe10slf2tWdLGlp1jHu9A/olLcXXEAaYmvzZ7Zhy693tEkoj
         fJqN/7P/bZ9+EZEqKuyp8WEevdfQinxoUWik/FWSYT6REWm1SvWUKhljrUdMpniafFYM
         ZmLZCnPcMhKZ8OLKRd6LYyOv/AEV2vG3sKzuNcOHJ7XGwJhc2ghDW2nW7x6jVFJA9zBa
         XUpl64Z+Isf9bF9r9yNS5Z6H1IVqCGbtRP0qs692nxBNDJ6iyn4ewCCcOOZb62L7Xzha
         lYzWZDj4Rdc2AG3x+sT7qJu8nhN2EQHhApyzeIhU71KV3qfiS5zAWtTwpGUwfzmbbtks
         6u6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kBIhuNzrd9/ICrWDQr4DVMV2/B2/59BRqjR58cRFSa8=;
        b=Ge6MUy1eCa2afAM2rZyDO/FNl08f0Bshehx8EN4+AuwM0xHGas8ctbfTrsJ+YDwf+R
         /6d/n9nYge6YvtwfD0BREtem0sMIeHaNXwAn1h1fNh8iW/poLCgbpOQedHZyYr3Ipqp5
         bO6uZGOo2fOrtMO2c4R4mgZHLXhezwQGzCPe/lbUFugdxKFWaD1hCqkEdKNnhPhBg4wl
         dgdvWJ95mv23z4l1dCbnRMGBWk31eX1pwPgQOWJe4RjKQow+KP8OkwyZyPzynb5Uy2Nd
         lVQlNjTOq6XO3cxAo+81AsM1/oB6jxodSonTXYRey0ko/FbCB+eufM3PaHKKbUq9d2OV
         8g2A==
X-Gm-Message-State: APjAAAWNqFRvSpG9wgN/vflpHMq2Jf7mtkNVvhZFtyan8DnHTXbswQql
        xxr8qJu1IGq4cfImesmuvPGskHuddBRKgZT5DTM=
X-Google-Smtp-Source: APXvYqy7eptXAdEZnovXNA47MGEG44idKZd6tifmRJg1r8lBP52ZR9PRv5Q5jHU2VMNFc4VIVH+tkdwNPjyGtXAaRz0=
X-Received: by 2002:a05:600c:2255:: with SMTP id a21mr6249867wmm.79.1582229308197;
 Thu, 20 Feb 2020 12:08:28 -0800 (PST)
MIME-Version: 1.0
References: <20200214154854.6746-1-sashal@kernel.org> <20200214154854.6746-530-sashal@kernel.org>
 <CADnq5_Oq-6VYYMWgvSbTcs5S6+DHP1K+ambo3Cd_BBkYFQk8HQ@mail.gmail.com> <20200220192654.GJ1734@sasha-vm>
In-Reply-To: <20200220192654.GJ1734@sasha-vm>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Thu, 20 Feb 2020 15:08:16 -0500
Message-ID: <CADnq5_MRkgK=Of_GJ7n1FHnnuSzdb=OJ7zdQJegi0=xMUidKXg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.5 530/542] drm/amdgpu/smu10: fix smu10_get_clock_by_type_with_voltage
To:     Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "for 3.8" <stable@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 20, 2020 at 2:26 PM Sasha Levin <sashal@kernel.org> wrote:
>
> On Fri, Feb 14, 2020 at 11:31:31AM -0500, Alex Deucher wrote:
> >On Fri, Feb 14, 2020 at 11:00 AM Sasha Levin <sashal@kernel.org> wrote:
> >>
> >> From: Alex Deucher <alexander.deucher@amd.com>
> >>
> >> [ Upstream commit 1064ad4aeef94f51ca230ac639a9e996fb7867a0 ]
> >>
> >> Cull out 0 clocks to avoid a warning in DC.
> >>
> >> Bug: https://gitlab.freedesktop.org/drm/amd/issues/963
> >
> >All of the upstream commits that reference this bug need to be applied
> >or this patch set will be broken.  Please either apply them all or
> >drop them.
>
> Okay, so I have these 3 in 4.19-5.5:
>
> c37243579d6c ("drm/amdgpu/display: handle multiple numbers of fclks in dcn_calcs.c (v2)")
> 4d0a72b66065 ("drm/amdgpu/smu10: fix smu10_get_clock_by_type_with_latency")
> 1064ad4aeef9 ("drm/amdgpu/smu10: fix smu10_get_clock_by_type_with_voltage"

Yes, that should do it.  Thanks!

Alex

>
> --
> Thanks,
> Sasha
