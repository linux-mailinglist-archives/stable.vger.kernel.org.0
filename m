Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 793C710C15B
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 02:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfK1BVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 20:21:14 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46436 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727109AbfK1BVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 20:21:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574904072;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/HFDV1dFXXc1XWLJ2qEUSb2HH9ThLGZlFl18InpcbEM=;
        b=geeb5ypGite6MhMQ5vIN4BYmB741gbviVHOKTCaV1yEeAToAbY05vir5zDDTNIaqFlbwqw
        BRmmNswrcuD0HX6YjKH9dBQ4j5Gu3SJdEZ14rjewjqOTh+vlaecZAutRmPjBUH/UIjBuDj
        7qLwLELQYq1VubSqPXE9XgAMC4lsaHU=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-gufBH08-MHah452UwuB0jg-1; Wed, 27 Nov 2019 20:21:10 -0500
Received: by mail-pg1-f199.google.com with SMTP id m13so13753024pgk.12
        for <stable@vger.kernel.org>; Wed, 27 Nov 2019 17:21:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=vTEn0L1tG99iZM5cLflAm0RZ2oMnvmDu1+wuwMQxkUM=;
        b=OwMRsbW9ANBsbMGVmsRUhzj3ifefHquq2M0dhDaLtzLBXgXEYz5ct0lNIwRixIdB5T
         2g55ouQdUGSnHHFuhWMCOS3W3fYdcHAvqanksvPJzTUXTKmupb72KX5yr6PLMj2BzNBH
         AnNEgQ8ltXHjocGwnDE+xroR0DmeVPCqFq7ChB1BEF6RJMKW3Qy1fOMi+FKvjp4t0x7x
         JsUfn3c9a8BsFD13Sv8Zd6Tcobby8BpCI4CSKke77UiZCD0gY1KS53teR2LI2UnTOMss
         LB1AybY/OwGIMBw0Tvb9t5gI/iJPv/AHrTq7DhGKosytO9+SdhHZUhaW0SnJFF7K+vN4
         Z5DQ==
X-Gm-Message-State: APjAAAUTMEP7BFFuHpyUWDkgmVja2C8FdpgHGcB+H3B6Tv4LY0PNVt00
        pGhGm8XVqu9iwXtfbkDflW8Pqal+dT/YJBr2L9+EoKQkLsWAfzs51oEp0Cn/cTPxxHudJPZex3H
        P5p+1oSAV604pBGTp
X-Received: by 2002:a17:90a:2ec1:: with SMTP id h1mr6483430pjs.135.1574904068882;
        Wed, 27 Nov 2019 17:21:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqyjVtEYxAwz6OxEYHIoYVxh1+vYXkjGP6L4qiqNj44pwBMCuMKKj8B0oFLc4FDJ/qFfluQ55w==
X-Received: by 2002:a17:90a:2ec1:: with SMTP id h1mr6483414pjs.135.1574904068578;
        Wed, 27 Nov 2019 17:21:08 -0800 (PST)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id u26sm2722140pfn.46.2019.11.27.17.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 17:21:07 -0800 (PST)
Date:   Wed, 27 Nov 2019 18:20:55 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org, James Morris <jmorris@namei.org>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] tpmdd updates for Linux v5.4
Message-ID: <20191128012055.f3a6gq7bjpvuierx@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
Mail-Followup-To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org, James Morris <jmorris@namei.org>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>
References: <20190902143121.pjnykevzlajlcrh6@linux.intel.com>
 <CAA9_cmeLnHK4y+usQaWo72nUG3RNsripuZnS-koY4XTRC+mwJA@mail.gmail.com>
 <20191127205800.GA14290@linux.intel.com>
 <20191127205912.GB14290@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20191127205912.GB14290@linux.intel.com>
X-MC-Unique: gufBH08-MHah452UwuB0jg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed Nov 27 19, Jarkko Sakkinen wrote:
>On Wed, Nov 27, 2019 at 10:58:00PM +0200, Jarkko Sakkinen wrote:
>> On Wed, Nov 20, 2019 at 08:48:25PM -0800, Dan Williams wrote:
>> > On Mon, Sep 2, 2019 at 7:34 AM Jarkko Sakkinen
>> > <jarkko.sakkinen@linux.intel.com> wrote:
>> > >
>> > > Hi
>> > >
>> > > A new driver for fTPM living inside ARM TEE was added this round. In
>> > > addition to that, there is three bug fixes and one clean up.
>> > >
>> > > /Jarkko
>> > >
>> > > The following changes since commit 8fb8e9e46261e0117cb3cffb6dd8bb7e0=
8f8649b:
>> > >
>> > >   Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel=
/git/rdma/rdma (2019-08-30 09:23:45 -0700)
>> > >
>> > > are available in the Git repository at:
>> > >
>> > >   git://git.infradead.org/users/jjs/linux-tpmdd.git tags/tpmdd-next-=
20190902
>> > >
>> > > for you to fetch changes up to e8bd417aab0c72bfb54465596b16085702ba0=
405:
>> > >
>> > >   tpm/tpm_ftpm_tee: Document fTPM TEE driver (2019-09-02 17:08:35 +0=
300)
>> > >
>> > > ----------------------------------------------------------------
>> > > tpmdd updates for Linux v5.4
>> > >
>> > > ----------------------------------------------------------------
>> > > Jarkko Sakkinen (1):
>> > >       tpm: Remove a deprecated comments about implicit sysfs locking
>> > >
>> > > Lukas Bulwahn (1):
>> > >       MAINTAINERS: fix style in KEYS-TRUSTED entry
>> > >
>> > > Sasha Levin (2):
>> > >       tpm/tpm_ftpm_tee: A driver for firmware TPM running inside TEE
>> > >       tpm/tpm_ftpm_tee: Document fTPM TEE driver
>> > >
>> > > Stefan Berger (2):
>> > >       tpm_tis_core: Turn on the TPM before probing IRQ's
>> > >       tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for interru=
pts
>> >
>> > Hi Jarrko,
>> >
>> > I'm replying here because I can't find the patches to reply to
>> > directly from LKML.
>> >
>> > Commit 7f064c378e2c "tpm_tis_core: Turn on the TPM before probing
>> > IRQ's" in the v5.3-stable tree caused a regression on a pre-release
>> > platform with a TPM2 device. The interrupt starts screaming when the
>> > driver is loaded and does not stop until the device is force unbond
>> > from the driver by:
>> >
>> >      echo IFX0740:00 > /sys/bus/platform/drivers/tpm_tis/unbind
>> >
>> > I checked v5.4-rc8 and it has the same problem. I tried reverting:
>> >
>> > 1ea32c83c699 tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for in=
terrupts
>> > 5b359c7c4372 tpm_tis_core: Turn on the TPM before probing IRQ's
>> >
>> > Which silenced the screaming interrupt problem, but now the TPM is rep=
orting:
>> >
>> > [    3.725131] tpm_tis IFX0740:00: 2.0 TPM (device-id 0x1B, rev-id 16)
>> > [    3.725358] tpm tpm0: tpm_try_transmit: send(): error -5
>> > [    3.725359] tpm tpm0: [Firmware Bug]: TPM interrupt not working,
>> > polling instead
>> >
>> > ...at load, where it was not reporting this previously. Can you take a=
 look?
>>
>> It is already in WiP:
>>
>> https://patchwork.kernel.org/patch/11240111/
>>
>> Stefan also sent patches that revert to changes that you described:
>>
>> https://patchwork.kernel.org/cover/11262363/
>>
>> Probably better first to fix the issue on top of master before deciding
>> actions.
>
>... and apologies for late response.
>
>/Jarkko
>

There also was that other issue reported on the list about
tpm_tis_core_init failing when calling tpm_get_timeouts due to the
power gating changes.

