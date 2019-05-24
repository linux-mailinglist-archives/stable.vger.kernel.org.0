Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0E67294FD
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 11:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389806AbfEXJkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 05:40:42 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:34360 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389881AbfEXJkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 05:40:42 -0400
Received: by mail-ua1-f67.google.com with SMTP id 7so3288009uah.1
        for <stable@vger.kernel.org>; Fri, 24 May 2019 02:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qhtiLTWzEtnqsdPvTdJR/gHIsATzGzPU5kOhBS91XPY=;
        b=lMnvlmrvv8ijKadLKgWvgd6kE+a8CYs0FsQVXLSiKFykkmXgcA0If2NqsTOaQV1OaW
         uu39KSUeS/X+AbE2FNIjpnAaL7nmzbSaiO2kfBppsQejf0xdaihSDyMxqfowB3NRvXGv
         L1lVieiHEYMYu/vjOZbyafSD4FIJmBkBGry/3FEyEaJwawyhNiQ4lxianWyUkBFDM1yt
         x8G1KHlG/U84jysrRTxUlkqE47oiqYN6MPxm1tIO5z/QQSHCz5IvwafOxUGYIr/cr0WF
         nAc/mqYbdDTVjWT8pZrNR0LhyIL9638FdSaXNWw0Bk3KbPIftL0ReSISgZTKpwCJ0FpN
         joVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qhtiLTWzEtnqsdPvTdJR/gHIsATzGzPU5kOhBS91XPY=;
        b=G/OkdYZhPd6TWqbk7YqS6z6yGdjNh/IrNAb3xepVXWPtfkCgEbNW6zTlh3/sSj422n
         kVEv+I8YWigI/CSGwzn7xSbKA+UwEzwUf0jpJdvEiNvuWgHV37NsMlQ5zcFxjMwJNGBC
         b/ZLV21RRX2ObFnw2rnl9B1691tw8K5jyQN3RTUY6nIa+WuIQF83IwWua78NACabHh7c
         lxo7qMOHIsqDtMzTFKGb8I3fBsJ5xhA6ft+ASs3yflkjHClU75PYAG4TluohUtfRFaWL
         ++aWyo0th3xDT6PfTuuTWE8eMFUVKGAelmcWYO1/0rHN5dUqmoOcdFG4+vyYiKTEn+Ge
         h5lA==
X-Gm-Message-State: APjAAAUIYd0f+SEYqM6IPEwRJUrYxV8CTL2NasXQ9omzNZPLNpwrQ8v0
        EnLHkboiRMwjeVn8EeglFDlKOeRDcNWkGAL7wPeISg==
X-Google-Smtp-Source: APXvYqxCHc+MjhwWdO72zjHFKq8gW/kRZ2qdwlZCqMFUYaItIkiFdWmyV1U/t7hpBjbytm+sQ+7psEiAwhs8h2KvNm8=
X-Received: by 2002:ab0:4782:: with SMTP id v2mr17345681uac.94.1558690841324;
 Fri, 24 May 2019 02:40:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190524051015.4680-1-jian-hong@endlessm.com> <s5h7eagflv5.wl-tiwai@suse.de>
In-Reply-To: <s5h7eagflv5.wl-tiwai@suse.de>
From:   Jian-Hong Pan <jian-hong@endlessm.com>
Date:   Fri, 24 May 2019 17:40:03 +0800
Message-ID: <CAPpJ_eepxOZ4FBERLb0z=PpVgHcxD3+duRFqXbnQjrW48MTnDQ@mail.gmail.com>
Subject: Re: [PATCH] Revert "ALSA: hda - Enforces runtime_resume after S3 and
 S4 for each codec"
To:     Takashi Iwai <tiwai@suse.de>
Cc:     stable@vger.kernel.org, Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Takashi Iwai <tiwai@suse.de> =E6=96=BC 2019=E5=B9=B45=E6=9C=8824=E6=97=A5 =
=E9=80=B1=E4=BA=94 =E4=B8=8B=E5=8D=881:43=E5=AF=AB=E9=81=93=EF=BC=9A
>
> On Fri, 24 May 2019 07:10:17 +0200,
> Jian-Hong Pan wrote:
> >
> > We have an ASUS E406MA laptop equipped with Intel N5000 CPU.  After
> > system suspend & resume, the audio playback does not work anymore. The
> > device for sound output is listed as a headphone device.  Plugging in
> > headphones no sound is audible neither.
> >
> > Here are the error messages after resume:
> >
> > [  184.525681] snd_hda_intel 0000:00:0e.0: azx_get_response timeout, sw=
itching to polling mode: last cmd=3D0x20bf8100
> > [  185.528682] snd_hda_intel 0000:00:0e.0: No response from codec, disa=
bling MSI: last cmd=3D0x20bf8100
> > [  186.532683] snd_hda_intel 0000:00:0e.0: azx_get_response timeout, sw=
itching to single_cmd mode: last cmd=3D0x20bf8100
> > [  186.736838] snd_hda_codec_realtek hdaudioC0D0: Unable to sync regist=
er 0x2b8000. -5
> > [  186.738742] snd_hda_codec_realtek hdaudioC0D0: Unable to sync regist=
er 0x2b8000. -5
> > [  186.767080] snd_hda_codec_hdmi hdaudioC0D2: Unable to sync register =
0x2f0d00. -5
> >
> > After bisect, we found reverting the commit b5a236c175b0 "ALSA: hda -
> > Enforces runtime_resume after S3 and S4 for each codec" can solve this
> > issue on Linux stable 5.0.x series.
> >
> > This reverts commit a57af6d07512716b78f1a32d9426bcdf6aafc50c.
> >
> > Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=3D203623
> > Fixes: a57af6d07512 ("ALSA: hda - Enforces runtime_resume after S3 and =
S4 for each codec")
> > Cc: <stable@vger.kernel.org> # 5.0.x
> > Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
>
> I thought this revert isn't needed if the i915 GLK fix is applied?

If the i915 GLK fix is applied, then this revert is not needed.

I have also sent the "i915 GLK" to stable mail list for Linux stable
5.1.x.  But I am still wondering for 5.0.x, due to the commit
dependency.
Any idea for Linux stable 5.0.x will be appreciated.

Jain-Hong Pan

> You must hit the very same problem even after reverting this when the
> machine goes to suspend while playing a stream.  So the revert is no
> proper fix at all.
>
>
> thanks,
>
> Takashi
