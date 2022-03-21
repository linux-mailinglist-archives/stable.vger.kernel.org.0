Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5204E303B
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 19:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352300AbiCUSuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 14:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239977AbiCUSuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 14:50:23 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85884163E;
        Mon, 21 Mar 2022 11:48:57 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id v22so8054831wra.2;
        Mon, 21 Mar 2022 11:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=NhgSfZDArluZLHM/ZGQGHtyPB2g1YM1L+AyBmippdgc=;
        b=E6H7FdlWYcATK/Ci37TDC97uxTfQV5wTZHy4seLU3weGUKtZUfpSHM5JUgph0J3fMJ
         tPcK6xSSZLn7dkMYTIKmrtgrCVdL6wehY5z1328CFqEJ+33VfHMA+K5GG7z0zYrGrg32
         x0b6JtYVnHsGSOKEJVkB40OKaK09JSx4dK1lEhvkXi7oTteeoaMo+cGjs5W6MOlW3bkn
         LVo65te+5eAEDA4j2QZlW121vCOxpHvfdAYe376s1EktIoJ9Kz8W53K/FhsZXycUu9ef
         +2lkpe6e1l6hLVKHkDjBBLOIiG22McoVy/sW9kvxu5S/4Q+o5AyzVf6rBWbiNCVdWwn6
         sRbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=NhgSfZDArluZLHM/ZGQGHtyPB2g1YM1L+AyBmippdgc=;
        b=dpQEJw9q+0AJeIojMaK8DqtjEaeUbh9tA40xIGOvSNHETgpYcp4m9++A9KkdTe/cm5
         TxwjSEePmR7nUfcW2Wgvg7u/7EWhoZRo7qMRxfFNQ5f+Za+V7MFX8vqisRwpR1ZZF9Uh
         Cs/cR7hl+0ihiqqaltZZuqmmVnW8J5Y7f666RJa2uFDQSeaq3ZXxFCHJpS8df9MhuAZz
         Z8JVLSs7xK0LocA5wCLIpDpmVVYg4H9e7psJkHIboUAY+86/3f15Oia5Mm8sDbCHZaCD
         OgF4ncGlj4IoarhGh6CEo40hLZCK6PX0wVOTfVjhexqYgf8my9s20AHzTUu8ugm+Ccos
         PkAA==
X-Gm-Message-State: AOAM533sVrJj7Do/tbwDKyfsI709TlwCu2/79nVkZuIT6u9UBpVOj4Rd
        ko9DwKq3nTB+Xy/O+kzkWqo=
X-Google-Smtp-Source: ABdhPJyfJdCZmE8tKzsiqRnR7Wsy3A+qRAqBFBPP0seRuR+2CuBc4MSPGkO7AsBhivZ2+kKQi2FkBQ==
X-Received: by 2002:a5d:6d81:0:b0:203:e187:1faa with SMTP id l1-20020a5d6d81000000b00203e1871faamr20083750wrs.381.1647888536391;
        Mon, 21 Mar 2022 11:48:56 -0700 (PDT)
Received: from elementary ([94.73.33.246])
        by smtp.gmail.com with ESMTPSA id h12-20020a5d548c000000b001f1f99e7792sm13796467wrv.111.2022.03.21.11.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 11:48:56 -0700 (PDT)
Date:   Mon, 21 Mar 2022 19:48:52 +0100
From:   =?iso-8859-1?Q?Jos=E9_Exp=F3sito?= <jose.exposito89@gmail.com>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Jiri Kosina <jkosina@suse.cz>, Takashi Iwai <tiwai@suse.de>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>, regressions@lists.linux.dev,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] HID: multitouch: fix Dell Precision 7550 and 7750 button
 type
Message-ID: <20220321184852.GA20347@elementary>
References: <20220320190602.7484-1-jose.exposito89@gmail.com>
 <CAO-hwJKZUSTaWUpE_vsvAs-MNoZ8UJLgxiCyQ6OzwHYFZszf2w@mail.gmail.com>
 <CAO-hwJL4=OGv34mXq3de4QEKW15tT4gZDOBxhkuXVh5AeSafeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO-hwJL4=OGv34mXq3de4QEKW15tT4gZDOBxhkuXVh5AeSafeQ@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 21, 2022 at 07:22:45PM +0100, Benjamin Tissoires wrote:
> Giving a little bit more context here (and quoting Peter).
> 
> """
> The problem with [37ef4c19b4] is that it removes functionality -
> before a clickpad was falsely advertised but the button worked, now in
> the affected devices it simply no longer works because the button code
> gets filtered. And user-space can't work around this.
> ...
> So the main question remains: why are we doing this?
> 
> And the answer here is: because libinput can't handle clickpads with
> right buttons. But that's not really true either, libinput just
> doesn't want to, and for no other reason than that it's easier to
> handle it this way.
> """
> 
> So basically, we tried to fix a choice on libinput assuming that all
> devices are perfect, for the only sake of making it easy for libinput.
> But the solution prevents further tweaks, and we then need to manually
> quirk devices in the kernel which involves a slightly heavier
> difficulty for end users than just dropping a config file or changing
> a setting in their UI.
> 
> With that said, this patch is:
> Nacked-by: me
> 
> José, could you send a revert of 37ef4c19b4, and add "Cc:
> stable@vger.kernel.org" and all the other tags for the regression
> tracker bot?

Sure, for reference, this patch should be ignored in favor of:
https://lore.kernel.org/linux-input/20220321184404.20025-1-jose.exposito89@gmail.com/T/

Jose
