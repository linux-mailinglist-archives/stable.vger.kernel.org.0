Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD3B1EFA1E
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgFEOLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728076AbgFEOLA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:11:00 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E85BA2074B;
        Fri,  5 Jun 2020 14:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366260;
        bh=qXMgIra7WpaA+Cld4TH+/g8/AjpoRdJsN9Dq45wDgpc=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=JSOgxfxv69WV9X2ybxw0VH/2IYYq3TNbmZXmGGynjvTc/gQn9GFiDrXSPQNXBdu0B
         Nupj9t292Kk7RK3Nek1KolXFk8hKqtxWjEik6jSjPrHXjClpkrKtPUn6mNA/SvWHpI
         q9HHdmGoBOXT1jd4rTVvRFbMHzLwWAw+Qf3Yu8Yg=
Date:   Fri, 05 Jun 2020 14:10:59 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Masahiro Yamada <masahiroy@kernel.org>
To:     linux-kbuild@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] kbuild: force to build vmlinux if CONFIG_MODVERSION=y
In-Reply-To: <20200531084707.1238909-1-masahiroy@kernel.org>
References: <20200531084707.1238909-1-masahiroy@kernel.org>
Message-Id: <20200605141059.E85BA2074B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: 2.5.71+

The bot has tested the following trees: v5.6.15, v5.4.43, v4.19.125, v4.14.182, v4.9.225, v4.4.225.

v5.6.15: Build OK!
v5.4.43: Build OK!
v4.19.125: Build OK!
v4.14.182: Build OK!
v4.9.225: Failed to apply! Possible dependencies:
    2c1f4f125159 ("kbuild: re-order the code to not parse unnecessary variables")
    312a3d0918bb ("kbuild: trivial cleanups on the comments")
    a9d9a400e075 ("kbuild: split exported generic header creation into uapi-asm-generic")

v4.4.225: Failed to apply! Possible dependencies:
    23121ca2b56b ("kbuild: create/adjust generated/autoksyms.h")
    2441e78b1919 ("kbuild: better abstract vmlinux sequential prerequisites")
    2c1f4f125159 ("kbuild: re-order the code to not parse unnecessary variables")
    2e8d696b79e9 ("kbuild: drop FORCE from PHONY targets")
    312a3d0918bb ("kbuild: trivial cleanups on the comments")
    a9d9a400e075 ("kbuild: split exported generic header creation into uapi-asm-generic")
    b9ab5ebb14ec ("objtool: Add CONFIG_STACK_VALIDATION option")
    ba79d401f1ae ("kbuild: fix call to adjust_autoksyms.sh when output directory specified")
    dd92478a15fa ("kbuild: build sample modules along with the rest of the kernel")
    fbe6e37dab97 ("kbuild: add arch specific post-link Makefile")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
