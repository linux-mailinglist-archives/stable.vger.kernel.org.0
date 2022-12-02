Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D87640436
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 11:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbiLBKKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 05:10:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233363AbiLBKJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 05:09:50 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D27CCFD7
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 02:09:49 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id z192so5496320yba.0
        for <stable@vger.kernel.org>; Fri, 02 Dec 2022 02:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uE3RHUY4qDJsuTo1Mm2gm/Dk1gjThhPaW9LXX2ZWWSs=;
        b=EPaBrLkZ4fkUP8uopzdMzRKYOxEwG5iHDTNXIJo6PgmsZRA1iyJoLIYSxqm2silPbP
         newFWO815fXH4pW6+LlOBAbMLwouTSaU0vTKvV/sJOBzWqo/1G8v/STzmF56u1Exm+AH
         aZ4UVCOu7TgFAM2r+hlUrtQOfkRp1XnEYX7eup1XBXJBTTRKaVdrH3DhCWsat7R90TGX
         iwR7K7HI4vZO6bkWLbtvGlTxlexPWlM93Y+wuXspHHmMw1IM85Zj/OOx98p+NHHZkzw2
         1oPbxzYORPuHQ4AWyG0tLc20X8uOiDPg6uo8c+9OHrdpOdfYyxVhyJEWAFRcgMWL4ETz
         D8xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uE3RHUY4qDJsuTo1Mm2gm/Dk1gjThhPaW9LXX2ZWWSs=;
        b=tVI8EA4FdFmjW9I4voScy33uCEndJtsEO7Jq+sz/z0D+HXnHSwXlcUgHSHBfbFePyM
         kFuj1amtC3ypNYSyY2hZXDLQJEGK09o5ACkpxzoHa1Zi6IxLcFXOqR3R1uQOw3tL81i7
         zbht5ATVFSXwhFUUbA0P9NyxG7aS4YjpxEisjDdC/O647pe3ZTQ0lbvMoOYjwOlO7LN1
         B6T3CyTb3E2eqQ9k6467zs7+MyqUu0HZ5+hPxb4zoY65IqMjvLPjoNQLhimYE605DTVt
         r7fyabnbd0Ypgz9AMITEUhH3Kbcf/JVqbzTuUpu4dyrxxVvqhGziYahzahXqbEugQrqn
         WqKw==
X-Gm-Message-State: ANoB5pl2C/KYPoqUVgipVQ2dt7nODnXn8IuH2BBt7W6xfL1nDFlU02j4
        G9x1o7LTKDiEpqP0zXkR6A5cpDwHUT8qp9Cdi8bf6w==
X-Google-Smtp-Source: AA0mqf4qrHnBmItNuN2Sb8T6ME/Nzligux3z6GGs7/pyfkazZNenMyaJVS5oU7yFwrZZj6rTT6rkfz5IGFlDRxsKREA=
X-Received: by 2002:a5b:505:0:b0:6e6:6f6e:95ff with SMTP id
 o5-20020a5b0505000000b006e66f6e95ffmr47433566ybp.582.1669975789182; Fri, 02
 Dec 2022 02:09:49 -0800 (PST)
MIME-Version: 1.0
References: <20221128195651.322822-1-Jason@zx2c4.com> <9793c74f-2dd0-d510-d8b6-b475e34f3587@leemhuis.info>
 <Y4nJe+XMoNwTVjlh@zx2c4.com>
In-Reply-To: <Y4nJe+XMoNwTVjlh@zx2c4.com>
From:   =?UTF-8?B?SmFuIETEhWJyb8Wb?= <jsd@semihalf.com>
Date:   Fri, 2 Dec 2022 11:09:38 +0100
Message-ID: <CAOtMz3P0e=8bR2RsxPB0EfsbW0CrvtasHOPgCRb2xQrr+m9yYw@mail.gmail.com>
Subject: Re: [PATCH v3] char: tpm: Protect tpm_pm_suspend with locks
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Jarkko Sakkinen <jarkko@kernel.org>, peterhuewe@gmx.de,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        linux-integrity@vger.kernel.org, jgg@ziepe.ca,
        gregkh@linuxfoundation.org, arnd@arndb.de, rrangel@chromium.org,
        timvp@google.com, apronin@google.com, mw@semihalf.com,
        upstream@semihalf.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jason,

Thanks for taking care of this!

Re 2/3 and 3/3 as you mentioned earlier, will get back to this when I
have some bandwidth and send it separately.

Best Regards,
Jan


pt., 2 gru 2022 o 10:46 Jason A. Donenfeld <Jason@zx2c4.com> napisa=C5=82(a=
):
>
> Thanks for handling this, Thorsten. I had poked Jarkko about this
> earlier this week, but he didn't respond. So I'm glad you're on the case
> now getting this in somewhere. Probably this should make it to rc8, so
> there's still one week left of testing it.
>
> Jason
