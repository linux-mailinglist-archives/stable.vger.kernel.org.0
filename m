Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7EFAE9FD
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 14:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfIJMH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 08:07:28 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40346 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbfIJMH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 08:07:27 -0400
Received: by mail-lj1-f196.google.com with SMTP id 7so16133763ljw.7;
        Tue, 10 Sep 2019 05:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oSyWHvy5qNmTZ73ob/z3PLdVlMLGMuAez5QFbh+wLI0=;
        b=PDyzOjUdhhtDOQp26qY5YZvkKj3iR3Tyj6FvHt6Y0wBUXhlyGDEC45ICUeKN2kDRGu
         fs0oo11Z7jcgxuu41yzPkf6ImmnxKFdRo6rJ8eXfW4AT9qI4ntrorCXTawbmAXHYNhqA
         OM/1z9/88eVibm/haR1eKbe3K7SWr+FNP6xS7Np0RPMM6qA9FdQ1VL2c4FUAG9ZpO976
         eTQ0cbf5Hlza7A56Ojsw3OG3GrSWqiRVkLQw7bBHX0Hfxf5x2L53tkP05KxeVakB44rf
         hzW7eWLieII46vL3KFDoYEQH43a6PoL4N4gxR95Jot9elq9+CXf7DvHoucBc9ZuX3xEW
         o7AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oSyWHvy5qNmTZ73ob/z3PLdVlMLGMuAez5QFbh+wLI0=;
        b=OI3nVKWYIZdR83hR9JBPnal6DpLP/22ox2GoF4ltvDO8un91x+mRMMYQzUXW1NtXuB
         6BS31mVqpBDaSDcyP0q6JDLmYbfl2XWs423/ots67qJ24iWhM9OdXfeuI3dowA/8/1jx
         Jp4sBw5uup1vJkEXpCBwjxof4InO1aet+djWK+84hu2updjUdqMJcQuJQm6Q6myPHCCB
         q+G5cHGtfTlu5ddVArK3fH14k5B/GFUJY0QJO6R6dUUTsKAv0q3iq5laNAdcJzZQ8ba9
         F8Txc2Qj6puPD7GxIDfjA90mYNialg7eNoMwIbQlmGOQ6Fmk8E2z/TTFoGX4tWWIbaRF
         wooQ==
X-Gm-Message-State: APjAAAUzVT96uc8M6tnZ38Em5cpt5p8RK2eVw/olPhOfHmhijnZjiyZH
        v0kwZKyLTOUXKn8VrlvELUVM12mOJ6HqfScHPCY=
X-Google-Smtp-Source: APXvYqyXOLNyXSxNMf6QIbIPNTPM6YVDRnOW6yZWF5MXi8mLLRt3Ff3GMWUwtDUol/3hzM7JQpAMKzZPJR8ld2tZy9k=
X-Received: by 2002:a2e:8814:: with SMTP id x20mr19976113ljh.221.1568117245889;
 Tue, 10 Sep 2019 05:07:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190905130252.590161292@stormcage.eag.rdlabs.hpecorp.net>
In-Reply-To: <20190905130252.590161292@stormcage.eag.rdlabs.hpecorp.net>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Tue, 10 Sep 2019 14:07:14 +0200
Message-ID: <CANiq72nTKbNEKezoy_CqdFRuQ0SD2OsORV8u=i_1g=2atkCRiA@mail.gmail.com>
Subject: Re: [PATCH 0/8] x86/platform/UV: Update UV Hubless System Support
To:     Mike Travis <mike.travis@hpe.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Christoph Hellwig <hch@infradead.org>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 5, 2019 at 3:50 PM Mike Travis <mike.travis@hpe.com> wrote:
>
> These patches support upcoming UV systems that do not have a UV HUB.

Please send patches as plain text without attachments. See:

  https://www.kernel.org/doc/html/latest/process/submitting-patches.html#no-mime-no-links-no-compression-no-attachments-just-plain-text

for details.

Cheers,
Miguel
