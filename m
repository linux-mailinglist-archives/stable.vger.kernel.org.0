Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 155AD8EB71
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 14:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731027AbfHOMWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 08:22:44 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:46628 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfHOMWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 08:22:43 -0400
Received: by mail-yw1-f67.google.com with SMTP id w10so626340ywa.13
        for <stable@vger.kernel.org>; Thu, 15 Aug 2019 05:22:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=F2qCY5teRzUF4uC1cWZ9xsTgTTBBFbp3qMsghNGHzK4=;
        b=G3c6MsFsbrr4KChBp3EB5RHd2JIWNhZnTKcz/VOVeYsRe+Q9Ft3L0nVbVAsE3tI8bo
         y9/oiBS1MQPG8TShe4nohI0VvjBnQQcdPGDzIDjPw4ya9LZkrB0cExGo3Rrz1xRl7TeV
         oFOgR4g/xhmu3TixZ2WFUd0N5s14IkvI2N5DtVt18UvQbpKRa4nyQ9SbmxnTGtQcFCZD
         CJh0UosgkNwJtm7oKktJbX3GJmN9vrpwoIZphCQr9A4vsQntIgzFeKPYaljb+wyEunLk
         q9g+3aIh8PjtQ8Wbuh4o5+sJ0GzjUzqpTXFby1W6XTs6C/q2r0f55/W29erd6nd2RRqq
         mhXA==
X-Gm-Message-State: APjAAAWaiLzgHos0Y0gd1X+EanSw0ReGyzJUZZ2Mz7CBBvADAEEinN4v
        hyzNaSFG3faUu1YP79QxzLIoItQ40Y8=
X-Google-Smtp-Source: APXvYqwXGWUN6r1tb6TY4aEQ+DF26qnXyUHHVvlYwPo11I+FK74hmBHx1wpHv2sRN0J0alxL7q6htg==
X-Received: by 2002:a81:3552:: with SMTP id c79mr2909731ywa.1.1565871762057;
        Thu, 15 Aug 2019 05:22:42 -0700 (PDT)
Received: from [192.168.10.164] (cpe-24-243-36-151.satx.res.rr.com. [24.243.36.151])
        by smtp.gmail.com with ESMTPSA id l82sm612163ywb.64.2019.08.15.05.22.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2019 05:22:41 -0700 (PDT)
Subject: =?UTF-8?Q?Re=3a_=e2=9c=85_PASS=3a_Test_report_for_kernel_5=2e2=2e9-?=
 =?UTF-8?Q?rc1-2440e48=2ecki_=28stable=29?=
To:     Linux Stable maillist <stable@vger.kernel.org>
References: <cki.BF9724DF28.NB2ZULIYXL@redhat.com>
From:   Major Hayden <major@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=major@redhat.com; prefer-encrypt=mutual; keydata=
 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 UNdR
Message-ID: <255f9af4-6087-7f56-5860-5aa0397a7631@redhat.com>
Date:   Thu, 15 Aug 2019 07:22:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <cki.BF9724DF28.NB2ZULIYXL@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/15/19 2:23 AM, CKI Project wrote:
>       Host 2:
>          ✅ Boot test [0]
>          ✅ xfstests: ext4 [29]
>          ✅ xfstests: xfs [29]
>          ✅ selinux-policy: serge-testsuite [30]
>          ⚡⚡⚡ lvm thinp sanity [31]
>          ⚡⚡⚡ storage: software RAID testing [32]
>          🚧 ❌ Storage blktests [34]

The blktests suite has normally passed for the patches in the stable queue on ppc64le, but caused a kernel panic this time around:

> [ 7101.664469] run blktests nvme/004 at 2019-08-14 21:47:13
> [ 7101.790613] nvmet: adding nsid 1 to subsystem blktests-subsystem-1
> [ 7101.911992] nvmet: creating controller 1 for subsystem blktests-subsystem-1 for NQN nqn.2014-08.org.nvmexpress:uuid:ca0ba025-7552-4280-aa1b-1b73939b8b1c.
> [ 7101.912194] nvme nvme1: creating 120 I/O queues.
> [ 7101.930157] BUG: Unable to handle kernel data access at 0x800a00066b9e7e28
> [ 7101.930185] Faulting instruction address: 0xc00000000067b230
> [ 7101.930199] Oops: Kernel access of bad area, sig: 11 [#1]
> [ 7101.930211] LE PAGE_SIZE=64K MMU=Radix MMU=Hash SMP NR_CPUS=1024 NUMA PowerNV
> [ 7101.930244] Modules linked in: nvme_loop nvme_fabrics nvmet loop crypto_user nfnetlink scsi_transport_iscsi xt_multiport bluetooth ecdh_generic rfkill ecc overlay ip6table_security ip6_tables xt_CONNSECMARK xt_SECMARK xt_state xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_security ah6 ah4 sctp dm_log_writes dm_flakey at24 regmap_i2c joydev i40e ses enclosure ofpart powernv_flash vmx_crypto mtd rtc_opal opal_prd ipmi_powernv ipmi_devintf ipmi_msghandler i2c_opal crct10dif_vpmsum sunrpc ip_tables xfs libcrc32c ast i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm crc32c_vpmsum nvme nvme_core mpt3sas drm_panel_orientation_quirks aacraid i2c_core raid_class scsi_transport_sas [last unloaded: null_blk]
> [ 7101.930371] CPU: 99 PID: 66936 Comm: nvme Not tainted 5.2.9-rc1-2440e48.cki #1
> [ 7101.930385] NIP:  c00000000067b230 LR: c00000000067b1d4 CTR: c000000000029140
> [ 7101.930400] REGS: c00020391ccc35c0 TRAP: 0300   Not tainted  (5.2.9-rc1-2440e48.cki)
> [ 7101.930413] MSR:  900000000280b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 44002228  XER: 20040000
> [ 7101.930433] CFAR: c0000000001d9e28 DAR: 800a00066b9e7e28 DSISR: 40000000 IRQMASK: 0 
>                GPR00: c00000000067b1d4 c00020391ccc3850 c0000000016cdb00 0000067578a4ab31 
>                GPR04: 0000000000000000 ffffffffffffffff 0000000001f3fb0e 0000000000000001 
>                GPR08: 800a00066b9e7d80 800a00066b9e7d80 0000000000000001 c00800000cd5db88 
>                GPR12: c000000000029140 c000203fff6b9800 0000000000000008 c00800000d5751e0 
>                GPR16: c000203985a8a6c0 c00800000e013278 c000203985a8a700 0000000000000038 
>                GPR20: 0000000000000030 0000000000000028 0000000000000020 fffffffffffff000 
>                GPR24: 0000000000000001 0000000000000400 0000000000000000 0000000000000023 
>                GPR28: 0000000000000000 0000000000000000 c00020391ccc38c8 c000003ef1b00000 
> [ 7101.930544] NIP [c00000000067b230] blk_mq_get_request+0x260/0x4b0
> [ 7101.930557] LR [c00000000067b1d4] blk_mq_get_request+0x204/0x4b0
> [ 7101.930569] Call Trace:
> [ 7101.930577] [c00020391ccc3850] [c00000000067b1d4] blk_mq_get_request+0x204/0x4b0 (unreliable)
> [ 7101.930594] [c00020391ccc38a0] [c00000000067b688] blk_mq_alloc_request_hctx+0x108/0x1b0
> [ 7101.930617] [c00020391ccc3910] [c00800000cd51aac] nvme_alloc_request+0x54/0xe0 [nvme_core]
> [ 7101.930633] [c00020391ccc3940] [c00800000cd5641c] __nvme_submit_sync_cmd+0x64/0x290 [nvme_core]
> [ 7101.930651] [c00020391ccc39c0] [c00800000d571650] nvmf_connect_io_queue+0x148/0x1e0 [nvme_fabrics]
> [ 7101.930668] [c00020391ccc3ab0] [c00800000e0106b0] nvme_loop_connect_io_queues+0x98/0xf8 [nvme_loop]
> [ 7101.930684] [c00020391ccc3af0] [c00800000e01116c] nvme_loop_create_ctrl+0x434/0x6a0 [nvme_loop]
> [ 7101.930700] [c00020391ccc3bd0] [c00800000d5724f0] nvmf_dev_write+0xd38/0x124c [nvme_fabrics]
> [ 7101.930719] [c00020391ccc3d60] [c000000000421e58] __vfs_write+0x38/0x70
> [ 7101.930731] [c00020391ccc3d80] [c000000000426188] vfs_write+0xd8/0x250
> [ 7101.930744] [c00020391ccc3dd0] [c000000000426558] ksys_write+0x78/0x130
> [ 7101.930758] [c00020391ccc3e20] [c00000000000bde4] system_call+0x5c/0x70
> [ 7101.930770] Instruction dump:
> [ 7101.930780] f91f0108 f91f0110 e91e0018 41820018 576a051c 554a0368 7d4a0034 554ad97e 
> [ 7101.930796] 69490001 79291f24 38e00001 7d284a14 <e94900a8> 394a0001 f94900a8 90ff00d4 
> [ 7101.930815] ---[ end trace 46fccc83bf29e598 ]---

We are still taking a look at this one but I figured it was worth mentioning here. :)

--
Major Hayden
