Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9351F5304
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 13:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgFJLVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 07:21:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbgFJLVP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jun 2020 07:21:15 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90C21204EA;
        Wed, 10 Jun 2020 11:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591788074;
        bh=Vy1uNGpCyh3WA6USKC361S2rQ3bIgdUucbjMN7/azjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XB3sMSmPStKwcCZbiYtdbjcc80l0y5WR7y4apK8+o9JokOR6gHgKEQwDzHFPMA85c
         FoCa4mEEx9ZMZAoRsv+zHWXuDbAvF/9mmVN4hLO1ZrO/iqgDUErh9zdAoFUs3ez8g3
         nU3W3qhCqAntUiYzsYf4mHoYpPfCt5U6DER3f7lQ=
From:   Will Deacon <will@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Enrico Weigelt <info@metux.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Allison Randal <allison@lohutok.net>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] arm64: acpi: fix UBSAN warning
Date:   Wed, 10 Jun 2020 12:21:08 +0100
Message-Id: <159178566875.41592.7975510364023488303.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200608203818.189423-1-ndesaulniers@google.com>
References: <CAKwvOdnBhHnhUZ9MHgqEQ4nEyzHWUH+DPV-J0KoYyWNEnsDHbg@mail.gmail.com> <20200608203818.189423-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 8 Jun 2020 13:38:17 -0700, Nick Desaulniers wrote:
> Will reported a UBSAN warning:
> 
> UBSAN: null-ptr-deref in arch/arm64/kernel/smp.c:596:6
> member access within null pointer of type 'struct acpi_madt_generic_interrupt'
> CPU: 0 PID: 0 Comm: swapper Not tainted 5.7.0-rc6-00124-g96bc42ff0a82 #1
> Call trace:
>  dump_backtrace+0x0/0x384
>  show_stack+0x28/0x38
>  dump_stack+0xec/0x174
>  handle_null_ptr_deref+0x134/0x174
>  __ubsan_handle_type_mismatch_v1+0x84/0xa4
>  acpi_parse_gic_cpu_interface+0x60/0xe8
>  acpi_parse_entries_array+0x288/0x498
>  acpi_table_parse_entries_array+0x178/0x1b4
>  acpi_table_parse_madt+0xa4/0x110
>  acpi_parse_and_init_cpus+0x38/0x100
>  smp_init_cpus+0x74/0x258
>  setup_arch+0x350/0x3ec
>  start_kernel+0x98/0x6f4
> 
> [...]

Applied to arm64 (for-next/core), thanks!

[1/1] arm64: acpi: fix UBSAN warning
      https://git.kernel.org/arm64/c/a194c33f45f8

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
