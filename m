Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C16C1049B2
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 05:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbfKUEsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 23:48:37 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:36683 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfKUEsh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 23:48:37 -0500
Received: by mail-il1-f194.google.com with SMTP id s75so2009130ilc.3;
        Wed, 20 Nov 2019 20:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fh2kN/lU7mRPHokRtJd6e3fCEFIJiroZZ0yxElbfzqs=;
        b=jA3ylDn3R3rlm4ISMWmWOZLv3cbhukQnCFPvuaVeBxawOL684lGXZxJ8blgLbTLQ0l
         jTXN4y2umAWY1w66x+eKSqVInaRvSB+myglrsWUpwQpUSybDLFbfvVfVss90Jz3eEvPJ
         xzB67KjCRlz1vJHybZ8IpjQg+LygNev64Wa1JplRnPh7xhAPu9XbN/aYcj5o8RGt2lVg
         +X2dYp0dR8caWXL7llZ4PzTx8KENv6c6YmR5AEv6oa3/ruy2592VPdRm2Mh4II/KR1vY
         CblbTmbAzZ9/9ieQKHgeZ2NrRwu4v3FET5Ig+yJYnAWZ55iyIlcKG4lSlwh8QiMdp6G7
         wDnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fh2kN/lU7mRPHokRtJd6e3fCEFIJiroZZ0yxElbfzqs=;
        b=D5gOkvkZKteAoCfuINcTyVm+Vsg49ZAAoZJg4SK8tTZcgEvAraFp+LB4GRIclccbB3
         O35F+38pgTXgrNavhZxTQqB/T8cNNRTfLNupHl5C51kEC6W/01/MBD3CV6pz5eUgBVYT
         MV26JCSln677ntxeY8R8RSobA41NY2FsRG6WERmEXbMnCufpoxIrDXtPDBA7MYX0f3xQ
         f5syT05p8/2qvsRdGjEWKTY7eUp+IjPdakmqp5efG/+92PCT5JLzakZIKDslUKYBdoVs
         J9qsNlrk+M0MBPo2BJVlTSZ9gI8lw1HrGHWBJHiE7EKFnC5a2/8OqyvewlZr5MXnNOwm
         uM7w==
X-Gm-Message-State: APjAAAWOODc68dqWonPFvK6G4E3Y4f38jzc4lkv2nLa6sQ6FvLpAltcQ
        0PuopkrkuJBxMKTkTbi+2focBYMuEYj3DTBNVK8=
X-Google-Smtp-Source: APXvYqyqC0bOLqeBjKWMPY+5UVaRAV7+YB6XL4nm9rXOT/pSx9MxWcMt0zCmleOAGia+kLdEe6eMwRry4gCHiNKUACM=
X-Received: by 2002:a92:ba04:: with SMTP id o4mr8252986ili.19.1574311716391;
 Wed, 20 Nov 2019 20:48:36 -0800 (PST)
MIME-Version: 1.0
References: <20190902143121.pjnykevzlajlcrh6@linux.intel.com>
In-Reply-To: <20190902143121.pjnykevzlajlcrh6@linux.intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 20 Nov 2019 20:48:25 -0800
Message-ID: <CAA9_cmeLnHK4y+usQaWo72nUG3RNsripuZnS-koY4XTRC+mwJA@mail.gmail.com>
Subject: Re: [GIT PULL] tpmdd updates for Linux v5.4
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org, James Morris <jmorris@namei.org>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 2, 2019 at 7:34 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> Hi
>
> A new driver for fTPM living inside ARM TEE was added this round. In
> addition to that, there is three bug fixes and one clean up.
>
> /Jarkko
>
> The following changes since commit 8fb8e9e46261e0117cb3cffb6dd8bb7e08f8649b:
>
>   Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma (2019-08-30 09:23:45 -0700)
>
> are available in the Git repository at:
>
>   git://git.infradead.org/users/jjs/linux-tpmdd.git tags/tpmdd-next-20190902
>
> for you to fetch changes up to e8bd417aab0c72bfb54465596b16085702ba0405:
>
>   tpm/tpm_ftpm_tee: Document fTPM TEE driver (2019-09-02 17:08:35 +0300)
>
> ----------------------------------------------------------------
> tpmdd updates for Linux v5.4
>
> ----------------------------------------------------------------
> Jarkko Sakkinen (1):
>       tpm: Remove a deprecated comments about implicit sysfs locking
>
> Lukas Bulwahn (1):
>       MAINTAINERS: fix style in KEYS-TRUSTED entry
>
> Sasha Levin (2):
>       tpm/tpm_ftpm_tee: A driver for firmware TPM running inside TEE
>       tpm/tpm_ftpm_tee: Document fTPM TEE driver
>
> Stefan Berger (2):
>       tpm_tis_core: Turn on the TPM before probing IRQ's
>       tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for interrupts

Hi Jarrko,

I'm replying here because I can't find the patches to reply to
directly from LKML.

Commit 7f064c378e2c "tpm_tis_core: Turn on the TPM before probing
IRQ's" in the v5.3-stable tree caused a regression on a pre-release
platform with a TPM2 device. The interrupt starts screaming when the
driver is loaded and does not stop until the device is force unbond
from the driver by:

     echo IFX0740:00 > /sys/bus/platform/drivers/tpm_tis/unbind

I checked v5.4-rc8 and it has the same problem. I tried reverting:

1ea32c83c699 tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for interrupts
5b359c7c4372 tpm_tis_core: Turn on the TPM before probing IRQ's

Which silenced the screaming interrupt problem, but now the TPM is reporting:

[    3.725131] tpm_tis IFX0740:00: 2.0 TPM (device-id 0x1B, rev-id 16)
[    3.725358] tpm tpm0: tpm_try_transmit: send(): error -5
[    3.725359] tpm tpm0: [Firmware Bug]: TPM interrupt not working,
polling instead

...at load, where it was not reporting this previously. Can you take a look?
