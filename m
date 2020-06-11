Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64081F6A1F
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 16:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgFKOfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 10:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728328AbgFKOfc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 10:35:32 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E659AC08C5C3
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 07:35:31 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id y11so7183159ljm.9
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 07:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KWk0k65t0kOficvgdudXMmddBkNR1PEPUz9kdhfi4Ks=;
        b=H+m1ObQ8oA3mUjWkoURr+qG3kfHMQzxTcPyrFKEeKFLi6uzC/t9Hui5UZJJxG08xH6
         7rVdxBgDpCFUOJtSUKhIraQlbkRCokMmbht3vVYFAapq1COXAdtnr1PRIgkBrbYmlc1A
         Q077llttOxRstZhQXqv+DFJlQLw6Mi9WfCdhbL88BGeNx1D2I5qk17f6LkYZNXEr6LQD
         yde6uy2zS8EgnuXvCsCR2rxzDu/YqFDvDZHK1mN/ky43mZNJsFtLzzH7l/GXX7K1Veqj
         gq7LpoEZk8Hy3Fwcq5sivLjtdusU0/gbcevZ21LB6tTmHTE2ro17OEwx2Ve63dfzvVVL
         N1EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KWk0k65t0kOficvgdudXMmddBkNR1PEPUz9kdhfi4Ks=;
        b=fiZVLqC32zP5WfS0xeLelB3QWvukrUueS4oBBo+ZOs6+ttPkAHRNxKJ+5V/bxTp8Y3
         OFXG902YT/ith3T/rbz595atkRvEV0lO2FZZupeY168EK1G9bwnhVGcoOei2KuT1pMTl
         O6aATqS72C8F49grBVORiVRWw2SHTD4F3XG3vFCTraS/78dV+p0meqTwhOyXNTwKFB3U
         nmYOIvIvAqx417VI1mG7b6DTCGD3uACS6Ug0SEgg/1gXYAiG1JA48Eg57KzRDR72uvR9
         g8dcvJERNdPcoJ3cc0UbHP4mVfZvDSbrUCsYDhYBp1dGFRP984eOgrLkjjzfZZ/DiBot
         VC+g==
X-Gm-Message-State: AOAM5322S5crH3kJN4Efpdr4/oXOIdoZOt/nqmNW05QxbQKe1Sj7wrTK
        KlGFxm0Ju3RGDNSTKA05sYAB1V1Rs7Cex5FcVtw6
X-Google-Smtp-Source: ABdhPJybuCvUjX/x8Ef8beUk/vAnwQAMrkhFzQY6QulcBSIDD6yCU7He7Vh09xpStp55hBURCug01ltnDXo7IhR0q74=
X-Received: by 2002:a2e:974e:: with SMTP id f14mr4390482ljj.102.1591886129560;
 Thu, 11 Jun 2020 07:35:29 -0700 (PDT)
MIME-Version: 1.0
References: <159169282952.17951.3529693809120577424.tip-bot2@tip-bot2> <20200611140951.GD30352@zn.tnic>
In-Reply-To: <20200611140951.GD30352@zn.tnic>
From:   Anthony Steinhauser <asteinhauser@google.com>
Date:   Thu, 11 Jun 2020 07:35:18 -0700
Message-ID: <CAN_oZf16odNhpY6_LqkVY2wpy90jKM9-vgKo4LE8OJ-QTDCKiw@mail.gmail.com>
Subject: Re: [tip: x86/urgent] x86/speculation: Avoid force-disabling IBPB
 based on STIBP and enhanced IBRS.
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-tip-commits@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Borislav,

On Thu, Jun 11, 2020 at 7:09 AM Borislav Petkov <bp@alien8.de> wrote:
>
> Can we merge this test into the one above? Diff ontop:

Yes, I think it's fine.

> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
