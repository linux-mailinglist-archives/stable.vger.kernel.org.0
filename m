Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 504F7123357
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 18:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbfLQRSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 12:18:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60571 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726842AbfLQRSv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 12:18:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576603128;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=CKPKIyJZy6U8LXytr+HzyJpjpcjvTy2Qoof8V3zblHk=;
        b=VgJHaWiZDDklwgKYGQw+FqSW19OiMvMKXU7ecyS5b6shD/FeuSfgSIq2OcIpkSnVRcHYed
        AuWtzWGjGTrJHCSg3IP9AJUSKu20OabEJVV70RkNiVHWP6F+TCON391U3xQVsbIJYPRb4p
        m7OohJwoF4gkNZcxju3vg4PRYFvrKIY=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-oodHzTPPM_6i5YuskwxLEg-1; Tue, 17 Dec 2019 12:18:47 -0500
X-MC-Unique: oodHzTPPM_6i5YuskwxLEg-1
Received: by mail-yb1-f200.google.com with SMTP id x186so9667452yba.6
        for <stable@vger.kernel.org>; Tue, 17 Dec 2019 09:18:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=CKPKIyJZy6U8LXytr+HzyJpjpcjvTy2Qoof8V3zblHk=;
        b=q7KFRczSuuLc0sRpGY4Yipt6d55tf9OPs2/DVm3j8UL/lVRAmv/TN33zU0U8YFcV4x
         Vc++B3/iq2KwJW6d+paYWUff2O8zKhz8SUiaWkSzibiocDyCkE73JYPXfjP2uoUN2j3U
         0HU5QcEMxQvuTXczln2qYvx2WoGr4puEcphi9NLzfGD37aE9touA7S2MFs6c/xjUjpQn
         lEx59bq07lW39rvWPOWPhCKKywfNSRbi+kl/0VUsfAoxOdHZ/Vbdhg+zZa7SJiXffd0l
         zzPdKSt6JWcuVI6Rbzl1VpgoRCmbCPzHFD+EJ4Yao14T16HRKVaAefO7scKkHNJbnCja
         q9Zw==
X-Gm-Message-State: APjAAAXyr24VyANHPg/4JxrkeT/aLL2FVeIs/5o1v5xpxClvfRJJUaWq
        39N2ojbd3tgSIotjCXIFSSAXTJncjXQrHYOC+h2PP3bLjqGBlOigGzZBsuBg3rERT2/f4OLnslT
        7dDKeoNBDUDS45wVG
X-Received: by 2002:a25:1286:: with SMTP id 128mr14032741ybs.214.1576603127013;
        Tue, 17 Dec 2019 09:18:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqzZrH0mBs2K/Kr+dAvXBSDBHex+NYXpJ/cSs5fhNlzaQzHOdQV1tnra7qB6pm6f7dWba0Vm3w==
X-Received: by 2002:a25:1286:: with SMTP id 128mr14032717ybs.214.1576603126752;
        Tue, 17 Dec 2019 09:18:46 -0800 (PST)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id h184sm6884054ywa.70.2019.12.17.09.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 09:18:45 -0800 (PST)
Date:   Tue, 17 Dec 2019 10:18:44 -0700
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
Message-ID: <20191217171844.huqlj5csr262zkkk@cantor>
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

Hi Jarkko, I'm waiting to hear back from the t490s user, but I imagine
it still has the problem as well.

Christian, were you able to try this patch and verify it still
resolves the issue you were having with the kernel failing to get the
timeouts and durations from the tpm?

Thanks,
Jerry

