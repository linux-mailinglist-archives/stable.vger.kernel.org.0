Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03D6319F814
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 16:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgDFOhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 10:37:40 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:42237 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728689AbgDFOhk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 10:37:40 -0400
Received: by mail-oi1-f195.google.com with SMTP id e4so13198919oig.9
        for <stable@vger.kernel.org>; Mon, 06 Apr 2020 07:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HKnv2mBmR9yN9qbcdc4nc869BI0bnFqTUaGrPnT6uTA=;
        b=B3xgvPWZ8T2lx96w1mZdahXpIPaW72HKpYX1DYt4uw62Z7y7mVUg45SEj30PrV2ndm
         S0hWwcZil2CtWTjuAECfT8l34zn8WJtGcoXglLxjIya5v9JUkSZwt7dhJSDrzYSZBwq2
         0zQBNO+EHCXdQB+7hqYNPWV/LG44hJlCdPIHbRmmo6+0evkV3hUb8nL9KHIc7f9bgNRX
         YiYs/TFfd2tyZCG0VuHKhge9inFArDItKpqJ+Y/yC7DlFVpdnOoLdSo3u+yIP6M6jdGM
         r7Zag8dFCopstIEveBcQ0j4fU8MQttsteKGae6bFnFWwY6rDuO1XK2gjbm3hAdzdqjAO
         C7ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HKnv2mBmR9yN9qbcdc4nc869BI0bnFqTUaGrPnT6uTA=;
        b=F516L232O9RU0YevSW9XEG41t82rXDoiOIR8fBdS4KUocticLGWQQ4mY/fPbO21CVZ
         sVUaAx9ngYbJQiYfh4qNsNlyp8/A+7oBXJ4/9ys5rCx/TInhjzDsB27jHvSQyXFF+520
         v600uoi4t+zqUXRg06ZtKyAOp0gPcrEV2N5zie27As5TMQ2QWQ6/xwUhdAh2mXv3j0UY
         PE3zZr+WuoBk40IAGdBC2ARzg2egz9fn3LcBtULrF2tUTctlD9/wM6M6c3ZMyP2D+fBe
         uZA7xB9pt/GxngXU/DH725uiD4wncYTWlfgOOTd5o2lciXFSTYJqhe4E/KUqZCEp8cLM
         Uf4A==
X-Gm-Message-State: AGi0Pua/86f4QmR3J1WjxTu2aWPQf318zg/qk8IKUnhI0rpKVMEJo8BI
        bGdfwUes7pKcMD3fWa/NlAyuEimqOczebNIpSxs=
X-Google-Smtp-Source: APiQypKzgzFGl0oSEfxMKxtOqdZ0FAtlfc9GwU9pMQrABEoag8aaaJbEuVbCC89+UJaty7JdRtceG5u3lxsnXNvCF90=
X-Received: by 2002:aca:100e:: with SMTP id 14mr13204767oiq.79.1586183857889;
 Mon, 06 Apr 2020 07:37:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAN19L9Fi0h0wHOyY3zdAU4vX=J+T_3sVkL_wsq89W+RgF7gBxA@mail.gmail.com>
 <CA+CK2bCEtgvkG7jd3rm2gipKE6KQ4dzfgFGERoib5W-=pchDWw@mail.gmail.com> <8508c19359077ac33c9ef305c468a44c6ddff772.camel@decadent.org.uk>
In-Reply-To: <8508c19359077ac33c9ef305c468a44c6ddff772.camel@decadent.org.uk>
From:   Martin Galvan <omgalvan.86@gmail.com>
Date:   Mon, 6 Apr 2020 11:37:26 -0300
Message-ID: <CAN19L9FP1cSGX6Nhvq--furWcAgx3Gmm84ffy2tRzsgvCdSU+g@mail.gmail.com>
Subject: Re: [PING] EFI/PTI fix not backported to 3.16.XX?
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Pavel Tatashin <pasha.tatashin@soleen.com>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

Was this included in a new release? I'm unaware of the release
schedule for 3.16, so perhaps it's still pending.

Thanks!

El dom., 15 mar. 2020 a las 17:36, Ben Hutchings
(<ben@decadent.org.uk>) escribi=C3=B3:
>
> On Fri, 2020-03-13 at 18:41 +0000, Pavel Tatashin wrote:
> > Hi Ben,
> >
> > I have tested and it cherry-picks cleanly on 3.16. I do not see any
> > issues with backporting it to 3.16. Do you want me to send a patch for
> > review, or can you just cherry-pick 7ec5d87df34a to 3.16?
>
> I've queued this up, thanks.
>
> Ben.
>
> > Thank you,
> > Pasha
> >
> >
> > On Fri, Mar 13, 2020 at 10:09 AM Martin Galvan <omgalvan.86@gmail.com> =
wrote:
> > > Hi all,
> > >
> > > I've been running some tests on Debian 8 (which uses a 3.16.XX
> > > kernel), and saw that my system would occasionally reboot when
> > > performing an EFI variables dump. I did some digging and saw that thi=
s
> > > problem first appeared in 4.4.110 and was fixed by Pavel Tatashin in
> > > commit 7ec5d87df34a. At the same time, 4.9.XX, 4.14.XX and mainline
> > > have commit 67a9108ed431, which also solves the issue. However, the
> > > 3.16 stable line doesn't seem to have either fix, and therefore the
> > > crash is still there.
> > >
> > > I don't know whether any distros use 3.16 other than Debian, but it'd
> > > still be good to have this fix backported as well.
> >
> >
> --
> Ben Hutchings
> Humour is the best antidote to reality.
>
>
