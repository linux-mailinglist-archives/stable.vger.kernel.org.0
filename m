Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80E4318099E
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 21:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgCJUze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 16:55:34 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:35629 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgCJUze (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 16:55:34 -0400
Received: by mail-oi1-f196.google.com with SMTP id c1so15409752oiy.2
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 13:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=HkTg2l81dVARODKvDV4LiJ911oOSk/1lFbaHd5CQuJc=;
        b=foyL/jTnDJsIRHCRWkF634mAB1D3pxf3bA+e9onN3QbEqkPnqz/Ptu2YAKK/WxqKrz
         AtwAp9lXr1sDlSpVa7PHJwbnNqoAMke1ly3FUrG180BTCwhcNmeqBdEJghYOfN79/OOb
         lcKaBf6K7J5SqbzjRxKr8/u9tM6oHpb5ZQcb12tYI8QwJ4cKpwI1zk7Awo0o00PNN/Xs
         5i0gySygBCgYiw1mQ4CDnXqbTQCqnEErMl69Yj1S/JcaKHCADk/JAjDARViTFxBohdKF
         Fo96IuqzJ7CnaOP8eOUuBvm+mYMFKFo2oK5ydHiJqbhx6WczKMyYDeCobVwRUPuc2j2H
         u9EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=HkTg2l81dVARODKvDV4LiJ911oOSk/1lFbaHd5CQuJc=;
        b=AB1UkjqaQR0YX1pnV+0i6pIhf6UQ+8WA1Rbx3vc7X+JySTA4mC7lPg/kiDMwtJ8yr0
         tHCdEUudECKzVassF7iGu47mRmvf65Y2SC7Y6uFCX3HK6TPtFCC2dyL8ON6EVQU9+YUa
         xxTnPuxtIQ1350mnfwCabkletXEJniL4xitIrKIjgZ0OD5chr2zhzYjdr3kV49DqbwNC
         2YJF0+OM6LpK3vOLLpI6CH4JySdvJBg7bGknCaTY+yjggVK0x67OUrbjq8pnVbUp/DYo
         GADFd1zlbf4nPAzKDKVpQeQYUFiXe3wMTR68seJsLFp3splLKgHF+OLMFPhwkbmUp4Vt
         +k7Q==
X-Gm-Message-State: ANhLgQ367Btd2jpoo9dXaq0odOSPpGHi2TalA5Jsj/Vpq8tpy++KcbJn
        Qo9LCjUVzPpk+BfWUZjgM4N9MxzL0BuLAZ4ZHM3KAL4P
X-Google-Smtp-Source: ADFU+vtXQd/H1PGHCMDjHRe7pOt2ZBZi2bWVNrvO+v+9t5IKYMlAWauGCPZZyiE2ErxisH8bK4mxS4h9iD8KhodZ4tA=
X-Received: by 2002:aca:2b14:: with SMTP id i20mr2623357oik.79.1583873733566;
 Tue, 10 Mar 2020 13:55:33 -0700 (PDT)
MIME-Version: 1.0
From:   Martin Galvan <omgalvan.86@gmail.com>
Date:   Tue, 10 Mar 2020 17:55:22 -0300
Message-ID: <CAN19L9G=_FHCvwhkMYkx-1wxRD_=mO4TumM3cgA+5mxr2qxmUQ@mail.gmail.com>
Subject: EFI/PTI fix not backported to 3.16.XX?
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

I've been running some tests on Debian 8 (which uses a 3.16.XX
kernel), and saw that my system would occasionally reboot when
performing an EFI variables dump. I did some digging and saw that this
problem first appeared in 4.4.110 and was fixed by Pavel Tatashin in
commit 7ec5d87df34a. At the same time, 4.9.XX, 4.14.XX and mainline
have commit 67a9108ed431, which also solves the issue. However, the
3.16 stable line doesn't seem to have either fix, and therefore the
crash is still there.

I don't know whether any distros use 3.16 other than Debian, but it'd
still be good to have this fix backported as well.
