Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98B7012374D
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbfLQU31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:29:27 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59788 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727231AbfLQU31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 15:29:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576614565;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=B6w85va6Ncayok+cnMrvDbJmyUfEY5Z0K1FVwp3qaqg=;
        b=Pj5A9xm6C0UcVzyMv3IoWzxJ3NtQ3OtGVwQcfZliE3x+4uCKbC/CkvcIf/DmmudGfrzRkT
        GGtLqhRY7tDjD+WjhzJkDVSZEZ7yjqNbDniUlb4JH2I643E12eB7ndkRdVwmMDV40OB7se
        Z0NroWYb/tYxZ+oDOkYP/DdXt7Hvm1w=
Received: from mail-yw1-f69.google.com (mail-yw1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-eLg9EmfRMn-6Oig3W76Ajw-1; Tue, 17 Dec 2019 15:29:23 -0500
X-MC-Unique: eLg9EmfRMn-6Oig3W76Ajw-1
Received: by mail-yw1-f69.google.com with SMTP id q185so1363800ywe.3
        for <stable@vger.kernel.org>; Tue, 17 Dec 2019 12:29:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=B6w85va6Ncayok+cnMrvDbJmyUfEY5Z0K1FVwp3qaqg=;
        b=L0dp1SvgI1Ap0vevZ35zUnpW6+rt8fDhb1erb8GlLETm2qHlzHSAiBLtMD27TTVqwq
         +VZcwbaQcOcVShCbQ2Csd08F9SjSa8sVUinXlmElc5a6KqTCrKl9JwFQibR2CZWwWeuA
         hZW/TOPPhiWm91QXxuaMzOqMlkwC9u8X4mdO+Eb9cz0YedfIhPtmGjqqIA2EsmLR7VKH
         PmI/T3XhXInvPPBh7ZoH6p0wiMNTpH+UddctGC0FtMDmefY35Jn+yrscFdLAY7nRcRpc
         SFKPhoPHr/RG/6SftHaX59C2gZpyx9Ado9nN0a+QnwMFYViUIt+hqfJyYrUFYyqzXE10
         BfJQ==
X-Gm-Message-State: APjAAAU0Tqt7ag55kSIf4nETNAZv4dhcbGm10GQBMxwYAOe9QZhV2X+t
        WsGrpWFVIDKlrGGwnikjXnbUfo4qbyys4T+aRxsStKY2ODTrm+RLBdmwI6Wr5rR5QOmje4jNnn9
        TV38JPPmoS0fbpQEh
X-Received: by 2002:a81:9a45:: with SMTP id r66mr459337ywg.446.1576614562497;
        Tue, 17 Dec 2019 12:29:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqyb258eJuuP+T1u1y5+GiE/8HF1tUR9cT2lsn7QBU6PYjGyZyQQefMkbh0UG51ut1kkWocH2A==
X-Received: by 2002:a81:9a45:: with SMTP id r66mr459312ywg.446.1576614562236;
        Tue, 17 Dec 2019 12:29:22 -0800 (PST)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id g29sm10511291ywk.31.2019.12.17.12.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 12:29:21 -0800 (PST)
Date:   Tue, 17 Dec 2019 13:29:20 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Bundy <christianbundy@fraction.io>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>, linux-integrity@vger.kernel.org
Subject: Re: [PATCH v2] tpm_tis: reserve chip for duration of
 tpm_tis_core_init
Message-ID: <20191217202920.kktuk3q3qrnuvscd@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
Mail-Followup-To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Bundy <christianbundy@fraction.io>,
        Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>, linux-integrity@vger.kernel.org
References: <20191211231758.22263-1-jsnitsel@redhat.com>
 <20191211235455.24424-1-jsnitsel@redhat.com>
 <5aef0fbe28ed23b963c53d61445b0bac6f108642.camel@linux.intel.com>
 <CAPcyv4h60z889bfbiwvVhsj6MxmOPiPY8ZuPB_skxkZx-N+OGw@mail.gmail.com>
 <20191217020022.knh7uxt4pn77wk5m@cantor>
 <CAPcyv4iepQup4bwMuWzq6r5gdx83hgYckUWFF7yF=rszjz3dtQ@mail.gmail.com>
 <5d0763334def7d7ae1e7cf931ef9b14184dce238.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <5d0763334def7d7ae1e7cf931ef9b14184dce238.camel@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue Dec 17 19, Jarkko Sakkinen wrote:
>On Mon, 2019-12-16 at 18:14 -0800, Dan Williams wrote:
>> On Mon, Dec 16, 2019 at 6:00 PM Jerry Snitselaar <jsnitsel@redhat.com> wrote:
>> > On Mon Dec 16 19, Dan Williams wrote:
>> > > On Mon, Dec 16, 2019 at 4:59 PM Jarkko Sakkinen
>> > > <jarkko.sakkinen@linux.intel.com> wrote:
>> > > > On Wed, 2019-12-11 at 16:54 -0700, Jerry Snitselaar wrote:
>> > > > > Instead of repeatedly calling tpm_chip_start/tpm_chip_stop when
>> > > > > issuing commands to the tpm during initialization, just reserve the
>> > > > > chip after wait_startup, and release it when we are ready to call
>> > > > > tpm_chip_register.
>> > > > >
>> > > > > Cc: Christian Bundy <christianbundy@fraction.io>
>> > > > > Cc: Dan Williams <dan.j.williams@intel.com>
>> > > > > Cc: Peter Huewe <peterhuewe@gmx.de>
>> > > > > Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>> > > > > Cc: Jason Gunthorpe <jgg@ziepe.ca>
>> > > > > Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>
>> > > > > Cc: stable@vger.kernel.org
>> > > > > Cc: linux-integrity@vger.kernel.org
>> > > > > Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")
>> > > > > Fixes: 5b359c7c4372 ("tpm_tis_core: Turn on the TPM before probing IRQ's")
>> > > > > Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
>> > > >
>> > > > I pushed to my master with minor tweaks and added my tags.
>> > > >
>> > > > Please check before I put it to linux-next.
>> > >
>> > > I don't see it yet here:
>> > >
>> > > http://git.infradead.org/users/jjs/linux-tpmdd.git/shortlog/refs/heads/master
>> > >
>> > > However, I wanted to make sure you captured that this does *not* fix
>> > > the interrupt issue. I.e. make sure you remove the "Fixes:
>> > > 5b359c7c4372 ("tpm_tis_core: Turn on the TPM before probing IRQ's")"
>> > > tag.
>> > >
>> > > With that said, are you going to include the revert of:
>> > >
>> > > 1ea32c83c699 tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for interrupts
>> >
>> > Dan, with the above reverted do you still get the screaming interrupt?
>>
>> Yes, the screaming interrupt goes away, although it is replaced by
>> these messages when the driver starts:
>>
>> [    3.725131] tpm_tis IFX0740:00: 2.0 TPM (device-id 0x1B, rev-id 16)
>> [    3.725358] tpm tpm0: tpm_try_transmit: send(): error -5
>> [    3.725359] tpm tpm0: [Firmware Bug]: TPM interrupt not working,
>> polling instead
>>
>> If the choice is "error message + polled-mode" vs "pinning a cpu with
>> interrupts" I'd accept the former, but wanted Jarkko with his
>> maintainer hat to weigh in.
>>
>> Is there a simple sanity check I can run to see if the TPM is still
>> operational in this state?
>
>What about T490S?
>
>/Jarkko
>

I just heard back from the t490s user, and as expected the problem still exists
there with this patch.

Regards,
Jerry

