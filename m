Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4CC40F9DC
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 16:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbhIQOBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 10:01:55 -0400
Received: from mail-lf1-f51.google.com ([209.85.167.51]:38643 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbhIQOBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Sep 2021 10:01:54 -0400
Received: by mail-lf1-f51.google.com with SMTP id x27so33433845lfu.5;
        Fri, 17 Sep 2021 07:00:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E61I5foD4VRAj+D798lIeaVMiRWwgvwIir1tV9IJeII=;
        b=JSObWgvvZkxGB47shNzphuEXFGLD6oGNZyy+wT77A3ir0XF46bclNOyYDFHydeBg9U
         4B0asOljzSIVMPO/Qn3kyGBvAo1PgWY6WO1S5w47CE9tm103yayFdmOarPnGclp20HpQ
         2LJd7b6GyAPraj86vl7Ow3LLqDvTdtYFNOFniBOB273CTj8dtWcL49mCR5yNM1Ok8lfS
         N0/Tc1jfcyEyF5aNmNJ0mKAEmDXq9SpZRxgtJKkXb/qcwL5KNJSxUA2jm+VcT2AIVpwn
         dH20GiEuhitXEwXbH62B/iolu3nE494Gg+c5GJZ8szjJFlFVHThBWqjlGUsC3Msy1VOD
         /Wfw==
X-Gm-Message-State: AOAM533PbEtb0tFqtX7r6w9tEh+6uPVOrl0XAqhw4n7of7vGcN12xi0X
        zaeRz7BDs/Be4et++kxSsbw=
X-Google-Smtp-Source: ABdhPJy5zHszxHrtyQboZ7yCpDL2BISj4S2a1+FSx7m5lMscAShOjwsI0BV7t1EIYtiErE8sgthOUQ==
X-Received: by 2002:a2e:85c4:: with SMTP id h4mr9733658ljj.321.1631887204995;
        Fri, 17 Sep 2021 07:00:04 -0700 (PDT)
Received: from rocinante ([95.155.85.46])
        by smtp.gmail.com with ESMTPSA id a11sm538424lfo.5.2021.09.17.07.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 07:00:04 -0700 (PDT)
Date:   Fri, 17 Sep 2021 16:00:03 +0200
From:   Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     x86@kernel.org, jose.souza@intel.com, hpa@zytor.com, bp@alien8.de,
        mingo@redhat.com, tglx@linutronix.de, kai.heng.feng@canonical.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org, rudolph@fb.com,
        xapienz@fb.com, bmilton@fb.com, stable@vger.kernel.org
Subject: Re: [PATCH] x86/intel: Disable HPET on another Intel Coffee Lake
 platform
Message-ID: <20210917140003.GA1520823@rocinante>
References: <20210916131739.1260552-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210916131739.1260552-1-kuba@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jakub,

[...]
> The Intel documentation does not list my device [1], but
> linuxhw [2] does, and it seems to list a few more bridges
> we do not currently cover (3e31, 3ecc, 3e35, 3e0f).

This might be out-of-scope for this particular patch, but it makes me
wonder - if we know that these other bridges were identified as having the
same issue, would it be prudent to add a quriks for them too?  It might
save some people a headache and such.

	Krzysztof
