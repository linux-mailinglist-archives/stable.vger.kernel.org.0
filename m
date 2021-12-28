Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1A2480D9B
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 23:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhL1WLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 17:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbhL1WLH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 17:11:07 -0500
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E698C061574
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 14:11:07 -0800 (PST)
Received: by mail-vk1-xa2f.google.com with SMTP id 70so11026422vkx.7
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 14:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eUMV0HLhg30stwX25SNqA4IGRD9+grjUzIs88+Nk1+M=;
        b=GOF7NoXUc9l8RPaprx0aqdu1ycAHfm4OQl/aPB5SNtUrv2TWvjxl1qrSpAjO/iyXEM
         Lzm0K1o1HUD9rSDI3hFPK1XXIBR1AMTViVrUl2Ms9ucJv4brnsCAleOcz3nHQvdKZwKg
         WcvgS1MJ9fvM97REhYiECICNMLycroBCjJu7unK8wIu3rrDR2agnh7BjItd2MkgYRDHg
         415xlzvvI9UEBu5xSBK2sSuLr6fa5pIrXlGHko8JhYW2gRyC4Jvty8HaIvOV0UAOqOFO
         ZfXpUNJr9ZUn4OOZAaBO/OijGwFW0jMVUVdwq6zrA/L/ywk660oV7qTkwPpOs7ce2hym
         edXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eUMV0HLhg30stwX25SNqA4IGRD9+grjUzIs88+Nk1+M=;
        b=Q82M0eLVN5ezaHWxAWrj39pIhgOgGABDTZjhRZvXb+9eSXZvWWogqEP+FuIgsFZE8b
         TKpwi1+wCHERe8uzbPMPBi8MSP+Ku1dGwgu7F8HHQYDiHKc/k6bTXyzlKHEv7Q7+H7TG
         WF0QYsERogTsvEyzH5VTRtE2o5muszWY1OqhqeOqSo+IM5WrTPosFCrKSx38lMDJnhjU
         YmF1moAczfMFwKIkptApci1+JjY6GVZn3Cilo1tL8S8e/kyZeEW4BMWMQe3yiANBwzvs
         CfyDk1yseqoh6OmjpLk72JvxXk8JlEvYLp7VsKSb1Z/htnk+KCTu3AJN+5rbfHbCMnwI
         QgCA==
X-Gm-Message-State: AOAM530cZxs2JBRRbLuyhxzSdvfcd4Wd8xpcGW4qgf9iLDYi9jr6u2h3
        ZLeNYBqKqmQolDjrLXXRwQUH9GLrBSLY1nrZUTI=
X-Google-Smtp-Source: ABdhPJyp/qXqIuUBrfToUhcYojznlPB8FJQFrZrGexvtH+m/cXz7X9KD1kF7syVncuFVD47Bv6yZvw9e9xRItJIIANw=
X-Received: by 2002:a1f:218e:: with SMTP id h136mr7693316vkh.41.1640729465221;
 Tue, 28 Dec 2021 14:11:05 -0800 (PST)
MIME-Version: 1.0
References: <fdf8fe50-e3b0-2042-cc83-fb0a214d727a@tmb.nu>
In-Reply-To: <fdf8fe50-e3b0-2042-cc83-fb0a214d727a@tmb.nu>
From:   Kevin Anderson <andersonkw2@gmail.com>
Date:   Tue, 28 Dec 2021 17:10:54 -0500
Message-ID: <CAJsSGwVqgRAqjOAc7KsGn96vMPG40fYKA3ozhye_OqVt8Y6rQw@mail.gmail.com>
Subject: Re: iwlwifi Backport Request
To:     Thomas Backlund <tmb@tmb.nu>
Cc:     gregkh@linuxfoundation.org,
        Luciano Coelho <luciano.coelho@intel.com>,
        johannes@sipsolutions.net, stable@vger.kernel.org,
        ilan.peer@intel.com, johannes.berg@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 28, 2021 at 11:37 AM Thomas Backlund <tmb@tmb.nu> wrote:
>
> Den 2021-12-28 kl. 02:59, skrev Kevin Anderson:
> > Hello,
> >
> > I wanted to see if I could have two patches backported to 5.15 stable
> > that concern Intel iwlwifi AX2XX stability.
> >
> > The patches are attached to the kernel bugzilla that can be found
> > here: https://bugzilla.kernel.org/show_bug.cgi?id=214549. I've also
> > attached them to this email.
> >
> > The patches fix an issue with the Intel AX210 that I have where it can
> > cause a firmware reset when the device is under load causing
> > performance to drop to around ~500Kb/s till the interface is
> > restarted. This reset is easy to reproduce during normal use such as
> > streaming videos and is problematic for devices such as laptops that
> > primarily use wifi for connectivity.
> >
> > The mac80211 change is currently in the 5.16 RC and the scan timeout
> > is in netdev-next and is supposed to be scheduled for 5.17 from what I
> > can tell.
> >  > I believe that the patches meet the requirements of the -stable tree
> > as it makes the adapter for many users including myself difficult to
> > use reliably.
> >
>
> The mac80211 change was/is marked for stable@ and is already in 5.15.11
>
>
> the scan timeout is only in a -next tree (as you already noted),
> so it cant land in 5.15 stable until it is also in linus tree...
>
>
> --
> Thomas
>

Hi Thomas,

Thank you. I missed the fact that the mac80211 change was already
tagged for stable. I will keep an eye for the other change to land in
linus' tree and submit it for stable if it isn't submitted by the
maintainer.

- Kevin
