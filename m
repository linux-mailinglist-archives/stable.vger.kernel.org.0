Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D97D30CCA3
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240249AbhBBUCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 15:02:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:38228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232707AbhBBNpm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:45:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E02CF64F83;
        Tue,  2 Feb 2021 13:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273264;
        bh=l4hLyjCOCqfeAtQBJ//nj+o+ge+pv5anEw51Je3xQdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2g2071uFe/BUrL4CHt+F4NbKUcJS7fxY9aeuBpSPlSoZ3DO3ipRY5aAKd4sxxffk
         uBX5tLUg27gYVbYw40s86PRqaEiQz/lMaozmeqSZdJwnJkfCYDqhcwxXX5SZALKS24
         SGiFD2nLZQ5PoAsm2sSIUwKXQIw1zo/eYXqNAji0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yannick Fertre <yannick.fertre@foss.st.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 010/142] media: cec: add stm32 driver
Date:   Tue,  2 Feb 2021 14:36:13 +0100
Message-Id: <20210202132958.126657384@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yannick Fertre <yannick.fertre@foss.st.com>

commit eaf18a4165141f04dd26f0c48a7e53438e5a3ea2 upstream.

Missing stm32 directory to Makefile.

Signed-off-by: Yannick Fertre <yannick.fertre@foss.st.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 4be5e8648b0c ("media: move CEC platform drivers to a separate directory")
Cc: <stable@vger.kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/cec/platform/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/cec/platform/Makefile
+++ b/drivers/media/cec/platform/Makefile
@@ -10,5 +10,6 @@ obj-$(CONFIG_CEC_MESON_AO)	+= meson/
 obj-$(CONFIG_CEC_SAMSUNG_S5P)	+= s5p/
 obj-$(CONFIG_CEC_SECO)		+= seco/
 obj-$(CONFIG_CEC_STI)		+= sti/
+obj-$(CONFIG_CEC_STM32)		+= stm32/
 obj-$(CONFIG_CEC_TEGRA)		+= tegra/
 


