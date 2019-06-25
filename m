Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 036A155225
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 16:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730777AbfFYOjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 10:39:51 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53034 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730689AbfFYOjv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 10:39:51 -0400
Received: by mail-wm1-f68.google.com with SMTP id s3so3114795wms.2
        for <stable@vger.kernel.org>; Tue, 25 Jun 2019 07:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YhXGhuvdh9IF62+1YEpdE+Se2v/aX5uivQD3lbSImbo=;
        b=QlaNDTN55WD4EZvnXjKzMxE0Oq3eAFdGtcd0vjHllEu7tYiIJmtOGyAv7A7xH5z2PA
         7mQ6GCXQNUe+BXAQHokpcXuUc68TR80B0Myq+WT+VKO0esycSIj3pVWr1/Z22urBwNBl
         +b6cxcaT1nOYBL7w+8q4KbrCZXTI643/CxZ3lS8sF4rYdNslGdqkdiO79yc3OhRXfrjp
         CjTUjl0ePctURXAGxgcFnJEVwNVt3XPTXNbNbw7iGxTxDpK1r4G53DrdsclNlZ8huoYz
         cZ4mFOzyDZnk1poy340pWQS6afPjZVa5rwTytHM+ilAJDIjw4TmH3mTYKVbdym60lrz8
         0iHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YhXGhuvdh9IF62+1YEpdE+Se2v/aX5uivQD3lbSImbo=;
        b=XUXU+II/KUpbi9xKfc9tlBEgWChwQ83Bi+cWwZx2XOxm86Xjr9RKTC7PF40i1HW2hr
         Y+J5jaJKxb1/o639KFL8PK9ZIHkaJ1YuYswvSfryEXMO5pl+ejc1O0WxCRYZCamrHQdi
         OsaZi9kGMdhKmW0AcEX037sVVW0H/XfELWOT/ZNEhv8KCDtPPvoq8bBppiBhUdILfa1E
         UMHXpizhZ3d5YOXmc2UO+K2eAg0x+aKhvrUHG8j91CjJgExfLPqEfFCb7YQDNe/7mshk
         ZFaLyxTlM9ey17gZwMZDzLxE2iPxdGRUJ6bHK9tIqJ2axTggQ0NuVvL7JW4829mZf393
         Ls8Q==
X-Gm-Message-State: APjAAAUhpbw3YT+k5+AcOB1rouQHhtpae1CFVb+mawGs3r2rYBAP/yPO
        2/BswlZeBK6W67hQCCn6RCVY0XbXvq+WbxFrnt8F+g==
X-Google-Smtp-Source: APXvYqxhppxoCTEpJFKTjOP1JIEUrEwL62e+5T2aQM5VBcmO7cnAZMd3GgNlgAHhq5awtSe5tlOfW9rv2CxCNvHj+yk=
X-Received: by 2002:a05:600c:2201:: with SMTP id z1mr19012360wml.59.1561473589197;
 Tue, 25 Jun 2019 07:39:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190625141725.26220-1-jinpuwang@gmail.com> <20190625141725.26220-2-jinpuwang@gmail.com>
 <20190625142444.GA6993@lst.de> <CAMGffEmDt91QfOtbBm2AsRgb0JHW5pzOQeC_7TdX_v3XrW40qA@mail.gmail.com>
 <20190625143303.GA7202@lst.de>
In-Reply-To: <20190625143303.GA7202@lst.de>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Tue, 25 Jun 2019 16:39:37 +0200
Message-ID: <CAMGffEnHAD6O02C7nMEP3EOT9s9S7ur+A783o9dPRKubOkXZog@mail.gmail.com>
Subject: Re: [stable-4.14 1/2] block: add a lower-level bio_add_page interface
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jack Wang <jinpuwang@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sashal@kernel.org, stable <stable@vger.kernel.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 25, 2019 at 4:33 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Tue, Jun 25, 2019 at 04:27:44PM +0200, Jinpu Wang wrote:
> > On Tue, Jun 25, 2019 at 4:25 PM Christoph Hellwig <hch@lst.de> wrote:
> > >
> > > Why does this patch warrant a stable backport?
> > [jwang: cherry pick to 4.14, requred for next patch to build] :)
>
> There was no next patch in my inbox..
Sorry, it's 17d51b10d777 ("block: bio_iov_iter_get_pages: pin more
pages for multi-segment IOs")
It has you Reviewed-by tag, I thought git will also sent to you, but
checked it's not.

link: https://git.kernel.org/pub/scm/public-inbox/vger.kernel.org/stable/0.git/commit/?id=938c071db43ad047f95a0fde25545a170ad20bf0
