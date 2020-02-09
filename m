Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C208156C2F
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 19:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbgBISmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 13:42:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:56416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727413AbgBISmU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 13:42:20 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9140E20733;
        Sun,  9 Feb 2020 18:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581273739;
        bh=r2GRFvfoRO5oBrVo3ME95fedtUMQE9GFQmW25dXijRc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YnU6fmL5AcM97QXBy9OdrbxjL8eXc/5pV4QykCYHOo5z8cB9621nqCe228jO1b0Sj
         UzrO8N3HGaO132WA+39CgtKWcSETaEWU2c+CkYtEMB3p4KnCciDmnRGmzLeLJvI0LB
         W1WM7Omc1YO0L36zbdz4RjaXsJhcp+T4UFa+TA0o=
Date:   Sun, 9 Feb 2020 13:42:18 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     pomonis@google.com, ahonig@google.com, jmattson@google.com,
        nifi@google.com, pbonzini@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: x86: Refactor picdev_write() to
 prevent Spectre-v1/L1TF" failed to apply to 4.4-stable tree
Message-ID: <20200209184218.GQ3584@sasha-vm>
References: <158124926134148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158124926134148@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 12:54:21PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.4-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 14e32321f3606e4b0970200b6e5e47ee6f1e6410 Mon Sep 17 00:00:00 2001
>From: Marios Pomonis <pomonis@google.com>
>Date: Wed, 11 Dec 2019 12:47:43 -0800
>Subject: [PATCH] KVM: x86: Refactor picdev_write() to prevent Spectre-v1/L1TF
> attacks
>
>This fixes a Spectre-v1/L1TF vulnerability in picdev_write().
>It replaces index computations based on the (attacked-controlled) port
>number with constants through a minor refactoring.
>
>Fixes: 85f455f7ddbe ("KVM: Add support for in-kernel PIC emulation")
>
>Signed-off-by: Nick Finco <nifi@google.com>
>Signed-off-by: Marios Pomonis <pomonis@google.com>
>Reviewed-by: Andrew Honig <ahonig@google.com>
>Cc: stable@vger.kernel.org
>Reviewed-by: Jim Mattson <jmattson@google.com>
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

I took in 9fecaa9e32ae ("KVM: x86: drop picdev_in_range()") as a
dependency and queued both for 4.4.

-- 
Thanks,
Sasha
