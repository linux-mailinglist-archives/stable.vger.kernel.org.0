Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340E243D0A5
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 20:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236888AbhJ0S0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 14:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238570AbhJ0S0U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 14:26:20 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA68C061570
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 11:23:54 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id x123so3335669qke.7
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 11:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5dU5i2rPAA1rWa1tBZegagA5UHnsbTclU/Hvls+bm6w=;
        b=LnRRS+MmzvGJTLZ4cdjuzpaM79iMGNZvfqRkeBYT+/VV6Zxo3dkTmrRHfLbM2Y/Cw2
         1+b0r9rHhreWhKzLcucFILGrNT9TEqlx0EM0ljZnye2h5Xduc1sS5dWHE1Xk3PzU3B1L
         3RQhu5MNmGTwvqi8CZObzmDLH4GSQbKTFjuwA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5dU5i2rPAA1rWa1tBZegagA5UHnsbTclU/Hvls+bm6w=;
        b=ifGh3ts7/BSEQ0tBbRgR8RsC/JI9xt6Ab8NhSECtzgUc4qNekQMVQW5gA6WpiZg7I9
         u9rGrbS+Wn2BYfvmXhAL3pZEJvaAAUMjV8aycfuNyOs7hgdV3XqquuWf9JnlVP4iFz6u
         9QnYPMeOejNBsS8VZ+c+TxZk8uWT3yXRaD6r1gBLE+UQsbm/58yXDoYFNRLxhpVdu4Ru
         44jabo88KbsyghU31LUAc5NzyTPpMUXTMYori6oS5j8u9JI6MSKxWUoBS/Ijll0//YBI
         DIH4Td3wyEil9qDaHeTZlDY2uQLWrSAO4SWkIhgiL3HrLx9j/ebfVGTqU/TuRfsjBgDl
         4H1Q==
X-Gm-Message-State: AOAM530lXSUydBK7JQAJk6VCh89dnA5DyOM9+5z83QPuH3cUsbzuDoCT
        BgC8kCOlGz5KgEI8Q9BUnFtVdDUtMMjESA==
X-Google-Smtp-Source: ABdhPJxTT+MWFqX3wgfw6oSX9JOCgwNL8p17RfLwn6Wu7H5PheUTwB7/MzruAX2s+D3qdYbaG7XIfQ==
X-Received: by 2002:a37:a7ca:: with SMTP id q193mr9615185qke.342.1635359033402;
        Wed, 27 Oct 2021 11:23:53 -0700 (PDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id g18sm379723qto.71.2021.10.27.11.23.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 11:23:52 -0700 (PDT)
Received: by mail-yb1-f175.google.com with SMTP id t127so8509279ybf.13
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 11:23:52 -0700 (PDT)
X-Received: by 2002:a25:b851:: with SMTP id b17mr32814544ybm.301.1635359032208;
 Wed, 27 Oct 2021 11:23:52 -0700 (PDT)
MIME-Version: 1.0
References: <20211026095214.26375-1-johan@kernel.org> <20211026095214.26375-3-johan@kernel.org>
 <CA+ASDXNbMJ1EgPRvosx0AbJgsE-qOiaQjeD=vCEyDLoUQAgkiw@mail.gmail.com> <YXkCVLJrQC7ig31t@hovoldconsulting.com>
In-Reply-To: <YXkCVLJrQC7ig31t@hovoldconsulting.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 27 Oct 2021 11:23:41 -0700
X-Gmail-Original-Message-ID: <CA+ASDXPGDOmZgCV01xAAgyOei9sSyNe_VUDWK7pkC_VLs4K8JA@mail.gmail.com>
Message-ID: <CA+ASDXPGDOmZgCV01xAAgyOei9sSyNe_VUDWK7pkC_VLs4K8JA@mail.gmail.com>
Subject: Re: [PATCH 3/3] mwifiex: fix division by zero in fw download path
To:     Johan Hovold <johan@kernel.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Amitkumar Karwar <akarwar@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 27, 2021 at 12:40 AM Johan Hovold <johan@kernel.org> wrote:
> On Tue, Oct 26, 2021 at 10:35:37AM -0700, Brian Norris wrote:
> > Seems like you're missing a changelog and a version number, since
> > you've already sent previous versions of this patch.
>
> Seems like you're confusing me with someone else.

Oops, you're correct :( It was only a week or two ago someone else was
trying to patch this, and I didn't remember the "From" correctly.
Sorry!

> I'll send a v2.

Looks better, thanks.

Brian
