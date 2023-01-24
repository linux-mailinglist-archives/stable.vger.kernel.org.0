Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBF0679BDE
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 15:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234949AbjAXOba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 09:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbjAXOb2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 09:31:28 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8661E4608B
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 06:31:21 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id d188so13445179oia.3
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 06:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8aIBjSXUfpYCdPRZCAqFHfonN341BvCufsa1ALucXT4=;
        b=diKKU4qNqun4yyyiEF/WTOZZxoDHmlcP91UYxpf4Yzc4fIyoG1PMt/f6EGUn/TpATr
         yX/p1MLRZpwYNJGNRsb1iJXaXjtuEESCwBagQqBqzkwWjSIhn1SRpweC+iePXKhdvsPV
         6QtzwkbHLCe1+6Xf1GUgPbQLGLtXZ49OinfDfpwWs1ubb7Wd367HswbxtKxDdws71VCo
         A8660rEu1OvSfjWwJQMo9pct8uRpIgRai8qw5qN1sDpmS9T608vD8aT16+DWrtsJoTdy
         I77kG4xTS2QJs1vop2KRr6EdrlCSunlqccJRSNK0PEYUUnye+EW5GQF6ImGSONmk8VsE
         ymrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8aIBjSXUfpYCdPRZCAqFHfonN341BvCufsa1ALucXT4=;
        b=BI5kiw0IbQGXH1lZzxoabUOQpqRX3ij4BItASpFy/rKh+AyyQ/X/ZBuci5dgfL3mCl
         4TT+uFusZ/TCyU6CQwznE+E5VjfHA/8qHRIoUdE1UQdXqlezYFbiIwFtt6XOC8dU06R2
         rsU2PPhpQrVFPv8Z8YRkHZv1U0ZhvaVUUpoMqAqkkp/b1Oz5E14l5flQy0SJnl8rcOp+
         PlX7GxEghvJmq2uZ8DUttuQXyk3pei28UNjCcNFPSAw5p5ycr4wfPxFqt1WyiiD9e/bu
         +LYbR/0REySppj+pd1NcNM6/AiVl+e2u6828TZ9TDtPkRZZ8Y+G1DZ1zIkO4puqHt6WV
         rL6A==
X-Gm-Message-State: AFqh2ko5+e32s5/EJrDT9ST21W7ynOwc7hDNXzVxTdam4F/+XDf4BZGr
        HGIM86GcM3dY2tf9pATdVKF55h1gwcKV1QCWWxk=
X-Google-Smtp-Source: AMrXdXtSqXT4h0olGTZ895AIXRb5yq00BRJP7OfVu5gTPWUGSwcpAlbcRtpJ9syrnsIl4U0Fnzw+mizMT3fe13l5vBE=
X-Received: by 2002:aca:ac12:0:b0:364:a686:4444 with SMTP id
 v18-20020acaac12000000b00364a6864444mr2103482oie.298.1674570680763; Tue, 24
 Jan 2023 06:31:20 -0800 (PST)
MIME-Version: 1.0
References: <CALFERdzKUodLsm6=Ub3g2+PxpNpPtPq3bGBLbff=eZr9_S=YVA@mail.gmail.com>
 <Y89n98fRfTpLmPUg@kroah.com> <CAFJ_xbqMx8LsD_Ry70jnqVmmhyGjTFpA-Gv7SpRR21v3Djr1DA@mail.gmail.com>
 <CALFERdxxAt5+Y0nxbEieYSZX8YLTA9aogtGWLLZBEpGdbWxT-g@mail.gmail.com> <CAFJ_xbrAVZDtXwe0Ku0V7b1xp580N+ao0caCRP1xiHBr11oKyQ@mail.gmail.com>
In-Reply-To: <CAFJ_xbrAVZDtXwe0Ku0V7b1xp580N+ao0caCRP1xiHBr11oKyQ@mail.gmail.com>
From:   Sasa Ostrouska <casaxa@gmail.com>
Date:   Tue, 24 Jan 2023 15:31:08 +0100
Message-ID: <CALFERdwpbQdpnyLuHxo67S4KC=if97AzLGDRVEo+u-HN2Tu0fg@mail.gmail.com>
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
To:     Lukasz Majczak <lma@semihalf.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        regressions@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>
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

On Tue, Jan 24, 2023 at 1:11 PM Lukasz Majczak <lma@semihalf.com> wrote:
>
> > If you need anything else just let me know.
> >
> > Thanks
> > Sasa
>
> Sasa,
>
> Thank you for sharing logs from the working version - could you also
> provide dmesg for the no sound scenario? You can also share them using
> e.g. https://gist.github.com/ .

Lukasz thanks, sure, will provide that too but let me reboot into the
non working kernel.
Will post it on gist.github.com and post the link here.

Rgds
Sasa
>
> Best regards,
> Lukasz
