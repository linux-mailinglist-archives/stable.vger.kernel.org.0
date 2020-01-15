Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 589AC13CCEA
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 20:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgAOTPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 14:15:40 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38031 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgAOTPk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 14:15:40 -0500
Received: by mail-ed1-f65.google.com with SMTP id i16so16563355edr.5;
        Wed, 15 Jan 2020 11:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Pdl37Qz7EAhdxR6KKQ4/2S/Fy6hVZh69tt7hp8EWDcc=;
        b=mEF+LCTmrBm4nq9IL8pT1qrPQGMBoS/tnyLEXFCZe6gCM7dzcMeWIrTNWubUBiSepV
         d3TrIkT4kDEuDiV1rTQv6QaU5+nX/vpZpVQsC5LYcOvPkHIf3urKcUxIGG13zC5oZxt3
         uD/yqCKIuKPAGgmoUWTbpgaIhe+LMUYVzzE8dXRQpMWlsZjlx6i4HbCElxp9OdJDKY91
         cAN6ZqutZHNCvesMgmnFgTCTmL7swRVZswgSjMbsPTU9tGk4AT4DsQ1WliSdBv9Rxga2
         EJAqqac11yoD96+pybh3vj1Xvehq6JoRZTbIlTbooaHe7+PK7wOVprUoL6YEitSgUVVn
         sZ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=Pdl37Qz7EAhdxR6KKQ4/2S/Fy6hVZh69tt7hp8EWDcc=;
        b=g9Dx24EKBkmc5DT4WXdo+LXUB9mqs4eiOYtHb+43zzoWMhjD+lK2z7PFQqBm8C3IgF
         xkToTHqb54IhHeEa+wUVkDoQo/cDu2A0CDsIjs8GyGox+a1IpTIbQSiI3JM7jWm0n4g+
         +INjV12DlxNcAEWXl0u+4+Myfgc7SoWljKWout06jSXhbz4znX43+5HPzL7Hp+sbCd+V
         GCMXLGwzkiIYL6dr8P5UH9dOoPB40MR1Dh9kd8SPOd8sYQICdiUaIV4jWbKPwjmxJ2Ty
         Ca9xOApM1cX758f17OTveKHZ3Tkn6nP7i+C4E1wdKP6YcYI7kG5RNgt2iv3T4IMmY4wH
         DOJw==
X-Gm-Message-State: APjAAAXefkfn1i2M/XZZkBwpg+YdtEcH0cHhoqh6JeWljdT1F/J4dG5U
        ZgIFh9TuJPI4PFFvWwmJTwsaKJl23XiYVddTEgs=
X-Google-Smtp-Source: APXvYqybopPT15MnRkh9zzxB44thyvq+8Q959ryLnsHzNCVc/rICNwFvOTNzElR0+en9sZB6NsufSIHQojK93gIi1Hs=
X-Received: by 2002:a05:6402:3059:: with SMTP id bu25mr32378646edb.216.1579115738217;
 Wed, 15 Jan 2020 11:15:38 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6402:1c11:0:0:0:0 with HTTP; Wed, 15 Jan 2020 11:15:37
 -0800 (PST)
In-Reply-To: <5C216684-6FDF-41B5-9F51-89DC295F6DDC@amacapital.net>
References: <CACMCwJLJCA2iXS0QMKKAWQv252oUcmfsNvwDNP5+4Z_9VB-rTg@mail.gmail.com>
 <5C216684-6FDF-41B5-9F51-89DC295F6DDC@amacapital.net>
From:   Jari Ruusu <jari.ruusu@gmail.com>
Date:   Wed, 15 Jan 2020 21:15:37 +0200
Message-ID: <CACMCwJLogOH-nG7QEMzrXK-iJPOdzCrL05y0a6yAbtPsfdRjsQ@mail.gmail.com>
Subject: Re: Fix built-in early-load Intel microcode alignment
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        johannes.berg@intel.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Lutomirski <luto@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/15/20, Andy Lutomirski <luto@amacapital.net> wrote:
> Hard lockup when loaded or hard lockup after loading?

No problem at microcode load time.
Hard lockup after 1-2 days of use.

-- 
Jari Ruusu  4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD  ACDF F073 3C80 8132 F189
