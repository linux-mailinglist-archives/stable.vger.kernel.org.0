Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368C6480B5B
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 17:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbhL1QhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 11:37:10 -0500
Received: from mail-0301.mail-europe.com ([188.165.51.139]:56367 "EHLO
        mail-0301.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbhL1QhK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 11:37:10 -0500
Date:   Tue, 28 Dec 2021 16:37:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tmb.nu;
        s=protonmail; t=1640709427;
        bh=oKlKADHC8a/mA4GUIizz3UzV7Z87trgGi9ckINNvr6w=;
        h=Date:To:From:Reply-To:Subject:Message-ID:From:To:Cc;
        b=VGLDyN1ZhHVnOiO1Do9buk2z6NPcypTjRqsZNnHoPBIQgwuK1rdV+zG1Z+T/mfmq8
         a9ddmca3BkMpOo4nEDxviLij01yfadY0NrdFSvIxmsg6rVSoQ88ROEoiKsC+eZ2J57
         hDrqJ7anWe/rj12TuUhLnSsRTR2x1x3r1+wWiiuE=
To:     Kevin Anderson <andersonkw2@gmail.com>, gregkh@linuxfoundation.org,
        luciano.coelho@intel.com, johannes@sipsolutions.net,
        stable@vger.kernel.org, ilan.peer@intel.com,
        johannes.berg@intel.com
From:   Thomas Backlund <tmb@tmb.nu>
Reply-To: Thomas Backlund <tmb@tmb.nu>
Subject: Re: iwlwifi Backport Request
Message-ID: <fdf8fe50-e3b0-2042-cc83-fb0a214d727a@tmb.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 2021-12-28 kl. 02:59, skrev Kevin Anderson:
> Hello,
>
> I wanted to see if I could have two patches backported to 5.15 stable
> that concern Intel iwlwifi AX2XX stability.
>
> The patches are attached to the kernel bugzilla that can be found
> here: https://bugzilla.kernel.org/show_bug.cgi?id=3D214549. I've also
> attached them to this email.
>
> The patches fix an issue with the Intel AX210 that I have where it can
> cause a firmware reset when the device is under load causing
> performance to drop to around ~500Kb/s till the interface is
> restarted. This reset is easy to reproduce during normal use such as
> streaming videos and is problematic for devices such as laptops that
> primarily use wifi for connectivity.
>
> The mac80211 change is currently in the 5.16 RC and the scan timeout
> is in netdev-next and is supposed to be scheduled for 5.17 from what I
> can tell.
>  > I believe that the patches meet the requirements of the -stable tree
> as it makes the adapter for many users including myself difficult to
> use reliably.
>

The mac80211 change was/is marked for stable@ and is already in 5.15.11


the scan timeout is only in a -next tree (as you already noted),
so it cant land in 5.15 stable until it is also in linus tree...


--
Thomas

