Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FECD1C094A
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 23:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgD3VcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 17:32:22 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49637 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727079AbgD3VcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 17:32:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588282340;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=Jzrv5wRZ4K7XtvWDWWDISsbmjMxGQe+9BSaROBXcFYM=;
        b=AgVmoz4kBlZy6j8mVFtcHDi/MREwcnra0ZYiYpOMC5tu4MtZQGh7al1TqkILD3YB6cmDsc
        hrPfJGyUTh9oGLtbTLDw7hhJirXzaIHMcTPzo/qBFCnZ83iEtxGM541kxSKLF7QBNditQT
        +xcJkbh3/EO0E91aGGanPmuemdVQ64M=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435--CbRWlZaMkm9WfwuO45NIg-1; Thu, 30 Apr 2020 17:32:18 -0400
X-MC-Unique: -CbRWlZaMkm9WfwuO45NIg-1
Received: by mail-qk1-f197.google.com with SMTP id 30so7875145qkp.21
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 14:32:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=Jzrv5wRZ4K7XtvWDWWDISsbmjMxGQe+9BSaROBXcFYM=;
        b=Ap0rdRD6iViDdSJUBCury3frCD53V11TKexHlgZ4eJLGfCMj258+XvEXUUUF0jiBhG
         KTC1Vf0ENQPOoMgNbKIteDMWUMSjB4RaiaZH5mJpCALYGnkX78N+CBTnRa87cPQoSJJD
         4MFFV9C2C/+Sj/Tz3bqxunccvnWEeZEnNprdU8R6lXjB3aY3WesUqMKGJNzXs/KxHosv
         CodBu31f+tKZ+lcrmg9guHzugOIf1rg4mMz1BzWFXBmRI+/yOlA3BqYfA+ecsWf3zsEm
         YVA2jsBPDvxmEOJ/ARh3mR85aIbeD8ROtYsm5tDKzext8R9+VDnKuX9FSfDYtnFdpYyz
         g3uA==
X-Gm-Message-State: AGi0PuanHAjdpfKJ6VEOZPzN5j4v++wioZ9PvsuV4qsuXcYhFGHInrkM
        mrtNNyLIamtTiRiSAbR9nhVpmDouSwzFJIXDs+N/u+Dh1ymzrIUDoU6Qgt0xqRn4UHRPdpzFYXf
        IIffM9UDO91ACYsk1
X-Received: by 2002:a37:5846:: with SMTP id m67mr569359qkb.78.1588282338108;
        Thu, 30 Apr 2020 14:32:18 -0700 (PDT)
X-Google-Smtp-Source: APiQypJZ/+p/l03HZUTw9TAzxeelMsC2X0K+JlusH68UBd280GrosJOpL9Xmkh0soQ588iZsWL59bA==
X-Received: by 2002:a37:5846:: with SMTP id m67mr569335qkb.78.1588282337907;
        Thu, 30 Apr 2020 14:32:17 -0700 (PDT)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id x16sm1077258qkh.14.2020.04.30.14.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 14:32:17 -0700 (PDT)
Date:   Thu, 30 Apr 2020 14:32:15 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Dave Young <dyoung@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>, Lyude Paul <lyude@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Peter Jones <pjones@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Scott Talbert <swt@techie.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi <linux-efi@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        "# 3.4.x" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] efi/tpm: fix section mismatch warning
Message-ID: <20200430213215.jqt2rj452hawj3j7@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
Mail-Followup-To: Ard Biesheuvel <ardb@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Dave Young <dyoung@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>, Lyude Paul <lyude@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Peter Jones <pjones@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Scott Talbert <swt@techie.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi <linux-efi@vger.kernel.org>,
        linux-integrity@vger.kernel.org, "# 3.4.x" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200429190119.43595-1-arnd@arndb.de>
 <20200430211516.gkwaefjrzj2dypmr@cantor>
 <CAK8P3a1xk9b9Ntsf302EUP2Sp+yWe5UEsbf973=xmYRkiN1KuQ@mail.gmail.com>
 <CAMj1kXHc0uzzTKp7oj23_=X9ek2KNrKMq1gL09X7cTnjhV=nXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <CAMj1kXHc0uzzTKp7oj23_=X9ek2KNrKMq1gL09X7cTnjhV=nXQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu Apr 30 20, Ard Biesheuvel wrote:
>On Thu, 30 Apr 2020 at 23:21, Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> On Thu, Apr 30, 2020 at 11:15 PM Jerry Snitselaar <jsnitsel@redhat.com> wrote:
>> >
>> > On Wed Apr 29 20, Arnd Bergmann wrote:
>> > >Building with gcc-10 causes a harmless warning about a section mismatch:
>> > >
>> > >WARNING: modpost: vmlinux.o(.text.unlikely+0x5e191): Section mismatch in reference from the function tpm2_calc_event_log_size() to the function .init.text:early_memunmap()
>> > >The function tpm2_calc_event_log_size() references
>> > >the function __init early_memunmap().
>> > >This is often because tpm2_calc_event_log_size lacks a __init
>> > >annotation or the annotation of early_memunmap is wrong.
>> > >
>> > >Add the missing annotation.
>> > >
>> > >Fixes: e658c82be556 ("efi/tpm: Only set 'efi_tpm_final_log_size' after successful event log parsing")
>> > >Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> >
>> > Minor thing, but should the Fixes be c46f3405692d ("tpm: Reserve the TPM final events table")? Or what am I missing
>> > about e658c82be556 that causes this? Just trying to understand what I did. :)
>>
>> You are right, I misread the git history. Can you fix it up when applying the
>> patch, or should I resend it?
>>
>
>I can fix it up, no worries.
>

With the fix applied:

Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>

