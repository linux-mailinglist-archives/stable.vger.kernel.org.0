Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF21583FD7
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 15:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbiG1NUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 09:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237024AbiG1NUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 09:20:14 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4385D14D1A;
        Thu, 28 Jul 2022 06:20:11 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id l9-20020a056830268900b006054381dd35so1153516otu.4;
        Thu, 28 Jul 2022 06:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QRyieLNejEFzDALRYVGJ8QkVxd5I7JJdYKsJ/9xCWWc=;
        b=J3B5x6EhTr8bB0kXgjOcrf57/Nc3ip81sbwt0IiNsbk7PYrAFssjVLMFJGQ+a1dd2E
         Mpa+Xqoi5sdnnPVuOhRbeKS2czSGvLEafTB2iIYLvG7i8trorDYmCSL4++w154sTQJkR
         b6W2I5dqN6PO9OM13+HHUxTjUaK0+swrzAJ/0Y6RA1pMztl7eKlDP4G1HKhvB8PxeB3y
         hxhKUpgekCzXJBh32fa36DeQNzD7QJbAo0rJftlRsK/Dzxx+3u74p0mMbdQY/SySIAKJ
         enkre2eak24OM4aaq6z3nRHa7pw9RIQka5IWzvx9meSm8Y/dq32xOZ6FwJDKj66iqnUn
         MVEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QRyieLNejEFzDALRYVGJ8QkVxd5I7JJdYKsJ/9xCWWc=;
        b=hgmVOaCi4G8J5XapUH+uAxkeindbEl+OC0rh60sSCyAJ+nJwRCszMOxTgrjCNW/sCs
         XYOppaHpKEf5oSJutVvx9qp+OPFwsedcAMZUnEyaJR7p9JZB9lKEE/TcD9YbWCvDeGh/
         r1/MkJto1buTfb2PPE1JN3WmwMmGf34qkcpQXZAgObx5ELK7qkHHrMVYUW3zbrTq3+mQ
         hRHlmZbHkNb2ZwTHc6YLiDOwucfDZIYrinQnGrQpwTorWdodIAAiagKQzwpBC7tEp49Q
         0pNyUOi/g/ZLzNdfRmx7kIeTaoEovft/A6GbTG+xmI8myrd2HI1hMDxUA+hbXgLOl97X
         ag5Q==
X-Gm-Message-State: AJIora+P+uw7EN/SMf3L998Gj8S6e7sQZBteRg2RcPkadY5C2Yc9/D9q
        SnkWo+F/A/ZQqzb8vzyiKuk=
X-Google-Smtp-Source: AGRyM1v6JYNXxK1LFAaXkJEjcZi6OmXLCIbh2BZYFc01GNLxSFBbQwSuonTw0F+LzAMPPaTWZNvxDA==
X-Received: by 2002:a9d:1789:0:b0:61d:403:5aa with SMTP id j9-20020a9d1789000000b0061d040305aamr6276737otj.361.1659014410521;
        Thu, 28 Jul 2022 06:20:10 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v22-20020a4ac916000000b0042573968646sm360616ooq.11.2022.07.28.06.20.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 06:20:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <570b5e5a-c25d-ccd4-42ce-f2d73d4e3511@roeck-us.net>
Date:   Thu, 28 Jul 2022 06:20:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.10 000/105] 5.10.134-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220727161012.056867467@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/27/22 09:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.134 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
> 

Crashes when trying to boot from btrfs file system. Crash log below.
I'll bisect.

Guenter

---
[   15.603570] BUG: kernel NULL pointer dereference, address: 0000000000000110
[   15.603709] #PF: supervisor read access in kernel mode
[   15.603776] #PF: error_code(0x0000) - not-present page
[   15.603896] PGD 0 P4D 0
[   15.604068] Oops: 0000 [#1] SMP PTI
[   15.604243] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.10.134-rc1+ #1
[   15.604329] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[   15.604688] RIP: 0010:bio_alloc_bioset+0x27/0x2a0
[   15.604897] Code: 00 66 90 41 57 41 56 41 89 f6 41 55 41 89 fd 41 54 55 53 48 89 d3 48 83 ec 20 65 48 8b 04 25 28 00 00 00 48 89 44 24 18 31 c0 <48> 83 ba 10 01 00 00 00 75 08 85 f6 0f 85 40 02 00 00 65 48 8b 04
[   15.605103] RSP: 0000:ffffa56b8001fa68 EFLAGS: 00000246
[   15.605191] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
[   15.605274] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000cc0
[   15.605356] RBP: ffffa56b8001faf0 R08: 0000000000000000 R09: ffff8fe184b96400
[   15.605439] R10: 0000000000000001 R11: ffff8fe184b91c00 R12: ffff8fe184b96400
[   15.605520] R13: 0000000000000cc0 R14: 0000000000000000 R15: ffff8fe184bc9428
[   15.605649] FS:  0000000000000000(0000) GS:ffff8fe19f700000(0000) knlGS:0000000000000000
[   15.605742] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   15.605809] CR2: 0000000000000110 CR3: 000000000b022000 CR4: 00000000001506e0
[   15.605960] Call Trace:
[   15.606189]  ? rcu_read_lock_sched_held+0x3e/0x80
[   15.606355]  ? kmem_cache_alloc_trace+0x1cc/0x270
[   15.606420]  btrfs_alloc_device+0x62/0x1f0
[   15.606505]  device_list_add.constprop.0+0x2d4/0x780
[   15.606574]  ? btrfs_scan_one_device+0xf3/0x1b0
[   15.606627]  btrfs_scan_one_device+0xf3/0x1b0
[   15.606688]  btrfs_mount_root+0x257/0x4e0
[   15.606747]  ? rcu_read_lock_sched_held+0x3e/0x80
[   15.606802]  ? kfree+0x1c8/0x2a0
[   15.606851]  legacy_get_tree+0x2b/0x50
[   15.606898]  vfs_get_tree+0x23/0xc0
[   15.606946]  vfs_kern_mount.part.0+0x74/0xb0
[   15.606999]  btrfs_mount+0x134/0x3e0
[   15.607051]  ? cred_has_capability.isra.0+0x73/0x120
[   15.607118]  ? legacy_get_tree+0x2b/0x50
[   15.607166]  ? btrfs_show_options+0x570/0x570
[   15.607216]  legacy_get_tree+0x2b/0x50
[   15.607263]  vfs_get_tree+0x23/0xc0
[   15.607309]  path_mount+0x2b2/0xc00
[   15.607365]  init_mount+0x53/0x87
[   15.607417]  do_mount_root+0x81/0x112
[   15.607468]  mount_block_root+0x112/0x209
[   15.607548]  prepare_namespace+0x136/0x165
[   15.607600]  kernel_init_freeable+0x28c/0x299
[   15.607662]  ? rest_init+0x25a/0x25a
[   15.607710]  kernel_init+0x5/0x106
[   15.607756]  ret_from_fork+0x22/0x30
[   15.607861] Modules linked in:
[   15.608000] CR2: 0000000000000110
[   15.608390] ---[ end trace dfad67f752e12a9e ]---
[   15.608510] RIP: 0010:bio_alloc_bioset+0x27/0x2a0
[   15.608570] Code: 00 66 90 41 57 41 56 41 89 f6 41 55 41 89 fd 41 54 55 53 48 89 d3 48 83 ec 20 65 48 8b 04 25 28 00 00 00 48 89 44 24 18 31 c0 <48> 83 ba 10 01 00 00 00 75 08 85 f6 0f 85 40 02 00 00 65 48 8b 04
[   15.608751] RSP: 0000:ffffa56b8001fa68 EFLAGS: 00000246
[   15.608815] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
[   15.608891] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000cc0
[   15.608967] RBP: ffffa56b8001faf0 R08: 0000000000000000 R09: ffff8fe184b96400
[   15.609042] R10: 0000000000000001 R11: ffff8fe184b91c00 R12: ffff8fe184b96400
[   15.609117] R13: 0000000000000cc0 R14: 0000000000000000 R15: ffff8fe184bc9428
[   15.609193] FS:  0000000000000000(0000) GS:ffff8fe19f700000(0000) knlGS:0000000000000000
[   15.609278] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   15.609340] CR2: 0000000000000110 CR3: 000000000b022000 CR4: 00000000001506e0
[   15.609496] BUG: sleeping function called from invalid context at include/linux/percpu-rwsem.h:49
[   15.609604] in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 1, name: swapper/0
[   15.609726] INFO: lockdep is turned off.
[   15.609790] irq event stamp: 481426
[   15.609842] hardirqs last  enabled at (481425): [<ffffffff9c82d234>] kmem_cache_alloc_trace+0x264/0x270
[   15.609946] hardirqs last disabled at (481426): [<ffffffff9d4fa5bd>] exc_page_fault+0x2d/0x200
[   15.610043] softirqs last  enabled at (481406): [<ffffffff9cb53aba>] get_gendisk+0xfa/0x150
[   15.610136] softirqs last disabled at (481404): [<ffffffff9cb53a58>] get_gendisk+0x98/0x150
[   15.610291] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G      D           5.10.134-rc1+ #1
[   15.610374] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[   15.610478] Call Trace:
[   15.610523]  dump_stack+0x77/0x9b
[   15.610573]  ___might_sleep.cold+0xa6/0xb6
[   15.610627]  exit_signals+0x17/0x2d0
[   15.610674]  do_exit+0xd0/0xb70
[   15.610719]  ? prepare_namespace+0x136/0x165
[   15.610776]  rewind_stack_do_exit+0x17/0x20
[   15.610948] RIP: 0000:0x0
[   15.611077] Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
[   15.611155] RSP: 0000:0000000000000000 EFLAGS: 00000000 ORIG_RAX: 0000000000000000
[   15.611252] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[   15.611326] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[   15.611398] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[   15.611474] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[   15.611546] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[   15.611771] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
[   15.612465] Kernel Offset: 0x1b600000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[   15.612831] ACPI MEMORY or I/O RESET_REG.
