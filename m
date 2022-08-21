Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298BF59B6A5
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 00:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbiHUWrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 18:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiHUWrS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 18:47:18 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF2E1AF15;
        Sun, 21 Aug 2022 15:47:17 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso12295222pjk.0;
        Sun, 21 Aug 2022 15:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=QmrK5C2AYCT+3vtlxA+/1DfLvakD1ir/7enLA1nC9To=;
        b=nxVRuW6ySNgSzZGlAbuaGsal9N3SaGyjaaGPHTIXN0HDvFeZFA/LOXs7A2Hy4FLrTx
         cDz0bCDsnxC4hKto89xsgVxwT4QekuqQHI3pL98v5cpM8qd2Mmp1BzcsrQBxf3t4g4U+
         kDzBkXwEF7iuqxhUQSoUYKm5TpjddLK1bK2IpIxnQPq3HZTeb+2Sm0GSFfbbGshJqXuG
         AqAcAq53QaVv+R4+8HlUaqTI098XDaYi/0RezeVs9d/nCsSCFni20fzE6/11j60kBoBh
         1orZBMzZfrL0yW5cmIepYsCzqDV7oQ7ygbW7px6x7BJ7xuk6c8ghGZE2J9pdd+QEvR3f
         M9rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=QmrK5C2AYCT+3vtlxA+/1DfLvakD1ir/7enLA1nC9To=;
        b=iUqMQVTKk3bnt6rY0T8Ar1g1yH4IFfi/Y1YiASxD4ois/M5cZOh8S9NT+6TR+ZFlvG
         TeP9cH/Y+eYSNNeGOd4Rqz/LVJofL4O4sueb8ak30X8AWxqYEP75kKZlk9psHNamdid+
         09FK7l/gddwlYOkynQNJi+c44MCmWZ+1XWHqmx7Ao+sDpkvPHCbv+vQtaPVDiNzhjSr1
         NVtTyOCSRBVByyxJoU+khNf05pCeQGR6jCZWVvhLzfNKmjURxA6486Dmz52oUu9NO5WZ
         +WxKvr9CmCK51I5JE/YK0ir1+cMZmy2meTCkrribuVCQuxc7k2346o56CAEeHtshqtZz
         d33Q==
X-Gm-Message-State: ACgBeo0fIloA3uGc8ftogV98pstixRsthCFReAq4SViLOTiyQVgpTzWp
        VItOGsh1I6V7NsCL9zAx6+OSZc1zx98=
X-Google-Smtp-Source: AA6agR5fgFTD7qPk0QzeGpoYRzJdks4YNumcgBR8Sul4gsk6eCwcO0y7c8EVhXU9sVRT3Qkzljk7Wg==
X-Received: by 2002:a17:90b:3c4e:b0:1fa:fc10:580f with SMTP id pm14-20020a17090b3c4e00b001fafc10580fmr1677625pjb.108.1661122037089;
        Sun, 21 Aug 2022 15:47:17 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b204-20020a621bd5000000b005361af33036sm2890765pfb.22.2022.08.21.15.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Aug 2022 15:47:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sun, 21 Aug 2022 15:47:13 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Stafford Horne <shorne@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/10] 5.15.62-rc2 review
Message-ID: <20220821224713.GA1875188@roeck-us.net>
References: <20220820182309.607584465@linuxfoundation.org>
 <20220821120903.GB2332676@roeck-us.net>
 <YwJQJxpsRDc6dqTJ@oscomms1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwJQJxpsRDc6dqTJ@oscomms1>
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

On Sun, Aug 21, 2022 at 03:32:55PM +0000, Stafford Horne wrote:
> On Sun, Aug 21, 2022 at 05:09:03AM -0700, Guenter Roeck wrote:
> > On Sat, Aug 20, 2022 at 08:23:24PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.15.62 release.
> > > There are 10 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Mon, 22 Aug 2022 18:23:01 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Build results:
> > 	total: 159 pass: 159 fail: 0
> > Qemu test results:
> > 	total: 485 pass: 484 fail: 1
> > Failed tests:
> > 	openrisc:or1ksim_defconfig
> > 
> > The openrisc failure is a soft lockup during restart. I only recently
> > enabled the soft lockup detector, so this is probably either a false
> > positive or not a new problem. I'll try to track it down, but it is
> > not a concern for now.
> > 
> > Tested-by: Guenter Roeck <linux@roeck-us.net>
> 
> Hi Guenter,
> 
> If you need help let me know, just let me know how to reproduce it.  I am
> currently working on some qemu patches to convert qemu to multithread-tcg.  I
> have fixed some lockup issues, but there are still some cases we get soft
> lockups.
> 
> If you have any details I can see if it's a similar issue.
> 

All I can say is that it happens with qemu 7.0, it happens more or less
randomly with all kernel versions as far as I can see, and it isn't a real
lockup but something wrong with time management. The lockup is reported
almost immediately on shutdown. It reports something like

reboot: Restarting system
watchdog: BUG: soft lockup - CPU#0 stuck for 371s! [init:225]
Modules linked in:
CPU: 0 PID: 225 Comm: init Not tainted 6.0.0-rc1-00303-g963a70bee588 #1

but it doesn't really wait for that much time; the message is seen almost
immediately. I don't do anything special, just boot the openrisc emulation
and restart. I have the following options enabled.

CONFIG_LOCKUP_DETECTOR CONFIG_SOFTLOCKUP_DETECTOR CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC
CONFIG_DETECT_HUNG_TASK CONFIG_BOOTPARAM_HUNG_TASK_PANIC

The problem is not seen without those options.

Guenter
