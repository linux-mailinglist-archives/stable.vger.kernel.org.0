Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B67FA220D84
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 14:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730739AbgGOM60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 08:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730054AbgGOM60 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 08:58:26 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A3BC061755
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 05:58:26 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id dp18so2040682ejc.8
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 05:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=v9mJg7XwGipwizXx2S4vBBwdqtrKKslDDhrfD/jXi6Q=;
        b=E65toy9yE3dWp6mE9zSSCUTS68BRTC3ozDL/84HtMGAF7cR7NYvxQArR8EHRSHuhlN
         +CfJUySYM/LNp0C0KvNDqblM/AFjRt4Ll9Ccl0mksR7maQdlKtjZm/zAduNRun/lC56y
         k+B5Mo5UcrpuIpgeaiVNzfNJ6xPqTwGAX8s10=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=v9mJg7XwGipwizXx2S4vBBwdqtrKKslDDhrfD/jXi6Q=;
        b=EdiR2cLxrKhtK2PB+v7372XhtnVQ4Ht02ORptevWHytJaUQ3Pi8cxgB10MUGTzYyyG
         NiRMmr7GMs/g0h91apiUL4Bu1TnUiumDstkTX6wnlBXbOxLhsSzRnKGhUBu0yLzHQP2b
         z++L9MQAidismFq3L+Cfl7Q0wtlSuVL3axbYxLBdCyFZgrjumkHGDNrXjYkWcj4sL4GD
         fREF4Jnv3tG+l5FceMf/M8TJHgCbsESqdFEFEAozULqn3eInM33EnUClwjEzWD0g9aTQ
         9rGDCeyHvqWPWyPThLbfLgF/iHw2etpMogMJ1eGzLf36HeZGcNn5lM65Ku/qy5qWaks8
         L+5A==
X-Gm-Message-State: AOAM531l+ypSopeKlmwWIg/29MeVvkUmg70BYkowI0SUkPbXs2JUZfwu
        nNInKFii7nyw7gA3kVvRRxrtGN67bf1dckyaQVVFBohHGV0=
X-Google-Smtp-Source: ABdhPJybPJKpuVcDzrBJ9aX/i515oH9wm4U2m50QYEEErG0T8nr61YDj0YV7C27geyilp3TNLu8mbDWP0+4BaOZ1QDU=
X-Received: by 2002:a17:906:f117:: with SMTP id gv23mr8763400ejb.528.1594817904541;
 Wed, 15 Jul 2020 05:58:24 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
References: <20200715115630.19457-1-chandrakanth.patil@broadcom.com>    <20200715122124.GA2937397@kroah.com>
In-Reply-To: <20200715122124.GA2937397@kroah.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKfxiKNv+ra1O767Z8oR49tlxGshAI/n7IRAdizjoQ=
Date:   Wed, 15 Jul 2020 05:58:21 -0700
Message-ID: <CABvwm=NmpcgRBqRAB15hzL99nt+Pyu7T7+aj+sC70jHJGcKpkQ@mail.gmail.com>
Subject: Re: [PATCH] megaraid_sas: remove undefined ENABLE_IRQ_POLL macro
To:     Greg KH <greg@kroah.com>
Cc:     "# v5 . 3+" <stable@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Sorry for the inconvenience. While circulating patch internally (within
company) with cc stable enabled in patch header has caused this problem.
I have sent a new patch including appropriate scsi developers and
maintainers.

Thanks,
Chandrakanth Patil

On Wed, Jul 15, 2020 at 5:21 AM Greg KH <greg@kroah.com> wrote:
>
> On Wed, Jul 15, 2020 at 05:26:30PM +0530, Chandrakanth Patil wrote:
> > Issue:
> > As ENABLE_IRQ_POLL macro is undefined, the check for ENABLE_IRQ_POLL
> > macro in ISR will always be false leads to irq polling non-functional.
> >
> > Fix:
> > Remove ENABLE_IRQ_POLL check from isr
> >
> > Fixes: a6ffd5bf6819 ("scsi: megaraid_sas: Call disable_irq from process
> > IRQ")
> > Cc: <stable@vger.kernel.org> # v5.3+
> > Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
> > Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> > ---
> >  drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 --
> >  1 file changed, 2 deletions(-)
>
> Why are you not sending this to the scsi developers / maintainers?
>
> thanks,
>
> greg k-h



-- 
Regards,
Chandrakanth Patil
