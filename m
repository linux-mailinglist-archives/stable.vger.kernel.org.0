Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08E168300B
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 15:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbjAaO7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 09:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbjAaO7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 09:59:01 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A0411146
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 06:59:00 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id d21-20020a056830005500b0068bd2e0b25bso1615780otp.1
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 06:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=b4cvP78TQ8pZ1o4FMvO56uD5G3a5Ju4sFzbJ19YYjIM=;
        b=IFaAilxDAKjtiRINHrrwg7JLOApL6mQVykAiI0uh+G7RjgzYbmzMnU+wU4mJKX/k+G
         +zDoIfF8qGE6/JdgEuyFB8DtLE0RJRPGmHxwINsbqu0X9yk0HMIWdy3oQy9bayS6se73
         tZFBx5KbKib7QP9MRwEjneruPD3/10jJdgXyINbQrqaa+po+fGG1CqvPFN4JK267CIps
         Sg5A/Qt9zOjngIS1aQ8MTrukY4hZDLOtI1KEBopIyyKjaAmJoB33bKkblUMgGa0u1h84
         8SNWVYfRpqLXfRiYR8Fe8zB8Y7xKqFzqf9r7TCsIpzXJvKJcFNYj6AMiiqZBf4bRwh0Z
         GMRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b4cvP78TQ8pZ1o4FMvO56uD5G3a5Ju4sFzbJ19YYjIM=;
        b=O9bM2oUhU4rV0DNbhkIl2yTRcouCy60LG4J2qUhZSiaL875A2fKsO/c8jrpdRHUi2k
         4SYNQGdEXDi+AANiHB0Ecz23Rnkky6DoizHuh/zj0neGkU9TV/k61uDapW4StB+mo2Jq
         nverzL09G00ockgOZfRgTKHmYYgR0ZXQHhVsPUohJNtcPWJofuTPSinTcgGLol7xMn4z
         ka/7OevY5HVU38OwCsGCoIXv1sZAbNB2QZCy3noGk4qMtEXWh2SsTFY7V9s8EyyfOYI4
         rzygQYd+1tHU/ueBKpFFi7C0pPZ6GeT561koA32BrNazfmBQO+KZ9/9KXMcONprbhElI
         U4Rw==
X-Gm-Message-State: AO0yUKV8QpEtYmtpCoRmCBFrtfiBHzXrceUXEtKUxndDIqYKCkeKa6bA
        +Edj028WXl97Fs3aWdWdk/jxeE4FKbjMY+AWaV8=
X-Google-Smtp-Source: AK7set/oz48a+BOBUWl6H3E2jgmx1ZFu/DouYKRJLpmFCA0JydLb6N9rLhwAmoEOnWAPtQz8na6TGcX1s8Ysb8fO060=
X-Received: by 2002:a05:6830:4aa:b0:68b:d2f3:a28 with SMTP id
 l10-20020a05683004aa00b0068bd2f30a28mr358850otd.113.1675177139683; Tue, 31
 Jan 2023 06:58:59 -0800 (PST)
MIME-Version: 1.0
References: <CAJD_bPJ1VYTSQvogui4S9xWn9jQzQq8JRXOzXmus+qoRyrybOA@mail.gmail.com>
 <Y9Vg26wjGfkCicYv@kroah.com> <CAJD_bPLkkgbk+GO66Ec9RmiW6MfYrG32WP75oLzXsz2+rpREWg@mail.gmail.com>
 <CAJD_bPK=m0mX8_Qq=6iwD8sL8AkR99PEzBbE3RcSaJmxuJmW6g@mail.gmail.com>
 <02834fa9-4fb0-08fb-4b5f-e9646c1501d6@leemhuis.info> <288d7ff4-75aa-7ad1-c49c-579373cab3ed@intel.com>
 <CALFERdw=GwNYafR3q=5=k=H_jrzTZMyDBQLouFGV0JGu8i9sCg@mail.gmail.com> <04a9f939-8a98-9a46-e165-8e9fb8801a83@intel.com>
In-Reply-To: <04a9f939-8a98-9a46-e165-8e9fb8801a83@intel.com>
From:   Sasa Ostrouska <casaxa@gmail.com>
Date:   Tue, 31 Jan 2023 15:58:48 +0100
Message-ID: <CALFERdwVzz5a7k7XjBkNyGKKd8+4Fez62Lq__6jOarqnBJQjJQ@mail.gmail.com>
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
To:     Cezary Rojewski <cezary.rojewski@intel.com>
Cc:     Linux regressions mailing list <regressions@lists.linux.dev>,
        Jason Montleon <jmontleo@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>, lma@semihalf.com,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        =?UTF-8?B?YW1hZGV1c3ogU8WCYXdpxYRza2k=?= 
        <amadeuszx.slawinski@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 31, 2023 at 1:37 PM Cezary Rojewski
<cezary.rojewski@intel.com> wrote:
>
> On 2023-01-30 1:22 PM, Sasa Ostrouska wrote:
>
> > Dear Czarek, many thanks for the answer and taking care of it. If
> > needed something from my side please jest let me know
> > and I will try to do it.
>
>
> Hello Sasa,
Hi Czarek,
>
> Could you provide us with the topology and firmware binary present on
> your machine?
>
Sure, see below.

> Audio topology is located at /lib/firmware and named:
>
> 9d71-GOOGLE-EVEMAX-0-tplg.bin
-rw-r--r--. 1 root root   37864 21 nov 20.18 9d71-GOOGLE-EVEMAX-0-tplg.bin


> -or-
> dfw_sst.bin
>
> Firmware on the other hand is found in /lib/firmware/intel/.
> 'dsp_fw_kbl.bin' will lie there, it shall be a symlink pointing to an
> actual AudioDSP firmware binary.

lrwxrwxrwx. 1 root root     23 23 gen 10.28 dsp_fw_kbl.bin.xz ->
dsp_fw_kbl_v3402.bin.xz

>
> The reasoning for these asks is fact that problem stopped reproducing on
> our end once we started playing with kernel versions (moved away from
> status quo with Fedora). Neither on Lukasz EVE nor on my SKL RVP.
> However, we might be using newer configuration files when compared to
> equivalent of yours.
>
> Recent v6.2-rc5 broonie/sound/for-next - no repro
> Our internal tree based on Mark's for-next - no repro
> 6.1.7 stable [1] - no repro
>
> Of course we will continue with our attempts. Will notify about the
> progress.

Ok, waiting for your good news, on the other hand if you need anything
else feel free to ask.
>
>
> [1]:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v6.1.7&id=21e996306a6afaae88295858de0ffb8955173a15
>
>
> Kind regards,
> Czarek

Rgds
Sasa
