Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F9534211C
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 16:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhCSPnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 11:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbhCSPmq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 11:42:46 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95107C06174A;
        Fri, 19 Mar 2021 08:42:45 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id b9so10456097ejc.11;
        Fri, 19 Mar 2021 08:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=AosAsdPYu9Ufpf4Wk/dfAmNbL8dSXdLyf4cxfVtJsJs=;
        b=lyiABF6FyD5T6JqaesOU6h9kIR+cKrn1Sh7bTfLrms514h0BC0oBI8qKQ5kFm8M212
         UH2rhod/YmnMU1/eLyFO1c2a+E+vdnNN1kPXazbx1W+g0MpCjxaFCzmHJlXQmAIrwaPU
         U2ReVax7N3j2SopCQcveKL9Yi83d2Xyn888ybrDJdvbFcCVPGLa8edUQ5RVIyzAsvL1a
         mfR4ba5Hss1Ze48Z/zR1LQ2HUTG5JqoZ9IDxfjoCTY7fQo7/UglYIhJUv5mnDkpGRO44
         zPrxTmF8BixYWaA/YUdRu80+XpSHYlvrzqAhSPI399dUn5hUksURO5SnvohjEALl0ZBf
         iosg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=AosAsdPYu9Ufpf4Wk/dfAmNbL8dSXdLyf4cxfVtJsJs=;
        b=EAGmXnK8SMk2wIYa80RVs1pu0iQpTn7wiNbhx8KcqF9JggHBYP60FsJZPqdyinQLte
         HNSGezeiw610qZRanP+AnURa81BkmmCuPENNPufYV0kqKxAfGDxHaUkd4/MtQvrRhcTf
         up2AJg4IlEja4lF5f5uNVHsSRK92P/K/h8K4RcRgCoqD85dH6bg8z122MmOGaMbh8Cb1
         ao4jxZPDkjGBvH5EP5u9upG666zjNeKKStV1BvXWYPOkeISXnuenKipD8cDUdJg0bjFn
         qBixz2dLG/xMzGfVbMLaka7zfHKXcc1HKENz7xRD8AS918JS0oa2gezd8oyzkN2mWHLZ
         ZrAw==
X-Gm-Message-State: AOAM533WMiKY3e1B2uYIQ7YtXZG3O2Ai0llmlE1fZsFWsCoWuBZYWbHP
        /vVO37lp8Iax1xE+0jr08Rs=
X-Google-Smtp-Source: ABdhPJzXUYXeQXqLVlM1MCjV0Leex/cYqKuZRVk8YjMdykP6fA1NLo4fwo9IQpog+vz9sgkmkV03cQ==
X-Received: by 2002:a17:907:2d24:: with SMTP id gs36mr5152295ejc.344.1616168558515;
        Fri, 19 Mar 2021 08:42:38 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id r17sm4203287edt.70.2021.03.19.08.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 08:42:38 -0700 (PDT)
Message-ID: <79ec60974875d4ac17589ea4575e36ec1204f881.camel@gmail.com>
Subject: Re: [PATCH v1 2/2] mmc: cavium: Remove redundant if-statement
 checkup
From:   Bean Huo <huobean@gmail.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     rric@kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "# 4.0+" <stable@vger.kernel.org>
Date:   Fri, 19 Mar 2021 16:42:37 +0100
In-Reply-To: <CAPDyKFrU591aeH5GyuuQW8tPeNc9wav=t8wqF1EdTBbCc9xheg@mail.gmail.com>
References: <20210319121357.255176-1-huobean@gmail.com>
         <20210319121357.255176-3-huobean@gmail.com>
         <CAPDyKFrU591aeH5GyuuQW8tPeNc9wav=t8wqF1EdTBbCc9xheg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-03-19 at 15:09 +0100, Ulf Hansson wrote:
> On Fri, 19 Mar 2021 at 13:14, Bean Huo <huobean@gmail.com> wrote:
> 
> > From: Bean Huo <beanhuo@micron.com>
> > Currently, we have two ways to issue multiple-block read/write the
> > command to the eMMC. One is by normal IO request path fs->block-
> > >mmc.
> > Another one is that we can issue multiple-block read/write through
> > MMC ioctl interface. For the first path, mrq->stop, and mrq->stop-
> > >opcode
> > will be initialized in mmc_blk_data_prep(). However, for the second
> > IO
> > path, mrq->stop is not initialized since it is a pre-defined
> > multiple
> > blocks read/write.
> 
> 
> As a matter of fact this way is also supported for the regular block
> 
> I/O path. To make the mmc block driver to use it, mmc host drivers
> 
> need to announce that it's supported by setting MMC_CAP_CMD23.
> 
> 
> 
> It looks like that is what your patch should be targeted towards, can
> 
> you have a look at this instead?
> 
> 

Hi Ulf,
Thanks for your comments. I will look at that as your suggestion.
The patch [1/2] is accepted, so I will just update this patch to
the next version.

Kind regards,
Bean

> 
> Kind regards
> 
> Uffe

