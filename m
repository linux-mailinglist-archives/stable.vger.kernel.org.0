Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77DD31D0E35
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388114AbgEMJ6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388254AbgEMJ6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 05:58:47 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3655CC061A0E;
        Wed, 13 May 2020 02:58:47 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id b8so7544193pgi.11;
        Wed, 13 May 2020 02:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=LZQdTItj+phmAsWkKaeFc8g4x0Z4pbN4y0XUWhGVwSA=;
        b=tDaUkcBMkv9tuhu8S0Ysk4WRXa5pdNBzsgIfZbM0sswrIoemyg4K2pzgOLSa5Lel3f
         4959Gsut18JVjREjJnT5Ylt/heVgtYR05Eg4VoxSjF7mS/bUxyIxWLMG/lBK/sE5OW1G
         7AkIaIbE5vSNeVap9XTydgUzNIe/UVZHw0EwuMif4+e9Aw3jepujLNs6VykOpo8uyXz+
         +eecW+BrYZ2auYUy9hEI3XgobA7cMYCsp2Eu7JqAeyK+CaPhx+wp40VwWr5Cxo7QUjYz
         KMlsSRZtKsAXX7Ax9uUo15cvzHwODLpUHd9ySWRvoi9fjPeQ3XHDeBrGyfZ/eLoe/ay1
         bPiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=LZQdTItj+phmAsWkKaeFc8g4x0Z4pbN4y0XUWhGVwSA=;
        b=meQjKILW1X7UnPt1MOKnUnuD/LPXUZsv3jjAaxg7/WNCoJWPV2zoAxQvhe2++prbl1
         R8fjl4NnlpKr+fwgFqJGeLYDMx5g0W0klWBnwAMJGL3gjBvhTwYHfxtARFRC5tr6lvWY
         TCDKNIokIWWARdW/bg+KqDhLt+HGTtNF7lCkyDj9UwO7yXvxMMdGcEkHT8psiShW6InV
         8+KRajJ8hCxKs6ZGTQThiyvOu9YUZfr95xpOyywXmBbdEJHuMP4EXRdEYF+CBgE5flGG
         moz/bFrY72PPxuOUjuE9qfBV7liJ67Nf5uidSTBM50A/+OX/qD0X4H1elbKT0yuw4glL
         hSMA==
X-Gm-Message-State: AOAM533IGpaLmmbI2iKcKw8O9ODm0ho6hv+ygmQIBgUmJ28WOMWzlFzG
        UL7jT6wdWUB9SeESDnx/4YU=
X-Google-Smtp-Source: ABdhPJwef0ZTrTANKoyN89Q+vPNOeDs4DObiVUNYwODBcHkwoUAO1pvyDn8tVkF6+tDa9yYtSQlN0Q==
X-Received: by 2002:a62:3487:: with SMTP id b129mr6349648pfa.3.1589363926738;
        Wed, 13 May 2020 02:58:46 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k1sm8860351pgh.78.2020.05.13.02.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 02:58:45 -0700 (PDT)
Date:   Wed, 13 May 2020 17:58:35 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andrii Nakryiko <andriin@fb.com>, stable@vger.kernel.org,
        lkp@lists.01.org, bpf@vger.kernel.org,
        kernel test robot <rong.a.chen@intel.com>
Subject: Re: [selftests/bpf] da43712a72: kernel-selftests.bpf.make_fail
Message-ID: <20200513095835.GD102436@dhcp-12-153.nay.redhat.com>
References: <20200513074418.GE17565@shao2-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200513074418.GE17565@shao2-debian>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Thanks test bot catch the issue.
On Wed, May 13, 2020 at 03:44:18PM +0800, kernel test robot wrote:
> Greeting,
> 
> FYI, we noticed the following commit (built with gcc-7):
> 
> commit: 77bb53cb094828a31cd3c5b402899810f63073c1 ("selftests/bpf: Fix perf_buffer test on systems w/ offline CPUs")
> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y

The author for this commit is Andrii(cc'd).

Mine is f1c3656c6d9c ("selftests/bpf: Skip perf hw events test if the setup disabled it")
> prog_tests/stacktrace_build_id_nmi.c:55:3: error: label ‘cleanup’ used but not defined
>    goto cleanup;
>    ^~~~

Hi Greg, we are missing a depend commit
dde53c1b763b ("selftests/bpf: Convert few more selftest to skeletons").

So either we need backport this patch, or if you like, we can also fix it by
changing 'goto cleanup;' to 'goto close_prog;'. So which one do you prefer?

> prog_tests/perf_buffer.c: In function ‘test_perf_buffer’:
> prog_tests/perf_buffer.c:39:8: warning: implicit declaration of function ‘parse_cpu_mask_file’ [-Wimplicit-function-declaration]
>   err = parse_cpu_mask_file("/sys/devices/system/cpu/online",
>         ^~~~~~~~~~~~~~~~~~~

I guess, this is due to the header file path changed.
Hi Andrii, what do you think?

Thanks
Hangbin
