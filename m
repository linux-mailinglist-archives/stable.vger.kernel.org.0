Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FADE2B4EE3
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 19:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730623AbgKPSJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 13:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730379AbgKPSJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 13:09:50 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A23C0613D2
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 10:09:48 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id u19so20188329lfr.7
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 10:09:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hu5++/kJeVjJEiUxVlOBfldGtXXjOObK0j9yLP+sNSY=;
        b=baew2OznxixMFWwa8rFtZDjYndGY/BNHPjeYN+gAEWyL0FCL+lP2R5/6+0IMTekE1b
         99wN8eBTB1s9tBaULqn1FTc9kugWtNBBn5NM7/2LqHdal6yjEeyuRb3cbNiHh8OnolhC
         Fji9oRMYFO1DUSacVg94h0YAeOGP8+oDGNNXc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hu5++/kJeVjJEiUxVlOBfldGtXXjOObK0j9yLP+sNSY=;
        b=VQGcqLSSGkznlChvdQ6xtDqO7R9eSVhjKTpB+QbNK41rk0sOLZPLHSN5LsMgtwehVC
         JgUb0XU1GyywwKBVbtJXEBwVr7NngaWvmYrcNbMUanMzTFk6vnNO/is03GBecXmtRHbB
         UjS2u6aK5IORKzoxSfWKjy1Ozcis9HzQw1QIZgrrsJVBmyEyRRA6/13myJpNuEmEmwNw
         HPH1CNfJOPajaJaox2A1WQPz/P97TN606AjZXJXFXp7yHiSuEjNQOB/4dBrvdGLQQRLH
         nQKmabgsW875MZMoWZyK3jzZuoje+35bW5/Uof1KLUkpvC0cbZfjfqOzc+9SDRnft3dg
         Jz+A==
X-Gm-Message-State: AOAM531XaZdDkJQ2eTBtz6VUKPWt/7MjSEB2EY6/JYI4PuW9QrdbUb29
        Jn19QVd8f49Fi7UKDcdN+yJkvlwDxU7l5g==
X-Google-Smtp-Source: ABdhPJx6qp8Qqt9GbqpOJazR6QqdZj1RA4vAIYQ6PEF92xG/MmLZ3r7u3zWav3oUwcNXlizd8QpTrA==
X-Received: by 2002:a05:6512:3245:: with SMTP id c5mr188789lfr.405.1605550186662;
        Mon, 16 Nov 2020 10:09:46 -0800 (PST)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id o84sm2819882lff.302.2020.11.16.10.09.45
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 10:09:45 -0800 (PST)
Received: by mail-lj1-f169.google.com with SMTP id i17so20099828ljd.3
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 10:09:45 -0800 (PST)
X-Received: by 2002:a2e:3503:: with SMTP id z3mr240954ljz.70.1605550184840;
 Mon, 16 Nov 2020 10:09:44 -0800 (PST)
MIME-Version: 1.0
References: <20201113080132.16591-1-roberto.sassu@huawei.com>
 <20201114111057.GA16415@infradead.org> <0fd0fb3360194d909ba48f13220f9302@huawei.com>
 <20201116162202.GA15010@infradead.org> <c556508437ffc10d3873fe25cbbba3484ca574df.camel@linux.ibm.com>
 <CAHk-=wiso=-Fhe2m042CfBNUGhoVB1Pry14DF64uUgztHVOW0g@mail.gmail.com> <20201116174127.GA4578@infradead.org>
In-Reply-To: <20201116174127.GA4578@infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 16 Nov 2020 10:09:28 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjd0RNthZQTLVsnK_d9SFYH0rug2tkezLLB0J-YZzVC+Q@mail.gmail.com>
Message-ID: <CAHk-=wjd0RNthZQTLVsnK_d9SFYH0rug2tkezLLB0J-YZzVC+Q@mail.gmail.com>
Subject: Re: [RESEND][PATCH] ima: Set and clear FMODE_CAN_READ in ima_calc_file_hash()
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 16, 2020 at 9:41 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> The "issue" with IMA is that it uses security hooks to hook into the
> VFS and then wants to read every file that gets opened on a real file
> system to "measure" the contents vs a hash stashed away somewhere.

Well, but that's easy enough to handle: if the open isn't a read open,
then the old contents don't matter, so you shouldn't bother to measure
the file.

So this literally sounds like a "doctor, doctor, it hurts when I hit
my head with a hammer" situation..

         Linus
