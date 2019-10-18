Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35162DBE6A
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 09:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504661AbfJRHci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 03:32:38 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38598 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504654AbfJRHci (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 03:32:38 -0400
Received: by mail-lj1-f194.google.com with SMTP id b20so5155000ljj.5;
        Fri, 18 Oct 2019 00:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M59q7a9C0OgA4oCmsCvNmrsotdikD3/oQO5y00c53pE=;
        b=QDjSdwVhwSC0JWfWLJhp/h9DdZY9n0KxIP8OCUJAgh30ovPE8RBv1vHr+hVbVE0tME
         iJD/yM8B0njK1VSHughXZlw5SQkhpbffxcCOWITVKsRI0dqS8/ILGqUXSDE6L6GQObAB
         8Spdl/ikovaOjEkQ7UyA0Glo6fnrOJKKEAP/gqHenduF5Lu0WFI9N0bTzyfpDg3zfBV2
         IRnoDoHGZNoLlHtk2Azb1de+77SEAhw9DcNfUSfk+GVqyQLuuShl+xT1Ca29rp3J6LGC
         y80VJ4sumAssPPDxX3/qBR8wbdfQ+PliuJhcYWI5xzyfTw1IL0YY22z+NQybKAWp1Wdy
         emHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M59q7a9C0OgA4oCmsCvNmrsotdikD3/oQO5y00c53pE=;
        b=OqejqXKR2Btm1eTSswEz+ntVUVN002t/R6PIbFviDA8rDmBsMfnOqN1irwdOo3hjLk
         YCQJmYJPPmSSliIOEzh3BExrQKzDWEeiUZ8AayTQPl8freFcAAWECvbqNSjxLkdTQxQH
         4kBGov1jEAb74kfS/wwJFKQ6ZC0kK+QCpj9Tek0yKgWE5jmyg2HTCo2Z5ljF7rAOuRYV
         CGtjMwbu5cewKg1OpkImqfETsVT4bRSnps0DURCtaijdt2vXKKxSPkUdDmLC/DiX+kCY
         LzDHJlA+CWX3ZvLndruQAhUAB/FTET9F+bvfxQ79i8N6bJpAMb6VP2lEpy23OeWbbf4U
         8qSQ==
X-Gm-Message-State: APjAAAUKB0TO2VE+TYCtmu/wgTBKNDFG/DLwK/HVpgBXIRZMFh15wFHX
        891On3Yw/5kr2uKORTWgdzQPvF5k2OXAXMhuJaY=
X-Google-Smtp-Source: APXvYqxGOxFAMF/DGekSaTRLTT9JUI7FrVcOqmXscMrke5xrFR1FwSh6E7g1AZnXqZ7em90pHobqgkjM7M2X9uVhFI0=
X-Received: by 2002:a2e:b4a8:: with SMTP id q8mr5095902ljm.106.1571383954846;
 Fri, 18 Oct 2019 00:32:34 -0700 (PDT)
MIME-Version: 1.0
References: <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A22E@ALPMBAPA12.e2k.ad.ge.com>
 <20191004182711.GC6945@linux.intel.com> <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A38B@ALPMBAPA12.e2k.ad.ge.com>
 <20191007000520.GA17116@linux.intel.com> <59b88042-9c56-c891-f75e-7c0719eb5ff9@linux.ibm.com>
 <20191008234935.GA13926@linux.intel.com> <20191008235339.GB13926@linux.intel.com>
 <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2B995@ALPMBAPA12.e2k.ad.ge.com>
 <20191014190033.GA15552@linux.intel.com> <1571081397.3728.9.camel@HansenPartnership.com>
 <20191016110031.GE10184@linux.intel.com> <1571229252.3477.7.camel@HansenPartnership.com>
In-Reply-To: <1571229252.3477.7.camel@HansenPartnership.com>
From:   Janne Karhunen <janne.karhunen@gmail.com>
Date:   Fri, 18 Oct 2019 10:32:23 +0300
Message-ID: <CAE=NcrbSrqNUF_Jhe4cL=BSmY=p45nS8axkSJC6HWeGo2NnXDA@mail.gmail.com>
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "Safford, David (GE Global Research, US)" <david.safford@ge.com>,
        Ken Goldman <kgold@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 16, 2019 at 6:35 PM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:

> > The documentation says that krng is suitable for key generation.
> > Should the documentation changed to state that it is unsuitable?
>
> How do you get that from the argument above?  The krng is about the
> best we have in terms of unpredictable key generation, so of course it
> is suitable ... provided you give the entropy enough time to have
> sufficient entropy.

Yes, so it can be both the safest and the least safe option available.
By default it's the worst one, but use it wisely and it can be the
best source. Hence I was proposing that kconfig option + boot time
printout to make this clear for everyone..


--
Janne
