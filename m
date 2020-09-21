Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E8D272B8E
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbgIUQSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727557AbgIUQSf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 12:18:35 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D77EC0613CF
        for <stable@vger.kernel.org>; Mon, 21 Sep 2020 09:18:35 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d9so9696134pfd.3
        for <stable@vger.kernel.org>; Mon, 21 Sep 2020 09:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+rDkAJQZBPo3e2gcsRP3XrUOVCJVt0Iwd3xFgW+iJL0=;
        b=W+irorD9mvgj8wp2KcMwxN9sXgBUJdFSiz4sdTPcqQOzYMWukEjJDeswF/QfxCfjmF
         PRj6bPmhB5nB+3ca/4HXFwkBECoVYbEALwxXJjEWNgXWOFb7AIQ4R/9IKPxTc3wuVZ7S
         6CDl19E6lGk4ipk4PDCMmzn8q5iQZmAOa0SAQmy7eKr3BgxbXK6wf/0DQ8tXMJ5AlSTm
         UH7eiXtmdFbJ9/l6qWLADrvNfnPtYzostgMcC3UarXXoJ5SddNp3giIa9VB620Q8M0/a
         5I55ys5zoOaVVuR9Qq5hDs9o90ar1MG67+52s3J1RtMFEAYv5fjoHcW1y508abnJm3L1
         tzqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+rDkAJQZBPo3e2gcsRP3XrUOVCJVt0Iwd3xFgW+iJL0=;
        b=t2gT/9Mnc65EHFb5oJDYEAmFpxZULqD8tSaTO0E4EKHsctkf1AFVFurO3255/QB2z3
         wJG9ai39VipqJIChvvmyEjq2rZIj9YHHNIWiiuCx6lQDkEizHyd3nQmE6TXpxLpp2uTy
         aspWA3ksn5esk239mVAka7buamSZn4aWFa8+vDir2yVdJmWIyUKVxjyxHI9+shQWysaj
         BisLGEOx/vRMHvJSKWWYrWAR/OVjj2NRaTdBcLtfeVIWbobf04dBxwcYMWFGvmwqZTjk
         OPnPRFxlssThR4MluovBh8ExBMg0Wf/KswOKK5BoCyl60e5zP93ggQRUSvjeQ/qve4Sn
         XFnw==
X-Gm-Message-State: AOAM530afZHSbSbvAmBxJW6HEnXFfJUl8HmpF5YALKXkuY/LoSNRzN9x
        UG9kC8BrvJ6dzdqvxB9P/PkPetotTx/C6PGESN8=
X-Google-Smtp-Source: ABdhPJx1/tJMhg+E45d+2hlA/fjdfugaRnjmrQXP6O8AlxtAu40RhwkwBA46ppGH44OWsps55vbLNblkXhoUsqgtIzo=
X-Received: by 2002:a17:902:b7c7:b029:d1:cc21:9c38 with SMTP id
 v7-20020a170902b7c7b02900d1cc219c38mr703979plz.21.1600705114843; Mon, 21 Sep
 2020 09:18:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAHp75Vc=v3wOZB7GovW6zzrQFpFB=Rpn8deo-heBLcMzTzfzFQ@mail.gmail.com>
 <20200921160843.GA1096614@kroah.com>
In-Reply-To: <20200921160843.GA1096614@kroah.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 21 Sep 2020 19:18:16 +0300
Message-ID: <CAHp75VewUYHtG-BNWePtnkU2W-H3JbqeXAMSkE_+w+raGn3D5g@mail.gmail.com>
Subject: Re: Request for backporting 72a9c673636b
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 7:08 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Sep 21, 2020 at 07:01:26PM +0300, Andy Shevchenko wrote:
> > Hi!
> >
> > Can we backport the commit 72a9c673636b ("x86/defconfig: Enable
> > CONFIG_USB_XHCI_HCD=y")?
> >
> > Today I had experienced very well the exact problem described there in
> > the commit message on v4.9.236.
>
> Sure, now queued up.  DIdn't realize anyone still used the x86 defconfig
> anymore :)

Thank you!


-- 
With Best Regards,
Andy Shevchenko
