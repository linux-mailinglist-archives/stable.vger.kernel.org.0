Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6085C47B330
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 19:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239869AbhLTStR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 13:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234026AbhLTStQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 13:49:16 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8FEC061574;
        Mon, 20 Dec 2021 10:49:16 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id 131so31505374ybc.7;
        Mon, 20 Dec 2021 10:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yq3XkX5Ybk67FSev2pv0YxhwJSiolYJ2lCI24c84oPM=;
        b=mbEe/DAE2Mt2NqkDpb1/ZVpmAIEAawX0XWFlKLUj1NvyD6BL+/P4TXRSwIDOebHkti
         JOnnfjV9hd+TIyxfEuyYBybfahTbjEzfwLknNSrblurIT6Z0BJJNC9RXgIG6yH7ZMeGq
         s/O/kqZV8VQEWL1DyGeIPl3PJDluoHvBOXAWOKuxWTgOJfM+RBalw2tW0kJL0fpxtZdQ
         W0jVOgZCpjEZuWjGQSsEfNCmHMEPcYko08+gYRQ1oQ8WuuitJ+AI3oCeAA8Wbq4Dt+Vw
         lvyjwjE1mcTPCfXdAyRfpTL5wGac6LoX0Q/XXj9ZNGbysFmncWaUyV4YpQwjk+U+nG2g
         87Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yq3XkX5Ybk67FSev2pv0YxhwJSiolYJ2lCI24c84oPM=;
        b=3hgfF0NoTAismSrA81utt9/QuwzIMFOAI1kxigjB59jT2A16JoWZqCU1CddVSyHCH7
         hnnFzamdbkdMEjqUfJ3zaDhV4SRLpZnquB15hfiMe/fEqD0Tvmp6eq9AkAdsDNNF5UBa
         Ee+kZIv9OhvxAX0s5MK4R+kb8RiM+iH8eT6H9Y9lSrtKTdTJZFKT5tDlypZe3C9E41qx
         SrffREpgisql+LNohsVqc0xxN2r3dJfqkZjcN/mhuRx30AoTurMe/ilrM4VeW1jU13+c
         z7JfkvNuYnQ/cG0Tzu7VrFMTgoTq4Ro5RUvcKa/7QWGFbTVSvObNIRvVGp8KjxGfWqTe
         wzlA==
X-Gm-Message-State: AOAM5321Q93Rji7Amg1bmjP9YZfbfvOHgsZjLzoNcLr4jY1axFk5Ov0n
        6hssZeECObnYC4drsfJJUHbvPE08w92T2MvlApg=
X-Google-Smtp-Source: ABdhPJyp9Y0T9l4klvXJ52ihdVW44XVxiAhV0l1KGboTToDy1i6iJsy4qBcsHZArHQqOZWc8MUE4Bb45i2UQB8HS4G0=
X-Received: by 2002:a25:4086:: with SMTP id n128mr24280844yba.280.1640026155160;
 Mon, 20 Dec 2021 10:49:15 -0800 (PST)
MIME-Version: 1.0
References: <163697618022.414.12673958553611696646.tip-bot2@tip-bot2>
 <20211209143810.452527-1-jdorminy@redhat.com> <YbIeYIM6JEBgO3tG@zn.tnic>
 <50f25412-d616-1cc6-f07f-a29d80b4bd3b@suse.com> <YbIgsO/7oQW9h6wv@zn.tnic>
 <YbIu55LZKoK3IVaF@kernel.org> <YbIw1nUYJ3KlkjJQ@zn.tnic> <YbM5yR+Hy+kwmMFU@zn.tnic>
 <YbcCM81Fig3GC4Yi@kernel.org> <YbcTgQdTpJAHAZw4@zn.tnic> <CANGBn69pGb-nscv8tXN1UKDEQGEMWRKuPVPLgg+q2m7V_sBvHw@mail.gmail.com>
In-Reply-To: <CANGBn69pGb-nscv8tXN1UKDEQGEMWRKuPVPLgg+q2m7V_sBvHw@mail.gmail.com>
From:   "Patrick J. Volkerding" <volkerdi@gmail.com>
Date:   Mon, 20 Dec 2021 12:49:52 -0600
Message-ID: <CANGBn6_cCd3ASh-9aec5qQkuK0s=mWbo90h0rMNwBiqsgb5AAA@mail.gmail.com>
Subject: Re: [tip: x86/urgent] x86/boot: Pull up cmdline preparation and early
 param parsing
To:     Borislav Petkov <bp@alien8.de>
Cc:     Mike Rapoport <rppt@kernel.org>, Juergen Gross <jgross@suse.com>,
        John Dorminy <jdorminy@redhat.com>, tip-bot2@linutronix.de,
        anjaneya.chagam@intel.com, dan.j.williams@intel.com,
        LKML <linux-kernel@vger.kernel.org>,
        linux-tip-commits@vger.kernel.org, stable@vger.kernel.org,
        x86@kernel.org, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Trying again since gmail didn't use plain text and the message got rejected.

We're waiting for these patches to appear in a 5.15 kernel so that we
can ship with an unpatched kernel. Will they be queued for the stable
kernels sometime soon?

Thanks,

Pat


On Mon, Dec 20, 2021 at 12:43 PM Patrick J. Volkerding
<volkerdi@gmail.com> wrote:
>
> Will these patches be queued for the stable kernels soon?
>
> Thanks,
>
> Pat
>
> On Mon, Dec 13, 2021, 03:33 Borislav Petkov <bp@alien8.de> wrote:
>>
>> On Mon, Dec 13, 2021 at 10:20:03AM +0200, Mike Rapoport wrote:
>> > Thanks for taking care of this!
>>
>> Sure, no probs.
>>
>> Lemme send them out officially so they're on the list. Will queue them
>> this week.
>>
>> Thx.
>>
>> --
>> Regards/Gruss,
>>     Boris.
>>
>> https://people.kernel.org/tglx/notes-about-netiquette
