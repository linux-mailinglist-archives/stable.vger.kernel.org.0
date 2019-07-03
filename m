Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63B5F5EDC5
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 22:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfGCUn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 16:43:59 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34862 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbfGCUn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 16:43:59 -0400
Received: by mail-qt1-f196.google.com with SMTP id d23so5699408qto.2
        for <stable@vger.kernel.org>; Wed, 03 Jul 2019 13:43:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j4Uoj0QGeni1IXAQooMWASukrjbYxAzGAUjv6HzKawI=;
        b=XJHKFrJidpf9NqfWfLzb7h2cVahjiWpMg4JswtifRisuQhLWXtrA7bUTR3E0ahrSQL
         np8nnl1cFr6u804Fi8DO2ndTLdP52s7Fo3dMvv7C/g2sZGczLibKxI9gybLPwqj1meUx
         E5CCiP2RZ94vNUw5zNZRhje3htHZ70SQdeEQW+B8LLMasr4QuDy02sXhoQWWRERRfFTI
         t1wqd0i4bGzQKBOx7x68EnqX9kHaJM6BNpDsGJNJEZB6ntP47oY5HVJI0hbIufMl75UH
         43n2I8A1FllbkcZDOdaikwkV6OD15QmrMromTF5k0cTUwEmNvLDiQECHCPcGr/mHrwgZ
         WNLQ==
X-Gm-Message-State: APjAAAXrw1cRqhPaQKH3p55dWdzhg+h2Fs+ysepP4jhLJWa9mHs/6lKk
        X2K4gBV+Xg4Ev4Wrxb/QeiWXb95qgjKjLzWYyBf+8Tkekjg=
X-Google-Smtp-Source: APXvYqxoIstY3ApSXaxiWsKuinB3rT4BmsnkZr23QfotnrOcSPbXWUViDqqdhG3UU3cdIvCGA3lmWW207tbDMTbjw4w=
X-Received: by 2002:aed:3e7c:: with SMTP id m57mr32309912qtf.204.1562186637971;
 Wed, 03 Jul 2019 13:43:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAK8P3a2yqf5WK37mud7k4oFn95rTJRqpOdZ+v6zJ-9xM0u11zw@mail.gmail.com>
 <CAK8P3a3M7cuxPeoZrNKaQGayg-Q6-UH+JEN4gsMDNxa9SWBpUw@mail.gmail.com>
In-Reply-To: <CAK8P3a3M7cuxPeoZrNKaQGayg-Q6-UH+JEN4gsMDNxa9SWBpUw@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 3 Jul 2019 22:43:40 +0200
Message-ID: <CAK8P3a11WpSu8qzyHme9vDZdmv-ZgdFhc1-3rw8LeygbdYER8Q@mail.gmail.com>
Subject: Re: [STABLE-4.9] proposed backports
To:     "4.4.y backports" <stable@vger.kernel.org>
Cc:     gregkh <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 3, 2019 at 10:31 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> Here is a similar list for 4.9, from
> https://kernelci.org/build/stable-rc/branch/linux-4.9.y/kernel/v4.9.184-66-g79155cd391a8/

On 4.14, I can only see one missing patch in
https://kernelci.org/build/stable-rc/branch/linux-4.14.y/kernel/v4.14.132-2-g69aa9e7d0127/

02eec6c9fc0c ("MIPS: netlogic: xlr: Remove erroneous check in nlm_fmn_send()")

though there are still a few more build issues that need further investigation:

cc1: error: '-march=r3000' requires '-mfp32'

fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used
uninitialized in this function [-Wmaybe-uninitialized]

warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR &&
SWIOTLB_XEN && AMD_IOMMU) selects SWIOTLB which has unmet direct
dependencies (CAVIUM_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 ||
NLM_XLP_BOARD || NLM_XLR_BOARD)

       Arnd
