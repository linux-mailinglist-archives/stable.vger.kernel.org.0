Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0305422FB55
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 23:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgG0VYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 17:24:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbgG0VYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 17:24:45 -0400
Received: from localhost (unknown [13.85.75.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C24920A8B;
        Mon, 27 Jul 2020 21:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595885085;
        bh=poZUDKW4Rt0IyGKuKuCOb0ovvNz/SRK+OoKvOS8wp+s=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=B9wieUB2+jYqqBxpSpGZJg/ollGGI4PPx8rF3at8poPXG7TFKrzv2vN/bFkNpOX1N
         Qa56+cgr0jW3EfJXGcwur5r/n/mYYFU2Pc1Vee1nKNtwIpNux/9P1zzDN5RNoxCOkk
         e2VRZAkiPiriB55fq2+2FHspzK+MD49Yd4nIvTK4=
Date:   Mon, 27 Jul 2020 21:24:44 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 05/19] fs/kernel_read_file: Remove FIRMWARE_EFI_EMBEDDED enum
In-Reply-To: <20200724213640.389191-6-keescook@chromium.org>
References: <20200724213640.389191-6-keescook@chromium.org>
Message-Id: <20200727212445.4C24920A8B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 548193cba2a7 ("test_firmware: add support for firmware_request_platform").

The bot has tested the following trees: v5.7.10.

v5.7.10: Build failed! Errors:
    drivers/firmware/efi/embedded-firmware.c:25:38: error: static declaration of ‘efi_embedded_fw_list’ follows non-static declaration
    drivers/firmware/efi/embedded-firmware.c:26:33: error: static declaration of ‘efi_embedded_fw_checked’ follows non-static declaration
    drivers/firmware/efi/embedded-firmware.c:25:38: error: static declaration of ‘efi_embedded_fw_list’ follows non-static declaration
    drivers/firmware/efi/embedded-firmware.c:26:33: error: static declaration of ‘efi_embedded_fw_checked’ follows non-static declaration
    drivers/firmware/efi/embedded-firmware.c:25:38: error: static declaration of ‘efi_embedded_fw_list’ follows non-static declaration
    drivers/firmware/efi/embedded-firmware.c:26:33: error: static declaration of ‘efi_embedded_fw_checked’ follows non-static declaration
    drivers/firmware/efi/embedded-firmware.c:25:38: error: static declaration of ‘efi_embedded_fw_list’ follows non-static declaration
    drivers/firmware/efi/embedded-firmware.c:26:33: error: static declaration of ‘efi_embedded_fw_checked’ follows non-static declaration


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
