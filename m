Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4B61A707
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 08:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbfEKG6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 May 2019 02:58:18 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40715 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728274AbfEKG6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 May 2019 02:58:18 -0400
Received: by mail-pf1-f193.google.com with SMTP id u17so4386394pfn.7;
        Fri, 10 May 2019 23:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4525HGCKYKUIAapdwWluuqynGvAVPVK39ZeXzU/AgIU=;
        b=B+b5ISSUBaP+7by+S8MqPgbupEfuJLYuQuLLULVYJH/wHZnQ1/Njs8RW3z7e7CHTHU
         qeBKtsyDYjs+KH2dT8jMOpPoxurTAux8WRON1fM23QFDOlWjIcynirrI2nq8wTxcA8p8
         QzVws4QDkvPDT0kycYzRcThn299KXw2ZnqfmBzKWWtWPb9dU/G6a1i8SmSG07poKumni
         U4V2QkdPgfxmrJ4g3QxLBtn4CSLfWZhlbHh3wKTU/vib0bcxoaUQ6TqTPczMTccgjakd
         dj84qXqULvojENgg0BiWmbTeCcJptwnKm5XIf6Df4VO7GPlRP+pFl7Z4SrDVvI2EdT6s
         MMOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4525HGCKYKUIAapdwWluuqynGvAVPVK39ZeXzU/AgIU=;
        b=pMA8V6Z/Vwe5gDfhDjeGAbU/wjWMwRAHAj2ucENBygXURi9bfy89m7Vmbn34kYCmO2
         VkcQ6F6Ed0cs349ZUq+vFC8LUBHDPx11eCznYK6YH9gpa02rXrlechQJacEPArdTOosc
         jG2VXaDUKnChFH6VfKTAEtVyXvcHswzQUt/f5X2+qa7Zypevv8qZ6YK0rKroUxhSHMHA
         MYZiahYywGAUV8p8wb/uq8woDxiFNURUjXPwF0I8OpmobW14wEA2JEkemc3TbjZZ8005
         uK5jqNkD2yvuA/uCxKah8DlqtqbsTliBMXaS/D4HamOvR0O/5m50JuG4An2BQEMwAWM0
         mscQ==
X-Gm-Message-State: APjAAAW0hM8RQQbZMPU83RNfwOSHyO9cZteZtfvb3WXVj9mKvqQMvXdH
        g7dSbbhKIlNSw/OiWoX2ids=
X-Google-Smtp-Source: APXvYqwdfhGTcoe9i5aGD0rc82DI1M58Dd90fWRsCpi0jU52OifRtTs4B2hC/572ks4l1immRnBTuA==
X-Received: by 2002:a63:af44:: with SMTP id s4mr18397248pgo.411.1557557897791;
        Fri, 10 May 2019 23:58:17 -0700 (PDT)
Received: from Gentoo ([103.231.90.172])
        by smtp.gmail.com with ESMTPSA id g71sm20395987pgc.41.2019.05.10.23.58.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 23:58:16 -0700 (PDT)
Date:   Sat, 11 May 2019 12:28:02 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.1.1
Message-ID: <20190511065802.GA3945@Gentoo>
References: <20190511065032.GA27580@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <20190511065032.GA27580@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

Thanks, a bunch Greg! :)

On 08:50 Sat 11 May , Greg KH wrote:
>I'm announcing the release of the 5.1.1 kernel.
>
>All users of the 5.1 kernel series must upgrade.
>
>The updated 5.1.y git tree can be found at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.1.y
>and can be browsed at the normal kernel.org git web browser:
>	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
>
>thanks,
>
>greg k-h
>
>------------
>
> Makefile                               |    2
> arch/arm64/include/asm/futex.h         |   55 ++-
> drivers/acpi/acpi_lpss.c               |    4
> drivers/bluetooth/hci_bcm.c            |   20 +
> drivers/cpufreq/armada-37xx-cpufreq.c  |   22 +
> drivers/hv/hv.c                        |    1
> drivers/hwtracing/intel_th/pci.c       |    5
> drivers/i3c/master.c                   |    5
> drivers/iio/adc/qcom-spmi-adc5.c       |    1
> drivers/scsi/lpfc/lpfc_attr.c          |  196 ++++++-------
> drivers/scsi/lpfc/lpfc_ct.c            |   12
> drivers/scsi/lpfc/lpfc_debugfs.c       |  474 ++++++++++++++++-----------------
> drivers/scsi/lpfc/lpfc_debugfs.h       |    6
> drivers/scsi/qla2xxx/qla_attr.c        |    4
> drivers/scsi/qla2xxx/qla_nvme.c        |   19 -
> drivers/scsi/qla2xxx/qla_target.c      |    4
> drivers/soc/sunxi/Kconfig              |    1
> drivers/staging/greybus/power_supply.c |    2
> drivers/staging/most/cdev/cdev.c       |    2
> drivers/staging/most/sound/sound.c     |    2
> drivers/staging/wilc1000/wilc_netdev.c |    2
> drivers/usb/class/cdc-acm.c            |   32 +-
> drivers/usb/dwc3/Kconfig               |    6
> drivers/usb/dwc3/core.c                |    2
> drivers/usb/musb/Kconfig               |    2
> drivers/usb/serial/f81232.c            |   39 ++
> drivers/usb/storage/scsiglue.c         |   26 -
> drivers/usb/storage/uas.c              |   35 +-
> include/net/bluetooth/hci_core.h       |    3
> kernel/futex.c                         |  188 ++++++++-----
> kernel/irq/manage.c                    |    4
> lib/ubsan.c                            |   49 +--
> net/bluetooth/hci_conn.c               |    8
> net/bluetooth/hidp/sock.c              |    1
> net/bluetooth/l2cap_core.c             |    9
> sound/soc/intel/common/sst-firmware.c  |    8
> 36 files changed, 715 insertions(+), 536 deletions(-)
>
>Alan Stern (1):
>      usb-storage: Set virt_boundary_mask to avoid SG overflows
>
>Alexander Shishkin (1):
>      intel_th: pci: Add Comet Lake support
>
>Andrew Vasquez (1):
>      scsi: qla2xxx: Fix incorrect region-size setting in optrom SYSFS routines
>
>Andrey Ryabinin (1):
>      ubsan: Fix nasty -Wbuiltin-declaration-mismatch GCC-9 warnings
>
>Bjorn Andersson (1):
>      iio: adc: qcom-spmi-adc5: Fix of-based module autoloading
>
>Chen-Yu Tsai (1):
>      Bluetooth: hci_bcm: Fix empty regulator supplies for Intel Macs
>
>Christian Gromm (1):
>      staging: most: sound: pass correct device when creating a sound card
>
>Dan Carpenter (1):
>      i3c: Fix a shift wrap bug in i3c_bus_set_addr_slot_status()
>
>Dexuan Cui (1):
>      Drivers: hv: vmbus: Remove the undesired put_cpu_ptr() in hv_synic_cleanup()
>
>Giridhar Malavali (1):
>      scsi: qla2xxx: Set remote port devloss timeout to 0
>
>Greg Kroah-Hartman (1):
>      Linux 5.1.1
>
>Gregory CLEMENT (1):
>      cpufreq: armada-37xx: fix frequency calculation for opp
>
>Hans de Goede (1):
>      ACPI / LPSS: Use acpi_lpss_* instead of acpi_subsys_* functions for hibernate
>
>Ji-Ze Hong (Peter Hong) (1):
>      USB: serial: f81232: fix interrupt worker not stop
>
>Johan Hovold (2):
>      staging: greybus: power_supply: fix prop-descriptor request size
>      USB: cdc-acm: fix unthrottle races
>
>Luiz Augusto von Dentz (1):
>      Bluetooth: Fix not initializing L2CAP tx_credits
>
>Marc Gonzalez (1):
>      usb: dwc3: Allow building USB_DWC3_QCOM without EXTCON
>
>Marcel Holtmann (1):
>      Bluetooth: Align minimum encryption key size for LE and BR/EDR connections
>
>Oliver Neukum (1):
>      UAS: fix alignment of scatter/gather segments
>
>Prasad Sodagudi (1):
>      genirq: Prevent use-after-free and work list corruption
>
>Quinn Tran (1):
>      scsi: qla2xxx: Fix device staying in blocked state
>
>Ross Zwisler (1):
>      ASoC: Intel: avoid Oops if DMA setup fails
>
>Samuel Holland (1):
>      soc: sunxi: Fix missing dependency on REGMAP_MMIO
>
>Silvio Cesare (1):
>      scsi: lpfc: change snprintf to scnprintf for possible overflow
>
>Suresh Udipi (1):
>      staging: most: cdev: fix chrdev_region leak in mod_exit
>
>Tetsuo Handa (1):
>      staging: wilc1000: Avoid GFP_KERNEL allocation from atomic context.
>
>Thinh Nguyen (1):
>      usb: dwc3: Fix default lpm_nyet_threshold value
>
>Will Deacon (2):
>      locking/futex: Allow low-level atomic operations to return -EAGAIN
>      arm64: futex: Bound number of LDXR/STXR loops in FUTEX_WAKE_OP
>
>Young Xiao (1):
>      Bluetooth: hidp: fix buffer overflow
>



--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAlzWcnAACgkQsjqdtxFL
KRWnvgf/YHT0hK7SF2Kh1xR/gCx8/pB8p0k443HMizb6rZJKNWOCe8F+PwmJXxE+
tNzJh0ZdxHGO89/VQ5poz0ZFn+WQjpKvuQtPg7hxvOFzEHattO6sur6LBZfKZMsV
6mQr236L1nn19U8KECdwgrKsDO6T1OtbLZogk1xSowpOrPqBWhbt68WtPhpMgQKJ
2R7hsXSyizz5IuqFYfkRc6PZx8qdZaFPH0aOq5vruQWJF5WzpfhLcffB4XXT4gQb
215a0lZ9TxMwbbVqS+jwREPcL+/P+blHlX2U/EGAYNeOnl64dbjigqKFsFsDRbRl
zANt+7dUYVu1j1/hOCIVNKnA9Efxng==
=oAWH
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
