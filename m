Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C10523DE2E
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 19:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbgHFRXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 13:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729557AbgHFRFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 13:05:18 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A505AC034626;
        Thu,  6 Aug 2020 06:34:57 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id kq25so37378698ejb.3;
        Thu, 06 Aug 2020 06:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rHqK38RuQ1sMAtSHsZ2jsHuSBhnKgRChw9PQXC5x/g8=;
        b=sHWsqQ3TaSk6xJtrxM7Zc2Si/hyLogx7R6vH44UqXNDLOarqWO/Vwyj5oMFdsWhsrq
         vXDe+POevMDU6Qf182IB0fgloTCU8P58rQAb/o3VmZS8mt7vs97r4K/faIC4dqGN4S/I
         uA0IpIurwug134o9qyzqFXZxk4EtAOAojb9Gp7cU3iNfBPhaSAZNSquAnQclz3EdEzNQ
         4gWTte+o0J7cVAlT9UNY3fdAKLHzw6XP0FNAS3cT05jhD+aK/24wmYZfVsn/HHX7qYjc
         ZRNJZCokPsmV/7mTUxcySkX9qKCivK9hIKO4kxK4iGGHNun7KSL9ySXvV4MSchWCd27O
         nhnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=rHqK38RuQ1sMAtSHsZ2jsHuSBhnKgRChw9PQXC5x/g8=;
        b=MDH22ed5+bqcQVZK4f+9E0rkxEjXWY3t/Xmaabx0fRknsNgpWkUhDQuBUBCxUEz0CQ
         rAP43EuxpTQgYEmnpBxktf0bkPf5ZEy5Bxl70TbGR4wdVRFQK0rO2+uXT7suTaiMSgb1
         x+Zj1in+GPu/JKS3R1+8e6+3evBGjMWNpEAW+i/AMWylWtQyJVLTKKccQkHKb0TJNXj1
         AejYIGcrSdDz35MMHo/QespaOpfDppW7gxbYtTHArjvcxARZ++zPUxT4seEZDWF6MyOg
         vEv1WiEFU7Q3cO9n0VmdQOD+UeYYuJRpcvwDkFycl6qeJaSvhsejwSTVvhcO8Xy16XJB
         bOew==
X-Gm-Message-State: AOAM533hyNv5PUTK6NVVx6At/x5X9od2YJ6a6JizsXsa59yPmDYb+Cnk
        JfFoIvW4QkGwNYwRKVrdICc=
X-Google-Smtp-Source: ABdhPJxA45bEMOJ9OTb4XWQbJNSFMMrPISkudFSUfT5Q7ezhysd1aO9TdtNGzvcZBPBZPfEKv3sVkg==
X-Received: by 2002:a17:906:a201:: with SMTP id r1mr4317065ejy.432.1596720896099;
        Thu, 06 Aug 2020 06:34:56 -0700 (PDT)
Received: from gmail.com (54033286.catv.pool.telekom.hu. [84.3.50.134])
        by smtp.gmail.com with ESMTPSA id x1sm3665602ejc.119.2020.08.06.06.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 06:34:54 -0700 (PDT)
Date:   Thu, 6 Aug 2020 15:34:52 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     kernel test robot <rong.a.chen@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc:     Dan Williams <dan.j.williams@intel.com>, tglx@linutronix.de,
        mingo@redhat.com, vishal.l.verma@intel.com, x86@kernel.org,
        stable@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Vivek Goyal <vgoyal@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Erwin Tsaur <erwin.tsaur@intel.com>, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org, 0day robot <lkp@intel.com>,
        lkp@lists.01.org
Subject: Re: [x86/copy_mc] a0ac629ebe: fio.read_iops -43.3% regression
Message-ID: <20200806133452.GA2077191@gmail.com>
References: <159630256804.3143511.8894023468833792004.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20200803094257.GA23458@shao2-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803094257.GA23458@shao2-debian>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


* kernel test robot <rong.a.chen@intel.com> wrote:

> Greeting,
> 
> FYI, we noticed a -43.3% regression of fio.read_iops due to commit:
> 
> 
> commit: a0ac629ebe7b3d248cb93807782a00d9142fdb98 ("x86/copy_mc: Introduce copy_mc_generic()")
> url: https://github.com/0day-ci/linux/commits/Dan-Williams/Renovate-memcpy_mcsafe-with-copy_mc_to_-user-kernel/20200802-014046
> 
> 
> in testcase: fio-basic
> on test machine: 96 threads Intel(R) Xeon(R) Gold 6252 CPU @ 2.10GHz with 256G memory
> with following parameters:

So this performance regression, if it isn't a spurious result, looks 
concerning. Is this expected?

Thanks,

	Ingo
