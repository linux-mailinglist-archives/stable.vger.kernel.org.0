Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1999D54402B
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 01:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbiFHXwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 19:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiFHXwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 19:52:34 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5799737943C;
        Wed,  8 Jun 2022 16:54:25 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id w16so20173496oie.5;
        Wed, 08 Jun 2022 16:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3Wgz6xxjuZn51lXK26rrEwTi4wOMLyW+nOu/Ss/NXAg=;
        b=EBfYopHIIs4yB7bKy89ZAzozlA43pg/M3bzN5abvFpRCGxliLqazgAqOd91KHur2TE
         oINV8cbNJwJEKqQPG3WgR8iqJbYg6PY45EK0nOxOUK2/SIWpm/dC5Ot1W01ItNtKeibi
         7DlLfm8PhUVpnbJ5z6Sxpe/+zg8BrLlQMPVDlBU1k23rn+0HvalzK2yI92A0EHXpszef
         2t3TA5kwo3ncmQifIE849H94swWz/6qRQS4acMqm3KorzuCmlxeckYakx9+gPcaTCwVC
         8/qTGzoKhoGpbBv9LYIUnXD+Dk64Qzpbxt53ZOTZ64jR+WwVMwqIVEK//uqWh8x0lP35
         Qr/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=3Wgz6xxjuZn51lXK26rrEwTi4wOMLyW+nOu/Ss/NXAg=;
        b=J4cbCZ7Hz0HlWWgbTa5MYAqvpZSZtYVTzRzZNQz5y57Mdwi+GJiT/UhcFdnuCgTZuw
         Ples5PfAiN1YQRisM0UHzsfvNfUnAWRkXb7l6qcbwR41FuoxXunM14vHGcFRjfiw13EO
         TQaiHhkboOdDlgDP0Jz1LTChTFYBsYFLG1dcF8dhkfWjo8wXGP7Azxvd6zOptyDj5/83
         Uv1N3Sil5+jqBn2YP7K7G3URfLmLhZhD7fbA74/vBmBYzJt0zJrz71HeK4s7eyG5/qk+
         DENxa8DQZLqd7wI6OIFNJ5s9PYXvZ3mj77H/+OjVKqu2rGuhVZ2YpIwnd/t739G8jbrf
         FpMw==
X-Gm-Message-State: AOAM5317ErWIPbkC05MffcnqxZO7heEgze+uvEul2q6ucOLuvr20G3WK
        o3+rvXh3yHKQ3DtCbQMqY5U=
X-Google-Smtp-Source: ABdhPJzUgezkkACC4TvC182yeFfRNejdCEkt9asU9jaHHeWOhcTijpoB+iGW2LXI7Z2VB9EjyyA+eQ==
X-Received: by 2002:a05:6808:13cc:b0:32c:20b7:373d with SMTP id d12-20020a05680813cc00b0032c20b7373dmr263225oiw.182.1654732464733;
        Wed, 08 Jun 2022 16:54:24 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y93-20020a9d22e6000000b0060c06bc1230sm3190215ota.69.2022.06.08.16.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 16:54:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 8 Jun 2022 16:54:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 000/772] 5.17.14-rc1 review
Message-ID: <20220608235422.GC3924366@roeck-us.net>
References: <20220607164948.980838585@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 06:53:12PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.14 release.
> There are 772 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

I see a new boot warning in some arm qemu tests, but that is related
to enabling CONFIG_KFENCE and not a new problem. v5.17.y and v5.18.y
are affected.

[    8.157727] ------------[ cut here ]------------
[    8.157843] WARNING: CPU: 0 PID: 0 at kernel/smp.c:894 smp_call_function_many_cond+0x38c/0x3a4
[    8.158289] Modules linked in:
[    8.158489] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.17.14-rc1-00773-gd0f9b2818e1e #1
[    8.158564] Hardware name: ARM-Versatile Express
[    8.158730]  unwind_backtrace from show_stack+0x10/0x14
[    8.158802]  show_stack from dump_stack_lvl+0x50/0x6c
[    8.158835]  dump_stack_lvl from __warn+0xd0/0x19c
[    8.158863]  __warn from warn_slowpath_fmt+0x5c/0xb4
[    8.158890]  warn_slowpath_fmt from smp_call_function_many_cond+0x38c/0x3a4
[    8.158919]  smp_call_function_many_cond from smp_call_function+0x3c/0x50
[    8.158947]  smp_call_function from set_memory_valid+0x74/0x94
[    8.158975]  set_memory_valid from kfence_guarded_free+0x280/0x4b4
[    8.159005]  kfence_guarded_free from kmem_cache_free+0x2f4/0x394
[    8.159032]  kmem_cache_free from rcu_core+0x358/0xc34
[    8.159062]  rcu_core from __do_softirq+0xf0/0x41c
[    8.159101]  __do_softirq from irq_exit+0xa4/0xd4
[    8.159127]  irq_exit from __irq_svc+0x50/0x68

Guenter
