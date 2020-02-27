Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3EB71727E1
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 19:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729504AbgB0Sof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 13:44:35 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46911 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729280AbgB0Soe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 13:44:34 -0500
Received: by mail-pl1-f193.google.com with SMTP id y8so135165pll.13;
        Thu, 27 Feb 2020 10:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=3EzoEiKTJsev6TY3rRthQ7y6X2EMBZONbWFfknQ3mOI=;
        b=LGTAxQmcY0aBGwm7kjMXVg0YtKiXVE+gXJn4OYJMFT053JxA8AzQtOEk6LSbtAwy1h
         JD+vQqaLzyjK/3Pg3GDRrZpy2hBUln2bxU/m83bQDATfzeBFHRFmzJLZrjTYRPELvxAX
         5M4xU/Mtk351EpzyEabHl8uqQukwdZZPd7IaSm0/3IEyk0h7O/koE/imeStf3Wfwca4Z
         +QtHTkPTyVmcMAyhVydCROwipY1wtFFlaOLz9cHyiORMY+zRvX4eKW0FfPU7hK3iqv6+
         +j9znRwnLRdYnQdnzhtIkWRABq25g0PdVrptwZQyaTRycLytXKOt/i/vWrM3OQEC5Pbe
         5mng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=3EzoEiKTJsev6TY3rRthQ7y6X2EMBZONbWFfknQ3mOI=;
        b=IeRig19/v1pTj1MDW9fDZ8qgz5xbSSoKVVnefNJrlreSF4vi7RaKuOMzMmSgtPusL8
         roPPAz7agkbdfdYGJSkGbJHp4RyuOyWa1jYFEoje7h1HzY948I/SNtQ30baSniiP2W1x
         D4G3tI3wUwl9NZcXAPM1TMhHVzlbh2dFmTqtyB69Vt9JRUJOuZAgX14swNGN41dklr9A
         JbOc8oCsvKtiFJBQ8lE9j/iHptpg1GrleoklJ0pK3rYutHoKPXhSfFpz3TD3EU5HAROr
         6bGe69ZoxL6mePlHoad4iFLyA9D85IDD06eYDb89CjgmMoQpXCII2LIZdTUnRT/51zVt
         pLHA==
X-Gm-Message-State: APjAAAX8FlEH5wrnR8ok8GUNo/Pmv0K+VCLrilLmh2RAM0eBrv+W33+t
        ksXQoBL/r6ZFtCS9HgPSDUw=
X-Google-Smtp-Source: APXvYqxNOLK7wXEg+ZMzunWOfKON/mH+l4nPeDMX7WHQm6G3DJM6gPdUDWLxzcwKbMwgD5hDzQDxHQ==
X-Received: by 2002:a17:902:b583:: with SMTP id a3mr159988pls.180.1582829073345;
        Thu, 27 Feb 2020 10:44:33 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x6sm7822006pfi.83.2020.02.27.10.44.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Feb 2020 10:44:32 -0800 (PST)
Date:   Thu, 27 Feb 2020 10:44:31 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/165] 4.9.215-stable review
Message-ID: <20200227184431.GA15944@roeck-us.net>
References: <20200227132230.840899170@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 27, 2020 at 02:34:34PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.215 release.
> There are 165 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
> Anything received after that time might be too late.
> 

Building powerpc:defconfig ... failed
--------------
Error log:
In file included from include/linux/bug.h:4:0,
                 from include/linux/thread_info.h:11,
                 from include/asm-generic/preempt.h:4,
                 from ./arch/powerpc/include/generated/asm/preempt.h:1,
                 from include/linux/preempt.h:59,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:35,
                 from include/linux/time.h:5,
                 from include/uapi/linux/timex.h:56,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:19,
                 from arch/powerpc/kernel/signal_32.c:20:
arch/powerpc/kernel/signal_32.c: In function ‘save_tm_user_regs’:
arch/powerpc/kernel/signal_32.c:521:10: error: ‘tm_suspend_disabled’ undeclared

Also affects v4.14.y.

Guenter
