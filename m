Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770D541C540
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 15:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344035AbhI2NMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 09:12:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344018AbhI2NMt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Sep 2021 09:12:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3762461407;
        Wed, 29 Sep 2021 13:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632921068;
        bh=y7oSv0Zt6pe3/Qt3nArX9bWdZBkd3cvha4kEdcajIb4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t0ahZ1hglVQvI9onTUW/YmmTpNgxXmZnAQAO4OzrgBHyrTRkvtKdh4sT8slMQ2UGG
         gCJ2EMoP28p3adQGJTQvn97oNIK95760sWzF8d0xP/O3qATagLq5JmD07UOtC1d36b
         TQUe1pe3IsIq1StlcgIxFJvzdCY0coFBd2+rUzVaqi9SD2CnwOZW+hWnE/Ue2TQ4p4
         pqvHaeUZ4R6IsdKlVzZzBjlfTlVr4/EYMU//ECzalzUhibQ5DdL67HgHoZtAJgPfBA
         +4mP5KhVBnbRYFdxdKBt1cOniofAiy7Re2P6rpes6UT1q6UT7dGTDP4iSkGsHX3PF0
         2wCxsB6y63Naw==
Date:   Wed, 29 Sep 2021 06:11:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     x86@kernel.org
Cc:     jose.souza@intel.com, hpa@zytor.com, bp@alien8.de,
        mingo@redhat.com, tglx@linutronix.de, kai.heng.feng@canonical.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org, rudolph@fb.com,
        xapienz@fb.com, bmilton@fb.com, paulmck@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/intel: Disable HPET on another Intel Coffee Lake
 platform
Message-ID: <20210929061107.243699c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210917024648.1383476-1-kuba@kernel.org>
References: <20210917024648.1383476-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 16 Sep 2021 19:46:48 -0700 Jakub Kicinski wrote:
> My Lenovo T490s with i7-8665U had been marking TSC as unstable
> since v5.13, resulting in very sluggish desktop experience...

Where do we stand? Waiting for tglx to refactor PC10 detection and use
that, or just review delay?

> +++ b/arch/x86/kernel/early-quirks.c
> @@ -716,6 +716,8 @@ static struct chipset early_qrk[] __initdata = {
>  		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
>  	{ PCI_VENDOR_ID_INTEL, 0x3e20,
>  		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
> +	{ PCI_VENDOR_ID_INTEL, 0x3e34,
> +		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
>  	{ PCI_VENDOR_ID_INTEL, 0x3ec4,
>  		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
>  	{ PCI_VENDOR_ID_INTEL, 0x8a12,

