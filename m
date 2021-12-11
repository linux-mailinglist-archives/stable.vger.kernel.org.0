Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506084711BB
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 06:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbhLKF2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Dec 2021 00:28:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29123 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229593AbhLKF2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Dec 2021 00:28:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639200280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vEoBWvfKJezafb/gz8qOuM9H17UzU01X5cgIQsGVem0=;
        b=EbB/bYYnPagNaNjVPXj+f9E3A1sGa9PpZuzuUr3oVimWEE+qKyvhXIhPzPD1EtZlq1cVII
        Nu3CJLhUxe2ka6bnbpMiyVUDbqdLgvddQ64jXa1/9oDtNeC9FFdGRqrIbnN+CSLNWB3kFD
        +nhSV9t5wsxskd7rCrfwFIgAnt8GAiM=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-216-hTqxFxMTOGaL9fdhwAHQPA-1; Sat, 11 Dec 2021 00:24:37 -0500
X-MC-Unique: hTqxFxMTOGaL9fdhwAHQPA-1
Received: by mail-ua1-f70.google.com with SMTP id k10-20020ab059ca000000b002e631c340b0so7732713uad.5
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 21:24:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vEoBWvfKJezafb/gz8qOuM9H17UzU01X5cgIQsGVem0=;
        b=pB8yFTmSY4VtfR/g413rcE7WHbFOu/cHP4Q2vUfZxlSU21H2F9RMzspVZy0s+U1KyM
         aA3Ce2GqH0w7LbLTDGF/MMSgab/AXlL2AqYfjSJpHPXsrWbJ+UoEqJYoZH5YHj+Mmx2I
         SLJ967bufNFFiYl6AlEZN4Ut/ljZoyP9UMXbXwwHgOqaLJwU1Yu3ClQWjLDI8xQDi9Sv
         6RyANqC5p8GkNlHss2oJ7X0tBbubGzmftBwPE9UGcV3xl1fnGlgbLxqM346+WrxHMGwx
         ivz/235DNM6vKd0/GUhRdSn4g1UX09vMKK5ySGUk47sBFcEo0RKERilcbHPAngeO26nR
         8MXw==
X-Gm-Message-State: AOAM533nrzCnejzV6ikZO8oRaVVPI4cZhm3MWtCUNmBq6f3A+fOgrvet
        3St7o2dLO1wQtH4QAS6zagzoIyX1maqtGPORxKSxIPYv7eZEio8L4IbLhPH09k6eFDZzBoEmUJb
        FbMv03KcYOh2F8hjYh5vMYrq7IGeH84Tk
X-Received: by 2002:a05:6102:2910:: with SMTP id cz16mr21266828vsb.9.1639200277285;
        Fri, 10 Dec 2021 21:24:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyYuTo+cFn0Ym+OeF+CcyKc83VT49otL8gLNPTOMiwVV425TmLj+Cp1WxDVtcutyVADxYR1xNwNuwfmYUW4Meo=
X-Received: by 2002:a05:6102:2910:: with SMTP id cz16mr21266819vsb.9.1639200277130;
 Fri, 10 Dec 2021 21:24:37 -0800 (PST)
MIME-Version: 1.0
References: <163697618022.414.12673958553611696646.tip-bot2@tip-bot2>
 <20211209143810.452527-1-jdorminy@redhat.com> <YbIeYIM6JEBgO3tG@zn.tnic>
 <50f25412-d616-1cc6-f07f-a29d80b4bd3b@suse.com> <YbIgsO/7oQW9h6wv@zn.tnic>
 <YbIu55LZKoK3IVaF@kernel.org> <YbIw1nUYJ3KlkjJQ@zn.tnic> <YbM5yR+Hy+kwmMFU@zn.tnic>
In-Reply-To: <YbM5yR+Hy+kwmMFU@zn.tnic>
From:   John Dorminy <jdorminy@redhat.com>
Date:   Sat, 11 Dec 2021 00:24:25 -0500
Message-ID: <CAMeeMh9DVNJC+Q1HSB+DJzy_YKto=j=3iGUiCgseqmx9qjVCUg@mail.gmail.com>
Subject: Re: [tip: x86/urgent] x86/boot: Pull up cmdline preparation and early
 param parsing
To:     Borislav Petkov <bp@alien8.de>
Cc:     Mike Rapoport <rppt@kernel.org>, Juergen Gross <jgross@suse.com>,
        tip-bot2@linutronix.de, anjaneya.chagam@intel.com,
        dan.j.williams@intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-tip-commits@vger.kernel.org, stable@vger.kernel.org,
        x86@kernel.org, Hugh Dickins <hughd@google.com>,
        "Patrick J. Volkerding" <volkerdi@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Apologies for delay; my dev machine was broken much of today. But I
have tested this patch under the same conditions as previously, and
agree with Hugh that the patches make mem= work correctly.

Thanks!

John Dorminy

