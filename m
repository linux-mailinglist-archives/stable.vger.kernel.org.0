Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B983F064B
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 16:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238970AbhHRORm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 10:17:42 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40800 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239071AbhHROP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 10:15:58 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1629296122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NSdpIbrLrHpIzNeBhXvU8ZWsmQfIv9ORq7hNFxN8vSM=;
        b=iei4/FKQN0OBTQdVoFSGm1wwo6DZVl4dZMsZh0mA64LyVK6OrZNkS1z/LRokzkEmDLmRKP
        qnFosQriT7UtzTs/Y2glmigU92F+fk0qOU0JAfZoctFWcWDwiQAsfdPYRKhjRYSn5i8o+c
        /O8lFtotG2cyjtE6LZPl4bjI1hSnPb6hFu07yooGH1F2P4bhqu44FGn7ILJf1xovlpid0L
        jHum7plopgm3UbXZVhWASF5E0Cj42SSIYvIJCJ+esWdBpsncB6fJlyFWuk5DNUuThbU8p2
        j3fAqRzet3j7nzKVzuH9/d6GonPcmmoennWev43qCUxGYSlto86j0yefXxei2Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1629296122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NSdpIbrLrHpIzNeBhXvU8ZWsmQfIv9ORq7hNFxN8vSM=;
        b=5de6KAgXVKS1qx7BCjE63/Asc4257krS/+3YRwDVIFRDkFG4+d7DDbAOpMy+TDYUkwEOER
        ubEPz/1dbDBXIjAw==
To:     gregkh@linuxfoundation.org, cuibixuan@huawei.com
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] genirq/msi: Ensure deactivation on
 teardown" failed to apply to 4.14-stable tree
In-Reply-To: <1629101069110160@kroah.com>
References: <1629101069110160@kroah.com>
Date:   Wed, 18 Aug 2021 16:15:21 +0200
Message-ID: <87pmua2612.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16 2021 at 10:04, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Hrm. My Fixes tag is going too far. Please ignore this one as the
wreckage was introduced later with the reservation mode bits.

Thanks,

        tglx
