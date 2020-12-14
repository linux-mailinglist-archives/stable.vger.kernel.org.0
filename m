Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371242D9A93
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 16:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgLNPHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 10:07:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405827AbgLNPHp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 10:07:45 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E855C061793
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 07:07:01 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id g20so7932204plo.2
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 07:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JN3Csvy64Jey5qVqkQVegYbviP2Gq5a9qi9hYq50luI=;
        b=SSvUmrRKogXsKM1CWMwDOXiihQtKzS69TgdAMuiWTIYZrH+1YfNqwMeq+jbtTAgme3
         cGk9C1ryxzp+o1XgUvJi9l2ppvbEUDGwHputruxWX6xgh2YItWJS0DfwNwYBz8yjL4vn
         x/IxxSxMojiKxPSS3QCmOzeQ+IZ0+bCoWWe21URqdoO/L+XDfWS0rZq2mX/7ITotBZ3y
         Uy5XC2DBRUKQI7Xv/+8NwW8hx7ffQYU/atqwqt845CPFkTx8jefjDVT3p1Rxyhu0QrmQ
         lOkJyQglpG9UFLS2nrwPQLOwahKZgYDskq7Z0WGZr8vJI/qF0mIAsIg+4torOw6smB5L
         wG/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JN3Csvy64Jey5qVqkQVegYbviP2Gq5a9qi9hYq50luI=;
        b=WPUEL8P8LWieTycdXV1J9bc2/FcnVlBHE3b824kNRqRtsgsTFbR9S/ZW+l5+US3FBx
         E4YfmXzKh2nN4NnHYjhLzrlXfi1hrkPHgkphrkWywCI7r3ONNDI9wmFgk63uqOw6OlzW
         iaUtuIMzT2Eyo49H5/kWfSzmUTbWf+oXG4pHbBPKUe3JiWKJFSnc2MqaZ8nRSrumo08Y
         DUWQgrnklsa4k/N7whZwtPNE96BAg2YrO0eXQl/oQwRmWCY6m7ZKVUPEjGjUz4fa9kqE
         Yf3zQnAcLSR1lDXrkotN87cXovGP2PtpB5YRfg9SNCUXwy60c+IR2gug3VPVyBsOIYcU
         KjbA==
X-Gm-Message-State: AOAM532nUkFKHa0Kv0ZqnkT8wQWOAZJqTCL23UJH0/mb/Fr43vpuSK3E
        C16ZwvBXJr6J2odf4C1D59rsd/8p/fDl4Vai5LIfIQ==
X-Google-Smtp-Source: ABdhPJyL89I6gyGPltJ2uDQeK6DOgJkqFytDsCnxWTs5NNGPzB4d7U94uIQdNFO8656+AaI7xitQkNIuqTco3Uktusc=
X-Received: by 2002:a17:90a:f683:: with SMTP id cl3mr25912152pjb.136.1607958420418;
 Mon, 14 Dec 2020 07:07:00 -0800 (PST)
MIME-Version: 1.0
References: <X9dDkwlOTFeo9eZ6@localhost> <000000000000af6ec005b66dbaa2@google.com>
 <X9d+dZq/IA+tiw5v@localhost>
In-Reply-To: <X9d+dZq/IA+tiw5v@localhost>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Mon, 14 Dec 2020 16:06:49 +0100
Message-ID: <CAAeHK+xLiLjGMJLuWpyPHMO=zD6k33s5VYSBDMMbTkAEauF3dA@mail.gmail.com>
Subject: Re: WARNING in yurex_write/usb_submit_urb
To:     Johan Hovold <johan@kernel.org>
Cc:     syzbot <syzbot+e87ebe0f7913f71f2ea5@syzkaller.appspotmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 14, 2020 at 4:02 PM Johan Hovold <johan@kernel.org> wrote:
>
> On Mon, Dec 14, 2020 at 06:48:03AM -0800, syzbot wrote:
> > Hello,
> >
> > syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> > WARNING in yurex_write/usb_submit_urb
>
> It appears syzbot never tested the patch from the thread. Probably using
> it's mail interface incorrectly, I don't know and I don't have time to
> investigate. The patch itself is correct.

Hi Johan,

I wasn't CCed on the testing request, so I can't say what exactly was wrong.

Could you send me the patch you were trying to test?

Thanks!
