Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E194225EC4B
	for <lists+stable@lfdr.de>; Sun,  6 Sep 2020 05:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgIFDQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Sep 2020 23:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728589AbgIFDQM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Sep 2020 23:16:12 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC67020E65;
        Sun,  6 Sep 2020 03:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599362171;
        bh=uNAri1KIqnnsU5Kj7HggleAx2lvWqgUJQmlz1+Z+SjY=;
        h=Date:From:To:To:To:CC:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=y1aWFe9kytuKHIrFEd61civt7b22zqJjK7gzpWP4uW2qLdp/Fh7UQmsLkCk8Mjr6G
         YILlUvTxDPYHC4tTodazhog8mx7OeqmUUp7K8zsQHH8RGXdLv5WAs2n8lkllQ4sYe/
         cPY3HX+S/ZwBFiytJsDwV+ptrJ0u3zaKFf9pd4mk=
Date:   Sun, 06 Sep 2020 03:16:11 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Zeng Tao <prime.zeng@hisilicon.com>
To:     <gregkh@linuxfoundation.org>
CC:     Zeng Tao <prime.zeng@hisilicon.com>
Cc:     stable <stable@vger.kernel.org>
Cc:     Alan Stern <stern@rowland.harvard.edu>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] usb: core: fix slab-out-of-bounds Read in read_descriptors
In-Reply-To: <1599201467-11000-1-git-send-email-prime.zeng@hisilicon.com>
References: <1599201467-11000-1-git-send-email-prime.zeng@hisilicon.com>
Message-Id: <20200906031611.AC67020E65@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 217a9081d8e6 ("USB: add all configs to the "descriptors" attribute").

The bot has tested the following trees: v5.8.6, v5.4.62, v4.19.143, v4.14.196, v4.9.235, v4.4.235.

v5.8.6: Build OK!
v5.4.62: Build OK!
v4.19.143: Build OK!
v4.14.196: Build OK!
v4.9.235: Build OK!
v4.4.235: Build failed! Errors:
    drivers/usb/core/sysfs.c:825:11: error: implicit declaration of function 'usb_lock_device_interruptible'; did you mean 'usb_lock_device_for_reset'? [-Werror=implicit-function-declaration]
    drivers/usb/core/sysfs.c:825:11: error: implicit declaration of function 'usb_lock_device_interruptible'; did you mean 'usb_lock_device_for_reset'? [-Werror=implicit-function-declaration]
    drivers/usb/core/sysfs.c:825:11: error: implicit declaration of function 'usb_lock_device_interruptible'; did you mean 'usb_lock_device_for_reset'? [-Werror=implicit-function-declaration]
    drivers/usb/core/sysfs.c:825:11: error: implicit declaration of function 'usb_lock_device_interruptible'; did you mean 'usb_lock_device_for_reset'? [-Werror=implicit-function-declaration]
    drivers/usb/core/sysfs.c:825:11: error: implicit declaration of function 'usb_lock_device_interruptible'; did you mean 'usb_lock_device_for_reset'? [-Werror=implicit-function-declaration]
    drivers/usb/core/sysfs.c:825:11: error: implicit declaration of function 'usb_lock_device_interruptible'; did you mean 'usb_lock_device_for_reset'? [-Werror=implicit-function-declaration]
    drivers/usb/core/sysfs.c:825:11: error: implicit declaration of function ‘usb_lock_device_interruptible’ [-Werror=implicit-function-declaration]
    drivers/usb/core/sysfs.c:825:11: error: implicit declaration of function ‘usb_lock_device_interruptible’ [-Werror=implicit-function-declaration]
    drivers/usb/core/sysfs.c:825:11: error: implicit declaration of function 'usb_lock_device_interruptible'; did you mean 'usb_lock_device_for_reset'? [-Werror=implicit-function-declaration]
    drivers/usb/core/sysfs.c:825:11: error: implicit declaration of function 'usb_lock_device_interruptible'; did you mean 'usb_lock_device_for_reset'? [-Werror=implicit-function-declaration]
    drivers/usb/core/sysfs.c:825:11: error: implicit declaration of function ‘usb_lock_device_interruptible’ [-Werror=implicit-function-declaration]
    drivers/usb/core/sysfs.c:825:11: error: implicit declaration of function ‘usb_lock_device_interruptible’ [-Werror=implicit-function-declaration]


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
