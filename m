Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4BB67410
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 19:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfGLRRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 13:17:45 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34293 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfGLRRp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 13:17:45 -0400
Received: by mail-io1-f67.google.com with SMTP id k8so22010066iot.1
        for <stable@vger.kernel.org>; Fri, 12 Jul 2019 10:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=shgJZazjYjKH3+omeuZSyWEnq8zqPtNlXTpLxyg8X50=;
        b=hOk3Df7mzMnfLlajNYELr35Wlbwvcb7odTRNx+EaW8gaYwpRBm4JwtjS/SE7taDl39
         Wbl34t6WMPtdLeI8uZeIDV51z/MoHx87XlV/FTWR03pmkWbj7N4Yug9NsuAwr2NZPdvX
         ZPi+IsK2GwwfWSWLPN7UK7X2qiCtRfg91BUmeqSImcj+Qg+Qi1RBqcqitMrlqJPMX7Lv
         e7iv/F83vJhdOlV/CFblVXoNBfohZinQzf4yfG0y7XloYBD+bwekru/ebObDAOhF62Vj
         VoAOdLbbfKQBX2El7UzA1mNoBqCYoAAVgPBDpCpRIIxpXtrFeiWrbWx6XSpOvCOtjfvf
         Sh2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=shgJZazjYjKH3+omeuZSyWEnq8zqPtNlXTpLxyg8X50=;
        b=qO50HSg1btMS0lHmLKTqyPsDOElEPTJh0S9w/me2JsC+GlEk2LxzOtstwMWdOfVa2Y
         yC8Pm0ACow/UXgUrT0DRC2Vhftcn4t3bbtUSgfFGcfeV9sYGEDXSk0cBrLYoFBj0sfnb
         NFC55V+sNlFWx81R5VY0y0t85QltMqi0RnoDzEcDqnRnQc8JnQ8py2/8NST2xZURPrme
         LgtXvBgHxMZJWjkZnWuDjM+5mZBg9y/eJETebJ040Xd9yHeAxuVt6E0t7olqDC4LahRo
         R7Flczvzy1I2MJEx8TMjqt0TjvuinjgMQW1ZrEiwmYm3hpgSR9Z6wmCShPXL5IZn9vRN
         7X8w==
X-Gm-Message-State: APjAAAVH2ShFPdTxogF5LXm6si2jNsfMqViYk4UaHwolxqCRCFFrT2Rz
        D7Oyl0zgm9c26J3a+pbsNoh1nw==
X-Google-Smtp-Source: APXvYqya6G+vU9AofvFIMWmnMdxNKt1TxbmxzX8xu+b6zBvl1tMoY9YyK6hcTQfvUd3shCDCnJ2QEQ==
X-Received: by 2002:a5d:8249:: with SMTP id n9mr11744067ioo.14.1562951863873;
        Fri, 12 Jul 2019 10:17:43 -0700 (PDT)
Received: from localhost (c-75-72-120-115.hsd1.mn.comcast.net. [75.72.120.115])
        by smtp.gmail.com with ESMTPSA id m10sm13637587ioj.75.2019.07.12.10.17.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 12 Jul 2019 10:17:43 -0700 (PDT)
Date:   Fri, 12 Jul 2019 12:17:40 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Major Hayden <major@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.2 00/61] 5.2.1-stable review
Message-ID: <20190712171740.xutpgyqzb4564e72@xps.therub.org>
Mail-Followup-To: Major Hayden <major@redhat.com>, stable@vger.kernel.org
References: <20190712121620.632595223@linuxfoundation.org>
 <6e3388fa-7d6a-2f64-001a-2a57db16dc22@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e3388fa-7d6a-2f64-001a-2a57db16dc22@redhat.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 12, 2019 at 12:00:00PM -0500, Major Hayden wrote:
> On 7/12/19 7:19 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.1 release.
> > There are 61 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.1-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> > and the diffstat can be found below.
> 
> We found that we have SATA issues on multiple types of aarch64 servers when we try to boot 5.2.1-rc1.
> 
> > [   14.187034] ata4: SATA max UDMA/133 abar m2097152@0x817000000000 port 0x817000000100 irq 32 
> > [   14.195703] ahci 0005:00:08.0: SSS flag set, parallel bus scan disabled 
> > [   14.202336] ahci 0005:00:08.0: AHCI 0001.0300 32 slots 1 ports 6 Gbps 0x1 impl SATA mode 
> > [   14.210442] ahci 0005:00:08.0: flags: 64bit ncq sntf ilck stag pm led clo only pmp fbs pio slum part ccc apst  
> > [   14.220444] ahci 0005:00:08.0: port 0 is not capable of FBS 
> > [   14.226557] WARNING: CPU: 48 PID: 500 at drivers/ata/libata-core.c:6622 ata_host_activate+0x13c/0x150 
> > [   14.235767] Modules linked in: 
> > [   14.238819] CPU: 48 PID: 500 Comm: kworker/48:1 Not tainted 5.2.0-0ecfebd.cki #1 
> > [   14.246204] Hardware name: Cavium ThunderX CRB/To be filled by O.E.M., BIOS 0ACGA023 11/22/2018 
> > [   14.254901] Workqueue: events work_for_cpu_fn 
> > [   14.259250] pstate: 00400005 (nzcv daif +PAN -UAO) 
> > [   14.264030] pc : ata_host_activate+0x13c/0x150 
> > [   14.268464] lr : ata_host_activate+0x70/0x150 
> > [   14.272809] sp : ffff00001a383bd0 
> > [   14.276114] x29: ffff00001a383bd0 x28: ffff810fa4175080  
> > [   14.281416] x27: ffff810fa9b00e80 x26: 0000000000000001  
> > [   14.286718] x25: ffff000010fb37f8 x24: 0000000000000080  
> > [   14.292020] x23: ffff000011831150 x22: ffff0000107f3908  
> > [   14.297322] x21: 0000000000000000 x20: ffff810fa9b00e80  
> > [   14.302624] x19: 0000000000000000 x18: 0000000000000000  
> > [   14.307926] x17: 0000000000000000 x16: 0000000000000000  
> > [   14.313228] x15: 0000000000000010 x14: ffffffffffffffff  
> > [   14.318530] x13: ffff00009a38378f x12: ffff00001a383797  
> > [   14.323832] x11: ffff0000116e5000 x10: ffff0000112a7069  
> > [   14.329134] x9 : 0000000000000000 x8 : ffff8000fbcd6500  
> > [   14.334436] x7 : 0000000000000000 x6 : 000000000000007f  
> > [   14.339738] x5 : 0000000000000080 x4 : ffff810fa47c4348  
> > [   14.345041] x3 : ffff810fa47c4344 x2 : ffff810fa9b80c00  
> > [   14.350343] x1 : ffff810fa47c4344 x0 : 0000000000000000  
> > [    14.355646] Call.358084]  ata_host_activate+0x13c/0x150 
> > [   14.362177]  ahci_host_activate+0x164/0x1d0 
> > [   14.366351]  ahci_init_one+0x6d4/0xcbc 
> > [   14.370098]  local_pci_probe+0x44/0x98 
> > [   14.373837]  work_for_cpu_fn+0x20/0x30 
> > [   14.377578]  process_one_work+0x1bc/0x3e8 
> > [   14.381578]  worker_thread+0x220/0x440 
> > [   14.385318]  kthread+0x104/0x130 
> > [   14.388541]  ret_from_fork+0x10/0x18 
> > [   14.392110] ---[ end trace 22a48d296a1d11eb ]--- 
> We haven't narrowed it down to which patch caused the problem, but we started seeing the failures after commit b4c577f035071bd0a3523e186602d54fdcaf80ef went into stable-queue.

For what it's worth we don't see this problem on aarch64 with SATA (on
juno-r2). What is the mainline hash for
b4c577f035071bd0a3523e186602d54fdcaf80ef? I don't see it anymore.


[    2.736859] sata_sil24 0000:03:00.0: version 1.1
[    2.741492] sata_sil24 0000:03:00.0: enabling device (0000 -> 0003)
[    2.750678] scsi host0: sata_sil24
[    2.755527] scsi host1: sata_sil24
[    2.759412] ata1: SATA max UDMA/100 host m128@0x50084000 port 0x50080000 irq 51
[    2.766695] ata2: SATA max UDMA/100 host m128@0x50084000 port 0x50082000 irq 51
...
[    4.942208] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[    4.950967] ata1.00: ATA-9: SanDisk SSD PLUS 120GB, UE5000RL, max UDMA/133
[    4.958055] ata1.00: 234455040 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    4.970470] ata1.00: configured for UDMA/100
[    4.978034] scsi 0:0:0:0: Direct-Access     ATA      SanDisk SSD PLUS 00RL PQ: 0 ANSI: 5
[    4.990447] sd 0:0:0:0: [sda] 234455040 512-byte logical blocks: (120 GB/112 GiB)
[    4.998283] sd 0:0:0:0: [sda] Write Protect is off
[    5.003081] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.008264] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.025885] sd 0:0:0:0: [sda] Attached SCSI disk

Full log @ https://lkft.validation.linaro.org/scheduler/job/821234

Dan

> 
> --
> Major Hayden

-- 
Linaro - Kernel Validation
