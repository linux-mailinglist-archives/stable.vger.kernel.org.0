Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F550654E07
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 10:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbiLWJE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 04:04:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiLWJEZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 04:04:25 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB551BEBD;
        Fri, 23 Dec 2022 01:04:23 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id h16so3976305wrz.12;
        Fri, 23 Dec 2022 01:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vMKIJQQf6XQ7e0LO/FmODfA1kV8rLyp4SAkApiLqNTw=;
        b=pdy1zHobnHCTR074QBSTKtI8D32zRfGKcwZYGaOchmrWWHbNccxZS1rb9qDoxeOug+
         ofVgoUYG0DzPgB0L4YQ0qDch9Ygro/yYn53NEudzVIyHB+PV941hspLyWbG6hVix+Fgq
         1fJO0DN+mjlTca17Ze1KVfGH7GFjAelnMrJ06o0tQpOQwjKIKfx3H4YgosCE8HBjxZFr
         1LjN8BR7+IIYCnL/CsL+Zw3TwL93fiB8UEHgjgVyXNDYrcpheyOrcy8IaPGpRMj5KUp5
         v2198A7v89s1nr/roRP81GaVyALDF17rTmjNncZX9O7YZ17z1T6pr4wXstVB2WIwt2V7
         ZDLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vMKIJQQf6XQ7e0LO/FmODfA1kV8rLyp4SAkApiLqNTw=;
        b=2OTGlbpF7WfGnPZhTraasqu+hM3uiLJCdzGfyLcPEyR7VLS8XVzVdExd7Ht6pHdkc0
         YqKOlTPN/Gj5LxCPkChUJe+gtIJOAVC0cVeSwU2f94pQx0v7K3ne68rQ+v59iNsGYT6V
         6ofpooELsA+Y9KcdWHLdNTKrgiM5QtF7+p78Ws+rDPg0zOU5DZISaTS1MG1YCX6+f704
         vhkskMic8WvC/qs35iMUzDTV6r6ahkLx62LKwwqfZ9/1OrQMa5aGI4ECziWdeLOxXj0o
         q2w4FBkhfUY8w8RfTmgPA7JJ3xKb94ZcT1AzhDS55WNoIIGwyjx7wVWTfAz3s1Uok80N
         XTXA==
X-Gm-Message-State: AFqh2kr4n6Xmg2bsKfFCJSJtbjHaLE7Ji8Xljl+yNY2oXkRUJgKkX+9Z
        jTlcyeNBpDT48aaiFtTZo20=
X-Google-Smtp-Source: AMrXdXtOMvN2HMj/OrXwsjqu85YK3DNoPLff93hlFSGSY91F1JaOuPCrW378L4XLwfvL2ddImkGsbA==
X-Received: by 2002:adf:f54a:0:b0:236:611b:e8eb with SMTP id j10-20020adff54a000000b00236611be8ebmr5690386wrp.37.1671786262402;
        Fri, 23 Dec 2022 01:04:22 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id j11-20020a5d452b000000b0022cc0a2cbecsm2551106wra.15.2022.12.23.01.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Dec 2022 01:04:21 -0800 (PST)
Date:   Fri, 23 Dec 2022 12:04:18 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Prashanth K <quic_prashk@quicinc.com>
Cc:     David Laight <David.Laight@aculab.com>,
        'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        John Keeping <john@metanate.com>,
        Pratham Pratap <quic_ppratap@quicinc.com>,
        Vincent Pelletier <plr.vincent@gmail.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "# 5 . 15" <stable@vger.kernel.org>
Subject: Re: usb: f_fs: Fix CFI failure in ki_complete
Message-ID: <Y6VvEmfgbQOmW2cN@kadam>
References: <1670851464-8106-1-git-send-email-quic_prashk@quicinc.com>
 <Y5cuCMhFIaKraUyi@kroah.com>
 <abe47a47aa5d49878c58fc1199be18ea@AcuMS.aculab.com>
 <acdda510-945f-ff68-5c8b-a1a0290bed6d@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acdda510-945f-ff68-5c8b-a1a0290bed6d@quicinc.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 22, 2022 at 06:21:03PM +0530, Prashanth K wrote:
> 
> 
> On 14-12-22 11:05 pm, David Laight wrote:
> > From: Greg Kroah-Hartman
> > > Sent: 12 December 2022 13:35
> > > 
> > > On Mon, Dec 12, 2022 at 06:54:24PM +0530, Prashanth K wrote:
> > > > Function pointer ki_complete() expects 'long' as its second
> > > > argument, but we pass integer from ffs_user_copy_worker. This
> > > > might cause a CFI failure, as ki_complete is an indirect call
> > > > with mismatched prototype. Fix this by typecasting the second
> > > > argument to long.
> > > 
> > > "might"?  Does it or not?  If it does, why hasn't this been reported
> > > before?
> > 
> > Does the cast even help at all.
> Actually I also have these same questions
> - why we haven't seen any instances other than this one?
> - why its not seen on other indirect function calls?
> 
> Here is the the call stack of the failure that we got.
> 
> [  323.288681][    T7] Kernel panic - not syncing: CFI failure (target:
> 0xffffffe5fc811f98)
> [  323.288710][    T7] CPU: 6 PID: 7 Comm: kworker/u16:0 Tainted: G S    W
> OE     5.15.41-android13-8-g5ffc5644bd20 #1
> [  323.288730][    T7] Workqueue: adb ffs_user_copy_worker.cfi_jt
> [  323.288752][    T7] Call trace:
> [  323.288755][    T7]  dump_backtrace.cfi_jt+0x0/0x8
> [  323.288772][    T7]  dump_stack_lvl+0x80/0xb8
> [  323.288785][    T7]  panic+0x180/0x444
> [  323.288797][    T7]  find_check_fn+0x0/0x218
> [  323.288810][    T7]  ffs_user_copy_worker+0x1dc/0x204
> [  323.288822][    T7]  kretprobe_trampoline.cfi_jt+0x0/0x8
> [  323.288837][    T7]  worker_thread+0x3ec/0x920
> [  323.288850][    T7]  kthread+0x168/0x1dc
> [  323.288859][    T7]  ret_from_fork+0x10/0x20
> [  323.288866][    T7] SMP: stopping secondary CPUs
> 
> And from address to line translation, we got know the issue is from
> ffs_user_copy_worker+0x1dc/0x204
> 		||
> io_data->kiocb->ki_complete(io_data->kiocb, ret);
> 
> And "find_check_fn" was getting invoked from ki_complete. Only thing that I
> found suspicious about ki_complete() is its argument types. That's why I
> pushed this patch here, so that we can discuss this out here.

I think the problem is more likely whatever ->ki_complete() points to
but I have no idea what that is on your system.  You're using an Android
kernel so it could be something out of tree as well...

regards,
dan carpenter


