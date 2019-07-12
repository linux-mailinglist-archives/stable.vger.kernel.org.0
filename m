Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBF5673A1
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 19:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfGLRAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 13:00:03 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:44776 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbfGLRAD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 13:00:03 -0400
Received: by mail-ot1-f67.google.com with SMTP id b7so10086204otl.11
        for <stable@vger.kernel.org>; Fri, 12 Jul 2019 10:00:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=bq4iszxoy++/FTb2b/rFVHGRkSpwN8j8ho2KOYF5/8I=;
        b=AFz8f6UssXh1fFey7Ge9CA8XnPPORUcva1RuGmavRfMr+viG2j/GKHDqv/3mFyuums
         nj+XUXbttKJUf5Uj98Jo/sx0YAWleOpKtZvHrDlVDtuEgm4+1DymDq7vMqy6qn+WoRHI
         TAZWRyaNYn4Dh7aU2+0Titwl4ZaN3tBjb60KHyQuPoa+wrZm3H10IlvR4O93JmBUXAqF
         istAj8zLOdxlG7Hln1bOa6kNjaJxuov4UDBugJml5/jvQup0I/cz45h9vulcVsk7TttY
         xwqLE7wp/YNNpz++kZXEz3rwhLASuK8tibFOKuOpoVv7+zK1p+Z42siCLNzXk9d5sStt
         Eveg==
X-Gm-Message-State: APjAAAVn10mCTNkBvxoD50OraC02yZORqp5WCK+cFJgQE2S0q/h3g+pQ
        5/Z9NyHg5igBOSY38YpnCc0EFxrt0L8=
X-Google-Smtp-Source: APXvYqwIPYkciuLluNcPHLW9+jOyhVbOj2SewDyWvyDxGYSQyoiIeP94sKZtCbtkeEjyBaulwEdPkA==
X-Received: by 2002:a05:6830:1155:: with SMTP id x21mr9042031otq.336.1562950801848;
        Fri, 12 Jul 2019 10:00:01 -0700 (PDT)
Received: from [192.168.10.164] (cpe-24-243-36-151.satx.res.rr.com. [24.243.36.151])
        by smtp.gmail.com with ESMTPSA id o82sm3345027oig.27.2019.07.12.10.00.01
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 10:00:01 -0700 (PDT)
Subject: Re: [PATCH 5.2 00/61] 5.2.1-stable review
To:     stable@vger.kernel.org
References: <20190712121620.632595223@linuxfoundation.org>
From:   Major Hayden <major@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=major@redhat.com; prefer-encrypt=mutual; keydata=
 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 UNdR
Message-ID: <6e3388fa-7d6a-2f64-001a-2a57db16dc22@redhat.com>
Date:   Fri, 12 Jul 2019 12:00:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/12/19 7:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.1 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> and the diffstat can be found below.

We found that we have SATA issues on multiple types of aarch64 servers when we try to boot 5.2.1-rc1.

> [   14.187034] ata4: SATA max UDMA/133 abar m2097152@0x817000000000 port 0x817000000100 irq 32 
> [   14.195703] ahci 0005:00:08.0: SSS flag set, parallel bus scan disabled 
> [   14.202336] ahci 0005:00:08.0: AHCI 0001.0300 32 slots 1 ports 6 Gbps 0x1 impl SATA mode 
> [   14.210442] ahci 0005:00:08.0: flags: 64bit ncq sntf ilck stag pm led clo only pmp fbs pio slum part ccc apst  
> [   14.220444] ahci 0005:00:08.0: port 0 is not capable of FBS 
> [   14.226557] WARNING: CPU: 48 PID: 500 at drivers/ata/libata-core.c:6622 ata_host_activate+0x13c/0x150 
> [   14.235767] Modules linked in: 
> [   14.238819] CPU: 48 PID: 500 Comm: kworker/48:1 Not tainted 5.2.0-0ecfebd.cki #1 
> [   14.246204] Hardware name: Cavium ThunderX CRB/To be filled by O.E.M., BIOS 0ACGA023 11/22/2018 
> [   14.254901] Workqueue: events work_for_cpu_fn 
> [   14.259250] pstate: 00400005 (nzcv daif +PAN -UAO) 
> [   14.264030] pc : ata_host_activate+0x13c/0x150 
> [   14.268464] lr : ata_host_activate+0x70/0x150 
> [   14.272809] sp : ffff00001a383bd0 
> [   14.276114] x29: ffff00001a383bd0 x28: ffff810fa4175080  
> [   14.281416] x27: ffff810fa9b00e80 x26: 0000000000000001  
> [   14.286718] x25: ffff000010fb37f8 x24: 0000000000000080  
> [   14.292020] x23: ffff000011831150 x22: ffff0000107f3908  
> [   14.297322] x21: 0000000000000000 x20: ffff810fa9b00e80  
> [   14.302624] x19: 0000000000000000 x18: 0000000000000000  
> [   14.307926] x17: 0000000000000000 x16: 0000000000000000  
> [   14.313228] x15: 0000000000000010 x14: ffffffffffffffff  
> [   14.318530] x13: ffff00009a38378f x12: ffff00001a383797  
> [   14.323832] x11: ffff0000116e5000 x10: ffff0000112a7069  
> [   14.329134] x9 : 0000000000000000 x8 : ffff8000fbcd6500  
> [   14.334436] x7 : 0000000000000000 x6 : 000000000000007f  
> [   14.339738] x5 : 0000000000000080 x4 : ffff810fa47c4348  
> [   14.345041] x3 : ffff810fa47c4344 x2 : ffff810fa9b80c00  
> [   14.350343] x1 : ffff810fa47c4344 x0 : 0000000000000000  
> [    14.355646] Call.358084]  ata_host_activate+0x13c/0x150 
> [   14.362177]  ahci_host_activate+0x164/0x1d0 
> [   14.366351]  ahci_init_one+0x6d4/0xcbc 
> [   14.370098]  local_pci_probe+0x44/0x98 
> [   14.373837]  work_for_cpu_fn+0x20/0x30 
> [   14.377578]  process_one_work+0x1bc/0x3e8 
> [   14.381578]  worker_thread+0x220/0x440 
> [   14.385318]  kthread+0x104/0x130 
> [   14.388541]  ret_from_fork+0x10/0x18 
> [   14.392110] ---[ end trace 22a48d296a1d11eb ]--- 
We haven't narrowed it down to which patch caused the problem, but we started seeing the failures after commit b4c577f035071bd0a3523e186602d54fdcaf80ef went into stable-queue.

--
Major Hayden
