Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E251B15F1
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 21:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgDTT30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 15:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725897AbgDTT3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 15:29:25 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD27C061A0C
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 12:29:25 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id gr25so8911627ejb.10
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 12:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ce20/CIQIX522RaPVTyPTfJEPqiyAriKhvUnxTulqdM=;
        b=Ew/qZu4sDhUqxZ/TYFqRH0ERtCxbKG4Z8viu2sPjWVDAgBWlvcnLRlRx5rwXTM/Oah
         mIYHqq0r+8iblP15rxoSx33CEyZunyDuuLZACk8dgur1ueNplknlYmcAylmjCtPf23DA
         W9fH6ydZ1sJNeXLG+uo/C5iF+Bx7zwA18kCdy3xNxw5iz8+YxTIHSDrMrmLspd9T1TpP
         ntKFG8X9R+1/qJUVjBuCLfLmn2FSJJekaPBY9XT3Vh9StB1/hFnewJwuLeKxA0WHVKuW
         mtpVxRXs6eZYVS5FIIcDdh1u3GSNKMaWuB1GMxDd8IXaXWIKV6KMRQ2rSrylkdDm8eYG
         MzqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ce20/CIQIX522RaPVTyPTfJEPqiyAriKhvUnxTulqdM=;
        b=BWITqzOWo2j4IgacUofJ2w6+elqowm0zEZCw5lXRFSyyH5TItLAQnDw+r5Sfi0xYMm
         7xez/dhIhO7XWkyE4OFjqUJJZFLfZXJ5PNPjdZklra0FhObZvNSWf5Iv3aPD5f5BLJP/
         Tc1FvcFNd3B/Zrhu6OE7r5ILB/03RcmL5ADL50tHQJEqVkNdyCA3l5gEb71W0WfjgZ7W
         IusLLoI8wk1vcnhSRIhVQ79w0TFn7HqP2aG0M6GMeTFa5Usw3BubuGqxBCeUoxwG3ECN
         +XeVXramPBDKK8NzQpper/Q72t5j0OgrZGk5i69bNypylKZ/yNmHD7X3mkxo2QrgyZbS
         S73A==
X-Gm-Message-State: AGi0PuY6PI2DqDVmrzmWGjqece8idJQLMKeGDVg6g+Fr5wPeVv30n1CO
        3GuUbGJU186O8T9RG/IlQKOzAA2kePKAZzifpNNNlgzW
X-Google-Smtp-Source: APiQypK9aQrIzZ87xSipVCdNGdFMMM1E4PzK+Awa+HpCEy9iTdMb3+e2PhmQ2RqaH5oAUbvtfE2smMIkNiOOGSkMCww=
X-Received: by 2002:a17:906:6d8e:: with SMTP id h14mr17131940ejt.123.1587410964104;
 Mon, 20 Apr 2020 12:29:24 -0700 (PDT)
MIME-Version: 1.0
References: <67FF611B-D10E-4BAF-92EE-684C83C9107E@amacapital.net>
 <CAHk-=wjePyyiNZo0oufYSn0s46qMYHoFyyNKhLOm5MXnKtfLcg@mail.gmail.com>
 <CAPcyv4jQ3s_ZVRvw6jAmm3vcebc-Ucf7FHYP3_nTybwdfQeG8Q@mail.gmail.com>
 <CAHk-=wjSqtXAqfUJxFtWNwmguFASTgB0dz1dT3V-78Quiezqbg@mail.gmail.com>
 <CAPcyv4hrfZsg48Gw_s7xTLLhjLTk_U+PV0MsLnG+xh3652xFCQ@mail.gmail.com> <CAHk-=wgcc=5kiph7o+aBZoWBCbu=9nQDQtD41DvuRRrqixohUA@mail.gmail.com>
In-Reply-To: <CAHk-=wgcc=5kiph7o+aBZoWBCbu=9nQDQtD41DvuRRrqixohUA@mail.gmail.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 20 Apr 2020 12:29:12 -0700
Message-ID: <CAPcyv4iTaBNPMwqUwas+J4rxd867QL7JnQBYB8NKnYaTA-R_Tw@mail.gmail.com>
Subject: Re: [PATCH] x86/memcpy: Introduce memcpy_mcsafe_fast
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        stable <stable@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 20, 2020 at 12:13 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Apr 20, 2020 at 11:20 AM Dan Williams <dan.j.williams@intel.com> wrote:
[..]
> I really really detest the whole mcsafe garbage. And I absolutely
> *ABHOR* how nobody inside of Intel has apparently ever questioned the
> brokenness at a really fundamental level.
>
> That "I throw my hands in the air and just give up" thing is a
> disease. It's absolutely not "what else could we do".

So I grew up in the early part of my career validating ARM CPUs where
a data-abort was either precise or imprecise and the precise error
could be handled like a page fault as you know which instruction
faulted and how to restart the thread. So I didn't take x86 CPU
designers' word for it, I honestly thought that "hmm the x86 machine
check thingy looks like it's trying to implement precise vs imprecise
data-aborts, and precise / synchronous is maybe a good thing because
it's akin to a page fault". I didn't consider asynchronous to be
better because that means there is a gap between when the data
corruption is detected and when it might escape the system that some
external agent could trust the result and start acting on before the
asynchronous signal is delivered.
