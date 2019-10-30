Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E542EE9792
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 09:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfJ3IGV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 30 Oct 2019 04:06:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40385 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbfJ3IGU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Oct 2019 04:06:20 -0400
Received: from mail-pl1-f197.google.com ([209.85.214.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1iPizi-0008DW-8t
        for stable@vger.kernel.org; Wed, 30 Oct 2019 08:06:18 +0000
Received: by mail-pl1-f197.google.com with SMTP id 40so1113579plf.15
        for <stable@vger.kernel.org>; Wed, 30 Oct 2019 01:06:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=L0tOiWIydj5CKljWNZmAK+aAA1mTh46IOLFAvkfBMjs=;
        b=PQbhyQvHufbvXNSDGpMLg1ee4GRzcI36Nf36pQB6ifKFOSRI535MMTKrDJbNxL6SVz
         FLW3DGuZFzcqU1n3C3/lCnUrm0XTjSW+2/UspdSRMn5bY0WubgeEzSbYfFrM6WY368kl
         yLHlsj9BaGXW470LxlCMcLkzTOGHuYVLdhUuLLYWRWiqCDkn4IBmxoLA9YcIviJeK2Pf
         Z+yeKfRWbA65OWBYmoCvCVgWbERglsEDi2sU02sbi33LgGcDcZPSxaDnQhqIUlTf83Er
         cmflmWhc19lODLoKHKp4YRbRB78mZjd+TG6KegcBjuXDBUGpOYTKOUbYRI+/Dk0HMERG
         /AHQ==
X-Gm-Message-State: APjAAAXLsmpm55G1jIy8P3jR8mTzQiN+2sYRfLYCnJ+V7B+B7iZt0lFf
        I9b3hUR2xLziK+/Tk/bn0tHvmh4+f0zPx/NsMM4VUHp2gG3hjWcSt/XVBQKSESFXSYCd47UMjNx
        Mvu8UHMm2ze7n7NIp2mmtlqn/IBGcpZCy9A==
X-Received: by 2002:a65:588e:: with SMTP id d14mr30104940pgu.56.1572422776862;
        Wed, 30 Oct 2019 01:06:16 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxjqeW/O9+0sJrDZkNWl5XuojZ9KLMO5fRYWvaW19tO/ikhUNfKG+QPqQ2zG4XhPzCTUlry1Q==
X-Received: by 2002:a65:588e:: with SMTP id d14mr30104908pgu.56.1572422776541;
        Wed, 30 Oct 2019 01:06:16 -0700 (PDT)
Received: from 2001-b011-380f-3c42-507c-6d05-b0b1-d40f.dynamic-ip6.hinet.net (2001-b011-380f-3c42-507c-6d05-b0b1-d40f.dynamic-ip6.hinet.net. [2001:b011:380f:3c42:507c:6d05:b0b1:d40f])
        by smtp.gmail.com with ESMTPSA id q7sm1739666pff.19.2019.10.30.01.06.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 01:06:15 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601\))
Subject: Re: [PATCH] x86/intel: Disable HPET on Intel Coffe Lake platforms
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <20191016103816.30650-1-kai.heng.feng@canonical.com>
Date:   Wed, 30 Oct 2019 16:06:13 +0800
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Harry Pan <harry.pan@intel.com>,
        feng.tang@intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <9CFF6CF0-9053-4206-B2C3-D286019B785F@canonical.com>
References: <20191016103816.30650-1-kai.heng.feng@canonical.com>
To:     Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
        Borislav Petkov <bp@alien8.de>
X-Mailer: Apple Mail (2.3601)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thomas,

> On Oct 16, 2019, at 18:38, Kai-Heng Feng <kai.heng.feng@canonical.com> wrote:
> 
> Some Coffee Lake platforms have skewed HPET timer once the SoCs entered
> PC10, and marked TSC as unstable clocksource as result.
> 
> Harry Pan identified it's a firmware bug [1].
> 
> To prevent creating a circular dependency between HPET and TSC, let's
> disable HPET on affected platforms.
> 
> [1]: https://lore.kernel.org/lkml/20190516090651.1396-1-harry.pan@intel.com/
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203183

Do you think it's a sane approach?

Kai-Heng

> 
> Cc: <stable@vger.kernel.org>
> Suggested-by: Feng Tang <feng.tang@intel.com>
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> arch/x86/kernel/early-quirks.c | 2 ++
> 1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> index 6f6b1d04dadf..4cba91ec8049 100644
> --- a/arch/x86/kernel/early-quirks.c
> +++ b/arch/x86/kernel/early-quirks.c
> @@ -710,6 +710,8 @@ static struct chipset early_qrk[] __initdata = {
> 	 */
> 	{ PCI_VENDOR_ID_INTEL, 0x0f00,
> 		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
> +	{ PCI_VENDOR_ID_INTEL, 0x3ec4,
> +		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
> 	{ PCI_VENDOR_ID_BROADCOM, 0x4331,
> 	  PCI_CLASS_NETWORK_OTHER, PCI_ANY_ID, 0, apple_airport_reset},
> 	{}
> -- 
> 2.17.1
> 

