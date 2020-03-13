Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9241184C2F
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 17:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgCMQRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 12:17:54 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43369 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgCMQRy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 12:17:54 -0400
Received: by mail-lf1-f67.google.com with SMTP id n20so5017458lfl.10
        for <stable@vger.kernel.org>; Fri, 13 Mar 2020 09:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GGKTLdP7NysMTjq7A/r6ibsN/jqrKxZ94DgLRwdxBUU=;
        b=rByIursShxrvJL8x7QUC8Ki6XMcvcoLltmEqaT1zaJzjg/ldGQ85qCtWChh3yi2sha
         XBRpP4/6FVsBNUAiH4b4VO6q85dWLJPVXycc1J97pT/KFfmqu+MBo4cZCFV6GHqOlB5q
         BrIIrIVFiSlB+HFKuCzrn3YM4AVtNWSKf0XsMzCAtwDVGrnAtlas3YS8NwwlXI5Y8BoB
         y8RFRCQ+q7yC3f/+cyMTqTRaWJUpda8IvD/9p1LpSHgRdywz9AJNDsapHW6poAwZQkOF
         aeDggx/IBtDr/w9XwwEj9Yx13onMnTE2VboIsbVBb95Tr4+j9yoTf0Nyoz3oXMvhblsK
         bWjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GGKTLdP7NysMTjq7A/r6ibsN/jqrKxZ94DgLRwdxBUU=;
        b=fD/wDpAkyx+hMjeqtdnchsriVHr4QxRvZKQBXyRdZLT10PeNcjq7EeLge63U0leKxs
         LFpGxidsOEmhU4PgTrN6cvrvtknk46CPd+ykDt8OxMVVrl/ayhJsG3dRzqLXZf88/ZoP
         YqF9rJkVVrIIQES1pNgqcCRP5Yz5oIZ0RR9J/L1FR/CuQlkTWGkxr/pQ/9qXPDFnCF7L
         Sy3UEGo2GcTarq6N/KsN8kdF3/O9ACsRWkleW8k0hfCU3NH/HgMxvipOTEousJFyBRq/
         XA8wnW5nXeLWufLBofUFdRgP2OaNu/M22bA16W7ysg/CWneiXYSvHIzidQHwo7YgipZF
         5JGQ==
X-Gm-Message-State: ANhLgQ2DEaHKIJnWNcynZE4q4puy1j0/sjN4aaeKFyD+vyCqcTO+tVXw
        vUZj2Rin6oO2/yWKJPGgFR5KY5fJ9iH6jS/LrKsfPg==
X-Google-Smtp-Source: ADFU+vtValKojWuh4Y5Xd2oyg0PROdnQd5jtfAmUywOUtPoRIjgVc6sIaJFcF6i+ykZj2N1GZzMbUMeIxPPBc8t2pwI=
X-Received: by 2002:a19:f601:: with SMTP id x1mr7277713lfe.55.1584116272680;
 Fri, 13 Mar 2020 09:17:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200310124203.704193207@linuxfoundation.org> <0074ed5d-1c87-4e0c-7d3f-bb5cc4e80366@kernel.org>
In-Reply-To: <0074ed5d-1c87-4e0c-7d3f-bb5cc4e80366@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 13 Mar 2020 21:47:41 +0530
Message-ID: <CA+G9fYvx8q9+VrweEZx4t+-XFEOQLaUJed2ooRUPG8NxjKkkeA@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/126] 4.14.173-stable review
To:     shuah <shuah@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Shuah

>
> Compiled and booted on my test system. I have a new alert on my system:
>
> RIP: kvm_mmu_set_mmio_spte_mask+0x34/0x40 [kvm] RSP: ffffb4f7415b7be8

Our system did not catch this alert.
Please share your kernel config file and
steps to reproduce and any extra kernel boot args ?

- Naresh
