Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FA03C73E4
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 18:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhGMQNa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 12:13:30 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:54072 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhGMQNa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 12:13:30 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1626192638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iEAhZ97kc19v5KOhlPKV1kLM8SFB0YQp8RmvQDnU2XE=;
        b=ho1DbTFaxUHhnPyMnI4J3nwQKqJgz2YxEcfwiqLjGhO7y5S0KUHSdOs2GUOwfXJ9Pyb3Iu
        q/YbW5YC2PpzHzMPId0giqqpC0JVj9eT8ZIDlPrdQzEtkdEybRNifRpjp3W+GABI1/mIWz
        AuMZl42DpiU+U3gmItI17SmeK+A9g/B7N5P2uIH7VVmP0kG9coYDdDDJKYIL8hNtqfrfcU
        73NO5umljMMq/14YspwSNBJJ3Il+780PUEfu6A0XwKyJ7uFCo5dTVKJltrFk3/nOs5Eiys
        6cE9l15kKglOJ9DnaEyGIC3tTp6U+q3WrrHJxIlg7SLXo+60dw+uxqubpFaZLQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1626192638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iEAhZ97kc19v5KOhlPKV1kLM8SFB0YQp8RmvQDnU2XE=;
        b=hDJAXLk2s+jZ7ffTp+oAOk1BpiDwv7hJIrqjFX70cWZd8QVV5firdqF92WgMdwDV5kao2+
        iNWr41XxFmz1frBg==
To:     Yongxin Liu <yongxin.liu@windriver.com>
Cc:     evgreen@chromium.org, rajatja@google.com, bhelgaas@google.com,
        stable@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org,
        maz@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/apic/msi: check interupt context before reporting warning
In-Reply-To: <20210713064609.25429-1-yongxin.liu@windriver.com>
References: <20210713064609.25429-1-yongxin.liu@windriver.com>
Date:   Tue, 13 Jul 2021 18:10:38 +0200
Message-ID: <874kcychz5.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 13 2021 at 14:46, Yongxin Liu wrote:
> Affinity change can happen in both interrupt context and non-interrupt
> context. The paranoia check for interrupt target cpu is not always true
> in non-interrupt context.

Supressing the warning is just papering over a larger underlying problem
which was discussed recently already. I'm working on a fix for that
already.

Thanks,

        tglx
