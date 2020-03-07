Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 268D017CAB8
	for <lists+stable@lfdr.de>; Sat,  7 Mar 2020 03:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgCGCVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 21:21:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:56380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726359AbgCGCVV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 21:21:21 -0500
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37F342067C
        for <stable@vger.kernel.org>; Sat,  7 Mar 2020 02:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583547680;
        bh=1hK61AOttKQjpFnefFnrB/B63DwRIlE6GKi1awj3rLE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jcG2U+tAucUJrcdf7foxLHER+S18d0t0CiE/qHc4WbCDY03zDroQZDGNTbLOwzBRZ
         uZwjv2VD42ADy0659mYmwE8RFkF7NCiqw9DpSMWcOTZU2OFObfl81htkDgn/JDoEWB
         FUktMHVUpGjvJ0eMU31YO23HcoOugstPiZbTxg9k=
Received: by mail-wr1-f52.google.com with SMTP id s5so593564wrg.3
        for <stable@vger.kernel.org>; Fri, 06 Mar 2020 18:21:20 -0800 (PST)
X-Gm-Message-State: ANhLgQ0LdM3ZDjiu1G280MssCtn3SgXL4lg7So0mDT/LcmYffoKGUekj
        yBUGdr6oc5Qh93C2T3gw5dLM/kLjr6gWNyDfRMO8Zg==
X-Google-Smtp-Source: ADFU+vvz6h+4nO7ePltpnekglr/xa+6kV6sjumEIgtsaGDr0ysbdKMaLv1gEgmu6PKjoVg7vlEzAcOHSVAFHa6JBjiA=
X-Received: by 2002:a05:6000:1ca:: with SMTP id t10mr6716238wrx.75.1583547678734;
 Fri, 06 Mar 2020 18:21:18 -0800 (PST)
MIME-Version: 1.0
References: <25d5c6de22cabf6a4ecb44ce077f33aa5f10b4d4.1583547371.git.luto@kernel.org>
In-Reply-To: <25d5c6de22cabf6a4ecb44ce077f33aa5f10b4d4.1583547371.git.luto@kernel.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 6 Mar 2020 18:21:07 -0800
X-Gmail-Original-Message-ID: <CALCETrVHMO14Vcg9-pmuhN+MmXCuKnfR5Zipc6sqkqVHQGAQRg@mail.gmail.com>
Message-ID: <CALCETrVHMO14Vcg9-pmuhN+MmXCuKnfR5Zipc6sqkqVHQGAQRg@mail.gmail.com>
Subject: Re: [PATCH] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
To:     Andy Lutomirski <luto@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 6, 2020 at 6:16 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> The ABI is broken and we cannot support it properly.  Turn it off.
>
> If this causes a meaningful performance regression for someone, KVM
> can introduce an improved ABI that is supportable.

Ugh, disregard this patch.  I flubbed the comment, and I'll send v2 shortly.
