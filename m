Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1E026634
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 16:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729669AbfEVOrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 10:47:05 -0400
Received: from mail-it1-f177.google.com ([209.85.166.177]:40862 "EHLO
        mail-it1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729491AbfEVOrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 10:47:05 -0400
Received: by mail-it1-f177.google.com with SMTP id h11so3458225itf.5;
        Wed, 22 May 2019 07:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wQm3IgF/8GknfNdjBodVZNb9GhgGog8F265tIB47+WQ=;
        b=AxeYXP8ExC9cVdtJv3AhssRjcHlSrZ7cMCLlAfQy0of+jhm3jY+qT4oQJ1LZqet6n4
         3GD1fyI3Jb24W6mvKabyhJAmw52OSwpM+Tmdd+CL2V52J3GJPz0HByHj6GB0iTZIAVp1
         5knz8aEroF1wSje3bSHN09ErM/43HbuGULCa/CUElyfaHrpetzyrvlx2TFG5EwZm3iEY
         mWkAqj6Aw4oBhwtAndhA1dw/PKT4zo+SuxznOpFYnxxgDTYglC5RGOOhfPU6MHv8z1qO
         QLtlO4ycB/ZVZIpcvlnzEDNNXDP5IMHO9wnclMOUqFb5+c0OPUxfTE0LZt5a/I+S0O34
         +uXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wQm3IgF/8GknfNdjBodVZNb9GhgGog8F265tIB47+WQ=;
        b=qx1qhlHuAIX+ztIafcNKUEAKsJtYDs5bg5Rzzuh0nvinGImpZ/9NH8bDZ3YmU4i5cw
         aoizVDT+QF5HjSzevANaNmrkCZ0JBeyrS3c3Hg0hnWAVhXQErfO7TZeeNQ8PG+mpPne8
         pstzhhiaJQ072aC9HdYirI9qoGxO0cGVUVSiRe6u4rKzLaKoDWz2LiG2JmkKtWx6APHN
         ADS8YUIrE/4CYkwsuJ4Xo8xrByEPaBy714w4Z15h4we7WEwx6VrqnYpe2+SFjal+XlrY
         Rx/Knl8ICaDQtx7Wf6+NcXEuYfKNT2vo1H1VtTkEDGgKEEjI0Wq/AmSbb6REnzR/xmwt
         orsQ==
X-Gm-Message-State: APjAAAXLAXe0fRwYtbJ89WugiGu0SnlkQRlw6uzOWjodmYxpf9HFTKWB
        yVq/UM/VOLfYIDmY1PVRjtJ/m22AOfeGMrUMUYk=
X-Google-Smtp-Source: APXvYqwIS0fzq4a3D9fPJ6QV4qBCwY8aGmOhFkZ4l7U9Ig6wqIBjlnmtmRjG3MBD0gvFbfEG4pQBNvdj8w/UYfH1m1k=
X-Received: by 2002:a24:8988:: with SMTP id s130mr8452004itd.79.1558536424800;
 Wed, 22 May 2019 07:47:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190522035525.3l7Xf%akpm@linux-foundation.org>
In-Reply-To: <20190522035525.3l7Xf%akpm@linux-foundation.org>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Wed, 22 May 2019 07:46:52 -0700
Message-ID: <CABeXuvr4onqWexVoGfLmzFvnDZPd98xzz6r--tYsNtiHWuZ1bQ@mail.gmail.com>
Subject: Re: + signal-adjust-error-codes-according-to-restore_user_sigmask.patch
 added to -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Jason Baron <jbaron@akamai.com>, Eric Wong <e@80x24.org>,
        Davidlohr Bueso <dave@stgolabs.net>, axboe@kernel.dk,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Andrew,

I had accidentally deleted a variable declaration when I rebased v2. I
sent a v3 fixing the issue. Can you pick up that one instead of this?

Thanks,
Deepa
