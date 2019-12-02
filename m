Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3399610EA6D
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 14:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbfLBNDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 08:03:09 -0500
Received: from mail-qk1-f181.google.com ([209.85.222.181]:39210 "EHLO
        mail-qk1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727605AbfLBNDI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 08:03:08 -0500
Received: by mail-qk1-f181.google.com with SMTP id d124so17207422qke.6
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 05:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7xRuuEGyAGanfoy5q3F5NENsdAyWJMeRKdcgAZk8b6w=;
        b=BE3iq2ZpIuCgwFcVamFkvW6pUOOlIbNrDoXwl5ZnUJwCxEaS36mYpKu6PGWDIGXD8d
         5nAj61ijp6j6BYbZddjD+1sCYLcYEb+mGXY+FCkE7cf/ux3am9ehp6A1HvgW9JuV/2AX
         AnFCV936pC7voJqDkfJ72Tp6qVf6oHWEZyYpXgXHqErwaE3Ro9MAkn+PlGwmKFTNMMbe
         PWccpVy75BSs0X0jzjZLIcHUwjQWKn8Aj6e7eCH0666MV8zLbPsW/RDvkFmXMRH0lhl7
         jf0NftCbxgY3/H7e/mEbLg6b0gSbqCpAFkzeUf7utSKUEjIV9cg1ieHzETt7tzujlf7Z
         evyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7xRuuEGyAGanfoy5q3F5NENsdAyWJMeRKdcgAZk8b6w=;
        b=jcFMFbG+Vrc7tY2G5tyzRgGUTdJRze13Fnadb04KSVjUFB0lpLEQd/uszkw4pLnaYD
         ptEU3SMMRaS8IDpbSjKVSISwG6kFOcItiyDmWScKiyPCzqLZAN8Z41xsEvGKGumkoBQz
         i2D5ekzqP9OyKKf8czE++cBsm0PRCEF8P26yBCk9Ot0amUgIKgSvRqFZcP4fRg7wT9kr
         PXNYJx4gzAjNe3vFDgExfmwtHGMhHPFyeQj+TL698XlmDQ9CPNRZ/8AewOmMCTMBaGop
         xgtOFO2jZjnOPAjpbCyi3ctK9FVEukCD4d04NtG4CTsNTHUSTADXNf6PUVt7HO3wnZGs
         L37Q==
X-Gm-Message-State: APjAAAXESzs/3a2HFaJguJEoonojg3jIzb2ElTJs6XfiHVAuy3byf+2g
        nh6NQhqHuyrrp4bkQl/fE93F+JzQ0Qa/GnSKLn4SRg==
X-Google-Smtp-Source: APXvYqxltmbW6yD4IujggvoIjL/CEqI/VBXGaRoEomUUHm6dM6wNDlC3eKlhd0Zv9T5JH91OBtiddPWWM2XLu/kzmR0=
X-Received: by 2002:ae9:e714:: with SMTP id m20mr29726503qka.403.1575291786620;
 Mon, 02 Dec 2019 05:03:06 -0800 (PST)
MIME-Version: 1.0
References: <20191201094246.GA3799322@kroah.com> <20191201193649.GA9163@debian>
 <20191202075848.GA3892895@kroah.com>
In-Reply-To: <20191202075848.GA3892895@kroah.com>
From:   Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date:   Mon, 2 Dec 2019 18:32:30 +0530
Message-ID: <CAG=yYwn3nYn2CmV7BWOJdBWicYPuK2DwBgz6p=bDC9nWOt6vqA@mail.gmail.com>
Subject: Re: Linux 5.4.1
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 2, 2019 at 1:28 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> You tested the performance of what?
i tested the performance of  5.4.0 and 5.4.1

> And 5.4.1 is faster?
>
and it seems to me that 5.4.1 is faster than 5.4.0
-- 
software engineer
rajagiri school of engineering and technology
