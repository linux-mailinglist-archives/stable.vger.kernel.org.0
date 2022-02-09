Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DAD4AF507
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 16:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235688AbiBIPUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 10:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbiBIPUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 10:20:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D7888C0612BE
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 07:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644420024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HWJxSwYp7jtZ92shaLhTfEcqyJ4FcqxLKxSHScXMFmA=;
        b=PyuTenbJ41dM5debF7w6Co+TKiLJfVBr8cyhYPUt4fu3dF08QvMM59PBa3YU3t17p2HsxK
        vFbAgD2o6GVPyf86BefZ69if5ZvtmMZtWxa+4YzYM7zZJ2bIKSBLAgApQUAnrwC0eJKzGU
        BY9JrygxUlbsn/uIpnzLeMZNAbu1B18=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-317-3Pm_hOh8MxyVtp4GaJ9SnQ-1; Wed, 09 Feb 2022 10:20:22 -0500
X-MC-Unique: 3Pm_hOh8MxyVtp4GaJ9SnQ-1
Received: by mail-wm1-f69.google.com with SMTP id c7-20020a1c3507000000b0034a0dfc86aaso2804824wma.6
        for <stable@vger.kernel.org>; Wed, 09 Feb 2022 07:20:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HWJxSwYp7jtZ92shaLhTfEcqyJ4FcqxLKxSHScXMFmA=;
        b=ST+JZvYmc3lzoaKWUBFkinEre9xNU8Q8EgV2tgh1zfodUFrEcLQNK3gLr9TcSZ/AUu
         zVdKCRCjMWi3kjWOORogSc4CpQpB+hojjsB/KyKMx5Ev1ThSJEh7kz3bl2weTHFym8KE
         f4HwiR4MUCYuBrqXh9S3ibRvMMKYgBpri1gZ8FFKswRtFjtm9B1/dILupK7RW/aXCn0S
         hmpD/PuyyznqYGSFn0KDGyH4os51gIE7tHIFJTnqs26auDy/rXRmupZZSuwIW1r/5BTr
         Gl9NigKhctxUf6AnZ10pxVrKUBkCf6pM4Nm121P0I9m9bWdQ2ZibVDNEbQhD999f3Ifq
         kayQ==
X-Gm-Message-State: AOAM5334eHNbWZo/KTuY6VzbvVD759PEAOcvs7V8MKrL5GzOBuQJnn2Q
        jFy0JDDAW+o1eboDdTWtPJJMVXaBKC78/35cuV+zp4uA664A7XR4r8PhrWXdMGMRFxqN8hYTa0i
        3RU1IYltBEIp6vvPrZTS/uMp0oMkSzKZH
X-Received: by 2002:a1c:2942:: with SMTP id p63mr2494651wmp.75.1644420021708;
        Wed, 09 Feb 2022 07:20:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzBIOqCE7cDbpGvT5TmCSizl7rrPw18L3EY0Uy8onixaMONTzYS0XvUHUkxcZEdMAG886y96+4xK4BB/NuuR5w=
X-Received: by 2002:a1c:2942:: with SMTP id p63mr2494623wmp.75.1644420021540;
 Wed, 09 Feb 2022 07:20:21 -0800 (PST)
MIME-Version: 1.0
References: <20220209085243.3136536-1-lee.jones@linaro.org> <20220209150904.GA22025@lst.de>
In-Reply-To: <20220209150904.GA22025@lst.de>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Wed, 9 Feb 2022 16:20:10 +0100
Message-ID: <CAHc6FU5e4GaQTfh6Z2_2vhcgxY+dbwUBOgazrXB3XW4=DRpLHQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] Revert "iomap: fall back to buffered writes for
 invalidation failures"
To:     Christoph Hellwig <hch@lst.de>
Cc:     Lee Jones <lee.jones@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>,
        syzbot+0ed9f769264276638893@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 9, 2022 at 4:09 PM Christoph Hellwig <hch@lst.de> wrote:
> On Wed, Feb 09, 2022 at 08:52:43AM +0000, Lee Jones wrote:
> > This reverts commit 60263d5889e6dc5987dc51b801be4955ff2e4aa7.
> >
> > Reverting since this commit opens a potential avenue for abuse.
> >
> > The C-reproducer and more information can be found at the link below.

This reproducer seems to be working fine on gfs2, but the locking in
gfs2 differs hugely from that of other filesystems.

> > With this patch applied, I can no longer get the repro to trigger.
>
> Well, maybe you should actually debug and try to understand what is
> going on before blindly reverting random commits.

Andreas

