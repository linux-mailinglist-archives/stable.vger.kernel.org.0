Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF082CEE80
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 14:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730164AbgLDM6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 07:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbgLDM6R (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 07:58:17 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D70C061A4F;
        Fri,  4 Dec 2020 04:57:37 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id t6so7466749lfl.13;
        Fri, 04 Dec 2020 04:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ChJxHnhoj3SJvtmx2+l76oFdOmA/pdMZHRiqzhvFFwE=;
        b=DTWuaNQtdyrW91DFgh8aXCQoDmWzKWXLRWbSx97b5MpJVnGqLF0AUy+sUK7/CIQA3x
         4rcMa9HgOHyMfkLbR86RyTkIUI/WY6+So7q8Sbw8OBF+7SYP/m86HV9Xaz/I/dMQ135f
         ELs/UjEZPkmRWnbC7qT0hRDsGhHkfi1icdZYSOiBHPdg43QNyNnixAITj0X0Pyq/pp6a
         4i1vwE48bHdNbYRW93xRcB22VdzW14Kr6Bp3hhNpqQOXaotbk8IBAlDCFlB3z0Ja9D84
         VOvCCg0la+aKs81CYgIRvSYmwu0k0AV8Zx9joYf/5RSb2iaUpSVh76Yf0x1enPyRR4pj
         Ogug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ChJxHnhoj3SJvtmx2+l76oFdOmA/pdMZHRiqzhvFFwE=;
        b=jcywD6jZssFBpnSTrFifz5etEpS1NKmyx8PT6sjGUD1M1x0MkLGaJgOgRwOSQ494/b
         Mp5KPKTJVCb4P7xK48TRVN1OBkoDMtWsQ1jt8R8CdaAUGwIT4WGwiu17Yi1aWKw+dYYM
         R4d+Rqg4w38Rvvkg7hr6TLHhkmwhiV1JvoYBOsaPmxUh4uNc/gaMZCevrvDAx46CVlg7
         gwVo1RcTTDxnB/C/2QFoGT3LyALK/bfGnrySZutTlSDwBpuKGdWixgaAiWoxGY69UqfJ
         Ndji7oVgJYY/Q2jjcrALgqIsKjGEppyEPs1dBAshLC1G1w6huiLgGM4d/LDUznFVaK08
         tzog==
X-Gm-Message-State: AOAM531uCeFbYV+Ns2a9TsSX8wdI6ajT3z/UqTyXBGFKwSMp3Vu2aipl
        c1QLMfFwimY1P/AbRPp7IXo=
X-Google-Smtp-Source: ABdhPJzWwcUnGUiRZFfB3QdPd3JwjqtLzP3rJ1aitEV2g6WdGKDL6z+50X54IIp/uScXDuG39+k66g==
X-Received: by 2002:ac2:5591:: with SMTP id v17mr3526525lfg.562.1607086655732;
        Fri, 04 Dec 2020 04:57:35 -0800 (PST)
Received: from xps13 ([37.78.35.64])
        by smtp.gmail.com with ESMTPSA id w19sm1614457lfe.175.2020.12.04.04.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 04:57:35 -0800 (PST)
Date:   Fri, 4 Dec 2020 15:57:33 +0300
From:   Artem Labazov <123321artyom@gmail.com>
To:     Sungjong Seo <sj1557.seo@samsung.com>
Cc:     stable@vger.kernel.org, 'Namjae Jeon' <namjae.jeon@samsung.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exfat: Avoid allocating upcase table using kcalloc()
Message-ID: <20201204125730.GA546513@xps13>
References: <CGME20201124194858epcas1p49cacda6a9b4877ff125f25f4dc5fcadf@epcas1p4.samsung.com>
 <20201124194749.4041176-1-123321artyom@gmail.com>
 <001101d6c867$ca8c5730$5fa50590$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001101d6c867$ca8c5730$5fa50590$@samsung.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> I have not yet received a report of the same issue.
> But I agree that this problem is likely to occur even if it is low
> probability.

Perhaps I should clarify my setup a little bit more.
The issue can be reliably reproduced on my laptop. It has 8 GBs of RAM
(pretty common amount nowadays) and runs an unmodified Fedora 32 kernel.
Also, I use zswap, which seems to be contributing to fragmentation as well.

> I think it would be more appropriate to use kvcalloc and kvfree instead.

I do not think this is really needed.
Upcase table allocation is relatively large (32 pages of 4KB size) and
happens only once, when the drive is being mounted. Also, exfat driver
does not rely on the fact that the table is physically contiguous.
That said, vmalloc/vfree seems to be the best option, according to kernel's
"Memory Allocation Guide".

--
Artem
