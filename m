Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DD41D28F5
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 09:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgENHmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 03:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgENHmC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 03:42:02 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AA5C061A0C
        for <stable@vger.kernel.org>; Thu, 14 May 2020 00:42:00 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id h4so29111029wmb.4
        for <stable@vger.kernel.org>; Thu, 14 May 2020 00:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fooishbar-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZWA9/LMqA4b3VlkBF3EXJYQj3K5659B/XXUAdyVkaXU=;
        b=SSi66/0Y6hCtpBzDagUQu9nsZHe3sRZSl8P800sQoFV2TAZ5v4l3iaf4v8fz6VmXko
         nOv7BPDtFdnDMQjNIod9HVy4irAHLWTfwE7H2uqirVq3ARJ/g9Z+wOzaV8rVyH/P5Rpy
         pA0x/k4IqKeUmpP5+c/Te+umtmZ/SY74KHWVsIA+8Mg9KjnhRDrFyjcKIDF1WPTfneWz
         Ddc36yuLnqp5QnSguImjev5Kw/DzWkbjWGGJXAielnV+px3Gr4Y+cWe+3msptsslr4q5
         cwJlVeVjCt9vl9AO1Tqfn/CGMtMpP5eGQDSjCuMMjTzm32WmF9GkRw9YUvYVfvdBy8LV
         US+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZWA9/LMqA4b3VlkBF3EXJYQj3K5659B/XXUAdyVkaXU=;
        b=QhGXGE60F+Wg4bltNS2Kx/2vSGjUojt1m6upOgdv3PI3ilQRQFe9uG9uoM+AY7nw3f
         XINCq/eC2O+rR9rvR5Qo0M7iurbo/tnua0bbCZITNvtCtFpWb/8kqJ5K1NfzBjt24Ilm
         xqjQ3uWirg4utF9owvSPm5yU/yDOx0U7rDmoTtBw3lRcpWPOFUnboWa/1szZFXF2xeQb
         uimcFnAFdiSgImdaJ3arCl69pphHt0vBOZxkR5xAUaxH957zWlWCtYTB0U56AB8vGD+R
         w1VVUV80STSjB2UdJDqOfgMkiq8b2iQcS+heTJszTDnFVp8VYgNDM0l5SNePL8kkhpcc
         wuzA==
X-Gm-Message-State: AGi0PuYh2ds77pWERlHuYvvmrnYDUcCB2P5BXkIEIpVuDbXruuEtoulI
        RVeUn6uo8SQkGDNEwlCGdK+m1yJ6TTe4S1t71J9P0w==
X-Google-Smtp-Source: APiQypIg1w3Jf7o/5wr4EHLUqu7AUcSm30r5cMiIA6xX1z8nEimMwDLIWcsrEf5C1hR1JZLcNv66F+pEKdDXTKTaHmU=
X-Received: by 2002:a1c:9e52:: with SMTP id h79mr46889694wme.84.1589442119280;
 Thu, 14 May 2020 00:41:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200408162403.3616785-1-daniel.vetter@ffwll.ch>
 <CAPj87rMJNwp0t4B0KxH7J_2__4eT7+ZJeG-=_juLSDhPc2hLHQ@mail.gmail.com>
 <CAKMK7uFU7ST9LWmpfhTuk1-_ES6VU-cUogMnPjA15BWFsEVacw@mail.gmail.com>
 <CAPj87rNRLsGJcGEM3dYnitYMwjh7iMNjo9KT=xcDZ0hebRC9iw@mail.gmail.com> <CAKMK7uG6krmntPW6Mud7aouvM=NRspYHoBdKeSwxS8wDwDZRkQ@mail.gmail.com>
In-Reply-To: <CAKMK7uG6krmntPW6Mud7aouvM=NRspYHoBdKeSwxS8wDwDZRkQ@mail.gmail.com>
From:   Daniel Stone <daniel@fooishbar.org>
Date:   Thu, 14 May 2020 08:40:21 +0100
Message-ID: <CAPj87rO1oG00ipUA57a1kGu7K2=-ugTreM7QXy_tWjbZ+KzkFg@mail.gmail.com>
Subject: Re: [PATCH] drm: avoid spurious EBUSY due to nonblocking atomic modesets
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Pekka Paalanen <pekka.paalanen@collabora.co.uk>,
        stable <stable@vger.kernel.org>,
        Daniel Stone <daniels@collabora.com>,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 14 May 2020 at 08:25, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> On Thu, May 14, 2020 at 9:18 AM Daniel Stone <daniel@fooishbar.org> wrote:
> > On Thu, 14 May 2020 at 08:08, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > I'd be very much in favour of putting the blocking down in the kernel
> > at least until the kernel can give us a clear indication to tell us
> > what's going on, and ideally which other resources need to be dragged
> > in, in a way which is distinguishable from your compositor having
> > broken synchronisation.
>
> We know, the patch already computes that ... So would be a matter of
> exporting that to userspace. We have a mask of all additional crtc
> that will get an event and will -EBUSY until that's done.

Yep, but unless and until that happens, could we please get this in?
Given it would require uAPI changes, we'd need to modify all the
compositors to work with the old path (random EBUSY) and the new path
(predictable and obvious), so at least preserving the promise that
per-CRTC updates are really independent would be good.

Cheers,
Daniel
