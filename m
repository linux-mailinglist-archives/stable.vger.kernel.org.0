Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58F2320A5F
	for <lists+stable@lfdr.de>; Sun, 21 Feb 2021 14:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhBUNE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 08:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbhBUNE1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Feb 2021 08:04:27 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83D8C061574
        for <stable@vger.kernel.org>; Sun, 21 Feb 2021 05:03:46 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id hs11so24745973ejc.1
        for <stable@vger.kernel.org>; Sun, 21 Feb 2021 05:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5UFOd4n0SdIi2wzwSi6M/Okvn2zak4gBx4aHvQhRqig=;
        b=k9bc/xW8HtNMAP9tftVBrNAtsOZO6BcFmEGegJPhFbhLDxv0SsdDwymvM8rkxzzzXZ
         wFTmmCCKA7SP9IHC9uHBIWqeJEiJpFMhKG1nVmR7lfq5RTltuHJ7+lybuAjiEZdaSud7
         C8qOdJhqtiWU0X9pXrssywjDEpges/fmlNvLeRZQO4YOUohjIoK0SxVk6NPgPd8zcnk8
         0En+ANUll3BbCNIIN/fJLMrMFYer2z2nvmf5d23b1gGIZ8kH9AtRuqw/Khwuc+1RxajS
         sFtkZNWQyW/Tys+b4rLeCHFAi2A5yfih2lVX/kAyrI2BsaHQNT/PlUzJch0kBAulq9GG
         +HWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5UFOd4n0SdIi2wzwSi6M/Okvn2zak4gBx4aHvQhRqig=;
        b=qQLcEulG3LI/fNbdudRFxP+hNBuv8T2NCd4i2iMMEBcspc3nzgb0ibHQtSWO35nIt2
         9eSHBkfE54N1vL6aC0s21ZUe1LQb9wvEgW1jnZ0uQQhqRIveBkxhmIl46WwRkDtI/qhN
         Tw0XnqmftFtgaIewdrC+9Zv0/dyP93MUU8jrgwewH/EEPbx/mR+Cnun2IqadnJyW+g0w
         S3KaFm1BKYDY1VYN/iBedyg+taIcdPcXR5gRmZijCZub7iICNbOdi0dwSGaGPD8wDfoa
         OmvU6Fs8/kdn6k6nv+CwDVBbb6l2RmV3+jOkIs9U49GlVd15mWWjEn3NLvWErORDgpUf
         Cuow==
X-Gm-Message-State: AOAM5330bPqIVJOIQ/ug1O+4oDM2e2GcTUfB+vdNJJaUoZDAlNOgRJ3n
        7+fv/FFL5dnHsfVV3e/Fm+o4OnjnhJddVpklQCs=
X-Google-Smtp-Source: ABdhPJzojSXIJmOStuelkxUDcDzp2gZgwPBGtoZzVXIy/J4XqjzQka9jC89pOELM1IGqbc22vatHxo9n1/CK/iaSNVA=
X-Received: by 2002:a17:906:b84d:: with SMTP id ga13mr16408059ejb.112.1613912625376;
 Sun, 21 Feb 2021 05:03:45 -0800 (PST)
MIME-Version: 1.0
References: <YDJWEh5qNUQbXcv2@eldamar.lan> <YDJXvYLSUQ3P0iMz@kroah.com>
In-Reply-To: <YDJXvYLSUQ3P0iMz@kroah.com>
From:   Trent Piepho <tpiepho@gmail.com>
Date:   Sun, 21 Feb 2021 05:03:34 -0800
Message-ID: <CA+7tXij-wK3-tswGx2sQMR60wbThZPg_C3yuVXFVfbgSSi7ecw@mail.gmail.com>
Subject: Re: Please apply commit 517b693351a2 ("Bluetooth: btusb: Always
 fallback to alt 1 for WBS") to back to v5.10.y
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 21, 2021 at 4:53 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sun, Feb 21, 2021 at 01:46:10PM +0100, Salvatore Bonaccorso wrote:
> > Hi
> >
> > 517b693351a2 ("Bluetooth: btusb: Always fallback to alt 1 for WBS")
> > was applied to mainline fixing (restoring) behaviour to pre 5.7. As
> > the commit message describes in effect, WBS was broken for all USB-BT
> > adapters that do not support alt 6.
> >
> > Can you consider it to apply it to back to 5.10.y?
>
> I do not see any such git commit id in Linus's tree, are you sure you
> picked the right one?

Full hash is 517b693351a2d04f3af1fc0e506ac7e1346094de.

Looks like it should work as I intended on current 5.10.y, but I
didn't test that kernel.
