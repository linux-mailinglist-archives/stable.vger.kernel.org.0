Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E68AC153387
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 15:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgBEO7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 09:59:06 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35733 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgBEO7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 09:59:05 -0500
Received: from [212.187.182.165] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1izM8r-0003fi-57; Wed, 05 Feb 2020 15:59:01 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 3C089100C31; Wed,  5 Feb 2020 14:58:55 +0000 (GMT)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Sasha Levin <sashal@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Evan Green <evgreen@chromium.org>
Cc:     Rajat Jain <rajatja@google.com>, Rajat Jain <rajatja@google.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, Marc Zyngier <maz@kernel.org>,
        stable@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/apic/msi: Plug non-maskable MSI affinity race
In-Reply-To: <20200205144509.7004C21D7D@mail.kernel.org>
References: <87lfpn50id.fsf@nanos.tec.linutronix.de> <20200205144509.7004C21D7D@mail.kernel.org>
Date:   Wed, 05 Feb 2020 14:58:55 +0000
Message-ID: <87wo91rsgg.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha Levin <sashal@kernel.org> writes:

> Hi,
>
> [This is an automated email]
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?

Use V2 :)
