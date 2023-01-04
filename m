Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55D6C65D67F
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbjADOsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbjADOsJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:48:09 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE5A30B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:48:06 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id x44-20020a05683040ac00b006707c74330eso20863287ott.10
        for <stable@vger.kernel.org>; Wed, 04 Jan 2023 06:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ralston.id.au; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=s4IRr68MatcS5enSJ+4EyfBihOdqulU9DD8OJv71rX0=;
        b=cyVTpqqBgR+DLc3/b4X7pbrsHIhFZ8b9/sb8OvVJZj421M6qv+O/7IAMBY2Y3PasKp
         e/NFl+Yy9J+l03eMBeZEeMN0tVFqSP0IiC4kWCz+0CZbqM9VflKNLj+rI2TvfccAcAfd
         0gXxpj0+upTyhKN0znkURqxfLQEWxYp6Kmg64=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s4IRr68MatcS5enSJ+4EyfBihOdqulU9DD8OJv71rX0=;
        b=j+VkhQT8Dmr0LbgkaXcnAy144sfIhtgIYYGt1BWUj345+RfayAWdm/kjp/K3yR4661
         kSFnUDXsf7vlJjQvr9dP71MCxQibTtLcUeicJ+yLRTL03q5tZIYNUovQoYyk0XKhyFUm
         ESzzMrpVq2hXim5RKBh6jllXHt7sl3ut8lVLYyvTqlolJScivrJYLqzJMEATxY3N0CZ7
         nLgU1DZsenBdBF7fq5uPGgrnyHI+GriLgiUjEV7prSObxS/J+xiwBqQhFrToJL5tV5zH
         /NQYGRTR+v/9Qi0a6qocZWrIZllfTwCe22/jTk5PXUvc+J/Bjo/7CW1Qsh2f9yAgW7mR
         WBFg==
X-Gm-Message-State: AFqh2kpzjC7Rw0Tmf7RBK/Qcir88fu/Jd544mitr4lbKfxE+8Z6qWbPT
        clEZsD41HSyyuJybfYCJ6dfYmU6U6x7nzjwn8XHsFg==
X-Google-Smtp-Source: AMrXdXv73rNorkMl6cG0cOQ7nvMTlCtZinuYWTFUsuzOa7bcFehB5DdMFB01EPykptneOgFz3/6BlqeBf0Gjl0o3V74=
X-Received: by 2002:a05:6830:1c8:b0:66e:b992:749f with SMTP id
 r8-20020a05683001c800b0066eb992749fmr2595450ota.52.1672843686199; Wed, 04 Jan
 2023 06:48:06 -0800 (PST)
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
 <87zgaymkcx.wl-tiwai@suse.de>
In-Reply-To: <87zgaymkcx.wl-tiwai@suse.de>
From:   Michael Ralston <michael@ralston.id.au>
Date:   Thu, 5 Jan 2023 01:47:29 +1100
Message-ID: <CAC2975LK6xuQ_PaD9vk_5Uwi4ZmZa30TZKfstyAhx2tv0YU9xQ@mail.gmail.com>
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

On Thu, 5 Jan 2023 at 01:42, Takashi Iwai <tiwai@suse.de> wrote:
fb425e1121ceef2b9d1b3ffccc195d55707
>
> Oh, did you test with 6.2-rc?  I checked the reverts only on top of
> the 6.1.0.  From there, you can revert all mentioned commits cleanly
> and should build.
>

I was basing everything on 6.1.2

> In anyway, do I understand correctly that the bug still persists at
> the revert of the commit 2be79d58645465351af5320eb14c70a94724c5ef, and
> it's fixed by the revert of ac5e2fb425e1121ceef2b9d1b3ffccc195d55707?

Yes that is correct.

>
> If so, what happens if you revert only
> ac5e2fb425e1121ceef2b9d1b3ffccc195d55707?
>

I just tested this, and that also fixes the issue.

--
Michael
