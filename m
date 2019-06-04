Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7990E34073
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 09:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfFDHik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 03:38:40 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:32799 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfFDHik (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 03:38:40 -0400
Received: by mail-io1-f65.google.com with SMTP id u13so16579900iop.0
        for <stable@vger.kernel.org>; Tue, 04 Jun 2019 00:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=whUdx3PYfAT1LgXbF2UhhptlKP0Ofnl0gzd3eFk94w4=;
        b=OgOr1GqzdH943Cm61amiU2StVTwXwnuPDFM14lyodXfNDFnHErCS5uM1fct1C0KkXA
         tA3Ga+r0sqrudTlVwuAuiDQbsTM2XFpz6R4safSqOu7Knmq8dt4GnVoLjXFNEyiNnRt0
         0XJKE8aVtzBtXcBskagj2mAcMoyFnabfKgxivz8rA3VJ/FduoeLaaAeJu/NUBU2EGbzW
         H9mamhPycD5ulvRcWvahJeu7JcvURCn43KCkfgs13+AQZ+qBFrweKFkuXu1PqYiE1ayS
         Ms4wMdER9dPAJHL0eC0dgngBaBGThe/1Qu23q71dG836y8oFr2bFY5Lit/0K7uiQKAPZ
         L8rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=whUdx3PYfAT1LgXbF2UhhptlKP0Ofnl0gzd3eFk94w4=;
        b=CgtX4Hhy0+w54UxPoi2SxxdWds+oMZ3J7lID3ASIvZeqJgcPh/0OoO3jKBf5Uy/zgd
         OLprdn9YWkXUbHdWOhCaPZ/I44Ygbdp+kp3s6+5a61IwJWyPUflU5dBUAdjyIB8trXcY
         sfBlOvguaxIA0s8dd5SX+HqW6eqYVTB5bCPDZRfitQVpXyMRs7H7kfK1wO02Da9qsZQ4
         +mmOjHemuE69HLPnSDgdQ/U0qyjysypUZ35W4LoroWyA00c3ikLsux8IdubU09KWocQ9
         zLvbmhBsZtJFCTikn6ao3UvqJqc/VlVfhGKqHKbdbtM7qYnVwk5YMJU7qDU/Eh3Zisaa
         itQw==
X-Gm-Message-State: APjAAAUhxSQcz0YEeP2bW2qiuaTwuyrxpUcawxFW2zPVgOF6qyfta8SG
        i1sjqW/2y3mYlWylDv/FAS+rNMVTIicGYvZOdZa8oQ==
X-Google-Smtp-Source: APXvYqy1ce99OBhREqeU5xsvJyvH0lUMM6mPiWpmj6B+QaiXWrvLiI8TKwqLv06plaTrMHBYnKKfTjuwUSRHLc6+wo8=
X-Received: by 2002:a5d:968e:: with SMTP id m14mr18784072ion.49.1559633919631;
 Tue, 04 Jun 2019 00:38:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190603223851.GA162395@google.com>
In-Reply-To: <20190603223851.GA162395@google.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 4 Jun 2019 09:38:27 +0200
Message-ID: <CAKv+Gu8VioGy1h8n0zKAqj+m_PBZdRU+BmJDH7=D7=iEiKRpgw@mail.gmail.com>
Subject: Re: 4e78921ba4dd ("efi/x86/Add missing error handling to old_memmap
 1:1 mapping code")
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        groeck@chromium.org, Gen Zhang <blackgod016574@gmail.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 4 Jun 2019 at 00:38, Zubin Mithra <zsm@chromium.org> wrote:
>
> Hello,
>
> CVE-2019-12380 was fixed in the upstream linux kernel with the commit :-
> * 4e78921ba4dd ("efi/x86/Add missing error handling to old_memmap 1:1 mapping code")
>
> Could the patch be applied in order to v4.19.y?
>
> Tests run:
> * Chrome OS tryjob
>

Unless I am missing something, it seems to me that there is some
inflation going on when it comes to CVE number assignments.

The code in question only affects systems that are explicitly booted
with efi=old_map, and the memory allocation occurs so early during the
boot sequence that even if we fail and handle it gracefully, it is
highly unlikely that we can get to a point where the system is usable
at all.

Does Chrome OS boot in EFI mode? Does it use efi=old_map? Is the
kernel built with 5 level paging enabled? Did you run it on 5 level
paging hardware?

Or is this just a tick the box exercise?

Also, I am annoyed (does it show? :-))  that nobody mentioned the CVE
at any point when the patch was under review (not even privately)
