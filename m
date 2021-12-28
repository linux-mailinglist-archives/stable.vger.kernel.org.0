Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D20480D9E
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 23:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbhL1WM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 17:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbhL1WM1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 17:12:27 -0500
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDB1C061574
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 14:12:27 -0800 (PST)
Received: by mail-ua1-x929.google.com with SMTP id v14so16629808uau.2
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 14:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KgnW6hDvw4Xm3UsB1Ur72oT67VzyjPXMVopq2T9K87A=;
        b=G8W+8aHLdSNNZ3kGU30YrZ6PspoN18j2Y06ng35HNLuwBS0Yzcihm5WKGdJJRHbmnV
         e8CiH23y+8x0GSSrrzMoIMuOFZJsisD7PLHD4e1+fNGdf0+v6aBcGpWasHwRHmAxDjbK
         3Gpuu+EOdF8uIspFjzpxAGX5SRdTIo/5O257nbDP/4jpFoB1Iz0/+JzeYo9NYRPV7hwY
         gFRfjlDSI/yVYbJ2QZtqi5PpX12/y+6sVSVJQMhSJKtvvDkVjRfaSTgH8Wyssa8mYXAz
         zxFR6pvX0R0X+CKiYSni763mmpNpG6U+mAclQvoZg64aTI+snPn1lcn0Jr3HXOJMeyP2
         GyTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KgnW6hDvw4Xm3UsB1Ur72oT67VzyjPXMVopq2T9K87A=;
        b=YzJztqY4aZ2zMrUwDkm2WJxm9xK6J2kwVMS+gD+ra3BF+lcAm9nVpy2NH1SjIEJuHA
         qYMufwKmlm/5yUUnGpbef5ei5rGGPaKTrCn5qIgaJQnR5Z6aUcFxYQgX5ZoKXcs6BFtj
         UM27rQaO0ncFEwYLASj7oAmOp2CsCHnt47ixy2Ug5CbrIjk4H8Odqdvd+mMsgTxa98uO
         izBa4YYUkItRN0kJz/iknTpOIpOiZzDE4z6CfSy9/1gAFyqPRAYLEEZTtdDtrv6XlVzO
         eEMZzptt4a0QZiwd13/MKHKv28NJXttjDeOeo2VUtKYBJbBUF4DUUFoOExdqk1DQ/wnO
         Ro3Q==
X-Gm-Message-State: AOAM5335JFtkLb7kayxAI4675ThPzJjIM74tUDiEjCx//cRlySpMCiEv
        sh+Z7mSklFWcnDRik3tPp+JPDMAELefQTe8F0EY=
X-Google-Smtp-Source: ABdhPJwTZoZ7Yv47x2oROD4+eOkZDBrMxRUvBW5W/Z0vRrXnPsnsHBkq7nK4GcOoBzMj7SZHt/i4UV5rgu0gu+LXrlo=
X-Received: by 2002:ab0:6813:: with SMTP id z19mr6991030uar.28.1640729546601;
 Tue, 28 Dec 2021 14:12:26 -0800 (PST)
MIME-Version: 1.0
References: <CAJsSGwWz3qncvb-XkpZefJsCJ1wfCPaiHVdJ-BTFSdiFWvhmRQ@mail.gmail.com>
 <516a36e229e9d57fb9640d44ca4920446b38c6dc.camel@intel.com>
In-Reply-To: <516a36e229e9d57fb9640d44ca4920446b38c6dc.camel@intel.com>
From:   Kevin Anderson <andersonkw2@gmail.com>
Date:   Tue, 28 Dec 2021 17:12:15 -0500
Message-ID: <CAJsSGwXvpRHAYU3AX2iYK5cr2OhOFTb10R3kMbSRSsfyFo=E5Q@mail.gmail.com>
Subject: Re: iwlwifi Backport Request
To:     "Coelho, Luciano" <luciano.coelho@intel.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "Peer, Ilan" <ilan.peer@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Luca,

Thank you for the guidance!

- Kevin

On Tue, Dec 28, 2021 at 1:46 AM Coelho, Luciano
<luciano.coelho@intel.com> wrote:
>
> On Mon, 2021-12-27 at 19:59 -0500, Kevin Anderson wrote:
> > Hello,
>
> Hi Kevin,
>
>
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
> >
> > I believe that the patches meet the requirements of the -stable tree
> > as it makes the adapter for many users including myself difficult to
> > use reliably.
> >
> > If this is the incorrect venue for this please let me know.
>
> You can send the patches directly yourself, but not as attachments and
> with with the following tag added:
>
> commit <SHA1 of the commit in Linus' tree> upstream.
>
> You can find more info on how to do it here:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/stable-kernel-rules.rst
>
>
> Thanks for your help!
>
> --
> Cheers,
> Luca.
