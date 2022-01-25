Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A43749BB9E
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 19:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbiAYSz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 13:55:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiAYSz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 13:55:56 -0500
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061C0C06173B
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 10:55:48 -0800 (PST)
Received: by mail-ua1-x931.google.com with SMTP id 2so39177812uax.10
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 10:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c9ZgTqaEJZN4qpmKovkjUxI/On3KKRk04Ai0LsfnAps=;
        b=D53NKWJbF5iGs2lwPt37/6vcFbkDm6/qAwycCJLfKbfOVq6OxA7A1YZUb6aVxqTF0r
         +vZpSA57NlD11RMTJJ2tKEiyWOFso7Zz0PaGR03LUEo7t9xggie5nBKrM+Ycs2WpPyfW
         UypfMpeY+tAzTpoUuQrPacOlBZpnlU1wELoZ0Y4wSyXXp1PXLCe40jb0lFbgB2tuciEp
         hafXgnLcQjZTS6ZeMfvGY1UsDrxwbhAiQ/X52cDcfMhjAjnPGjoD7eIkIGT7zJIK2jtO
         00kIRbGGZsUx/qrMrHtwLW+HtqpBfVPhx2ScX45ZAKXVi/YHny1c4jHQi9bvpsW1xytw
         2tJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c9ZgTqaEJZN4qpmKovkjUxI/On3KKRk04Ai0LsfnAps=;
        b=IgaFpSvxJ8RBJDUJ5HIlG2ZpMynP9zAABi4QRhm68g/nqZyQy+EJa78ukSH+1lmK7x
         iwDqoNt8n8IxFI1JTMLAspsHuIEVtvw318H9w3xxRTmQxEAVXkD6wPeG8P0pL6U9CV+I
         /NMTJemVWWRl7YxzTxvSWauYT/a2L+5HnNTVssV5XT0dw7EwApPpx7DSXxeRw7OHauqs
         sgn3tRRu+VP2z/MfZjQnnC+Ym9S30B/xzLcll1wlgvEPHBBI0IBThp23tuskDv2Zvmkb
         HVOCLaogYZuMCdqyZ7xjQ0AzdupR1iqjtDZUrv+9bnMDYjAoEPElGE7bLCIuiiNhENPd
         GL6A==
X-Gm-Message-State: AOAM530HiJbxRlQFytT7mgZok4jgOrksq2HZXk3pBMIEDxLGKMr2r2Xx
        QHJPMS5pU6gvZvGnzgoZYv4bfJloDDTcIqpiAz099Q==
X-Google-Smtp-Source: ABdhPJxxmuPTe6D45cYxOPvtCn+QtiikAuvqB5o7PhTTrNJnyQLbq8mUFz8alvACbfDVK8p8PoE0O79DsR+VtkRnvXs=
X-Received: by 2002:a67:cb87:: with SMTP id h7mr7659810vsl.3.1643136947213;
 Tue, 25 Jan 2022 10:55:47 -0800 (PST)
MIME-Version: 1.0
References: <0af17d6952b3677dcd413fefa74b086d5ffb474b.camel@rajagiritech.edu.in>
 <YfAKYWOMdGJ0NxjE@kroah.com> <CAG=yYwksvQmEsfRyFiQTbSxUL39WGf7ryHaywtAxgdL1Nt67OQ@mail.gmail.com>
 <YfAk90OPjlpjruV5@kroah.com> <CAG=yYw=BK1gU0UV8g5_ZT5gOe5P2W2rKHWdFyPi4ZHSy4CGMFw@mail.gmail.com>
In-Reply-To: <CAG=yYw=BK1gU0UV8g5_ZT5gOe5P2W2rKHWdFyPi4ZHSy4CGMFw@mail.gmail.com>
From:   Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date:   Wed, 26 Jan 2022 00:25:11 +0530
Message-ID: <CAG=yYwkMrdGEX0cQX+z6Oj=vJp9LnrzuS7+vAzGZG8GW6t-Oyg@mail.gmail.com>
Subject: Re: review for 5.16.3-rc2
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

a
> > Does
> > 5.16.2 build properly for you?

anyway  5.16.2 does not build properly for me now.
may be this build error issue started when i
plugged in a usb transmitter for my new wireless keyboard and mouse.

-- 
software engineer
rajagiri school of engineering and technology
