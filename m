Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B245CAFCE
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 22:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730803AbfJCULu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 16:11:50 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40531 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730768AbfJCULu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 16:11:50 -0400
Received: by mail-ed1-f65.google.com with SMTP id v38so3776922edm.7
        for <stable@vger.kernel.org>; Thu, 03 Oct 2019 13:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=eDMhB0Tt2U7BO+EvWGUZPWCUp971OHEktxEGr5vY6LY=;
        b=MW4vDbYa664AVfr3rFl/+pzftvHKWBl3kQnKMya7r7vUXHP2SNjtXeFj1e9vM7LS2V
         sKWEZ4Ru03o2etp74APZ81EfAeCeKPqLzf/QP2GurPgSqOPKzksBotRMC8/bz20X4tna
         4x66c4aDyJEKeK5PYxmtilO6udno56keF5jye+uCxv2ssHjn9V7DZzTy5vYyB8J56aCN
         USBLtxXhzdWLmjkcFyzkv//WEySeuln3RyLCghXakshP0haTrGvmXQ65bAaZcMpTgniV
         ZyLIRoQErokzZ0YP2lJqCC3UPx/kBS78R6BVgpQTQd+9FmF26U79hWthhw2pPcZ8DyNf
         2SJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=eDMhB0Tt2U7BO+EvWGUZPWCUp971OHEktxEGr5vY6LY=;
        b=Exuwt3XR6FAoo2iwUQYlssHxfwiHuvcksWaiA9j5AQxozcRu0rPdtoet03OaY1Pmxy
         uv2Nh8APrfYT57IjdefOpGi9oSdG/e0uy/E+4gwMLYoA6cNUe+H7RavXpuUOHMlCM1Lk
         E63X3jJNK0XCeR0SS59aZgB3TT3U9cbmF10Yi/9tSlofMFh8USkU02sEOdBX0N1DeKWv
         s4uWP28Go1RnP4aK9yJup9HZJKQd6SPL1OFu0rF16Q9ekETgtZXBELX6MVuZ4MBKo5Ce
         saX2ogONZOUpH0kgk/tnuk3SZ2ZZ1ItNhb+roNr94gnrOGJr0AxzCyvO167PuvtSNfTZ
         v2zA==
X-Gm-Message-State: APjAAAXWl7Q7+mvM1y5uyZS+mH33qMSd2YdFVKLVHVKHOS7W6woKS6Jp
        ILatHvAwoVFRaEJ+mZMw2o1TtJpwIHxboA==
X-Google-Smtp-Source: APXvYqyV2XQaBtjcQ8Nz2JwIdhUikRc7vb1zd7qwIM02gu5voNqnh6UYRtumaccSzvvkLl5dbnG/VQ==
X-Received: by 2002:a17:907:11c8:: with SMTP id va8mr9262470ejb.111.1570133508117;
        Thu, 03 Oct 2019 13:11:48 -0700 (PDT)
Received: from [192.168.1.2] (host-109-89-151-97.dynamic.voo.be. [109.89.151.97])
        by smtp.gmail.com with ESMTPSA id m19sm349388eja.35.2019.10.03.13.11.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2019 13:11:47 -0700 (PDT)
Subject: Re: [PATCH 4.19 000/211] 4.19.77-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20191003154447.010950442@linuxfoundation.org>
 <ea824819-1047-e74b-2e71-814c3c2756e9@gmail.com>
 <20191003191016.GB3585751@kroah.com> <20191003192042.GA3587427@kroah.com>
 <20191003200512.GB3590105@kroah.com>
From:   =?UTF-8?Q?Fran=c3=a7ois_Valenduc?= <francoisvalenduc@gmail.com>
Message-ID: <a9398d8d-c5ba-4aa1-4da8-148c34be8931@gmail.com>
Date:   Thu, 3 Oct 2019 22:11:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003200512.GB3590105@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: fr-moderne
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Le 3/10/19 à 22:05, Greg Kroah-Hartman a écrit :
> On Thu, Oct 03, 2019 at 09:20:42PM +0200, Greg Kroah-Hartman wrote:
>> On Thu, Oct 03, 2019 at 09:10:16PM +0200, Greg Kroah-Hartman wrote:
>>> On Thu, Oct 03, 2019 at 09:02:23PM +0200, François Valenduc wrote:
>>>> This does not compile. I get this error:
>>>>
>>>>   CC      drivers/ras/debugfs.o
>>>> drivers/ras/debugfs.c:9:5: error: redefinition of 'ras_userspace_consumers'
>>>>  int ras_userspace_consumers(void)
>>>>      ^~~~~~~~~~~~~~~~~~~~~~~
>>>> In file included from drivers/ras/debugfs.c:2:
>>>> ./include/linux/ras.h:14:19: note: previous definition of
>>>> 'ras_userspace_consumers' was here
>>>>  static inline int ras_userspace_consumers(void) { return 0; }
>>>>                    ^~~~~~~~~~~~~~~~~~~~~~~
>>>> drivers/ras/debugfs.c:39:12: error: redefinition of 'ras_add_daemon_trace'
>>>>  int __init ras_add_daemon_trace(void)
>>>>             ^~~~~~~~~~~~~~~~~~~~
>>>> In file included from drivers/ras/debugfs.c:2:
>>>> ./include/linux/ras.h:16:19: note: previous definition of
>>>> 'ras_add_daemon_trace' was here
>>>>  static inline int ras_add_daemon_trace(void) { return 0; }
>>>>                    ^~~~~~~~~~~~~~~~~~~~
>>>> drivers/ras/debugfs.c:55:13: error: redefinition of 'ras_debugfs_init'
>>>>  void __init ras_debugfs_init(void)
>>>>              ^~~~~~~~~~~~~~~~
>>>> In file included from drivers/ras/debugfs.c:2:
>>>> ./include/linux/ras.h:15:20: note: previous definition of
>>>> 'ras_debugfs_init' was here
>>>>  static inline void ras_debugfs_init(void) { }
>>>>                     ^~~~~~~~~~~~~~~~
>>>> make[2]: *** [scripts/Makefile.build:304: drivers/ras/debugfs.o] Error 1
>>>> make[1]: *** [scripts/Makefile.build:544: drivers/ras] Error 2
>>>> make: *** [Makefile:1046: drivers] Error 2
>>>> zsh: exit 2     LANG="C" make
>>>>
>>>>
>>>> Does somebody have an idea about this ?
>>> If you add b6ff24f7b510 ("RAS: Build debugfs.o only when enabled in
>>> Kconfig") to your tree, does that solve the issue?
>>>
>>> This should not be a new thing right?
>> Yeah, the above should fix this for you.  But again, is this a new
>> thing with this -rc release, or can you duplicate this in 4.19.76?
> Wait, I just dropped a ras patch from the queue, and your config file
> builds just fine for me.  So I think that solves the issue here.
>
> I've pushed out a 4.19.77-rc2 with that fixed up, can you let me know if
> that solves the issue for you or not?
>
> thanks,
>
> greg k-h

Indeed, this build correctly for me.

Thanks for your help,

François Valenduc

