Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F181F1E642F
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 16:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbgE1OlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 10:41:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725928AbgE1OlD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 10:41:03 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94E4B20814;
        Thu, 28 May 2020 14:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590676862;
        bh=L+ma6FzEv9uQ0oyQAuoXks8htL8INZGJgrOTXK5xYfc=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=o/KvC47i3cvvgm4Mm9AcJjNlHkj96QAXKWQIP7ttQq+WOQTEHwz6bTIh2Cee9GHjA
         +VtGdd0QkROx4nDIYTgRU6Qpq7QK5KxjV3Mat9MSPb77KLUmTetkK1KY5bf+y3bJXr
         ujRZAFI3J+tzJAA5t2+dOomZG5HGJmN5RKf3mKXM=
Date:   Thu, 28 May 2020 14:41:01 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
To:     Alexander Potapenko <glider@google.com>
To:     adobriyan@gmail.com, akpm@linux-foundation.org, glider@google.com
Cc:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [patch 4/5] fs/binfmt_elf.c: allocate initialized memory in fill_thread_core_info()
In-Reply-To: <20200528052052.tLpI_z4pp%akpm@linux-foundation.org>
References: <20200528052052.tLpI_z4pp%akpm@linux-foundation.org>
Message-Id: <20200528144102.94E4B20814@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.14, v5.4.42, v4.19.124, v4.14.181, v4.9.224, v4.4.224.

v5.6.14: Build OK!
v5.4.42: Build OK!
v4.19.124: Build OK!
v4.14.181: Failed to apply! Possible dependencies:
    27e64b4be4b8 ("regset: Add support for dynamically sized regsets")

v4.9.224: Failed to apply! Possible dependencies:
    27e64b4be4b8 ("regset: Add support for dynamically sized regsets")

v4.4.224: Failed to apply! Possible dependencies:
    27e64b4be4b8 ("regset: Add support for dynamically sized regsets")
    90954e7b9407 ("x86/coredump: Use pr_reg size, rather that TIF_IA32 flag")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
