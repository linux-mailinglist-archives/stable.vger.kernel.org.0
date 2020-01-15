Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7A013CC72
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 19:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbgAOSqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 13:46:07 -0500
Received: from mail-ed1-f54.google.com ([209.85.208.54]:41063 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729019AbgAOSqH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 13:46:07 -0500
Received: by mail-ed1-f54.google.com with SMTP id c26so16452348eds.8;
        Wed, 15 Jan 2020 10:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=a0rRgPi8qpuxt+ikgqB/GgY+ZCw2HyoB33EFPqTmGV4=;
        b=X/z2KUJ/PVOccJqrqDgc8Ho50bVKHqCmWXiyKWMO0GB8bEVtnr57Rus0FXR0qp4skq
         UVfAY7ua5eLk5nyP2gHgiy7HzXQeA2n8WBB+f4h7bGxYd10PhSv10EMMwORupjL6bTyM
         32wRNV1rWftXKtBg9nM7fcqG72tBetWrR2YQVo/7OLOrhV3ul0nNG503lTuw1F1lk2Ty
         91CmxxcbAfhKWOBY66XIhS6exFJovVg3rSJbszhr1NYVCNBBunWdApIkgIY/L8XtjX1U
         Ggcdrjf1gYxQ0Uh8xy0JWjpg4YrAO9gOH4DVLjwBocof5Pxqvalb8oqVeUXIS2GRS+OZ
         Hcgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=a0rRgPi8qpuxt+ikgqB/GgY+ZCw2HyoB33EFPqTmGV4=;
        b=TTS5fDcgOGG9uRONQV1GptXQ/AqD8VUM/ha/NygYKK0DkJfGKGgAL8/rHaiUW7m2t2
         YLRLuPaBwK1LT2W+lNBuog3fK6i3l1Q2FDfXEYxPcSCmcXsYz2Z8c+tbrzss4JVZCVlA
         YfcX19kvtCwuXaAm80z6mQebgT80bVgrh+Mf4CveoVa0EZ16M+pBY2Nvvc3Mx92voeoE
         JTKaU6qCPQ/tQ3rAladTr+8DYGLKbGL9NkaCH+y74xN2E3vYvoSNMLpl6X62leUMSnW/
         Y6yji9q753HPMepi+2QnbeCcmppagGKVomam7QZsug9I2KePYRPdzgzr5zj3WcMz3ZML
         4ZDA==
X-Gm-Message-State: APjAAAVW434GXR3GPnolOFw/u2DTqzBuR7StBwKKowNgZfww0oDXkLTc
        cbLUW2154FDeEERznSt6bscd83BeGhJTFkuu8mzg6xhr
X-Google-Smtp-Source: APXvYqyTrgWJ1LIzmTrqXapfgFa2R1OYqAfeJV6bZihFAyHMRXUZ3QYJpptivIqDltyoLS2yqDeHHxJCHpHlURPmTuI=
X-Received: by 2002:a17:906:b797:: with SMTP id dt23mr29845299ejb.241.1579113965153;
 Wed, 15 Jan 2020 10:46:05 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6402:1c11:0:0:0:0 with HTTP; Wed, 15 Jan 2020 10:46:04
 -0800 (PST)
In-Reply-To: <20200115021545.GD11244@42.do-not-panic.com>
References: <CACMCwJK-2DHZDA_F5Z3wsEUEKJSc3uOwwPD4HRoYGW7A+kA75w@mail.gmail.com>
 <20200113154739.GB11244@42.do-not-panic.com> <CACMCwJL8tu+GHPeRADR_12xhcYSiDv+Yxdy=yLqMxEsn=P9zFA@mail.gmail.com>
 <20200115021545.GD11244@42.do-not-panic.com>
From:   Jari Ruusu <jari.ruusu@gmail.com>
Date:   Wed, 15 Jan 2020 20:46:04 +0200
Message-ID: <CACMCwJLJCA2iXS0QMKKAWQv252oUcmfsNvwDNP5+4Z_9VB-rTg@mail.gmail.com>
Subject: Re: Fix built-in early-load Intel microcode alignment
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        johannes.berg@intel.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Lutomirski <luto@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/15/20, Luis Chamberlain <mcgrof@kernel.org> wrote:
> On Mon, Jan 13, 2020 at 09:58:25PM +0200, Jari Ruusu wrote:
>> Before that 16-byte alignment patch was applied, my only one
>> microcode built-in BLOB was "accidentally" 16-byte aligned.
>
> How did it accidentially get 16-byte aligned?

Old code aligned it to 8-bytes.
There is 50/50-chance of it also being 16-byte aligned.
So it ended up being both 8-byte and 16-byte aligned.

> Also, how do you *know* something is broken right now?

I haven't spotted brokenness in Linux microcode loader other
than that small alignment issue.

However, I can confirm that there are 2 microcode updates newer
than what my laptop computer's latest BIOS includes. Both newer
ones (20191115 and 20191112) are unstable on my laptop computer
i5-7200U (fam 6 model 142 step 9 pf 0x80). Hard lockups with both
of them. Back to BIOS microcode for now.

-- 
Jari Ruusu  4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD  ACDF F073 3C80 8132 F189
