Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E801565D6AD
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjADO5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:57:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239465AbjADO4w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:56:52 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10E2BF49
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:56:51 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id v70so29700395oie.3
        for <stable@vger.kernel.org>; Wed, 04 Jan 2023 06:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ralston.id.au; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ofz/y3FhP6VUDywdGg5+DJeyYF7KJW5MeQOUiXDEaj8=;
        b=L/nIXdSXduxZ/CNHNbtBEPIlDS8BzYT2DeIXy3mW2Pt/OM21X1+fcLV/lCxGmORHIk
         VXn5hZpuZkSydB4qvfGjQezIK48g6AZBJpMyFtQqoCU0MzC38meMDqPPrew7Vv1OtrO3
         TWAhVm/iAcQApq/25z0ekru/NK5WAtSj1XeRQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ofz/y3FhP6VUDywdGg5+DJeyYF7KJW5MeQOUiXDEaj8=;
        b=RV6H9GGtFOcu3JUObs5B44Iua5o/bWG3EOpn3Y2n0N9z0bZoFQ/S98o83Ti7C2Mrx2
         a4jgS4NsMA3UPcN5itQcmhJqXsYjURXltI+erEranXey7yqhhuDfO7cgkcXzkuEHdjlE
         72dRcmOSPR+sHZN63SXTtL80lN4aJLYhk3D3yJ9pm1foZIv0VzvUpdLkkE445NiiA4Oh
         3Eo/7cUwZHtUFvVfvG2f1rX+HMNNS5TShudIpNh4+Npb2eBwhLOg9JQ1uaaHgE+ONBP9
         +s7p+0I+OpONdAnHWm6eekQkcXUl2C/iBiyuUjtfoBshmCjC1oabb/ostpcs1FlU/bS9
         BupA==
X-Gm-Message-State: AFqh2kobWZ+Jc1KPz2IUM16uCC5lvHra2X/ZbEIbgN8eXaFJviqBOlA4
        R/ljcd51nwOrQeEDjnhUEaz1T3SBLW3zl6zRqln5592qhtkWhSiW
X-Google-Smtp-Source: AMrXdXuQzlkjEsymLTUFsBgrJPzGoYT2zReCDRWDPCTePLIEVE1m+BDYNcJFe+60I5hy8VdLVN3u5MqJx+87kHBXUJM=
X-Received: by 2002:a05:6808:48d:b0:35c:3327:ecf0 with SMTP id
 z13-20020a056808048d00b0035c3327ecf0mr2487333oid.220.1672844211273; Wed, 04
 Jan 2023 06:56:51 -0800 (PST)
MIME-Version: 1.0
References: <CAC2975JXkS1A5Tj9b02G_sy25ZWN-ys+tc9wmkoS=qPgKCogSg@mail.gmail.com>
 <bf646395-1231-92f6-7c5a-5b7765596358@leemhuis.info> <87zgb0q7x4.wl-tiwai@suse.de>
 <CAC2975K24Gt3rGieAToHjb7FEHv84aqiRSQx7EOuR2Q7KByUXw@mail.gmail.com>
 <87sfgrrb5f.wl-tiwai@suse.de> <CAC2975+cUqiFC0LO-D-fi0swH+x=_FMuG+==mhg6HH4pc_YDRA@mail.gmail.com>
 <87bknfr6rd.wl-tiwai@suse.de> <CAC2975+CP0WKmXouX_8TffT1+VpU3EuOzyGHMv+VsAOBjCyhnA@mail.gmail.com>
 <878rijr6dz.wl-tiwai@suse.de> <CAC2975+Ybz2-jyJAwAUEu5S1XKfp0B-p4s-gAsMPfZdD61uNfQ@mail.gmail.com>
 <87zgazppuc.wl-tiwai@suse.de> <CAC2975+476CHDL3YM=uExHu96UB2rodAng9PVYHX+vGnSCppGA@mail.gmail.com>
 <CAC2975Ja-o6-qCWv2bUkt3ps7BcKvb96rao_De4SGVW1v8uE=A@mail.gmail.com>
 <CAC2975KFqvTitbJHJZ6a4Tuxsq=nPGvW3vjAAtkQxw=sBgeDqw@mail.gmail.com>
 <CAC2975Jw63j26DhvDjiLc7dXwaRz=eK0aWNuErQ8dkEn_Gemjg@mail.gmail.com>
 <87ilhmpvdt.wl-tiwai@suse.de> <CAC2975LFWnK6f05j5my4=ebmhS0bVhigz8VH6cbaUtVT+ADxbA@mail.gmail.com>
 <87zgaymkcx.wl-tiwai@suse.de> <CAC2975LK6xuQ_PaD9vk_5Uwi4ZmZa30TZKfstyAhx2tv0YU9xQ@mail.gmail.com>
 <87y1qimjsw.wl-tiwai@suse.de>
In-Reply-To: <87y1qimjsw.wl-tiwai@suse.de>
From:   Michael Ralston <michael@ralston.id.au>
Date:   Thu, 5 Jan 2023 01:56:15 +1100
Message-ID: <CAC2975+dBD9ox0qu0Km_5g=7zifH4GCACdWMh=kXSgGimmyO7A@mail.gmail.com>
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

On Thu, 5 Jan 2023 at 01:54, Takashi Iwai <tiwai@suse.de> wrote:
>
> OK, thanks for confirmation.  Then we should revert this, as it was
> meant only as a minor optimization.
>

I'm glad I could help find the issue! Keep up the good work.

--
Michael
