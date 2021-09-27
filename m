Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2048A419F2E
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 21:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhI0Tc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 15:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhI0Tc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 15:32:58 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DFEC061575
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 12:31:20 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id x191so11806967pgd.9
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 12:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3zxyKK6GFj9MDblq5TRwW3b2ka+tg7Fz4b/WqwBWElk=;
        b=rXNo6MfupXb2z2wrdwLR9xKO++AAOMSMmEFmrLyGIL4u8eDeeFys5ZhbuWnuzJvSi9
         m8UNdgHUqHYJ73pZeEd4P3W1wxTJWhgN/NLhBqqEOBk/ns6h2dtN1h9fnLLrRrhPr8/q
         GtFkD7CZMs3K3K7IlvAvaXYRwrP+9V+r+d/AM+WGdyNLA3y1ljbA5f/TTqL2cagDtLfc
         HP9ejfRM5WgIjhuLtq6c7Bk7nn2GGFjglysdZ1gXGGssaw1BrEklXVJGnV3Clm1LZSRI
         6xO8DSVpApLvNXEa41DuZAO/+CbUnjtXPWxwdUp6yD27t7oLob9IDdjrFF7o38+WZySp
         AcKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3zxyKK6GFj9MDblq5TRwW3b2ka+tg7Fz4b/WqwBWElk=;
        b=C229yEn21+CfCFjkEo7ZSbFlTWywguuRJ3JO255j2w0jhwQV/PBeni9yvu//rNs5Fl
         PdsxfQdBWjn0wER9nkqHGg9GWulaoIUiC9rYoVVT3QDA3ikol8WVraZDZ3vzvMQV3b0/
         eQCFPDpwNzVfSFxGIuxtv82StryjyV47EC1TRmn6YKdyDq5Seyd4opgN4NOTkDFwRyoe
         VDo1j77dG/z6908CcJTpjav7FVQ+PgsosNt+mgJtmOD68KGXXwZMt0U5GRSTO0xYdfaM
         qnggo6q2NwijbRGxFKVIqajd4SggpyQqUCL8z0qSNK4Aui43MaFiQDD8DtvUSOXbt9vI
         a9cw==
X-Gm-Message-State: AOAM532vbt6oAnK+jWfRUqWbrmzW0prjo9BFIuI5onW/W58NSJCXxpCq
        YyUzAkoh9caCkJGfH6QXpieYHA==
X-Google-Smtp-Source: ABdhPJy6VAzUdMHjmM9Bjj76EdaHRGQ3Fcq/somFxW7PYveDUIo2Nfd4WNv1zbQJP4D8zyGmnHeZwQ==
X-Received: by 2002:a63:3d8c:: with SMTP id k134mr1126408pga.394.1632771079890;
        Mon, 27 Sep 2021 12:31:19 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p13sm17829313pff.73.2021.09.27.12.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 12:31:19 -0700 (PDT)
Date:   Mon, 27 Sep 2021 19:31:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     gregkh@linuxfoundation.org
Cc:     dje@google.com, mathieu.desnoyers@efficios.com,
        pbonzini@redhat.com, pefoley@google.com, shakeelb@google.com,
        tglx@linutronix.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: rseq: Update rseq when processing
 NOTIFY_RESUME on xfer" failed to apply to 5.10-stable tree
Message-ID: <YVIcAy/nf+0bBdqG@google.com>
References: <1632660262120183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1632660262120183@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 26, 2021, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

5.10 backport sent: https://lkml.kernel.org/r/20210927192846.1533905-1-seanjc@google.comb
