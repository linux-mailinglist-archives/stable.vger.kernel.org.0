Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74440601E14
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiJRAFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiJRAFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:05:10 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194E02F3B2
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 17:05:08 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id f140so12565550pfa.1
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 17:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UbvMCu0XnVUIatC5HjOpWZoBH39srdxVv2oZXv9o6kg=;
        b=ek41R8j3J6wTdRKFT2MnQ4muQsMMz+T6TNdhkVhnlu8cRmb/CnRGg/YXmcu6scqmCC
         r3scl4YLlMuMGrLZJPg1LTzFXQDPnQ8ttyHzXFJoXp7gpFIf6yUzrvpiFv3hYiCWIBuE
         j/1mDG0IoHcBgvUL2mLxt16p55Y+zODpquTYbZld3EmpDWerem0YkwJDan28B2f19SwN
         hWftzE2O15VP4vgQYWeNZUqWGp3o4yqshTd7bLap1TwroOvIm5FQ/ZqEnK28D88mq2t4
         43fsWX247vX5Bi6Od37oCunxlm4Qm0pS1aV778oxw8kjl0dYZ9amOQ6FwnMzyMNcK9S7
         cn3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UbvMCu0XnVUIatC5HjOpWZoBH39srdxVv2oZXv9o6kg=;
        b=7Sx6ZZ8G51I174VPCNcQ6dum7LPz2hrMY77xl4wytmvEH2AMqQgPwb9ajitpSz9eMm
         X5560eOGWAo95Fg3Xfnc9qbfR26TW6OQVtMZPp8otigaS2BQLQcK5mf0wGZ/LkfSLarC
         cqdXXRYqZQ8ufWhSt2ZCbu4+Divv3nbohk5RiwlUPNjadnYIETjevYXCEjQ+SDRUbIxu
         7Ugxv9+Qot+eK7lvnlr/mgC9TU2LwONanHZFj44FsEqygCsutLEspVV4gY142Li0AAJz
         T+Iq6ouaQC4pCR7K4lpwuXUL4HuAhnpV+yPOp7vqMzUlypPreVe0bJ4R3HJHU123WeUk
         qkZw==
X-Gm-Message-State: ACrzQf36PO4FmNffP0GqRRQYIifL3yqMwSzuw2VuXMPJvkh5iATWuxQN
        8qldse2phhLcigCXgpPInr/XbuH0w5wwPC82fCHjhA==
X-Google-Smtp-Source: AMsMyM6hVsd0XuPZrTHBzn4zdOlZacCWPRU8taK43Sx8zFOnaVmfTWG0mjGTGIJEKfua9jpsDaq/9is3dQ8xuF/d8wI=
X-Received: by 2002:a62:1a97:0:b0:562:5587:12d6 with SMTP id
 a145-20020a621a97000000b00562558712d6mr333112pfa.37.1666051507409; Mon, 17
 Oct 2022 17:05:07 -0700 (PDT)
MIME-Version: 1.0
References: <Y0mSVQCQer7fEKgu@kroah.com> <20221014171040.849726-1-ndesaulniers@google.com>
 <70a859bc-a33b-79f5-6f44-5cccfb394749@gmail.com>
In-Reply-To: <70a859bc-a33b-79f5-6f44-5cccfb394749@gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 17 Oct 2022 17:04:55 -0700
Message-ID: <CAKwvOd=L7i6iMZ6CRKWpY1yzg5QZj5FM7Rd1HtVFj-6J-qdPtQ@mail.gmail.com>
Subject: Re: [PATCH v2] Documentation: process: replace outdated LTS table w/ link
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Sasha Levin <sashal@kernel.org>, Tyler Hicks <code@tyhicks.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 14, 2022 at 7:06 PM Bagas Sanjaya <bagasdotme@gmail.com> wrote:
>
> On 10/15/22 00:10, Nick Desaulniers wrote:
> > The existing table was a bit outdated.
> >
> > 3.16 was EOL in 2020.
> > 4.4 was EOL in 2022.
> >
> > 5.10 is new in 2020.
> > 5.15 is new in 2021.
> >
> > We'll see if 6.1 becomes LTS in 2022.
> >
> > Rather than keep this table updated, it does duplicate information from
> > multiple kernel.org pages. Make one less duplication site that needs to
> > be updated and simply refer to the kernel.org page on releases.
> >
> > Suggested-by: Tyler Hicks <code@tyhicks.com>
> > Suggested-by: Bagas Sanjaya <bagasdotme@gmail.com>
> > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> Should this patch be backported to all stable releases? I see Cc: stable
> on message header, but not in the patch trailer.

I don't think so; unless people read stable versions of the
documentation rather than HEAD?
Perhaps I didn't need to cc stable, but I think that's ok for
notifying people who are interested in stable, not necessarily
strictly for backports?
Either way, thanks again for the reviews+suggestions.

>
> >  Some kernels are designated "long term" kernels; they will receive support
> > -for a longer period.  As of this writing, the current long term kernels
> > -and their maintainers are:
> > -
> > -     ======  ================================        =======================
> > -     3.16    Ben Hutchings                           (very long-term kernel)
> > -     4.4     Greg Kroah-Hartman & Sasha Levin        (very long-term kernel)
> > -     4.9     Greg Kroah-Hartman & Sasha Levin
> > -     4.14    Greg Kroah-Hartman & Sasha Levin
> > -     4.19    Greg Kroah-Hartman & Sasha Levin
> > -     5.4     Greg Kroah-Hartman & Sasha Levin
> > -     ======  ================================        =======================
> > +for a longer period.  Please refer to the following link for the list of active
> > +long term kernel versions and their maintainers:
> > +
> > +     https://www.kernel.org/category/releases.html
> >
>
> LGTM, thanks.
>
> Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
>
> --
> An old man doll... just what I always wanted! - Clara
>


-- 
Thanks,
~Nick Desaulniers
