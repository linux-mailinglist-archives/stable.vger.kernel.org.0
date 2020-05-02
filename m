Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFD01C264D
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 16:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgEBOwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 10:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbgEBOwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 May 2020 10:52:18 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB0FC061A0C
        for <stable@vger.kernel.org>; Sat,  2 May 2020 07:52:17 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id x4so3247740wmj.1
        for <stable@vger.kernel.org>; Sat, 02 May 2020 07:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=eUmO9lFyYnSEUotvSkDdW7nX84l9YUGsDR7MyoCN3CU=;
        b=YJr5Y8afBHWlluBWUgx/5EYN6hyE6dcLw2z1n9vRkLHzQbpSGBhpcOfqygIy3U0gu3
         ZU0X0/T6IEfb9apK8ibAiOkQJB8QlmXhpHVMRe9jOCvalPLCRrcDaDdUz7BHVGmDsBdG
         u0quqzJnaF5I8H1s35iZ55qzUq6QYCjn4YnQcYk32wqe6fgKXVJnpcLkiex+yTPHan9n
         mVgx3/aJ99LjjauFWmgwTQallkMJgpWyd89bUQVy+MrLy5YJ3z9ta+ZgPG+Kt5yzEzD+
         h/CVwqzTMwVfGsIiYzVW3V/WuilTmu0Zdf20RW+WSqc2FJpiUV/KjciIkYOVE8Y0RaLJ
         nMPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=eUmO9lFyYnSEUotvSkDdW7nX84l9YUGsDR7MyoCN3CU=;
        b=ODbcuzJx412Dgo0QYn6lPl2yZNDRz0LTjxVRJ5Nf0ahtQDUhpRi6bDxHQMoPYM8rAU
         ULlNLUf+QmW/AQoapypEnL+WhK27BwV85+PXNPw+WS1iyIIxFoPJfNatXDoibzJgyNeO
         zSEcWBFhEjfvmYaQW6lvShhJjX3y8KEYVvJsPm5tGN8b9GC+qslBKS5oUNp7NTyB4KxH
         Thp2EPUXEC2t4n++5Ir6a9m+HRsy5trDi1J80AkvKrjNgQsVA1NTY9ydS9WWamHi18Sx
         /7D6JXclq0sX2FVYQXgbV3kx1u0Vz4v0wqr3dKprUvZTZ/9k3keyldv827VfF3ZMKk1K
         askQ==
X-Gm-Message-State: AGi0PubgjF1TZSFj8HmiPjW0M96awCNfWdm2W10bw2Ss1fiwknHeFwoF
        CiweqGHB84HKCwaGX12QUMrOzZZQYnE=
X-Google-Smtp-Source: APiQypLQZrhbbLoB4l9/FVLUeKO9DpS30JZtXUoebbOs+GhYQzJCdHKM8cIDEnbn665XnkBqaQKeSA==
X-Received: by 2002:a1c:6389:: with SMTP id x131mr5212531wmb.155.1588431136061;
        Sat, 02 May 2020 07:52:16 -0700 (PDT)
Received: from localhost (cag06-3-82-243-161-21.fbx.proxad.net. [82.243.161.21])
        by smtp.gmail.com with ESMTPSA id 92sm10023040wrm.71.2020.05.02.07.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2020 07:52:15 -0700 (PDT)
References: <5eabecbf.1c69fb81.2c617.628f@mx.google.com> <cc10812b-19bd-6bd1-75da-32082241640a@collabora.com> <20200501122536.GA38314@sirena.org.uk> <20200502134721.GH13035@sasha-vm> <20200502140908.GA10998@kroah.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Mark Brown <broonie@kernel.org>,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        kernelci@groups.io, Kevin Hilman <khilman@baylibre.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: Re: stable-rc/linux-5.4.y bisection: baseline.dmesg.alert on meson-g12a-x96-max
In-reply-to: <20200502140908.GA10998@kroah.com>
Date:   Sat, 02 May 2020 16:52:14 +0200
Message-ID: <1jd07mie3l.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Sat 02 May 2020 at 16:09, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Sat, May 02, 2020 at 09:47:21AM -0400, Sasha Levin wrote:
>> On Fri, May 01, 2020 at 01:25:36PM +0100, Mark Brown wrote:
>> > On Fri, May 01, 2020 at 12:57:27PM +0100, Guillaume Tucker wrote:
>> > 
>> > > The call stack is not the same as in the commit message found by
>> > > the bisection, so maybe it only fixed part of the problem:
>> > 
>> > No, it is a backport which was fixing an issue that wasn't present in
>> > v5.4.
>> > 
>> > > >   Result:     09f4294793bd3 ASoC: meson: axg-card: fix codec-to-codec link setup
>> > 
>> > As I said in reply to the AUTOSEL mail:
>> > 
>> > | > Since the addition of commit 9b5db059366a ("ASoC: soc-pcm: dpcm: Only allow
>> > | > playback/capture if supported"), meson-axg cards which have codec-to-codec
>> > | > links fail to init and Oops:
>> > 
>> > | This clearly describes the issue as only being present after the above
>> > | commit which is not in v5.6.
>> > 
>> > Probably best that this not be backported.
>> 
>> Hrm... But I never queued that commit... I wonder what's up.
>
> I saw the Fixes: tag, but missed the changelog text.  My fault.
>
> I'll go drop it from everywhere, sorry about that.
>
> greg k-h

Hi everyone,

Sorry for the mess this seems to have triggered.

Indeed, with the Fixes tag, I understand why the patch has been picked
up. Even I thought that a backport would be OK, since the mistake was
quite old.

If I had wrote it correctly from the start, I would have found the
problem that was waiting for us in ASoC ... but the 2 errors cancelled
each other out.

It is only now that ASoC has been fixed that we found my mistake.

Again, sorry for the mess.
Thanks a lot for your time and effort on this
