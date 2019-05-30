Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 600592FF94
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 17:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfE3PsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 11:48:24 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44771 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3PsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 11:48:24 -0400
Received: by mail-io1-f68.google.com with SMTP id f22so5429881iol.11;
        Thu, 30 May 2019 08:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3olQvP45h39vAZdvBqNRdDIW/OYVYSxl9B+1Z8goMDM=;
        b=OSlz9oSP57X73P9v8T1SGzdHu+TSRK0BQfHQ52vHbEKVUXF1//MODLfSiNzRLny+3w
         rleqXIdXCv5T7ezYqzKxFLxTnkfIlrGvuW1dB1cp1I7dk0q1VYaM0uiZzzjbCiCOeWI1
         U03eULXCOm5eGLcqRwiRqk4gGdHjoSYCMXAU1NgyUlCVaXVZ5QwTXJoJnErzm1hbpCtN
         eMLG/tSelV6Xkn/jzRCBsAeXCK7On/ITxYk/U/j/hpGMiwH+kqIsxQn+d58L7pwCPLSb
         RFBx2v/K8WSSuhU0Dx32A4ha5ulOFuxygaptgd3Dwoziw1QyfU3cJlVzVZqPYrfuTyQP
         M6gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3olQvP45h39vAZdvBqNRdDIW/OYVYSxl9B+1Z8goMDM=;
        b=JHnGNIVGudtTrDWDnA7CFDQCrDQAh75hIJfyuGgAk/xTv53JjZ/DWLQRE2UMw6vfzH
         FConwWdLVuLMnN8AvFcExXT5gqmDeknEFWtPhVYpLReGDTK9fX7xmo2NE5x/9H6IK6EZ
         UiClImY58UKpVRiLOB0sfzr443M6ZjXb+ZLyit8NE+pyoqieWGERtrDw/VOZ8AHJ5BTY
         bxbn67QycyB+fSNhuoaoWyMj617jmrjsLv1hby54uKEtAZ8xuG+FTHxhSQZ0Y/p3m8/y
         pqUA/7awtkPICzsy1HvmTzLmuqR+CoIoesrNE8b8ocZ+HSPt+hFSqV+xDhNveloIOZzC
         Hoxw==
X-Gm-Message-State: APjAAAXJXybq2HoscdvpX50AgB+skq4XNxBeUpDIVbsrJKfZreD/EdlB
        9lJIziu4cI2a26ffzPgt2Iqr/XTPuOETicZqlU4=
X-Google-Smtp-Source: APXvYqzxYpkdxpKc35hfYTazS7WePXHFReDy++1I+d8I5tTo+pAFe1tbs+Nn+yj5IJpa57U4mzBaSaT7/6aUGiL3P4U=
X-Received: by 2002:a6b:6217:: with SMTP id f23mr3170264iog.110.1559231303258;
 Thu, 30 May 2019 08:48:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com> <87woi8rt96.fsf@xmission.com> <871s0grlzo.fsf@xmission.com>
In-Reply-To: <871s0grlzo.fsf@xmission.com>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Thu, 30 May 2019 08:48:12 -0700
Message-ID: <CABeXuvoRmWXVk3KTKO3MLoLxxw7TU2G1YQVOe_ATAqBkjcROsA@mail.gmail.com>
Subject: Re: pselect/etc semantics
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, dbueso@suse.de, axboe@kernel.dk,
        Davidlohr Bueso <dave@stgolabs.net>, Eric Wong <e@80x24.org>,
        Jason Baron <jbaron@akamai.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>,
        Omar Kilani <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On May 30, 2019, at 8:38 AM, Eric W. Biederman <ebiederm@xmission.com> wr=
ote:
>
> ebiederm@xmission.com (Eric W. Biederman) writes:
>
>> Which means I believe we have a semantically valid change in behavior
>> that is causing a regression.
>
> I haven't made a survey of all of the functions yet but
> fucntions return -ENORESTARTNOHAND will never return -EINTR and are
> immune from this problem.
>
> AKA pselect is fine.  While epoll_pwait can be affected.

This was my understanding as well.

> Has anyone contacted Omar Kilani to see if that is his issue?
> https://lore.kernel.org/lkml/CA+8F9hicnF=3DkvjXPZFQy=3DPa2HJUS3JS+G9VswFH=
NQQynPMHGVQ@mail.gmail.com/

Omar was cc-ed when this regression was reported. I did cc him on fix
and asked if he could try it. We have not heard from him.

> So far the only regression report I am seeing is from Eric Wong.
> AKA https://lore.kernel.org/lkml/20190501021405.hfvd7ps623liu25i@dcvr/
> Are there any others?  How did we get to be talking about more
> than just epoll_pwait?

This is the only report that I know of. I=E2=80=99m not sure why people
started talking about pselect. I was also confused why instead of
reviewing the patch and discussing the fix, we ended up talking about
how to simplify the code. We have deviated much from what should have
been a code review.

-Deepa
