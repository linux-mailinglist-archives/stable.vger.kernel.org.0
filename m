Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBA71406CA
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 10:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgAQJrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 04:47:35 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38609 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbgAQJrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 04:47:35 -0500
Received: by mail-ed1-f66.google.com with SMTP id i16so21677783edr.5;
        Fri, 17 Jan 2020 01:47:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=M2H04oFMQClOJRF53bzNbKYuXDn11Q5ncPxXvQj1eI0=;
        b=QTgyBAbtBdrf/arF2vRIshn7dzjpjf3Lw2KHZv1s31zsyKOYBy73upjsFEIz25eKHZ
         kVUqolz5KcwW265CLz4RuIifEq5A7Maxtbn2Xt/uEWBgHJyxAiThbLoFZxv8vOv95/i/
         pP3+4GeSnswYWUqfJlnmnO4xIauXkmYcqSx6dtLvxhIW16BhSd9TPqbdF9+tZXwAg9C8
         GAzSgMaK49rMR0vRWjXo7xGOjT12IF49Kr1S9cwTpkcpH6H3yLxbOjsXzZbdQr5DriA3
         prvE7uT1/GQkj8Uu/j6sOqQPO7MYU6oAuxMIem0uvHRD25XeO/5HACLITa2EVE0IBf6E
         F5xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=M2H04oFMQClOJRF53bzNbKYuXDn11Q5ncPxXvQj1eI0=;
        b=SL5B4TVTOVAK653vKBLTRj92N0mPIGQT3RHqS58jCR1rmL1nVQLUXTiDfO5ij6f04A
         6+2Isf7yP402nnsvouWNoi//BXMKpF37FouuYd0/IH0R1H45EYKWZjyBdAxHhiq/isi5
         TJnLPU4t2gjNmHSyg6920qwPnty32TqBekmYg/5okH+VNInRtCFguIGAquZ/tOfHA2nX
         YvEmRrw5dy+eXifwopC0oGJItiiQFYERNyNU8MUK9oQrDNewhdnu/mPkZL7JmOK20gWR
         cgqyaoueNqrb2smfjSafE+3atVpcWjGLdGiq5fZM0lu6XuLbKig6o2Hd+HFXr5amjdXh
         MGsQ==
X-Gm-Message-State: APjAAAVA/jv5G0JohZF7+UtcaSQUdjQb6ucZsYhFKN0GNHja4MuZduyu
        V4GLGi3c79S+WOZpceD9anU89k6hbVjucsmliZA=
X-Google-Smtp-Source: APXvYqxcszSOGk1df4pS/p/jWmCxduCkNXzBykj+PzGBGPgkrJrFcBop5OGwYK+qY92vUixz8zZM/mtEdjvUTBO/6lU=
X-Received: by 2002:aa7:d450:: with SMTP id q16mr2707757edr.169.1579254453401;
 Fri, 17 Jan 2020 01:47:33 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6402:1c11:0:0:0:0 with HTTP; Fri, 17 Jan 2020 01:47:32
 -0800 (PST)
In-Reply-To: <20200116191632.GB117689@otc-nc-03>
References: <CACMCwJLJCA2iXS0QMKKAWQv252oUcmfsNvwDNP5+4Z_9VB-rTg@mail.gmail.com>
 <5C216684-6FDF-41B5-9F51-89DC295F6DDC@amacapital.net> <CACMCwJLogOH-nG7QEMzrXK-iJPOdzCrL05y0a6yAbtPsfdRjsQ@mail.gmail.com>
 <CAHk-=wiqPHc=BzSYO4N=awucq0td3s9VuBkct=m-B_xZVCgzBg@mail.gmail.com>
 <CACMCwJL+kdkJRfRhG6bt_ojU0UeipqxVL3vwS3ETqVEjnWL1ew@mail.gmail.com> <20200116191632.GB117689@otc-nc-03>
From:   Jari Ruusu <jari.ruusu@gmail.com>
Date:   Fri, 17 Jan 2020 11:47:32 +0200
Message-ID: <CACMCwJLTWi=8yyhdxjsnwtqc_M7K4fPaJtB9PRiq_sz_q0R3UA@mail.gmail.com>
Subject: Re: Fix built-in early-load Intel microcode alignment
To:     "Raj, Ashok" <ashok.raj@intel.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Fenghua Yu <fenghua.yu@intel.com>, johannes.berg@intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Lutomirski <luto@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/16/20, Raj, Ashok <ashok.raj@intel.com> wrote:
> I don't suspect the alignment issue during microcode load to trigger
> any hangs after couple days.

Microcode was properly aligned when it was loaded to CPU.

> Can you please also document the OEM, BIOS versions, and also both the
> old and new microcode versions after the update.
>
> Would suggest logging the hang issue in public github for microcode issues.
> This would let the product folks look at them.
>
> https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files

I opened issue there.

https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files/issues/23

-- 
Jari Ruusu  4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD  ACDF F073 3C80 8132 F189
