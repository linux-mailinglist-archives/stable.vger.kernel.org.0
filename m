Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD62488585
	for <lists+stable@lfdr.de>; Sat,  8 Jan 2022 20:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiAHTFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jan 2022 14:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiAHTFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jan 2022 14:05:48 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D59C06173F
        for <stable@vger.kernel.org>; Sat,  8 Jan 2022 11:05:48 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id m21so36134724edc.0
        for <stable@vger.kernel.org>; Sat, 08 Jan 2022 11:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y7zBl0QJhQaIMKWir3D2qyPpg5BRTJfotr5P2ix9a6M=;
        b=CMkchWkhb1ErXHhsBqu5/I7GWoSys5Dll2s9CCHWgbXXDTKAj1iqm3HWWIH/vcg9ct
         PG41fK+4BRHbtywUpNAUeTgqPSNJGLOWOU8J2JWt3BhSFqJXuRtUKEXhnbpJAw8Aqq9k
         24+SCB0nTbaS+UYWUswSEtvSKqk2u8vwJiFrk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y7zBl0QJhQaIMKWir3D2qyPpg5BRTJfotr5P2ix9a6M=;
        b=rP69PbM0h5NGKb7HyOpnRVrpg3Nwm618Cqx6kqPy9CNgo4Sl5N8WvwcoAAIbJ/4Jfh
         mgp7p+DR6JkN0JaE/VIKn2uVC5r6UUUo3qLwtC13MXy2cPOc4SPcE0OogkrF0eHXl5JC
         TbHc7aL2QfUDKO5T4aq/oDdcFElSiC8SnErzB5d71F4getavALzc/O+LqmOUbKFigdOH
         vEO0NdRcWPtAVOzfq2o9Z7IkyUC31y70fHi8VhFd+2iInmVNSURC0vYg537/dC7qqZ9C
         jS+iI15haWcNrj+P8gFW+B7/N9S90Qctl0demkMF2tBoqondpIu3peJxFat6i69l3Ope
         dHaA==
X-Gm-Message-State: AOAM531W2T2WEFsPLJMLNGyhmQfwlTVf+XFNBSytjY9a61J/P1SSGkfs
        zJHNQSaOmneCSeuJtSLGOGlRq2LyEu8rCxjI
X-Google-Smtp-Source: ABdhPJxb3MthfJI/SZJJJfut6Th5j7kfYekylC1ZrHDS1tNd+MybMC0tCmtyve7RVxRYoft8ZqIQeQ==
X-Received: by 2002:a17:906:4347:: with SMTP id z7mr56773816ejm.671.1641668746644;
        Sat, 08 Jan 2022 11:05:46 -0800 (PST)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com. [209.85.128.48])
        by smtp.gmail.com with ESMTPSA id f15sm1059267edq.33.2022.01.08.11.05.46
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Jan 2022 11:05:46 -0800 (PST)
Received: by mail-wm1-f48.google.com with SMTP id 18-20020a05600c22d200b00347d3a13c7cso2317814wmg.0
        for <stable@vger.kernel.org>; Sat, 08 Jan 2022 11:05:46 -0800 (PST)
X-Received: by 2002:a7b:c92a:: with SMTP id h10mr15403895wml.26.1641668745875;
 Sat, 08 Jan 2022 11:05:45 -0800 (PST)
MIME-Version: 1.0
References: <d796d15c3577a35a46e4feac7e6a9e85@ercanersoy.net> <YdnBZXiGf57u6fut@kroah.com>
In-Reply-To: <YdnBZXiGf57u6fut@kroah.com>
From:   Linus Torvalds <torvalds@linuxfoundation.org>
Date:   Sat, 8 Jan 2022 11:05:29 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiRVWyT2Kg8uAdxE3T8mbWQew5EASpYS6AK7OEVDuQj4g@mail.gmail.com>
Message-ID: <CAHk-=wiRVWyT2Kg8uAdxE3T8mbWQew5EASpYS6AK7OEVDuQj4g@mail.gmail.com>
Subject: Re: [PATCH 1/1] Fix uninitialiazed variable bug
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Ercan Ersoy <ercanersoy@ercanersoy.net>,
        Security Officers <security@kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 8, 2022 at 8:52 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Sat, Jan 08, 2022 at 07:37:59PM +0300, Ercan Ersoy wrote:
> >
> > This bug is in mem_cgroup_resize_max function
> > in mm/memcontrol.c source file.
> >
> > Signed-off-by: Ercan Ersoy <ercanersoy@ercanersoy.net>
>
>
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.

Even more relevantly, I think the patch is bogus.

What broken tool claims that 'ret' is uninitialized?

That mem_cgroup_resize_max() uses an endless loop construct
(admittedly an odd one - "do while (true)" is not the usual "for (;;)"
syntax). And every single 'break' out of that loop sets the 'ret'
variable.

Whatever tool reported this is just broken, or I'm blind.

                    Linus
