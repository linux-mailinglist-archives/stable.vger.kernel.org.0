Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F5219FF1A
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 22:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgDFUcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 16:32:05 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:51715 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgDFUcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 16:32:05 -0400
Received: by mail-pj1-f66.google.com with SMTP id n4so62268pjp.1
        for <stable@vger.kernel.org>; Mon, 06 Apr 2020 13:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=s3PQnqVK/Yp5FB3uyQarAlUfZ38sT1XktoIyfn14ZiM=;
        b=mlZBK7K6tkif4LvKiDSrGiP1TfmDWE0Ch8yTetjbcKPs/ijeFgu8hv8nvJ/0md4ssI
         +a9DZ+gMb+8meffX/p88nTieoYytmRNy2jqN671tmgF9HeQsk8cMndM7JyJKCA6QNt+V
         b/fLkbBC595wMGr/qgN/G+VGcMkpGZSwQAlc8hZgib02pj1cnCaBBSbQM4VBGanNkdcR
         D4ojtK36QSI5XbiMg+nmOTGrvhDuSinSmZLyozBnX+AUli2q3DSUGToOi6n+mGeogVgo
         VMnPQXCwlL7v0cIrvYAtU/wgmUJTAWeYpUbY34JDbJV1y7cLGRHSKhd6DWiDAAVyUWdF
         6TGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=s3PQnqVK/Yp5FB3uyQarAlUfZ38sT1XktoIyfn14ZiM=;
        b=alwtOFQ9H5HM+qdhjhyrz8o8Px+BTcjBO0gZShemtvIdTcUHO7X2DD//DxC61AMODx
         hvba7E+m+XLXv7fb8pB09RVZ5riC4dx7KhNVMx0CQppOQoaYJk8+f8F42MnJyXP1tXPf
         31btDhtnDlvKrfQXDAo4DwH7iCYSJtoHtbnnDHLxEzWIplSpT0RZyG2glx7fGs9B2TGi
         Ur4DmT+AcxdjIWrlBfCMrhxyKz7QPkOMmiY/ilaNY6cDMuC9NihdZm5vYO2py0fjwMyD
         Std/NArEWmILGgAUjaY7r8pBuqVLH1npp8lqReaEpZK5AoydVag7sVUT7F2aBk7KE27J
         nMtw==
X-Gm-Message-State: AGi0Puartme5Cgd0zT3LxM7f0ppQTPYOQg4I/LMJf7uDVb7QKqKwRv+D
        G9UuqmctVVCx3cLXeUlOma/isdArcD0=
X-Google-Smtp-Source: APiQypLrft5l6a8yfyKck7ACjfTPE9IytjF/AJo+wymjrE4JINBQSMNS42wvAC5dgzya9mlw54buYw==
X-Received: by 2002:a17:90a:a40b:: with SMTP id y11mr1350538pjp.130.1586205123643;
        Mon, 06 Apr 2020 13:32:03 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:54d3:a29c:f391:9a0d? ([2601:646:c200:1ef2:54d3:a29c:f391:9a0d])
        by smtp.gmail.com with ESMTPSA id y14sm12278847pfp.127.2020.04.06.13.32.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2020 13:32:02 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
Date:   Mon, 6 Apr 2020 13:32:01 -0700
Message-Id: <6875DD55-2408-4216-B32A-9487A4FDEFD8@amacapital.net>
References: <20200406202505.GO2452@worktop.programming.kicks-ass.net>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
In-Reply-To: <20200406202505.GO2452@worktop.programming.kicks-ass.net>
To:     Peter Zijlstra <peterz@infradead.org>
X-Mailer: iPhone Mail (17E255)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> On Apr 6, 2020, at 1:25 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> =EF=BB=BFOn Mon, Apr 06, 2020 at 03:09:51PM -0400, Vivek Goyal wrote:
>>> On Mon, Mar 09, 2020 at 09:22:15PM +0100, Peter Zijlstra wrote:
>>> On Mon, Mar 09, 2020 at 08:05:18PM +0100, Thomas Gleixner wrote:
>>>> Andy Lutomirski <luto@kernel.org> writes:
>>>=20
>>>>> I'm okay with the save/restore dance, I guess.  It's just yet more
>>>>> entry crud to deal with architecture nastiness, except that this
>>>>> nastiness is 100% software and isn't Intel/AMD's fault.
>>>>=20
>>>> And we can do it in C and don't have to fiddle with it in the ASM
>>>> maze.
>>>=20
>>> Right; I'd still love to kill KVM_ASYNC_PF_SEND_ALWAYS though, even if
>>> we do the save/restore in do_nmi(). That is some wild brain melt. Also,
>>> AFAIK none of the distros are actually shipping a PREEMPT=3Dy kernel
>>> anyway, so killing it shouldn't matter much.
>>=20
>> It will be nice if we can retain KVM_ASYNC_PF_SEND_ALWAYS. I have another=

>> use case outside CONFIG_PREEMPT.
>>=20
>> I am trying to extend async pf interface to also report page fault errors=

>> to the guest.
>=20
> Then please start over and design a sane ParaVirt Fault interface. The
> current one is utter crap.

Agreed. Don=E2=80=99t extend the current mechanism. Replace it.

I would be happy to review a replacement. I=E2=80=99m not really excited to r=
eview an extension of the current mess.  The current thing is barely, if at a=
ll, correct.=
