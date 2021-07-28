Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07F53D9357
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 18:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhG1Qi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 12:38:58 -0400
Received: from mail-oi1-f181.google.com ([209.85.167.181]:39565 "EHLO
        mail-oi1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhG1Qi6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 12:38:58 -0400
Received: by mail-oi1-f181.google.com with SMTP id a19so4469173oiw.6;
        Wed, 28 Jul 2021 09:38:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CherJlzM4YGvqKLn9RV0mougYI2kDPt41trNIWs2biA=;
        b=SUynTPzkBGf0/tde9auFsk5f5q0FWqLjaeKiEgYdFtKpqNH2WcQnLPIpgwsohYFUcx
         szumhi45kvKeTzYXo/A1aQLw0KV2sNVxCF/lEdBEJ6yQBPbZY4cN7BJ7ZVpQ+1MHApP7
         LyIFQfzzrhoCBNeoB2ko0LKmIwaFZVhXq+Q+QHCueTh5arAFqNGEV7E0GTPxvUrkSCTx
         qknkE+mT1u4rxPmsuqEnxEUu7GE70LMwIQcHvc7q0pqmUHRVK2/YTBEniMyd7RgAv/Hr
         ho9VasF7Nyskl/epIEcdNfR7nSdNFUBqmx/vb6FrNOK1qF7xer9hxP8zwOzIZOVpKUrc
         MasQ==
X-Gm-Message-State: AOAM531H59gOGjB/O/3euP0T+tkt0YMFOEdfU7CuL/QqHFY0RMp890+i
        0eCpvCKSuYpen595mZKcejIdS5PjDcWO82ZpoD0=
X-Google-Smtp-Source: ABdhPJxX7nIwJRKdvPxqiHV6EUo3aU7BFVPT3TP/omLXRcoXW5LLae7T9ie2zP65wo250rEzdAApWanWcYqZ+F3id6Q=
X-Received: by 2002:aca:d7d5:: with SMTP id o204mr214340oig.69.1627490335422;
 Wed, 28 Jul 2021 09:38:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210728151958.15205-1-hui.wang@canonical.com> <YQGA4Kj2Imz44D3k@kroah.com>
In-Reply-To: <YQGA4Kj2Imz44D3k@kroah.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 28 Jul 2021 18:38:44 +0200
Message-ID: <CAJZ5v0iKTXSHRU96_xjnh4Zjh4gNfwZs9PusrX3OA059HJNHsw@mail.gmail.com>
Subject: Re: [PATCH] Revert "ACPI: resources: Add checks for ACPI IRQ override"
To:     Greg KH <gregkh@linuxfoundation.org>,
        Hui Wang <hui.wang@canonical.com>
Cc:     ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Stable <stable@vger.kernel.org>, manuelkrause@netscape.net,
        pgnet.dev@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 28, 2021 at 6:08 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Jul 28, 2021 at 11:19:58PM +0800, Hui Wang wrote:
> > The commit 0ec4e55e9f57 ("ACPI: resources: Add checks for ACPI IRQ
> > override") introduces regression on some platforms, at least it makes
> > the UART can't get correct irq setting on two different platforms,
> > and it makes the kernel can't bootup on these two platforms.
> >
> > This reverts commit 0ec4e55e9f571f08970ed115ec0addc691eda613.
> >
> > Regression-discuss: https://bugzilla.kernel.org/show_bug.cgi?id=213031
> > Reported-by: PGNd <pgnet.dev@gmail.com>
> > Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
> > Signed-off-by: Hui Wang <hui.wang@canonical.com>
> > ---
> >  drivers/acpi/resource.c | 9 +--------
> >  1 file changed, 1 insertion(+), 8 deletions(-)
>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Applied as 5.14-rc material, thanks!
