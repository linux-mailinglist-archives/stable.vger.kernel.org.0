Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2358D139A6C
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 20:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgAMT62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 14:58:28 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39133 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbgAMT61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 14:58:27 -0500
Received: by mail-ed1-f68.google.com with SMTP id t17so9679062eds.6;
        Mon, 13 Jan 2020 11:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=qzvxwRh5Bt8QIXGD6Pm0HD5kXY1LbZYZZfaSaPRE2KA=;
        b=nvMErXvQlXROM/PWEKtlHWv4GFQQztu7nGnFZt4n9PZwykpCnXBUITFV8TlpBIjuOw
         CcR6qPMb4QQ7wtIasMJLlPsR2MnII4VBBLyYJOafh1p92Mwxm8u5m+rkhRQYg2Wh0Bxi
         Rph+BY/1ulVB8uY/dNwLgjegfrpEqiite8LDDxY99XavLLKJlDU4OmMlyw0ktpnk6mF3
         NyiDs14tIs2xleldSB9awdcE9+J7joD0/rJt4JPlJVSwo+UuyIcFCj+e5adqq4/X69cF
         Jba+YLDe0z0qphggVfD9K6CggLTLyOyNnq2+daJ62uEQAebZefBaEVXJyA2vyGxIBqcb
         w3uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=qzvxwRh5Bt8QIXGD6Pm0HD5kXY1LbZYZZfaSaPRE2KA=;
        b=Jhn3A8coCQzlMieOb9qH/3qZHxAMavkTYeEt4QyFRe5vLUhFwm/MePuIjXReCk+EjH
         tWJ1wqEb7ixW8FVHk7q6W3xAZEVZinPBHfNV589p+b9M7qXzo3WVTRX/F0CVfjgq5wm0
         lRaugJLSLNadcifV3FJJxWp+LAreKxLFyh4Pmr0IVgzHKIrSST38/0k3wLh7T7V2435o
         MlgEHo6UxUjK/dprKdJFW/scWLnrs73WgGll9P0hvq/tk9fZQue+R2+mWGZseb+IIyMU
         vhVpvkBHBHX5TBPNd27vKKOIWOumbGfCLuQUTdHpt4PNnOcrK0+qx1hTdGC71V0aUBVk
         PW1A==
X-Gm-Message-State: APjAAAUANgNWlKQsWgd/UxLyrmscqpk80aFxaaoQ+9DWkW+RXxAvY2Rw
        b8w6UNkdpTt3KTEt3IOXBGEY0gNkCDXXVYO0KSJmE6DtSAM=
X-Google-Smtp-Source: APXvYqzG4Jzi2rCD0qnvrCHtjmGAdgxjMnoUPj2xTS4RUgj4upPABXQprKbNOq5gSwROsDw7R5yWGk8gVdBkBL7zYqQ=
X-Received: by 2002:a17:906:1b07:: with SMTP id o7mr18514714ejg.131.1578945505894;
 Mon, 13 Jan 2020 11:58:25 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6402:1c11:0:0:0:0 with HTTP; Mon, 13 Jan 2020 11:58:25
 -0800 (PST)
In-Reply-To: <20200113154739.GB11244@42.do-not-panic.com>
References: <CACMCwJK-2DHZDA_F5Z3wsEUEKJSc3uOwwPD4HRoYGW7A+kA75w@mail.gmail.com>
 <20200113154739.GB11244@42.do-not-panic.com>
From:   Jari Ruusu <jari.ruusu@gmail.com>
Date:   Mon, 13 Jan 2020 21:58:25 +0200
Message-ID: <CACMCwJL8tu+GHPeRADR_12xhcYSiDv+Yxdy=yLqMxEsn=P9zFA@mail.gmail.com>
Subject: Re: Fix built-in early-load Intel microcode alignment
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        johannes.berg@intel.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/13/20, Luis Chamberlain <mcgrof@kernel.org> wrote:
> So what happens with you use the built-in firmware loader for
> the Intel microcode at this time? I am surprised this issue
> wasn't reported earlier, so thanks for picking it up, but to
> be complete such a change requires a bit more information.
>
> What exactly happens now?

Before that 16-byte alignment patch was applied, my only one
microcode built-in BLOB was "accidentally" 16-byte aligned.

After that patch was applied, new kernel System.map file was
exactly same. So, for me that patch did not change anything.

Same 16-byte alignment before and after patch:

$  grep " _fw_.*_bin" System.map
ffffffff81f55e90 r _fw_intel_ucode_06_8e_09_bin

>> Fix this by forcing all built-in firmware BLOBs to 16-byte
>> alignment.
>
> That's a huge stretch, see below.

I understand and to some degree agree.

> So I'd like to determine first if we really need this.

We do need it. Violating Intel specs is not good. It may be that
some processor models require aligned and some accept less
aligned.

> If set as a global new config option, we can use the same logic and
> allow an architecture override if the user / architecture kconfig
> configures it such:
>
> config ARCH_DEFAULT_FIRMWARE_ALIGNMENT
> 	string "Default architecture firmware aligmnent"
> 	"4" if 64BIT
> 	"3" if !64BIT
>
> config FIRMWARE_BUILTIN_ALIGN
> 	string "Built in firmware aligment requirement"
> 	default ARCH_DEFAULT_FIRMWARE_ALIGNMENT if !ARCH_CUSTOM_FIRMWARE_ALIGNMENT
> 	default ARCH_CUSTOM_FIRMWARE_ALIGNMENT_VAL if
> ARCH_CUSTOM_FIRMWARE_ALIGNMENT
> 	  Some good description goes here
>
> Or something like that.

It doesn't have to user visible config option, only default align
changed when selected set of options are enabled.

My patch was intentionally minimal, without #ifdef spaghetti.

-- 
Jari Ruusu  4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD  ACDF F073 3C80 8132 F189
