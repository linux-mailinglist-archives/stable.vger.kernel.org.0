Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5B522FB47
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 23:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgG0VYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 17:24:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgG0VYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 17:24:38 -0400
Received: from localhost (unknown [13.85.75.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E34D920A8B;
        Mon, 27 Jul 2020 21:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595885078;
        bh=poZUDKW4Rt0IyGKuKuCOb0ovvNz/SRK+OoKvOS8wp+s=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=pF8PCC7R5hMAM4xUYElDOa6IW6Kiv2M43RU7DxG/EIvccQRt6HFJkPZ8cEhfP2VKX
         pVw98AlW3hwh0W055BZc1lSWYaTOMJz7BHt509B8a3LiMoD4vrORodz8gZCMVPSzWS
         9Yd+ojyu9hTwCbth7rgMSEOShnKl+q8GTRJAzGL4=
Date:   Mon, 27 Jul 2020 21:24:37 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 01/19] test_firmware: Test platform fw loading on non-EFI systems
In-Reply-To: <20200724213640.389191-2-keescook@chromium.org>
References: <20200724213640.389191-2-keescook@chromium.org>
Message-Id: <20200727212437.E34D920A8B@mail.kernel.org>
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
