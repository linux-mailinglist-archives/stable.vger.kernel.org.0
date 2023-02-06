Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A38E168B880
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 10:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjBFJWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 04:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjBFJWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 04:22:00 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68208126D9
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 01:21:59 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id z1so11454371plg.6
        for <stable@vger.kernel.org>; Mon, 06 Feb 2023 01:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nbtLCktUnTvc6tDQd6pkWtN4dTqogS5A4cKzIwH0YbA=;
        b=bSi92/ajdDeIjs5KHu8WJlQHX37khYIKxEY6yYgfjTpKDaqOwWHWlfqkO/GDrbzkpO
         Rb90EzKTdv9nI09HKm9AdtaqcugPFTzW6fsudy/3x9SWzkgr8K4CW6Xrj0zysma405Mz
         qoWBhLPYYLPzRPQQ5K6nxdLik8zzAtZbisp4v7JY7crIS0eEnqTVfNVtET/iGszWjTT2
         Gm2afcvhuY7vucXT9kR3QydNvTp//jw4g5z7xJTWXKxyp0XEwQOxB/N6JRIACgwckotK
         nwsPBupW87UKhMdyI70nYtKUj2XAlF2q8kHoGKtgvFm7kIt1v98YgUjFSUq1wr3LmU+/
         W4Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nbtLCktUnTvc6tDQd6pkWtN4dTqogS5A4cKzIwH0YbA=;
        b=bIekXiT14nTKoLu/95wp63kglDwWeWsTFDvWxMiwe4P/G31RiZsYJAHWc8QYBiQnma
         2qGmS+AzFTacqJyJOH08uB84aLN34ZrGIEBxONcmxIEyD8+6qNc8OVkXdz8ADHluwSaJ
         zVsCAnde9jpehPsp7USa5sTBaiSSoigN0WzfblreElzkTOaL1DpyWozG4oIE2HeqXXWC
         GQba5B7lBKYZuzGV+EAZ81TNQnSOI5RwKVNxHLNduBuNvk9bX186qn8fGAvR1W5S7wSn
         RgoEMAPrEb0dZpyoBs97Y4pnZHBParoDky84CKCNcUlQP0ER9HMz4YTbO1tk5VYMGAkK
         w/EA==
X-Gm-Message-State: AO0yUKWpq3b2JmGgUM0zkL1bLQV7u44k0laLPAC0tFEtXf2t+xkxDeaw
        hRN8CQz9iqRZEwzz+Rrc3uj41ibnG7UlKz+yqT4=
X-Google-Smtp-Source: AK7set/8Qo3PLaRWxz+xDZ8MPU6yfhqZBEu1EEYECA2GC6I0WvagEzTgkCOvzrhDniA5S6jI/qZh6ChBKnADSi7B7i8=
X-Received: by 2002:a17:90a:74c4:b0:22b:f34a:1f52 with SMTP id
 p4-20020a17090a74c400b0022bf34a1f52mr2807806pjl.76.1675675318708; Mon, 06 Feb
 2023 01:21:58 -0800 (PST)
MIME-Version: 1.0
References: <CAEm4hYXr28O8TOmZWEKfp-00Y9R7Ky7C6X3JTtfm-0AD42KbrA@mail.gmail.com>
 <Y+CSwTDESQjTzS8S@kroah.com>
In-Reply-To: <Y+CSwTDESQjTzS8S@kroah.com>
From:   Xinghui Li <korantwork@gmail.com>
Date:   Mon, 6 Feb 2023 17:22:54 +0800
Message-ID: <CAEm4hYW-LzXbf-ZrsG59LrHB067NhuYkRSLzsd8RBfwzA8z1mg@mail.gmail.com>
Subject: Re: [bug report]warning about entry_64.S from objtool in v5.4 LTS
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     peterz@infradead.org, jpoimboe@redhat.com, tglx@linutronix.de,
        stable@vger.kernel.org, x86@kernel.org, alexs@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> =E4=BA=8E2023=E5=B9=B42=E6=9C=886=E6=
=97=A5=E5=91=A8=E4=B8=80 13:40=E5=86=99=E9=81=93=EF=BC=9A

> If you rely on the 5.4.y kernel tree, and you need this speculation
> fixes and feel this is a real problem, please provide some backported
> patches to resolve the problem.
>
> It's been reported many times in the past, but no one seems to actually
> want to fix this bad enough to send in a patch :(
>
> Usually people just move to a newer kernel, what is preventing you from
> doing that right now?
>
> thanks,
>
> greg k-h
Thanks for your reply~ I am sorry about reporting the known Issue.
I am trying to fix this issue right now. And I met the CFA issue, so I
just want to discuss it with the community.

We keep staying in v5.4 because we developed the product base on v5.4
3 years ago.
So it is unstable and difficult to update the kernel version.

I will try to find out a way to fix this issue.

Thanks a lot.
