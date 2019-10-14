Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFAD2D6649
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 17:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731177AbfJNPki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 11:40:38 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43649 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728905AbfJNPkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 11:40:37 -0400
Received: by mail-qk1-f196.google.com with SMTP id h126so16254388qke.10
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 08:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=l/DUG+6AJxTWO2v2Di5KIMbX7EJQuPQIDCSW9MTCQJ0=;
        b=n9TejyfrtuzGpb8hnp3BYJYglnBwJCDZZO81KDOihB5f3ke7mgS5aOQkFEnPduHEri
         ZY3zQiPYOEPGaZxT1YPe+SHMiECp+x8jbiNCzCXBRR0gTEgM+RgTGbKahaaMxiXRMujS
         Uqfp6xTWEMAWnXccSGRsPjkpBGKBiJ52YxRwgLwYevzvHFujsApAlZY//6q4zgnJfxhz
         7xHyrpxY9Ujnn3SQqBYl+2aY28gF52u26B4vAnaEdb6UwwmlW3w+Oz4or49qKdWe8K2o
         PYLxp+ewmVHbQAu9yh2jcdOpXIfRFk9eGYxnbCrgh8N9MI0giY3uMI5q3skUSlWg9Hzp
         gxBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=l/DUG+6AJxTWO2v2Di5KIMbX7EJQuPQIDCSW9MTCQJ0=;
        b=ZNFEgJnBh4rwr/3/ocIt6eCOdd/9zxbsNhU/FuB6BpIz2uEZZZA4Kziy+OyNpU3XDV
         RT+Bu6QhX7Yy11hz98Ig3wTYBToOz7+kz4ELGrSRZk3S4f65KdPqoBxWrLJs0jiXR1lY
         uog2Ecc1JC68gZsDU4HW4EP/3Gc3HOh5K0qX9/IguvUd3V55gc/Ans1/hvY7b0UGfnNz
         MCujWaViP2fg7FvidQRNTO87GIKRM21cqQ7d2pMakRsq84sDCVsM2pm3EXB2qhhr8ES2
         VU/hKeOThJB5/9AbJFLMTbppfl2WOP48zf9SI8MZWChOdlOrDQZxqZgR46SFNz+XHuf3
         41xw==
X-Gm-Message-State: APjAAAUijiQuWhiorHJ5WQSec9QxoCc1hhEeOJBvIelVWLB+jV9f3jex
        WhfqfpzloAypAFq5o0I3o5I=
X-Google-Smtp-Source: APXvYqyFoTwEACn4DdfJH+Tx+4Ed8u8thClLBAg22DdKOhM39k2EyoWAf4iS9RN8eXp5A1bA4+0x+A==
X-Received: by 2002:ae9:f108:: with SMTP id k8mr27641571qkg.78.1571067636536;
        Mon, 14 Oct 2019 08:40:36 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::1:50c5])
        by smtp.gmail.com with ESMTPSA id q207sm10195740qke.98.2019.10.14.08.40.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Oct 2019 08:40:35 -0700 (PDT)
Date:   Mon, 14 Oct 2019 08:40:34 -0700
From:   Tejun Heo <tj@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>,
        Jan Kara <jack@suse.cz>, stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] writeback: fix use-after-free in
 finish_writeback_work()" failed to apply to 5.3-stable tree
Message-ID: <20191014154034.GE18794@devbig004.ftw2.facebook.com>
References: <157086827811218@kroah.com>
 <CAHk-=wiE8oFcPHCMM11j0svKQWwM8nuhnQ9R1OdLbfum5ALvOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiE8oFcPHCMM11j0svKQWwM8nuhnQ9R1OdLbfum5ALvOg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 12, 2019 at 02:54:26PM -0700, Linus Torvalds wrote:
> On Sat, Oct 12, 2019 at 1:18 AM <gregkh@linuxfoundation.org> wrote:
> >
> > The patch below does not apply to the 5.3-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Hmm. It looks to me like 5.3 doesn't have the use-after-free problem,
> and that it was introduced by 5b9cce4c7eb0696558 ("writeback:
> Generalize and expose wb_completion")
> 
> So I think the "Fixes" tag is right, and the "Cc: stable" is wrong.

Yeap, sorry about that.  I think I forgot --contains when running
git-describe and mindlessly copied the output.

Thanks.

-- 
tejun
