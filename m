Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43B324EAE4
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 04:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgHWCRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 22:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbgHWCQ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Aug 2020 22:16:58 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84ED0C061574
        for <stable@vger.kernel.org>; Sat, 22 Aug 2020 19:16:57 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id n128so5162972oif.0
        for <stable@vger.kernel.org>; Sat, 22 Aug 2020 19:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=yZZhZYoy1V9bZIDpM4iID+t1LN6tQrXJRjdBrD270ms=;
        b=shQ07h181aJxSE68YmUJNXwkVI/L1lclI9eMH8H1FHzCMgvSxM/pqHk8bX2VVOr/2E
         70EiQAEpIPaZlpvzOtk8AEBVoCZwPb7aIFAtLow4JMAWR7U7lqdofDtnmrTW/scwVXeZ
         FPdLI0bQrJOPVodHpFpKejvKGJpDedSlGHe5f0LiJAkHU+v7ZKjNFItm/KK5rAtmvpZz
         xj2I6iDdWpaJZZBQFP7oicxwHPD2gUHc9QFSmYRma4POMDaurvCf50WSLMl+vuEdHy58
         tV+JAvxOj67a/2UxUCjfRLadPIe8gDX57tFZ1YMMk5e21Z+ysvRqrllFDUmLyEc4DLpw
         ETrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=yZZhZYoy1V9bZIDpM4iID+t1LN6tQrXJRjdBrD270ms=;
        b=IZQAQLv8aEsHdHmnmAGZ05RSiSDCxJ+qi7w7maRZdxHedVOp1CJa9kQQ16kLm9Euj3
         1an/MhT2WKxkkR64YY50keVMngZFDniw5z+yvb34EWO5/Zf345LZIrEqfLyIJxZ/C+Q5
         0rT098xBk3wo9NJUS4Ggqn+b2ZzMzEyFFrKBpDpD9CIq+BEvrfDi5YVTkZXYTfDcQ/id
         v2+MACXlMlfeD/oByzKpzwV+M+M58U91hq68ztFrhPa2XpJ75RK+HTULkh74HJNxcu2P
         DYDndtY3UTY9QsRpCjc6Fp55tHKZ+9CPvMmiaJ2gNPnk5J9dy/npBUbQTASi68eXJaGi
         3ipg==
X-Gm-Message-State: AOAM53247MiuMCwHXf+6Hbrkpzfi69Np2CvFM9a6QYkhll9nbxh1PF7U
        gJYnJ3+F6BH4ckyQCvNCac8mIw==
X-Google-Smtp-Source: ABdhPJyNPLb8qctZ0zDKAaBLTF0gqLe5gEOtFBfgGEOWXSVoTU3B69FtoRrVMOUj+S8qui74xCxhBA==
X-Received: by 2002:aca:fcd2:: with SMTP id a201mr62935oii.166.1598149016602;
        Sat, 22 Aug 2020 19:16:56 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id f84sm116368oia.32.2020.08.22.19.16.52
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Sat, 22 Aug 2020 19:16:55 -0700 (PDT)
Date:   Sat, 22 Aug 2020 19:16:39 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     Sasha Levin <sashal@kernel.org>
cc:     Hugh Dickins <hughd@google.com>,
        Greg KH <gregkh@linuxfoundation.org>, aarcange@redhat.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mike.kravetz@oracle.com, songliubraving@fb.com,
        torvalds@linux-foundation.org, stable-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Patch "khugepaged: khugepaged_test_exit() check mmget_still_valid()"
 has been added to the 5.8-stable tree
In-Reply-To: <20200822212053.GE8670@sasha-vm>
Message-ID: <alpine.LSU.2.11.2008221900570.11463@eggly.anvils>
References: <1597841669128213@kroah.com> <alpine.LSU.2.11.2008190625060.24442@eggly.anvils> <20200819135306.GA3311904@kroah.com> <alpine.LSU.2.11.2008211739460.9564@eggly.anvils> <20200822212053.GE8670@sasha-vm>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 22 Aug 2020, Sasha Levin wrote:
> 
> I've followed your instructions and backported the patches:
> 
> bbe98f9cadff ("khugepaged: khugepaged_test_exit() check
> mmget_still_valid()") - to all branches.
> f3f99d63a815 ("khugepaged: adjust VM_BUG_ON_MM() in
> __khugepaged_enter()") - to all branches.
> 59ea6d06cfa9 ("coredump: fix race condition between collapse_huge_page()
> and core dumping") - for 4.4.

That's saved me time, thanks a lot for doing that work, Sasha.

I've checked the results (haha, read on) and they're all fine,
but one minor flaw in bisectability: the added 4.4 backport of
"coredump: fix race condition..." adds a line (deleted by the next commit)
	result = SCAN_ANY_PROCESS;
but neither "result" nor "SCAN_ANY_PROCESS" is defined in that tree,
so that intermediate step would generate an easily fixed build error.

FWIW - I don't know whether that's something to care about or not.

Thanks again,
Hugh
