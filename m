Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F371CA049
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 03:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgEHBrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 21:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726514AbgEHBrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 21:47:49 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411FDC05BD43
        for <stable@vger.kernel.org>; Thu,  7 May 2020 18:47:49 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id y6so3510416pjc.4
        for <stable@vger.kernel.org>; Thu, 07 May 2020 18:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=f9eiMDw+TYT+YpY+WIf+wyHCcdJr+jALbf8pRs9wo94=;
        b=ALo96trml03jRans8W1z9pGzbrEDgDqHsar9PVW4R9ptwxsp3Ejhh1nFeyi1xKQfHI
         uRYYY300AT5z9eiRP64Tzt5i6e6FslcrJfbe0pFMXs6nY7RYE7h2em9rK6wd8Gj+Gj82
         AXiPHSV65NzOwb1esK3cqIvxlC8Vnh0hN/n57EPgEsUMrXfc50shuJzHnwNEuq2hdIXu
         js7ZeBi9WuijaRUVpU6Kwtu+28RK1OuLhRjceEkWDMMCYJRXmdSGdb0aDV9zLksMmeZB
         zIFLZ2u6Nw9bvwWnahBsQtkyhJafTiv7nLp5zeQgjpcKPVnkHLE1VtibIJZmD/RdKAVp
         tLbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=f9eiMDw+TYT+YpY+WIf+wyHCcdJr+jALbf8pRs9wo94=;
        b=drSiPofZax++P0aJhAmlllpy2tfPtaFfHkNzkbeZk4MJndGEVo/D6klF1mBHpDC8Ni
         eFdsR+bFnpbWzHkhh+1QQLvfxkN1wzdP8i9fnTaFl8Q09IMYsA+KpdxzSR9b3t4oe3D7
         GIDWWR00s77UMfL7C/VZYswSYMvW9djKEWJ3BoyfBehDwGtNJRgbv4aBcAenPENoWjLw
         GtxK4MfZir8G+FiIi4M9h/aNTfhiMimSX+uSv0TUwETpmd20Qu+81qfSft2ZTBTyw6QM
         hAMl9Kx4NMgwafQY2PVR+LoSmyKvClgxv+abKuM1OfmqLuYe6jeKCtcnQEAl8Ue9wsRk
         /DHw==
X-Gm-Message-State: AGi0PuYpnyWKdF+foANdx52rT5Q1Ly9D9G6lzlC3VLXvrXwmcDy72txc
        Vk3SylSlJNkNJNAwipwASrI=
X-Google-Smtp-Source: APiQypLU7dd0pYeDOpbH0cHb2maPxLv5siGqT00cQQrFQLZiF1iP/PvsQgp85GEEtH9epZiWocxiig==
X-Received: by 2002:a17:90a:252f:: with SMTP id j44mr3313706pje.9.1588902468645;
        Thu, 07 May 2020 18:47:48 -0700 (PDT)
Received: from iclxps (155-97-232-235.usahousing.utah.edu. [155.97.232.235])
        by smtp.gmail.com with ESMTPSA id a196sm49243pfd.184.2020.05.07.18.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 18:47:47 -0700 (PDT)
Message-ID: <f86e1777b6ca07ea496079fe96c5e5934b9e3a99.camel@gmail.com>
Subject: Re: Patch "lib: devres: add a helper function for ioremap_uc" has
 been added to the 4.19-stable tree
From:   Tuowen Zhao <ztuowen@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        acelan.kao@canonical.com, andriy.shevchenko@linux.intel.com,
        gregkh@linuxfoundation.org, mika.westerberg@linux.intel.com,
        subdiff@gmail.com, hch@lst.de, akpm@linux-foundation.org,
        alexios.zavras@intel.com, allison@lohutok.net,
        bcain@codeaurora.org, boqun.feng@gmail.com, geert@linux-m68k.org,
        gregkh@linuxfoundation.org, lee.jones@linaro.org,
        mcgrof@kernel.org, mingo@redhat.com, natechancellor@gmail.com,
        ndesaulniers@google.com, peterz@infradead.org, rfontana@redhat.com,
        tglx@linutronix.de, will@kernel.org
Date:   Thu, 07 May 2020 19:47:44 -0600
In-Reply-To: <20200508005104.CDBDD208CA@mail.kernel.org>
References: <20200508005104.CDBDD208CA@mail.kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I believe some patches are needed to fix build issues on Hexagon:

ac32292c8552f7e8517be184e65dd09786e991f9 hexagon: clean up ioremap
7312b70699252074d753c5005fc67266c547bbe3 hexagon: define ioremap_uc

The same is for stable v5.4.

Best,
Tuowen

