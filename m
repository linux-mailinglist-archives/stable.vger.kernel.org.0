Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E1B65C77F
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 20:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbjACT1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 14:27:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239109AbjACT0G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 14:26:06 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7597513DDC
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 11:24:53 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id h185so5377064oif.5
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 11:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ralston.id.au; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=a1Pvovz6KD/rGdi5Cr+RhhTptgsnk7UiVcQNAM8+eBU=;
        b=A3iZHMq1qX7BLuv8LOjD2/WgSAjRCflHSb5ljgUjZXfI8UO7kxCSKjMML05dAGROBq
         Brk9fkjqudbKAi0IhPSRvRw8xF/XcmKn2bWbYCmQCa+KKDylcfx7e0By5aHaOZYzMbB/
         Q3T4Oeed30ocfaOtl6ejPaxlyYYpEkjoNQ5Hk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a1Pvovz6KD/rGdi5Cr+RhhTptgsnk7UiVcQNAM8+eBU=;
        b=fjPZ9MASzJ3accHoi8AqfBF2o2r7HOmmOH2Tj7qbaeN9hfSwrnBTdXT2AXXDsVh0+Q
         Jy2tbTX0NGFlmhq1XQMd7RBJhYgptSNOw81K8g6pXjrnj8UGOlaNmpCxI6hGJyTdCaJU
         6jr6Fzz34RPjhdVTP1SQqsd3DKfua3UXEQyONHpcefzzaCbDM6fESTR2ycMYCn0hW77q
         J4turx7baaqnfCqnt3eKvC71ePiHaYPUttVBDgWvYWkh209HwdSikKKCu/VH9GNF0tYJ
         M5mN3P7RENMKeT6VVEXAsuiLY+qUe49Z1kMq/CuwGaGHIVSg+x0P7e53KuXS6UpZJs88
         2NMQ==
X-Gm-Message-State: AFqh2kpSb5BYSyYfu52KVFvPAC8n8GzNz4DnTj99qQ+Eb/LAqjf9aEeM
        a2DVL0G8xX3I5aVy/0RbVWLyH5c/qREpfS62D3yBDQ3ePoA09VUX
X-Google-Smtp-Source: AMrXdXsSrUBgeuZr11V5MVDq1ahDjM3YnzlwexugjDHVzjW3s/niOCBfKCmmzgVetZXBqZkQUi4GfRfYldJc0F2Ls1w=
X-Received: by 2002:a05:6808:48d:b0:35c:3327:ecf0 with SMTP id
 z13-20020a056808048d00b0035c3327ecf0mr2314709oid.220.1672773892807; Tue, 03
 Jan 2023 11:24:52 -0800 (PST)
MIME-Version: 1.0
References: <CAC2975JXkS1A5Tj9b02G_sy25ZWN-ys+tc9wmkoS=qPgKCogSg@mail.gmail.com>
 <bf646395-1231-92f6-7c5a-5b7765596358@leemhuis.info> <87zgb0q7x4.wl-tiwai@suse.de>
 <CAC2975K24Gt3rGieAToHjb7FEHv84aqiRSQx7EOuR2Q7KByUXw@mail.gmail.com>
 <87sfgrrb5f.wl-tiwai@suse.de> <CAC2975+cUqiFC0LO-D-fi0swH+x=_FMuG+==mhg6HH4pc_YDRA@mail.gmail.com>
 <87bknfr6rd.wl-tiwai@suse.de> <CAC2975+CP0WKmXouX_8TffT1+VpU3EuOzyGHMv+VsAOBjCyhnA@mail.gmail.com>
 <878rijr6dz.wl-tiwai@suse.de> <CAC2975+Ybz2-jyJAwAUEu5S1XKfp0B-p4s-gAsMPfZdD61uNfQ@mail.gmail.com>
 <87zgazppuc.wl-tiwai@suse.de> <CAC2975+476CHDL3YM=uExHu96UB2rodAng9PVYHX+vGnSCppGA@mail.gmail.com>
In-Reply-To: <CAC2975+476CHDL3YM=uExHu96UB2rodAng9PVYHX+vGnSCppGA@mail.gmail.com>
From:   Michael Ralston <michael@ralston.id.au>
Date:   Wed, 4 Jan 2023 06:24:16 +1100
Message-ID: <CAC2975Ja-o6-qCWv2bUkt3ps7BcKvb96rao_De4SGVW1v8uE=A@mail.gmail.com>
Subject: Re: USB-Audio regression on behringer UMC404HD
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        alsa-devel@alsa-project.org, regressions@lists.linux.dev,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 4 Jan 2023 at 06:09, Michael Ralston <michael@ralston.id.au> wrote:
>
> On Wed, 4 Jan 2023 at 03:03, Takashi Iwai <tiwai@suse.de> wrote:
> >
> > OK, thanks.  Then it's not about the USB interface reset.
> > It must be subtle and nasty difference.
> >
> > Could you apply the change below on the top?
> > It essentially reverts the hw_params/prepare split again.
> >
>
> Very sorry to say this still hasn't fixed the problem :(
>

I did a diff between the sound/usb directory for 6.0.16 and 6.1.2 and
reverted that entire directory.

It is working with that change, so there must be something else.

Michael
