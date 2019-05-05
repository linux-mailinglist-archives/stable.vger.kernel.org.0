Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43A8013E7F
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 10:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727603AbfEEIxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 04:53:35 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40831 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbfEEIxf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 04:53:35 -0400
Received: by mail-ot1-f66.google.com with SMTP id w6so8963324otl.7
        for <stable@vger.kernel.org>; Sun, 05 May 2019 01:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=daDeBA8D0turtah81O0f+d3JFTWpkur5O2h2PhMenYM=;
        b=cjQiXbqV0dxlXQar/ns7jLS7PVkX3h9rzrH2aED7GoiJW53AIYSX0bdhsDfRUscDTv
         MRIFJysAUWsYhyIiE8qQ2dsPPPNoBOkrHrxJOkCVxHFhUyrbj7BS+Go+fE+s+4Z5yOfD
         XWbmkcv8XQL45FPMJa7ugnn43gXmKwMcMvEGrQ9tVtZKWFKh+LUFugDMA2WOyAw+hNuD
         hDHwA0OMZmuZm7DWuBdqx378xiFJ08nWtrtWXbrmTFdV9S1qs4v1w1XClGvIBBRHSGHU
         8shBZPBvvkywFCUFs82J5tUS0DG3NlQx8t3yUDCmo/z/Ufbuzo3E0sIDBDjrcgVT3u9K
         hYtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=daDeBA8D0turtah81O0f+d3JFTWpkur5O2h2PhMenYM=;
        b=XE40nOkzT5fDjtkrgwmHB3DtQEwnA0y/7QQh6qyFVmgjEMkVF9IBX9tWJhZaH5K4dM
         En8SemBS8AB298QrsW1jYiSYn0iRzT7+QdFHRclT6icAoA5CL7+U7Y2w3DrJYdF7dmB+
         H3SnLesX1d/pC8jDZr3NacKZxTHJWEnJPq5H+xY/umMdcZqHyFvbbS2RQduBOkslObv8
         /F/Iy/2/TfKKqOwO91GouETQB/XxjFXaFBs3uk1RuSpwG0PINPM8mPTgiO75whhiUzvP
         yAJm5wBlq9wm96Kmf7SMTPfRhzVMbeopvkgx4HBRJuW8PkQBIC5PldKPSeMvRFelV/oy
         ZESw==
X-Gm-Message-State: APjAAAVXbWNXU5tdiJp8wIFxAZo4X8pGBTKzVt/0dAsckVtQLfQNFeXb
        mHzFZC/fNwRur/nYf0GiGpIdnrFX6F7VFwLqq59HvA==
X-Google-Smtp-Source: APXvYqxypsOxhisCL6iasTk+odHglTg1kI9HqYO7/GE2rZoa/z93b/55YRTHsWPdk7tMeM8b63vWVC0FMrDHpW0TAtM=
X-Received: by 2002:a9d:5612:: with SMTP id e18mr12667305oti.109.1557046414651;
 Sun, 05 May 2019 01:53:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190504102451.512405835@linuxfoundation.org> <20190505030044.q3dlgd5bhfx5txmf@xps.therub.org>
 <20190505070854.GA3895@kroah.com>
In-Reply-To: <20190505070854.GA3895@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 5 May 2019 14:23:22 +0530
Message-ID: <CA+G9fYv668HB5nZSn_drMd5cLhfH7GP0NxDsF88wtp3MUAMimA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/23] 4.19.40-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 5 May 2019 at 12:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sat, May 04, 2019 at 10:00:44PM -0500, Dan Rue wrote:
> > On Sat, May 04, 2019 at 12:25:02PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.19.40 release.
> > > There are 23 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Mon 06 May 2019 10:24:19 AM UTC.
> > > Anything received after that time might be too late.
> >
> >
> > Results from Linaro=E2=80=99s test farm.
> > Regressions detected.
>
> Really?  Where?

Not really.
selftest: net: msg_zerocopy.sh is an intermittent failure on qemu_i386 devi=
ce.
We could ignore this failure as known issues.

- Naresh
