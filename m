Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE8944268
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731137AbfFMQWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:22:19 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:35191 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731047AbfFMIi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 04:38:26 -0400
Received: by mail-vs1-f65.google.com with SMTP id u124so12112568vsu.2
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 01:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+C2CsivH9IqrRnR8WwWUxyFi2YnhU8MQIyYAZwXuW4Y=;
        b=JizwhX3IgWKZuXn27vf9/zgAH/7XetHlTOexacKYvrNV/5K3aoRQw0fdH6Rfy0oXGV
         ZwSdVjVfCbEhS1TbbPL8+MrkSa5qAXp9hbvCOMiVMzFAMakqUWshqzCr1Y5gCXU6mBNf
         8JsPIHxg9x8YhkdUd39KUy3reByhjy8ILKH3FHJUcLj6g7SLhA/T+U/UZt6nCHYDOg4p
         Qi/l3FYPRIf359G3Chu5PmHfrT0ZYZSfq9jsUGfPIna9Sz+TlIbXM29UVEsmdglGDWbm
         PLpdB9EOemv9AXIVxk+FK72mqJ3e6tyhcQGgT4ex+BaZ/BPlQFiEIQ4FTLd2mc72+puL
         VTEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+C2CsivH9IqrRnR8WwWUxyFi2YnhU8MQIyYAZwXuW4Y=;
        b=gRxEMCM/yAnKGv41fEPnTVT+/0nZ1drczVk9kiIbtCCUx2mU5nA0sYqJaJaaJxrQSm
         GYhVu9nUMkFyB8/Ingse0LOMzTA2pmRk+04JPaGEQtx5YCPz00JJOZCKtvvRv+lNye7T
         9bD9M5dB44PUTMj4zlLrJpab60tbGibYL2CvQMmn1duGEcnXZAqQRbna3I/1GIdsnfgB
         aYaXjOxS8HF1TRwKiGx8L6iK/Ilm7fAWtCJDYONNvAaLFK7LtKTzVckrU13iTT+vvEwg
         FieonePmBzl0JWuGdydJF2/kDwwDIdxEDVHFmFsHs8w7SxG6kGL1QF3nqjSy0Fbb9Gyy
         kljA==
X-Gm-Message-State: APjAAAXRrmK9PUI4a712lbamMmKhZYBOe813QulCYArJ4dl+Q6Vj/LjI
        GztjdtcM8yfJ/rfoWXmpO/CAzS8gfG0BXQK1HtGaNg==
X-Google-Smtp-Source: APXvYqzE+ancjlKXC1Tuyys4uXXeWH0g8p+sa0N995NcT/3g2qgNoZO3CvGKON8bG1rcpPicWYKbyVsFVMxClxZosHs=
X-Received: by 2002:a67:f297:: with SMTP id m23mr20877437vsk.109.1560415104933;
 Thu, 13 Jun 2019 01:38:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190603100938.5414-1-jian-hong@endlessm.com> <20190610060141.5377-1-jian-hong@endlessm.com>
 <20190613075256.GF19685@kroah.com>
In-Reply-To: <20190613075256.GF19685@kroah.com>
From:   Jian-Hong Pan <jian-hong@endlessm.com>
Date:   Thu, 13 Jun 2019 16:37:48 +0800
Message-ID: <CAPpJ_ecg1ERjrSYoB_Abuf2oy_Nay4sr3Bpb15OXRFbrXUW=6Q@mail.gmail.com>
Subject: Re: [PATCH stable-5.1 0/3] drm/i915: Prevent screen from flickering
 when the CDCLK changes
To:     =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Abhay Kumar <abhay.kumar@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Clint Taylor <Clinton.A.Taylor@intel.com>
Cc:     stable@vger.kernel.org,
        Linux Upstreaming Team <linux@endlessm.com>,
        Hui Wang <hui.wang@canonical.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> =E6=96=BC 2019=E5=B9=B46=E6=9C=8813=E6=
=97=A5 =E9=80=B1=E5=9B=9B =E4=B8=8B=E5=8D=883:52=E5=AF=AB=E9=81=93=EF=BC=9A
>
> On Mon, Jun 10, 2019 at 02:01:39PM +0800, Jian-Hong Pan wrote:
> > Hi,
> >
> > After apply the commit "drm/i915: Force 2*96 MHz cdclk on glk/cnl when =
audio
> > power is enabled", it induces the screen to flicker when the CDCLK chan=
ges on
> > the laptop like ASUS E406MA. [1]
> >
> > So, we need these commits to prevent that:
> > commit 48d9f87ddd21 drm/i915: Save the old CDCLK atomic state
> > commit 2b21dfbeee72 drm/i915: Remove redundant store of logical CDCLK s=
tate
> > commit 59f9e9cab3a1 drm/i915: Skip modeset for cdclk changes if possibl=
e
> >
> > [1]: https://bugzilla.kernel.org/show_bug.cgi?id=3D203623#c12
> >
> > Jian-Hong Pan
> >
> > Imre Deak (2):
> >   drm/i915: Save the old CDCLK atomic state
> >   drm/i915: Remove redundant store of logical CDCLK state
> >
> > Ville Syrj=C3=A4l=C3=A4 (1):
> >   drm/i915: Skip modeset for cdclk changes if possible
> >
> >  drivers/gpu/drm/i915/i915_drv.h      |   3 +-
> >  drivers/gpu/drm/i915/intel_cdclk.c   | 155 ++++++++++++++++++++++-----
> >  drivers/gpu/drm/i915/intel_display.c |  48 +++++++--
> >  drivers/gpu/drm/i915/intel_drv.h     |  18 +++-
> >  4 files changed, 186 insertions(+), 38 deletions(-)
>
> These are all big patches, I would like to get an ack from the i915
> developer(s) that these are acceptable for the stable tree before
> applying them...
>
> thanks,
>
> greg k-h

Hi Intel friends,

We have laptops like ASUS E406MA, which hits the issue: The audio
playback does not work anymore after suspend & resume [1]
Thanks for your contribution.  We found the commit "drm/i915: Force
2*96 MHz cdclk on glk/cnl when audio power is enabled" can fix it.
But, it induces the screen to flicker when the CDCLK changes on.  So,
we need these commits to be back ported to Linux stable 5.1.x tree to
prevent flickering:

59f9e9cab3a1 drm/i915: Skip modeset for cdclk changes if possible
2b21dfbeee72 drm/i915: Remove redundant store of logical CDCLK state
48d9f87ddd21 drm/i915: Save the old CDCLK atomic state
905801fe7237 drm/i915: Force 2*96 MHz cdclk on glk/cnl when audio
power is enabled

[1] https://bugzilla.kernel.org/show_bug.cgi?id=3D203623

May we have your comment or ack for the back port patches?
https://www.spinics.net/lists/stable/msg308491.html
https://www.spinics.net/lists/stable/msg310121.html
https://www.spinics.net/lists/stable/msg310122.html
https://www.spinics.net/lists/stable/msg310124.html
https://www.spinics.net/lists/stable/msg310125.html

Thank you,
Jian-Hong Pan
