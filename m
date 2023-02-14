Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24DD696B36
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 18:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjBNRRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 12:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbjBNRRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 12:17:11 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B213028E;
        Tue, 14 Feb 2023 09:15:51 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id v15so13522790oie.9;
        Tue, 14 Feb 2023 09:15:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=c4eYGmAnG6oz7K1k5viKNr7yMloNw/vUb4CdRNYYMkg=;
        b=IOVXgjzBMAzYLINVqSZME7sbGWyDhvliBq9alOMb2G+nl6f01BRRCyXLnfo8nPV3MM
         kF27iPYBH5EcghoKercqrdC4qrILDznShaOS97ZYQZoxn7K3sfPkJxEkXovHSybnt04u
         QIB+MFURu+q/kx6N+zcFEJbqXbbUj1gmiXuiopntfkEzD7TfJ2g9FOenRaVCSLTVhxzO
         Paket1qVz+JEaNi8yDabRyqWn0z0mMgvGmmhb3rzN8mnc9Tqn4bNpUdmFaTO8LYWNbD8
         P6iPqI5CBT1+wnGW4vU968yYkEe+WPCQmju23ygIQ3z34eY6oGpnim6t0BjJcf7oeu/m
         kWew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c4eYGmAnG6oz7K1k5viKNr7yMloNw/vUb4CdRNYYMkg=;
        b=8MadBRtoOi6lF2vEX629ppcfwR7G0yk2BUsFLfeuJQMhG78QGPt8JP6KruhlJGerkw
         hdJePDzxciUQp9HbclIwk/3hGgi4Sz9hoy8eodMlGtLe6j/OqJevK8HJyGGHvmMwADnZ
         /15Qmw7e3xgo17BezigdGA58dUd5JicX1XqC+crZjlNOqe0qaNkxAfD6AATezJRBR73y
         Q+XAQDd+SD7Cv+Qqp6kXbORZFBHAguvfZ3C0ZYgnq+5PokiJpHwb9A2IUP9DadOlghPX
         KhHbnswfPOF735V9yUNf1wcxP6J7Kdzdeo6SslDGvaW+LmVkuu8tgwLwedngk9DYdGPY
         IRDg==
X-Gm-Message-State: AO0yUKXVd764JRgnLCH3yYl0tEsNfjYLn862hK+HPmOWLmXQWYpx3JJv
        MbERK06tRZ4aBX7h0nLZNpH2SzR6TTw=
X-Google-Smtp-Source: AK7set+lOaN6JMyVwDSfiTARKoCraeU4xOFSIKwPiOtj1sC9rZQbUYAaX8vGbRDSw/GXp+G+dhQYnA==
X-Received: by 2002:a05:6808:2892:b0:378:9bd:2ce0 with SMTP id eu18-20020a056808289200b0037809bd2ce0mr1397564oib.59.1676394945086;
        Tue, 14 Feb 2023 09:15:45 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b6-20020aca1b06000000b0037d813cd612sm3437824oib.43.2023.02.14.09.15.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 09:15:44 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <05984672-d897-6050-3e8b-3e7984c81bd9@roeck-us.net>
Date:   Tue, 14 Feb 2023 09:15:42 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/139] 5.10.168-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230213144745.696901179@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/13/23 06:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.168 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.
> 

Seen with several x86_64 boot tests during reboot:

[   13.465146] ------------[ cut here ]------------
[   13.465644] list_del corruption. prev->next should be ffff9836448a5008, but was ffff9836448a2010
ILLOPC: ffffffffae597813: 0f 0b
[   13.466452] WARNING: CPU: 0 PID: 302 at lib/list_debug.c:59 __list_del_entry_valid+0xb3/0xe0
[   13.466710] Modules linked in:
[   13.467103] CPU: 0 PID: 302 Comm: init Not tainted 5.10.168-rc1+ #1
[   13.467281] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[   13.467545] RIP: 0010:__list_del_entry_valid+0xb3/0xe0
[   13.468234] Code: cc cc cc 4c 89 c2 48 c7 c7 f8 c6 82 af e8 ad c9 8e 00 0f 0b 31 c0 c3 cc cc cc cc 4c 89 c2 48 c7 c7 30 c7 82 af e8 95 c9 8e 00 <0f> 0b 31 c0 c3 cc cc cc cc 4c 89 c6 48 c7 c7 70 c7 82 af e8 7d c9
[   13.468694] RSP: 0018:ffff9f160017bde0 EFLAGS: 00000282
[   13.469076] RAX: 0000000000000000 RBX: ffff9836448a5008 RCX: 0000000000000006
[   13.469297] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffae0e03dd
[   13.469494] RBP: ffff98364482c2f0 R08: 0000000000000001 R09: 0000000000000001
[   13.469699] R10: 0000000000000001 R11: ffffffffafa6f3e0 R12: ffff9836448a5000
[   13.469974] R13: ffff9836448a3910 R14: 00000000fee1dead R15: 0000000000000000
[   13.470122] FS:  00007ff4118d7b28(0000) GS:ffff98365f600000(0000) knlGS:0000000000000000
[   13.470230] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   13.470311] CR2: 00007fd877982830 CR3: 0000000005218000 CR4: 00000000001506f0
[   13.470438] Call Trace:
[   13.470532]  device_shutdown+0xae/0x1c0
[   13.470610]  __do_sys_reboot.cold+0x2f/0x5b
[   13.470675]  ? __lock_acquire+0x5bd/0x2640
[   13.470777]  ? lock_acquire+0xc6/0x2b0
[   13.470934]  ? lockdep_hardirqs_on_prepare+0xdc/0x1a0
[   13.471015]  ? syscall_enter_from_user_mode+0x1d/0x50
[   13.471101]  do_syscall_64+0x33/0x40
[   13.471162]  entry_SYSCALL_64_after_hwframe+0x61/0xc6
[   13.471313] RIP: 0033:0x7ff411860aa6
[   13.471437] Code: ff 5a c3 48 63 ff b8 bb 00 00 00 0f 05 48 89 c7 e9 95 e9 ff ff 48 63 d7 bf ad de e1 fe 50 be 69 19 12 28 b8 a9 00 00 00 0f 05 <48> 89 c7 e8 78 e9 ff ff 5a c3 49 89 ca 50 48 63 d2 4d 63 c0 b8 d8
[   13.471627] RSP: 002b:00007ffd01d415e0 EFLAGS: 00000246 ORIG_RAX: 00000000000000a9
[   13.471741] RAX: ffffffffffffffda RBX: 000000000000000f RCX: 00007ff411860aa6
[   13.471899] RDX: 0000000001234567 RSI: 0000000028121969 RDI: 00000000fee1dead
[   13.472008] RBP: 0000000001234567 R08: 0000000000000000 R09: 0000000000000000
[   13.472099] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[   13.472185] R13: 00007ffd01d417a8 R14: 00007ff4118d7b28 R15: 0000000000000000
[   13.472384] irq event stamp: 479
[   13.472453] hardirqs last  enabled at (487): [<ffffffffae0e03dd>] console_unlock+0x4dd/0x5e0
[   13.472560] hardirqs last disabled at (494): [<ffffffffae0e0334>] console_unlock+0x434/0x5e0
[   13.472666] softirqs last  enabled at (242): [<ffffffffaf000fe2>] asm_call_irq_on_stack+0x12/0x20
[   13.472775] softirqs last disabled at (237): [<ffffffffaf000fe2>] asm_call_irq_on_stack+0x12/0x20
[   13.472964] ---[ end trace 34290884cd36b277 ]---

Currently bisecting.

Guenter

