Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 664CCD0967
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 10:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbfJIIR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 04:17:27 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55992 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfJIIR1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 04:17:27 -0400
Received: by mail-wm1-f66.google.com with SMTP id a6so1380693wma.5
        for <stable@vger.kernel.org>; Wed, 09 Oct 2019 01:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DrMVnrzn3+u79252XdcGLAzKToAZt3nyGYegK0vJhik=;
        b=y8Zgp6LEz/kNThe/rhWBYfXVy5Mv1tq5f2gvRQqHiSglOxQ41iOMGW8J9VoK6j9ZOc
         cppNw5aQ6UzApaevRQPOdavNQtAbahw4DXV+2td7nkKpe3JqTar6U2VKHy5ad4anudCH
         A4G6urORYLjst9s9qQkn9m1xL2C2gXRa9DsJszSAtfay88+zkO6PJgaL0+TlMnUr6MRX
         QNNoteP1FfGlmmX9dnk7MsW8RcYZ+e5hjeBnrqB9SfiKtLdIfW05oOoIa2f8PuKPWiHM
         kD+bgdKHUE6ohaqygWB6iSus7Gqlr7U2ChVtnKzNQFZccFHOG4FECeXXEMBgVqkl7RsM
         +l4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DrMVnrzn3+u79252XdcGLAzKToAZt3nyGYegK0vJhik=;
        b=hwKTj5rqCjG1xZhu9PsdX0MXKXbrGfWQvn4mCgDx4hVPXIaNAlYLrwrzbm98+pxFNH
         2nPti1D+bVrOeNsbROgGGshL41x+ShOliD0x5mS02ABbwG7R9LooctM9TLBt/t++rE4T
         auwo8Il1ikGH+oIU9SyLcTMOzTnqEulS2TAn91I3dSAZxofeacv+cuOmqNC72s4yxi2/
         MI5WMvWyCxkTvyw+1bQI2P5Y68j6WNMoB3EcnuRdj8vFBB8UoV4BWr//e1fk/Z+DWjm0
         hLKP8oBqHklu8o6ETXNysDGAIA98XMg4ojAh5F18gerjxIHGfjig3LjEa9hlpOBBlSSE
         4T3A==
X-Gm-Message-State: APjAAAUmOHIPofzC5QynlDir663ropHZtYcJjlhqtPCUQ//HTUfubRt9
        Svseor/AygNJFu5IZ3IOuhQy4VgjRiSUv+U5Z6YYN1De4O2ziA==
X-Google-Smtp-Source: APXvYqwR/fyWhVugqsvHQCRzkO9pQZmrY4GFCJqImVp02eh/4BQCz+w3KuDBOm45Tun6AsbjiM2T2yIrM3mJ9O4eeoY=
X-Received: by 2002:a7b:cb54:: with SMTP id v20mr1488828wmj.119.1570609045190;
 Wed, 09 Oct 2019 01:17:25 -0700 (PDT)
MIME-Version: 1.0
References: <20191008153930.15386-1-ard.biesheuvel@linaro.org> <20191009080422.GA3881278@kroah.com>
In-Reply-To: <20191009080422.GA3881278@kroah.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 9 Oct 2019 10:17:12 +0200
Message-ID: <CAKv+Gu-t9Dzn-LqZKXVUFjsC14RNz3qz1E1sFunC73ji9QGHXQ@mail.gmail.com>
Subject: Re: [PATCH for-stable-v4.19 00/16] arm64 spec mitigation backports
To:     Greg KH <greg@kroah.com>
Cc:     linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        stable <stable@vger.kernel.org>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 9 Oct 2019 at 10:04, Greg KH <greg@kroah.com> wrote:
>
> On Tue, Oct 08, 2019 at 05:39:14PM +0200, Ard Biesheuvel wrote:
> > This is a backport to v4.19 of the arm64 patches that exists in mainline
> > to support CPUs that implement the SSBS capability, which gives the OS
> > and user space control over whether Speculative Store Bypass is
> > permitted in certain contexts. This gives a substantial performance
> > boost on hardware that implements it.
> >
> > At the same time, this series backports arm64 support for reporting
> > of vulnerabilities via syfs. This is covered by the same series since
> > it produces a much cleaner backport, where none of the patches required
> > any changes beyond some manual mangling of the context to make them apply.
> >
> > Build tested using a fair number of randconfig builds. Boot tested
> > under KVM and on ThunderX2.
>
> All now queued up, thanks.
>

Thanks Greg.
