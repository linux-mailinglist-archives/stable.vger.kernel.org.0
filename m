Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAFAF4B79AA
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 22:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243657AbiBOVfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 16:35:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243511AbiBOVfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 16:35:39 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7238FBA45
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 13:35:27 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id p22so118587lfu.5
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 13:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=telus.net; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7ehaiWQc2/KmkZJmJvXnPNJ6ZOAY30nrwUVn52VaHtg=;
        b=DQY326IHNvI7Mtfy1KvTw6bFdkNDr2WGo8mEEiTKzV3quR+Tyc20dAv2ufunP8N/1n
         lJR9nTQPrM7qHEGA1HQwmFZBfxopdFQcvDpTOrB2yV3s5W3zJQF6MUKdMdWgIse7eJkF
         wZy7CmChPjvHjS+7t5ErHhQs2QV1bXfSl4H4qFMdLDwXIzpYSqDGEtH4QS7z6KITlhnt
         pnbQbHF6wH3VlRZPTUvRaZfuet/ieaAeSZOgrTaZFRQqY0PGtOxOHTQYmFE+qGqlh4P3
         rGnuBRcavmz6iGGTYgqHhgoewu/jAwFr4VCK78pPaBcsdg7gDS5P3u7tPVZr4kE488wr
         fNJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7ehaiWQc2/KmkZJmJvXnPNJ6ZOAY30nrwUVn52VaHtg=;
        b=YyimiTS+USIwzGS4FMzn/fWIuiSSVMCos5r3O1TnGa9Ii5OaCgzfBcTUA5ty85hXyq
         +o3NZcMATCU7Bdmtt31qZCCQNl37m9+TVIqNJl48IuYWgW600PuVORZsegkNrNU4iywC
         ZgRKJc6afhmbehVElFUb0b3CZC4mVL/Fuc70MJDRsIbv/4EoHqMtNy4vPZ6HzxtmHQHb
         hhPaeL/KtAmqiS8ON6uUyyptl0i/q2wtjogIfhfWuMLRw+h2k7h6oVZChDqWcoOcB2QZ
         T7KtzuUqyz57kzI2//ejSZTnEFLhCTsAMCMy1GVG3IQzH+jYXcrbD4F6yMSBHgqHOev8
         j83w==
X-Gm-Message-State: AOAM532fSH2dPEEK3uIal346hu+ICzGbEqjhLFjyMEWmvQ/vOX+KQsFh
        fcjo/gkWd96hn7QhoTstylHyLldKDCxeKZ/koFOnrQ==
X-Google-Smtp-Source: ABdhPJyBOxodZeG2mNX8T98KnNk+VhICzDG6JNMIJf0VapUko7Nap6krUPF4HAvMIHl6yOeh24xIOD1fz2RGgW1dUPA=
X-Received: by 2002:a05:6512:a85:: with SMTP id m5mr773781lfu.465.1644960926228;
 Tue, 15 Feb 2022 13:35:26 -0800 (PST)
MIME-Version: 1.0
References: <003f01d81c8c$d20ee3e0$762caba0$@telus.net> <20220208023940.GA5558@shbuild999.sh.intel.com>
 <CAAYoRsXrwOQgzAcED+JfVG0=JQNEXuyGcSGghL4Z5xnFgkp+TQ@mail.gmail.com>
 <20220208091525.GA7898@shbuild999.sh.intel.com> <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
 <e185b89fb97f47758a5e10239fc3eed0@intel.com> <CAAYoRsXbBJtvJzh91nTXATLL1eb2EKbTVb8vEWa3Y6DfCWhZeg@mail.gmail.com>
 <aaace653f12b79336b6f986ef5c4f9471445372a.camel@linux.intel.com>
In-Reply-To: <aaace653f12b79336b6f986ef5c4f9471445372a.camel@linux.intel.com>
From:   Doug Smythies <dsmythies@telus.net>
Date:   Tue, 15 Feb 2022 13:35:16 -0800
Message-ID: <CAAYoRsXc_Wa9DgzjVdaXUdFwNN=LKnVU=CNtd+QYvpN6KjeM=g@mail.gmail.com>
Subject: Re: CPU excessively long times between frequency scaling driver calls
 - bisected
To:     srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
Cc:     "Zhang, Rui" <rui.zhang@intel.com>,
        "Tang, Feng" <feng.tang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        dsmythies <dsmythies@telus.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Srinivas,

On Mon, Feb 14, 2022 at 7:17 AM srinivas pandruvada
<srinivas.pandruvada@linux.intel.com> wrote:
>
> Hi Doug,
>
> I think you use CONFIG_NO_HZ_FULL.

No. Here is the relevant excerpt from the kernel config file:

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ_FULL is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
# end of Timers subsystem

> Here we are getting callback from scheduler. Can we check that if
> scheduler woke up on those CPUs?

As far as I can determine, yes.
But note that I am unfamiliar with this area.

> We can run "trace-cmd -e sched" and check in kernel shark if there is
> similar gaps in activity.

I do not use trace-cmd and had never heard of kernel shark.
Nor do I actually run any desktop GUI on linux, only servers.
I attempted to acquire what you wanted with primitive trace
commands.

Workflow: All as before (the 347 Hertz work/sleep frequency
test), with a 20 minute trace in the middle. Powers were
monitored again to confirm differences, and just in case trace
itself modified the system response (it didn't).

Power averages (excluding the sample where the trace
file was being written to disk):
Stock: 4.1 +37%
Revert:  3.0

I only looked at a few of the CPUs data, the largest, smallest
and a mid-range file sizes, excluding the main working CPU.
Maximum times between "sched_wakeup", seconds:

Stock:
CPU 2: 4.0
CPU 4: 4.0
CPU 9: 1.0

Revert:
CPU 1: 2.0
CPU 2: 4.0
CPU 7: 1.54

I do not know if other stuff in the files might be odd or not.

... Doug
