Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEE4366703
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 10:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbhDUIbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 04:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235103AbhDUIbj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 04:31:39 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28439C06138B
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 01:31:05 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id u187so2199074wmb.0
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 01:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mJcwZlu0Ar0OqbJ+UZHBMNI1VVtXFf5qDweduy1D6/0=;
        b=o024ty8UnwIIrWAXLRcFarFxMWg7aB5MoAF8/o0gVibbG8v/5/bOJSDD6mISRw2/3t
         RISq8FAaPPdXjtCkc80AWVZZhVMXSS9ePy/0e42mO8s65dFlUpQtGRxAzzUexbPHTd6M
         E93/bEHx+TF1PTCdAkNCXbq6Pp+HRcW0ij6FCmQkFFbVoW6lQ++b5RuvNMMe+wNz/h3/
         PbB7VRCpoGtVwhW/m+6VhBrAkJDqFoDnHmnr+0FTaBBaq8a72TaQ7IaFKCSmpQlYp9Pq
         v0kVNof5TCP9ajsRScnrw6YgYHN4D5Xa6TM1a1Qiz3aZsJ+jjQlgmTFShG0WApO6GR58
         GRaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mJcwZlu0Ar0OqbJ+UZHBMNI1VVtXFf5qDweduy1D6/0=;
        b=hkCQZX5BOU5SMeYTCPV+hrolPI9kvLikkwvFEsQsIJjGMfyFFUYB+rkH8yX5wOg3cR
         7oXJIOI2juLtLZ557yQiGoPETAdIAClKbILfl1D6zvZpa51anhD0G6z17R9shIHv5ar7
         UtdoIJybhnXZtQHJDRFMZuzk6Wjc8lVWiahFKurkCQsowf+MOirnOOmlOdvVWRRleu2F
         5x32NvDIQ5SPmBZ9GD4OocHdTdFEJ1om+3tFgo5Z8hd0w345kN+Cnyeyp4msbz3y/Tzp
         4olmPb8eWG1Xt2UOFBIg8HY86I/bGMC4dgkpxqky2Va54LtaIgDpXFkV97W0gEU0gy/f
         NtcQ==
X-Gm-Message-State: AOAM533YGTUJw/MY1E3tHROP2KHYDqJmqtbNG6ZEzxOgJw4TqjrA6yJi
        C8EXLyA32GUERBb1lC30XBFIGuIgjcRjCQ==
X-Google-Smtp-Source: ABdhPJwEGruRSdnWTaFzBtUIiMhSy7VtcwIGQ/9y41wbzN7dfUybADZ1XDSeTl9FBzz3Ugj+bZUM4A==
X-Received: by 2002:a1c:b3c5:: with SMTP id c188mr2432123wmf.168.1618993863536;
        Wed, 21 Apr 2021 01:31:03 -0700 (PDT)
Received: from google.com (105.168.195.35.bc.googleusercontent.com. [35.195.168.105])
        by smtp.gmail.com with ESMTPSA id g5sm2156525wrq.30.2021.04.21.01.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 01:31:02 -0700 (PDT)
Date:   Wed, 21 Apr 2021 08:31:00 +0000
From:   Quentin Perret <qperret@google.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Alexandre TORGUE <alexandre.torgue@foss.st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Boichat <drinkcat@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        Android Kernel Team <kernel-team@android.com>,
        Architecture Mailman List <boot-architecture@lists.linaro.org>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [v5.4 stable] arm: stm32: Regression observed on "no-map"
 reserved memory region
Message-ID: <YH/ixPnHMxNo08mJ@google.com>
References: <4a4734d6-49df-677b-71d3-b926c44d89a9@foss.st.com>
 <CAL_JsqKGG8E9Y53+az+5qAOOGiZRAA-aD-1tKB-hcOp+m3CJYw@mail.gmail.com>
 <001f8550-b625-17d2-85a6-98a483557c70@foss.st.com>
 <CAL_Jsq+LUPZFhXd+j-xM67rZB=pvEvZM+1sfckip0Lqq02PkZQ@mail.gmail.com>
 <CAMj1kXE2Mgr9CsAMnKXff+96xhDaE5OLeNhypHvpN815vZGZhQ@mail.gmail.com>
 <d7f9607a-9fcb-7ba2-6e39-03030da2deb0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7f9607a-9fcb-7ba2-6e39-03030da2deb0@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday 20 Apr 2021 at 09:33:56 (-0700), Florian Fainelli wrote:
> I do wonder as well, we have a 32MB "no-map" reserved memory region on
> our platforms located at 0xfe000000. Without the offending commit,
> /proc/iomem looks like this:
> 
> 40000000-fdffefff : System RAM
>   40008000-40ffffff : Kernel code
>   41e00000-41ef1d77 : Kernel data
> 100000000-13fffffff : System RAM
> 
> and with the patch applied, we have this:
> 
> 40000000-fdffefff : System RAM
>   40008000-40ffffff : Kernel code
>   41e00000-41ef3db7 : Kernel data
> fdfff000-ffffffff : System RAM
> 100000000-13fffffff : System RAM
> 
> so we can now see that the region 0xfe000000 - 0xfffffff is also cobbled
> up with the preceding region which is a mailbox between Linux and the
> secure monitor at 0xfdfff000 and of size 4KB. It seems like there is
> 
> The memblock=debug outputs is also different:
> 
> [    0.000000] MEMBLOCK configuration:
> [    0.000000]  memory size = 0xfdfff000 reserved size = 0x7ce4d20d
> [    0.000000]  memory.cnt  = 0x2
> [    0.000000]  memory[0x0]     [0x00000040000000-0x000000fdffefff],
> 0xbdfff000 bytes flags: 0x0
> [    0.000000]  memory[0x1]     [0x00000100000000-0x0000013fffffff],
> 0x40000000 bytes flags: 0x0
> [    0.000000]  reserved.cnt  = 0x6
> [    0.000000]  reserved[0x0]   [0x00000040003000-0x0000004000e494],
> 0xb495 bytes flags: 0x0
> [    0.000000]  reserved[0x1]   [0x00000040200000-0x00000041ef1d77],
> 0x1cf1d78 bytes flags: 0x0
> [    0.000000]  reserved[0x2]   [0x00000045000000-0x000000450fffff],
> 0x100000 bytes flags: 0x0
> [    0.000000]  reserved[0x3]   [0x00000047000000-0x0000004704ffff],
> 0x50000 bytes flags: 0x0
> [    0.000000]  reserved[0x4]   [0x000000c2c00000-0x000000fdbfffff],
> 0x3b000000 bytes flags: 0x0
> [    0.000000]  reserved[0x5]   [0x00000100000000-0x0000013fffffff],
> 0x40000000 bytes flags: 0x0
> 
> [    0.000000] MEMBLOCK configuration:
> [    0.000000]  memory size = 0x100000000 reserved size = 0x7ca4f24d
> [    0.000000]  memory.cnt  = 0x3
> [    0.000000]  memory[0x0]     [0x00000040000000-0x000000fdffefff],
> 0xbdfff000 bytes flags: 0x0
> [    0.000000]  memory[0x1]     [0x000000fdfff000-0x000000ffffffff],
> 0x2001000 bytes flags: 0x4
> [    0.000000]  memory[0x2]     [0x00000100000000-0x0000013fffffff],
> 0x40000000 bytes flags: 0x0
> [    0.000000]  reserved.cnt  = 0x6
> [    0.000000]  reserved[0x0]   [0x00000040003000-0x0000004000e494],
> 0xb495 bytes flags: 0x0
> [    0.000000]  reserved[0x1]   [0x00000040200000-0x00000041ef3db7],
> 0x1cf3db8 bytes flags: 0x0
> [    0.000000]  reserved[0x2]   [0x00000045000000-0x000000450fffff],
> 0x100000 bytes flags: 0x0
> [    0.000000]  reserved[0x3]   [0x00000047000000-0x0000004704ffff],
> 0x50000 bytes flags: 0x0
> [    0.000000]  reserved[0x4]   [0x000000c3000000-0x000000fdbfffff],
> 0x3ac00000 bytes flags: 0x0
> [    0.000000]  reserved[0x5]   [0x00000100000000-0x0000013fffffff],
> 0x40000000 bytes flags: 0x0
> 
> in the second case we can clearly see that the 32MB no-map region is now
> considered as usable RAM.
> 
> Hope this helps.
> 
> > 
> > In any case, the mere fact that this causes a regression should be
> > sufficient justification to revert/withdraw it from v5.4, as I don't
> > see a reason why it was merged there in the first place. (It has no
> > fixes tag or cc:stable)
> 
> Agreed, however that means we still need to find out whether a more
> recent kernel is also broken, I should be able to tell you that a little
> later.

FWIW I did test this on Qemu before posting. With 5.12-rc8 and a 1MiB
no-map region at 0x80000000, I have the following:

40000000-7fffffff : System RAM
  40210000-417fffff : Kernel code
  41800000-41daffff : reserved
  41db0000-4210ffff : Kernel data
  48000000-48008fff : reserved
80000000-800fffff : reserved
80100000-13fffffff : System RAM
  fa000000-ffffffff : reserved
  13b000000-13f5fffff : reserved
  13f6de000-13f77dfff : reserved
  13f77e000-13f77efff : reserved
  13f77f000-13f7dafff : reserved
  13f7dd000-13f7defff : reserved
  13f7df000-13f7dffff : reserved
  13f7e0000-13f7f3fff : reserved
  13f7f4000-13f7fdfff : reserved
  13f7fe000-13fffffff : reserved

If I remove the 'no-map' qualifier from DT, I get this:

40000000-13fffffff : System RAM
  40210000-417fffff : Kernel code
  41800000-41daffff : reserved
  41db0000-4210ffff : Kernel data
  48000000-48008fff : reserved
  80000000-800fffff : reserved
  fa000000-ffffffff : reserved
  13b000000-13f5fffff : reserved
  13f6de000-13f77dfff : reserved
  13f77e000-13f77efff : reserved
  13f77f000-13f7dafff : reserved
  13f7dd000-13f7defff : reserved
  13f7df000-13f7dffff : reserved
  13f7e0000-13f7f3fff : reserved
  13f7f4000-13f7fdfff : reserved
  13f7fe000-13fffffff : reserved

So this does seem to be working fine on my setup. I'll try again with
5.4 to see if I can repro.

Also, 8a5a75e5e9e5 ("of/fdt: Make sure no-map does not remove already
reserved regions") looks more likely to cause the issue observed here,
but that shouldn't be silent. I get the following error message in dmesg
if I if place the no-map region on top of the kernel image:

OF: fdt: Reserved memory: failed to reserve memory for node 'foobar@40210000': base 0x0000000040210000, size 1 MiB

Is that triggering on your end?

Thanks,
Quentin
