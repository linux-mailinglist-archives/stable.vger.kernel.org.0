Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B852836FEC4
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 18:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhD3QlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 12:41:16 -0400
Received: from mail-oi1-f178.google.com ([209.85.167.178]:46780 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhD3QlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 12:41:15 -0400
Received: by mail-oi1-f178.google.com with SMTP id m13so70537993oiw.13;
        Fri, 30 Apr 2021 09:40:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5ltcm9XValrWnJU3k5i7CWIWvH2RB/2Nbdgne/1Anh4=;
        b=sm0ZyZBsbz+Z0UgRFsYnlgY9Hadse6rgbQMemJ/fTjn8fvhCzvotrv9ZBLBtvWWHv6
         tOZSPYFSjheZQpooTwAdjLDs8u3J9LUWdlB4SFpgb9UWDtTYsDjqOI7ExWm5n9GKcsI5
         aJBwKkql9YhSRGG3QJ1Tz8fNnmGeM1EVYDYlG4lVXqk4975ZR3iAbVti9V3dvixptCxL
         q/8OxWtQacH182mAaUEcnuxJw+i644MPupPWtWY94cJ9SLHayjhhcQb9lhOItH6tHMSa
         scNj7wHtObXGwR7YP6K6djUj3a7EjxwcjnfcdG5TXVevihUz9iIPaa78mMc2irQklgw6
         tOIg==
X-Gm-Message-State: AOAM530E8n4Z5QYQMEY0V8WApyNZTk6y2tGzqE8xAxWLh/3RkE/obJ/h
        HRH87rZdVWP6piEAOPD8dnppfOMrphFa10P8T+5aeXjG
X-Google-Smtp-Source: ABdhPJzm7vvV4CmNTvLJgDmLkIuFXIGl7ETPZ7qdPS25C5hM8BiWVkoq/W0PxNtvB1CDZfqi/U1lJnKjwVJq9dscdTY=
X-Received: by 2002:a54:4501:: with SMTP id l1mr11988303oil.157.1619800826138;
 Fri, 30 Apr 2021 09:40:26 -0700 (PDT)
MIME-Version: 1.0
References: <13f5c864-9b15-b2dd-53e1-d71b27a94a74@oracle.com>
 <69f6104e-ca54-5686-4cbf-dc14cb1697f3@oracle.com> <YIjrQdJtpJ0br5m9@kroah.com>
 <db5625eb-f304-2f47-49f3-5fb7b3d019e9@oracle.com> <36779f96-2314-fd35-7c02-accd6da0be56@oracle.com>
 <YIwIvx+uBBb/nz+S@kroah.com> <31211f9c-56ee-d5b5-ccb2-eb58a324c548@oracle.com>
In-Reply-To: <31211f9c-56ee-d5b5-ccb2-eb58a324c548@oracle.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 30 Apr 2021 18:40:15 +0200
Message-ID: <CAJZ5v0jv_+McHC0FXdBU0+MFRxPSnhx0OXAi3pKVjTkR+KDLig@mail.gmail.com>
Subject: Re: Needed in 5.4.y: [PATCH 5.10 055/126] ACPI: tables: x86: Reserve
 memory occupied by ACPI tables
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dhaval Giani <dhaval.giani@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stable <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86 Maintainers <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 30, 2021 at 5:57 PM George Kennedy
<george.kennedy@oracle.com> wrote:
>
>
>
> On 4/30/2021 9:40 AM, Greg Kroah-Hartman wrote:
> > On Thu, Apr 29, 2021 at 01:24:06PM -0400, George Kennedy wrote:
> >>
> >> On 4/28/2021 8:52 AM, George Kennedy wrote:
> >>>
> >>> On 4/28/2021 12:57 AM, Greg Kroah-Hartman wrote:
> >>>> On Tue, Apr 27, 2021 at 06:18:05PM -0400, George Kennedy wrote:
> >>>>> CC+ stable@vger.kernel.org
> >>>>>
> >>>>> On 4/27/2021 6:17 PM, George Kennedy wrote:
> >>>>>> Hello Greg,
> >>>>>>
> >>>>>> We need the following 2 upstream commits applied to 5.4.y to
> >>>>>> fix an iBFT
> >>>>>> boot failure:
> >>>>>>
> >>>>>> 2021-03-29 rafael.j.wysocki@intel.com - 1a1c130a 2021-03-23 Rafael J.
> >>>>>> Wysocki ACPI: tables: x86: Reserve memory occupied by ACPI tables
> >>>>>> 2021-04-13 rafael.j.wysocki@intel.com - 6998a88 2021-04-13 Rafael J.
> >>>>>> Wysocki ACPI: x86: Call acpi_boot_table_init() after
> >>>>>> acpi_table_upgrade()
> >>>>>>
> >>>>>> Currently, only the first commit (1a1c130a) is destined for
> >>>>>> 5.10 & 5.11.
> >>>>>>
> >>>>>> The 2nd commit (6998a88) is needed as well and both commits are needed
> >>>>>> in 5.4.y.
> >>>> Is this a regression (i.e. did this hardware work on older kernels?),
> >>>> and if so, what commit caused the problem?
> >>>>
> >>>> These commits are already in 5.10.y, what changed in older kernels to
> >>>> require this to be backported?
> >> Hello Greg,
> >>
> >> Can the same 2 patches also be applied to 4.14.y, which one of distros is
> >> based on?
> >>
> >> 4.14.y crashes during ibft boot with KASAN enabled without the 2 patches.
> > What about 4.19.y?  You do not want to skip anything in the middle,
> > right?
> >
> > And I need an ack from the authors and maintainers of these changes
> > before I can take them into the stable trees.  Any reason you didn't cc:
> > them all?
> CC+ maintainers
>
> Rafael and Mike,
>
> We need Rafael's 2 upstream ACPI commits (1a1c130a & 6998a88) backported
> to more of the stable branches - at least in 5.4.y, 4.14.y, and 4.19.y.
>
> Can you (along with the other maintainers) ACK the request?

Sure, please send an inclusion request to stable@vger.kernel.org as
per the documentation with a CC to me and I'll respond with an ACK if
needed.

Thanks!
