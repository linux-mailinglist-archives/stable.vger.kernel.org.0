Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED1240B659
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 19:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhINSAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 14:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbhINSAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 14:00:08 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FD5C061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 10:58:51 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id w4so106533ljh.13
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 10:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nGuWr5Cf4Jqy9IQkXV8lo75YPFGOAqB++8MQJKEZ/ME=;
        b=ZlJuW70tqeUSd5l9b1vYfQxAuXVWBR7mDfXJniYpdPw69gFaFm1iEolMkBXpb7F8tW
         Wk+ksPeUQ0ahSZBY9SZsEnAB+32Je3naZX3luEWFgJfJBmfHCFGFApcQHx8a+yLHAehK
         +vS0liL4ZrtzXm47Y4yH0uiL980+ioUyQp09LiE6pkb+UOshF2rbPiWq9KmDn+Px+Lx2
         qcXFuZyAHqic4RmmyMqkFcUWX0wDudGquz62gJaVGWRelzD9OZbJZUEWnTQLW44iAuE6
         4NH8Sy9TtBty16+OxZWfrDaVKFvWXlEuj98LWrUY8G6x1ESivT56rfvpR1iZczEO32iX
         ytLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nGuWr5Cf4Jqy9IQkXV8lo75YPFGOAqB++8MQJKEZ/ME=;
        b=gZaQdRaHU2MFI+0FpiB3ist6Xw1oRdOLmKhftpuCUahc9/4YejibqaizQsLMiSY8qR
         tyEQJBQSEeWbO4Ph3fj8tKkj8K44pOSwtuJmze/3iQ3xWngBGRtv7dun+ohRy5vu8LVM
         AF0PqL1DUIv/sGpxfWEFVigFzOJ8RMXGeTPexN8cvO7XD37/fImqYEb+HwNxrXnXWVwn
         0xEtylzCfVyy2pjNLEWFb77VtoCSQxEsFHROJVMo84rRxPs0lMzng/wKD0nCAw/xl71M
         OgjmN7KNYw8OviGl4l5focBpoNvtDdWmVgheYMjAJfVM+cXCkhEsy5AfhZlUEJGSclT7
         3OEw==
X-Gm-Message-State: AOAM5330mhwgcb6ME51cc3BIrOuL30AAUgOiq0TmMzZNDTTTOUMcPA9L
        eZE60fdMgdaiH5zZYt+EKWk9s4dtROKCH3VsYaNakA==
X-Google-Smtp-Source: ABdhPJzOHDvb2Res/SQDtP09QCjmfCMlp9GZdRXj6NTTqGM3YzEO2uGvw4XNaISgW8ko6tdzw2bQUEaqM26cKYpZOJA=
X-Received: by 2002:a2e:b8cc:: with SMTP id s12mr17029070ljp.527.1631642329211;
 Tue, 14 Sep 2021 10:58:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210914171551.3223715-1-pgonda@google.com> <YUDcvRB3/QOXSi8H@google.com>
In-Reply-To: <YUDcvRB3/QOXSi8H@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 14 Sep 2021 11:58:37 -0600
Message-ID: <CAMkAt6opZoFfW_DiyJUREBAtd8503C6j+ZbjS9YL3z+bhqHR8Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: Disable KVM_CAP_VM_COPY_ENC_CONTEXT_FROM for SEV-ES
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Tempelman <natet@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 14, 2021 at 11:32 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Sep 14, 2021, Peter Gonda wrote:
> > Copying an ASID into new vCPUs will not work for SEV-ES since the vCPUs
> > VMSAs need to be setup and measured before SEV_LAUNCH_FINISH. Return an
> > error if a users tries to KVM_CAP_VM_COPY_ENC_CONTEXT_FROM from an
> > SEV-ES guest.
>
> What happens if userspace does KVM_CAP_VM_COPY_ENC_CONTEXT_FROM before the source
> has created vCPUs, i.e. before it has done SEV_LAUNCH_FINISH?

That's not enough. If you wanted to be able to mirror SEV-ES you'd
also need to call LAUNCH_UPDATE_VMSA on the mirror's vCPUs before
SEV_LAUNCH_FINISH. That is do-able but I was writing a small change to
fix this bug. If mirroring of SEV-ES is wanted it's a much bigger
change.

>
> Might be worth noting that the destination cannot be an SEV guest, and therefore
> can't be an SEV-ES guest either.

sev_guest() implies sev_es_guest() so I think this case is covered.

>
> > Fixes: 54526d1fd593 ("KVM: x86: Support KVM VMs sharing SEV context")
>
> Cc: stable@vger.kernel.org

Oops. I'll update in the V2 if needed. Added to this thread for now.
