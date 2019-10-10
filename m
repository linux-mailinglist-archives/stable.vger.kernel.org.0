Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E56A2D2C1F
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 16:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbfJJOJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 10:09:20 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44228 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbfJJOJU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 10:09:20 -0400
Received: by mail-wr1-f65.google.com with SMTP id z9so8078531wrl.11;
        Thu, 10 Oct 2019 07:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tO5W28a04FS+i+OwLxhAexOxe7uJSS3pIQOIBzkDCBo=;
        b=AI2t++eI7d3w5Pijtth2inC+llf8jcbpsdxYC3Mtq8jZ3WbHAQV6jS8WAiePSMPLxT
         Q1EwES9oUszKi20jSQsB64R/KfaIhsT7qixwLz1x5gXh5q+CU1oVtWZ509P//7lYLe+g
         ZOFh4STCURSfwS+c6P1A4TsuLLMAJZ9+jC2jzzDAz2PQFnd5c0Zt5qS2vV0OGZl78cw2
         +4fu6SQIl6FJnKxlJN+TM/zZL6YXfwzo/ZCMsvuO8iRqUpb4PjYLFAb4C6taY2dBJpNC
         7c1MBx2IRtyNnW/5yT789x0SQyzsUrBE1t5ngdys3aDQA5/li54uBmgvGS78PDlq+x30
         KNDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tO5W28a04FS+i+OwLxhAexOxe7uJSS3pIQOIBzkDCBo=;
        b=SzAJRvw+HMe6CEdtp3moUR2UfRxRG5WMQkKLj0mEQBjrXW37hTz1T8TafFrUguHZR+
         gPI8lVJEAwzTot85fqHOP0M8lxxmQIsTG5Bt2NFI/4fmbra2gIHiQrzzpag+79GwjHt3
         +lL7zXKQqIVT9jhtE/a0f6L/PUEmGhcfJx+4mLQ4WS1hJeQPnT0MDgh1cM7+j0kaAWad
         dlYnBn9/3QnzUPGfayhXIA4DIKyG0rpegKIeLcp5cXQ5DcAYvli+hFH6NQvPzKb5YQUC
         9kmNfxOr+m+vxu0KA2VaRk+b/F/QrVWhf3LPQ5Gjkd2HL/PNf1dKKcVsBfRbBweWAvq6
         xRKQ==
X-Gm-Message-State: APjAAAVmLN2kaWiH1vxmoIRJYUF9AncpiIRoYXzD1pEBeGPbrTik2fww
        N9at7M1z4yebzEF+HiSBz6JCx8Yy3wk43UXqKupDTDS+
X-Google-Smtp-Source: APXvYqzRwqF/g9Pq2VxpVRkcy6egfXsdJQqqLodWcJRxLOfjedVI3T/d51inutRBKV8D2NRh45n0feT3ag8U7NtA8Jg=
X-Received: by 2002:adf:ba07:: with SMTP id o7mr9132698wrg.50.1570716555986;
 Thu, 10 Oct 2019 07:09:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190402033037.21877-1-kai.heng.feng@canonical.com>
 <54557F79-6DE1-4AA4-895A-C0F014926590@canonical.com> <E40AB4FE-7F61-48C9-A1C9-C24454FE0586@canonical.com>
In-Reply-To: <E40AB4FE-7F61-48C9-A1C9-C24454FE0586@canonical.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Thu, 10 Oct 2019 10:09:02 -0400
Message-ID: <CADnq5_OVeqLGigRJP3XSNtoqZEEeKK=s1bO75jeG6jaBm+14nQ@mail.gmail.com>
Subject: Re: [PATCH] drm/edid: Add 6 bpc quirk for SDC panel in Lenovo G50
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sean Paul <sean@poorly.run>, Dave Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "for 3.8" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 9, 2019 at 3:12 AM Kai-Heng Feng
<kai.heng.feng@canonical.com> wrote:
>
>
>
> > On Jun 6, 2019, at 16:04, Kai-Heng Feng <kai.heng.feng@canonical.com> wrote:
> >
> > Hi,
> >
> > at 11:30, Kai-Heng Feng <kai.heng.feng@canonical.com> wrote:
> >
> >> Another panel that needs 6BPC quirk.
> >
> > Please include this patch if possible.
>
> Another gentle ping.

Reviewed and pushed out to drm-misc-fixes.

Thanks,

Alex

>
> >
> > Kai-Heng
> >
> >>
> >> BugLink: https://bugs.launchpad.net/bugs/1819968
> >> Cc: <stable@vger.kernel.org> # v4.8+
> >> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> >> ---
> >> drivers/gpu/drm/drm_edid.c | 3 +++
> >> 1 file changed, 3 insertions(+)
> >>
> >> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> >> index 990b1909f9d7..1cb4d0052efe 100644
> >> --- a/drivers/gpu/drm/drm_edid.c
> >> +++ b/drivers/gpu/drm/drm_edid.c
> >> @@ -166,6 +166,9 @@ static const struct edid_quirk {
> >>      /* Medion MD 30217 PG */
> >>      { "MED", 0x7b8, EDID_QUIRK_PREFER_LARGE_75 },
> >>
> >> +    /* Lenovo G50 */
> >> +    { "SDC", 18514, EDID_QUIRK_FORCE_6BPC },
> >> +
> >>      /* Panel in Samsung NP700G7A-S01PL notebook reports 6bpc */
> >>      { "SEC", 0xd033, EDID_QUIRK_FORCE_8BPC },
> >>
> >> --
> >> 2.17.1
> >
> >
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
