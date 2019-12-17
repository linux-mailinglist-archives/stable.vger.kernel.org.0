Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36F3C1221C9
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 03:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfLQCAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 21:00:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57655 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726180AbfLQCAc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 21:00:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576548031;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=rPjKUP3c5OBgFxjGzOJRPYxmS5qHOOKhkgjmkw+YN2I=;
        b=hoouPTynpKhm2U7bgsUIWh/UjutlPauw8r0mLU/WaowP7lHYEGDEVIGM1BNHmaaFKs8ka3
        CX3xdGz70AQLQpKmxSCOYi1MawqY6cT88NxIW7ZbYZnU90T2vRxRepjwUBqhUTW9G/L2w3
        aKF9IqGrrcpVTN6q3mP96Abuo1fGRIc=
Received: from mail-yw1-f72.google.com (mail-yw1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-aRA9gZf1O1yWUe3dWg7FnA-1; Mon, 16 Dec 2019 21:00:26 -0500
X-MC-Unique: aRA9gZf1O1yWUe3dWg7FnA-1
Received: by mail-yw1-f72.google.com with SMTP id a190so4028453ywe.15
        for <stable@vger.kernel.org>; Mon, 16 Dec 2019 18:00:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=rPjKUP3c5OBgFxjGzOJRPYxmS5qHOOKhkgjmkw+YN2I=;
        b=YfJXb1PL/cW7I6XuFyG9JF1CVtIHUw1uPjrTyt9Zcid0IxIGFmFYgEKmtjOjPbeYb/
         WHqTDM8Rcg7MoghCE5E6A3V1Qc0y86t8yB+9KCmYk6QUs2K7qjc9HaUMg919DPavZo4O
         dG9xdkZGCjdntSfF7/z+bixpsusBHBWugwLJGzji15gGSfZfF1ZeGjT6c1/y/WSp7Egu
         yhX4Xr2XwIRiyhvYxvhokAJVvtyesoLoalKriYqLZWKIhCKLEPfH/R0s2WqU6XdMuTvI
         +mboptBbi+eybmNQxSAdAkmgkmp7G3pVwW1OosTxJixHRhq6Mdf7Yeo6nggkIgN9msS/
         LjCQ==
X-Gm-Message-State: APjAAAWa6hoJN0FTbFrFDvw9qk+JfNZZ2IP/Q4+chiNeyaPhTIh8wACj
        fS45ccB+tlPhtiZYitKLSDjn0gnYXLakr/dTisjw4/MBW4sTpP88t3eytU6znAyQkN1lXzgR8Ng
        yfIRQjuzxadAE5RgD
X-Received: by 2002:a25:8c9:: with SMTP id 192mr4617221ybi.328.1576548025511;
        Mon, 16 Dec 2019 18:00:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqzSHXlqGOcOwe8mrQawvzd98LxvqAZaVnHrkCZ/xB8ek5ZKZOwysxZHuTASPJ2GCZv3Avp1zw==
X-Received: by 2002:a25:8c9:: with SMTP id 192mr4617202ybi.328.1576548025222;
        Mon, 16 Dec 2019 18:00:25 -0800 (PST)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id n1sm2256975ywe.78.2019.12.16.18.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 18:00:24 -0800 (PST)
Date:   Mon, 16 Dec 2019 19:00:22 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Bundy <christianbundy@fraction.io>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>, linux-integrity@vger.kernel.org
Subject: Re: [PATCH v2] tpm_tis: reserve chip for duration of
 tpm_tis_core_init
Message-ID: <20191217020022.knh7uxt4pn77wk5m@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
Mail-Followup-To: Dan Williams <dan.j.williams@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Bundy <christianbundy@fraction.io>,
        Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>, linux-integrity@vger.kernel.org
References: <20191211231758.22263-1-jsnitsel@redhat.com>
 <20191211235455.24424-1-jsnitsel@redhat.com>
 <5aef0fbe28ed23b963c53d61445b0bac6f108642.camel@linux.intel.com>
 <CAPcyv4h60z889bfbiwvVhsj6MxmOPiPY8ZuPB_skxkZx-N+OGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <CAPcyv4h60z889bfbiwvVhsj6MxmOPiPY8ZuPB_skxkZx-N+OGw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon Dec 16 19, Dan Williams wrote:
>On Mon, Dec 16, 2019 at 4:59 PM Jarkko Sakkinen
><jarkko.sakkinen@linux.intel.com> wrote:
>>
>> On Wed, 2019-12-11 at 16:54 -0700, Jerry Snitselaar wrote:
>> > Instead of repeatedly calling tpm_chip_start/tpm_chip_stop when
>> > issuing commands to the tpm during initialization, just reserve the
>> > chip after wait_startup, and release it when we are ready to call
>> > tpm_chip_register.
>> >
>> > Cc: Christian Bundy <christianbundy@fraction.io>
>> > Cc: Dan Williams <dan.j.williams@intel.com>
>> > Cc: Peter Huewe <peterhuewe@gmx.de>
>> > Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>> > Cc: Jason Gunthorpe <jgg@ziepe.ca>
>> > Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>
>> > Cc: stable@vger.kernel.org
>> > Cc: linux-integrity@vger.kernel.org
>> > Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")
>> > Fixes: 5b359c7c4372 ("tpm_tis_core: Turn on the TPM before probing IRQ's")
>> > Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
>>
>> I pushed to my master with minor tweaks and added my tags.
>>
>> Please check before I put it to linux-next.
>
>I don't see it yet here:
>
>http://git.infradead.org/users/jjs/linux-tpmdd.git/shortlog/refs/heads/master
>
>However, I wanted to make sure you captured that this does *not* fix
>the interrupt issue. I.e. make sure you remove the "Fixes:
>5b359c7c4372 ("tpm_tis_core: Turn on the TPM before probing IRQ's")"
>tag.
>
>With that said, are you going to include the revert of:
>
>1ea32c83c699 tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for interrupts

Dan, with the above reverted do you still get the screaming interrupt?

>5b359c7c4372 tpm_tis_core: Turn on the TPM before probing IRQ's
>
>...in your -rc3 pull?
>

