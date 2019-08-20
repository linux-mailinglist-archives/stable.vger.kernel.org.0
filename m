Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93560961DD
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 16:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbfHTOEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 10:04:47 -0400
Received: from mail-lj1-f174.google.com ([209.85.208.174]:34784 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728248AbfHTOEr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 10:04:47 -0400
Received: by mail-lj1-f174.google.com with SMTP id x18so5253340ljh.1
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 07:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kd4TLeOwTCqmpa5fLYaRDIu+voPPXvoA7T/cWWd66zY=;
        b=EHbY0b0h1Q7gF5aFFzbqpM7XsAWchtdZLT3s+R4HH7lTeeUTQRG/Bp8UB+jER5Oiwi
         xAMTcRYcNzHLCALB7GgWsf3BAAEIEcLxNVFGch+yH41qBENNSQCXHqvcMbdyLyo6nlxR
         JQcGvLOwZZ1QAApIeyWMqT2N6zTchpGZxWcfpCuI9xQrbWxtbLMGTXvPJfBaLozaY06g
         MD3EutSS7yicxSZC7ft57Ap1rv94bpiMOvS2w3VsNY8pXPaWB7MzJ+zBSipiVA3r2qeQ
         FSs7dJmWlwNBM4Hte/BF8XlL9Au1gtx9VS7baZWoy+7kuOTCbQ5lM0TULd1On5XsxUps
         glQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kd4TLeOwTCqmpa5fLYaRDIu+voPPXvoA7T/cWWd66zY=;
        b=ijoVa5P2dUuoPThhFhT1rxJXXWqxdP6zpYwb8ZqK82g4IGFgw5Y8ESN1yLIugMxUIE
         o4gU+dfrQKPZ3XaLO4uckG2Nm65ZLlOxLCGmsRJCJGyUHHc96QvPlbHZXeEWQyR5WOJN
         z2qko0kOPh80zIoO6950uxIuFmY+hCCvrxqcgeeEepyDSGurfaa8kJ/AVY8cFootjUUp
         QJygzifk0q/giuUH8e30ZFqh1LRK+Vh8eNHGYDeTbH64iEiMITqnBQHTzPJc3eAm6gWF
         5ZXMXiV5jHqAz21M3LqvTbVDRMwfbfXKnfxk+QQoGVHy3a0AA5dbY1mMUucXvTKXIUNC
         xOXQ==
X-Gm-Message-State: APjAAAXvso+jKLN/M5jR2j+ZU1QFdjswckI2rCm9UR66VfFDcIMbkmiz
        TQh3rRPXagdGlPc1MkCxysBps/SP+nWx+ciauUqo/A==
X-Google-Smtp-Source: APXvYqx0g1K4OOThGQcfJVq8B7ZTW0gBre6ZccxLOxwht9G3AOdFbx5k82n1nCsAS0O91FOArHowhc81CoFNGqkXAik=
X-Received: by 2002:a2e:b174:: with SMTP id a20mr13239748ljm.108.1566309885554;
 Tue, 20 Aug 2019 07:04:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAK8P3a0gX2dM=VDjs2Ezh1EYM-buXCZ+79bdG2E+HCjO21StcA@mail.gmail.com>
 <a1f81a90-26e5-364b-743a-25a3525a9e99@xilinx.com> <CACRpkdY2zJNGMkf5+F1Zu2CrtG3-059uwsQopm0rS=aZUxjJzw@mail.gmail.com>
 <d7a685c3-bc28-2135-f48c-5eded7dfa03d@xilinx.com>
In-Reply-To: <d7a685c3-bc28-2135-f48c-5eded7dfa03d@xilinx.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 20 Aug 2019 16:04:33 +0200
Message-ID: <CACRpkdYf9YnvrBVA6xry-ox3ohKwT9WZqDfMBo6nK3TkNezYjw@mail.gmail.com>
Subject: Re: stable backports, from contents found in xilinx-4.9
To:     Michal Simek <michal.simek@xilinx.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "stable-4.9" <stable@vger.kernel.org>,
        gregkh <gregkh@linuxfoundation.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Felipe Balbi <balbi@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 20, 2019 at 3:46 PM Michal Simek <michal.simek@xilinx.com> wrote:
> On 20. 08. 19 15:29, Linus Walleij wrote:
> > On Fri, Aug 16, 2019 at 8:54 AM Michal Simek <michal.simek@xilinx.com> wrote:
> >
> >> What's the purpose of this work? Make v4.9 better?
> >
> > Yes. The purpose is to pick all stuff you have backported and see if it should
> > actually be in -stable so that stable is stable for everyone. It's kind of
> > crowdfunding stable development.
>
> Ok. I wasn't aware about it. What's the expectation from us in this?
> Comment that list or it is just for information that this is happening
> and stable maintainers should pick it up?

Something like that.

I think Arnd will get around to sending them to Greg, Sasha et al once
he have them on the archaic stable patch format. But he can
answer once he has time.

I guess it also illustrates stuff you should ideally mail stable about
directly, but I understand as well as everyone that this takes time
and effort and I know why all processes are not always optimal.
We are stepping in and helping out a bit, at least for a one-off.

Yours,
Linus Walleij
