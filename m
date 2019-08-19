Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5914191F16
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 10:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfHSIiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 04:38:03 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39472 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfHSIiD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 04:38:03 -0400
Received: by mail-wr1-f65.google.com with SMTP id t16so7765192wra.6
        for <stable@vger.kernel.org>; Mon, 19 Aug 2019 01:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linbit-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=yo+SdyqZ/O4jXuFjj8QZr2O/7A5RWexuHtaCgMhz+og=;
        b=ntdlk6mVJT05SvDl8G9rkbVUSwiBi09oFdnJt4ab1t8Mc211HaWcimS5aP/d6EWWB/
         ltgQmGv2xkM6fMtCmspbvi8CPgoaolEoqEi7S7/g6QPpSS/XjcjuudlJjyAfFl+zUKnZ
         5FkOnONhEI1x4+t8GMItA+ikzNDYLhMq3m1nmgonF7EIq3HgQbHSgEt6sHoqDELbP2vf
         omCCF6k6RwMRo+2zf0rx6pfB52zv3Ekb2l6HliGhB4RLBI+dw4Wwx97RvmEg8T4VkWbw
         qITiQasUJNWwJf/6jujnoEcY1ChkHAvYg84J9FeZ04HlKtrPrx45rpT6S7zQBAFZHtT1
         D0aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=yo+SdyqZ/O4jXuFjj8QZr2O/7A5RWexuHtaCgMhz+og=;
        b=ZXTKQdfFjYxvJV7sPyPxv78ANRuGUtebaWHlmx4kXJgv6sBzB+ku57at234s7+WaHa
         LXc9xR8OMpp3D7XwDCbI0PWBQGayY2zM71Z9AmAk/windzNYk/PyrDBTTGsvOqonU/IS
         uinih1/lMzfkwjUyLiTEA+g3H8WLdSL61EODgV+PnBmX+cGdzYkzeNRZobaBkDfQfzxj
         eQzIiNn57vKwgD9Bwh1TM/LvmIHQKsNmBlee5h7AmoRbXX40g0O+xHIaVVRUrAnqYVVB
         P3TrJNh6PTOv2MX35fjh7p49VYQXqDwEhs0RTYaAJklRFZsuIJeqhe1/kpukSYdTGmbf
         Ahug==
X-Gm-Message-State: APjAAAW5qhsnJuH702v1u/u7Kq5XB3/hrcqqk5Y8klGou1cQU1sib8WF
        h6MG0zlVFjJOkVn4FPzIKkttyQ==
X-Google-Smtp-Source: APXvYqypvER9X0766kDn+Er3VblrpVkzmTxd+/kEnAYu/iDWYOMaqZpjxfXTAy2520/LCRDLpWF3xA==
X-Received: by 2002:adf:9482:: with SMTP id 2mr25343130wrr.91.1566203881132;
        Mon, 19 Aug 2019 01:38:01 -0700 (PDT)
Received: from localhost ([2001:858:107:1:1d81:f726:81fa:b07a])
        by smtp.gmail.com with ESMTPSA id p69sm13597648wme.36.2019.08.19.01.38.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 19 Aug 2019 01:38:00 -0700 (PDT)
Date:   Mon, 19 Aug 2019 10:37:59 +0200
From:   Christoph =?utf-8?Q?B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Philipp Reisner <philipp.reisner@linbit.com>,
        David Laight <David.Laight@aculab.com>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Jeff Layton <jlayton@primarydata.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] signal: Allow cifs and drbd to receive their terminating
 signals
Message-ID: <20190819083759.73ee5zct4yxbyyfd@gintonic.linbit>
References: <20190729083248.30362-1-christoph.boehmwalder@linbit.com>
 <1761552.9xIroHqhk7@fat-tyre>
 <1fcbb94c5f264c17af3394807438ad50@AcuMS.aculab.com>
 <2789113.VEJ2NpTmzX@fat-tyre>
 <87k1bclpmt.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87k1bclpmt.fsf_-_@xmission.com>
User-Agent: NeoMutt/20171215
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 16, 2019 at 05:19:38PM -0500, Eric W. Biederman wrote:
> 
> My recent to change to only use force_sig for a synchronous events
> wound up breaking signal reception cifs and drbd.  I had overlooked
> the fact that by default kthreads start out with all signals set to
> SIG_IGN.  So a change I thought was safe turned out to have made it
> impossible for those kernel thread to catch their signals.
> 
> Reverting the work on force_sig is a bad idea because what the code
> was doing was very much a misuse of force_sig.  As the way force_sig
> ultimately allowed the signal to happen was to change the signal
> handler to SIG_DFL.  Which after the first signal will allow userspace
> to send signals to these kernel threads.  At least for
> wake_ack_receiver in drbd that does not appear actively wrong.
> 
> So correct this problem by adding allow_kernel_signal that will allow
> signals whose siginfo reports they were sent by the kernel through,
> but will not allow userspace generated signals, and update cifs and
> drbd to call allow_kernel_signal in an appropriate place so that their
> thread can receive this signal.
> 
> Fixing things this way ensures that userspace won't be able to send
> signals and cause problems, that it is clear which signals the
> threads are expecting to receive, and it guarantees that nothing
> else in the system will be affected.
> 
> This change was partly inspired by similar cifs and drbd patches that
> added allow_signal.
> 
> Reported-by: ronnie sahlberg <ronniesahlberg@gmail.com>
> Reported-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Philipp Reisner <philipp.reisner@linbit.com>
> Cc: David Laight <David.Laight@ACULAB.COM>
> Fixes: 247bc9470b1e ("cifs: fix rmmod regression in cifs.ko caused by force_sig changes")
> Fixes: 72abe3bcf091 ("signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of force_sig")
> Fixes: fee109901f39 ("signal/drbd: Use send_sig not force_sig")
> Fixes: 3cf5d076fb4d ("signal: Remove task parameter from force_sig")
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  drivers/block/drbd/drbd_main.c |  2 ++
>  fs/cifs/connect.c              |  2 +-
>  include/linux/signal.h         | 15 ++++++++++++++-
>  kernel/signal.c                |  5 +++++
>  4 files changed, 22 insertions(+), 2 deletions(-)
> 

Just tested this patch, and I can confirm that it makes DRBD work as
intended again.

Tested-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>

--
Christoph Böhmwalder
LINBIT | Keeping the Digital World Running
DRBD HA —  Disaster Recovery — Software defined Storage
