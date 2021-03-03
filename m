Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BDF32BC1E
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443013AbhCCNlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355334AbhCCGeT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 01:34:19 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44003C061756
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 22:33:17 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id p16so24542051ioj.4
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 22:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q64iFG3Ey7PFtAuHICFJ86ZWqNBONNvnRLeuSXKpOtg=;
        b=MXvPcFwvaRiWoP883rxUo42wt3PIpeDZC+zNDqo2kjzhyy5GbgUnPgTxjo7j+yJffw
         GDXA3D8to2HScufzlrfo5ip3QZTfymccUZj/szpSM6L8ZlPSLq6/eY3iBXBOqmNqagZO
         QJxOBfVMkma0El+ycwMtrN1DrTMMWEjzebEyZijtVgXBxx0j5c9PQ5/tXtj255+KV7u9
         ICcSv24dqFNNmjyw5uaUJ+ih60N1aamcc8MJ9v5VAncykyaP/Mr/Zs4lwwji6educ3uf
         2BaTD8YlkaVbYi+VhbaLYJUf4P9GP40GjFU3xSN6TpT/a6Cemt6xlSvF83F6uVBPrqmu
         2HUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q64iFG3Ey7PFtAuHICFJ86ZWqNBONNvnRLeuSXKpOtg=;
        b=Tqn5tM4aDDbeF7r2NsohorJy8j+xmoUfQsE+Zs2rWmEtmY80JfHT45ivNIgb+zjx9B
         fEsrpVH3yYlfdW56pt+ipfMNiKODPrzSMvzi1khc7Tv44GksGpjjzgECRlgFAL3zxIOv
         1GAYATlrZiFJ0Fty1GFi+bjJXHOIPhximTE1boBBpMUI5ZB3TDtNgL4s3Cc0r9yCz0Ir
         v1QYaInFf7SJYbWyZzKgKc1gheJDhWlFx26VpDLZDUog8YZE/AoXdBdZu6Fyf13VCjCm
         bdig87xlrN8JrdU9xgu/nysF86/vpc59w6bu+FspG+BDcVGJ6Yo4K0wh4nqK1bMgPrir
         hYrg==
X-Gm-Message-State: AOAM532hd/aIazE6ds61NAbVhGRhC0v93Xdhdn2TpVgj+Do638LA82tC
        vyaZCfVqffEL8YHoFhr5e2dqJWUdW2j9ha0w5GVkCAts6i0=
X-Google-Smtp-Source: ABdhPJyCpTY/dQY44vqXElD0y+rta25INNXYueBqnWM8XOqYtKgomN3oUl3gHHGf5V0f4XioV1drRMydihHqMsCKmDA=
X-Received: by 2002:a05:6638:43:: with SMTP id a3mr15494012jap.102.1614753196583;
 Tue, 02 Mar 2021 22:33:16 -0800 (PST)
MIME-Version: 1.0
References: <161461457416034@kroah.com> <CAA68J_ZM-YhX+dWSw=JChPtQ-hQSJmSy_NZpD-pEWM+icVMuYg@mail.gmail.com>
 <YD02/mC7BpCKIXub@kroah.com>
In-Reply-To: <YD02/mC7BpCKIXub@kroah.com>
From:   "Cong Wang ." <cong.wang@bytedance.com>
Date:   Tue, 2 Mar 2021 22:33:05 -0800
Message-ID: <CAA68J_b+f99z15opsJnNFGN5uVkCKsDiPiYH+wDtwLPiKBFqOQ@mail.gmail.com>
Subject: Re: [Phishing Risk] [External] FAILED: patch "[PATCH] net_sched: fix
 RTNL deadlock again caused by request_module()" failed to apply to 5.4-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        kuba@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 1, 2021 at 10:53 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Mar 01, 2021 at 09:54:33AM -0800, Cong Wang . wrote:
> > On Mon, Mar 1, 2021 at 8:02 AM <gregkh@linuxfoundation.org> wrote:
> > >
> > >
> > > The patch below does not apply to the 5.4-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> >
> > This patch is not suitable for -stable due to its large size.
>
> The size here is fine:
>  3 files changed, 79 insertions(+), 41 deletions(-)
>

If you are fine with this, sure. I will take a look at your backports.

> Given that syzbot can trigger this, that means that humans can as well,
> so why shouldn't we fix this?

I meant, it existed for a long time, probably longer than what the Fixes tag
indicates, and no human reported it.

Thanks.
