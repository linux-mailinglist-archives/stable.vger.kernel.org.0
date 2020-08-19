Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652C524AA5B
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 01:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgHSX6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 19:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbgHSX4h (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 19:56:37 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90C3F20B1F;
        Wed, 19 Aug 2020 23:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881396;
        bh=95eHrYkAN34bwk2zQZmOyD2HRv92Shs9u6NAKUbcWZM=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=qmBS/vEkZzGDUWb5FWIYZ4saIU35mm9apjQav/s4yWlEhW+qbtJfG/ffZNHGYfifW
         KHDXDP4os9ZI26X5GLjZQtUzcanrdXpq7zGx5vRw5Z1tWYk9RbmfiBKa68QZSCM1Mk
         QrymejrS4bBWOqhIKLtRtMkYVWkA1sz5CJtsLP/8=
Date:   Wed, 19 Aug 2020 23:56:36 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au
Cc:     Nathan Lynch <nathanl@linux.ibm.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 3/4] powerpc/memhotplug: Make lmb size 64bit
In-Reply-To: <20200806162329.276534-3-aneesh.kumar@linux.ibm.com>
References: <20200806162329.276534-3-aneesh.kumar@linux.ibm.com>
Message-Id: <20200819235636.90C3F20B1F@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.1, v5.7.15, v5.4.58, v4.19.139, v4.14.193, v4.9.232, v4.4.232.

v5.8.1: Build OK!
v5.7.15: Build OK!
v5.4.58: Build OK!
v4.19.139: Failed to apply! Possible dependencies:
    Unable to calculate

v4.14.193: Failed to apply! Possible dependencies:
    Unable to calculate

v4.9.232: Failed to apply! Possible dependencies:
    1a367063ca0c ("powerpc/pseries: Check memory device state before onlining/offlining")
    25b587fba9a4 ("powerpc/pseries: Correct possible read beyond dlpar sysfs buffer")
    333f7b76865b ("powerpc/pseries: Implement indexed-count hotplug memory add")
    753843471cbb ("powerpc/pseries: Implement indexed-count hotplug memory remove")
    943db62c316c ("powerpc/pseries: Revert 'Auto-online hotplugged memory'")
    c21f515c7436 ("powerpc/pseries: Make the acquire/release of the drc for memory a seperate step")
    e70d59700fc3 ("powerpc/pseries: Introduce memory hotplug READD operation")
    f84775c2d5d9 ("powerpc/pseries: Fix build break when MEMORY_HOTREMOVE=n")

v4.4.232: Failed to apply! Possible dependencies:
    183deeea5871 ("powerpc/pseries: Consolidate CPU hotplug code to hotplug-cpu.c")
    1a367063ca0c ("powerpc/pseries: Check memory device state before onlining/offlining")
    1dc759566636 ("powerpc/pseries: Use kernel hotplug queue for PowerVM hotplug events")
    1f859adb9253 ("powerpc/pseries: Verify CPU doesn't exist before adding")
    25b587fba9a4 ("powerpc/pseries: Correct possible read beyond dlpar sysfs buffer")
    333f7b76865b ("powerpc/pseries: Implement indexed-count hotplug memory add")
    4a4bdfea7cb7 ("powerpc/pseries: Refactor dlpar_add_lmb() code")
    753843471cbb ("powerpc/pseries: Implement indexed-count hotplug memory remove")
    9054619ef54a ("powerpc/pseries: Add pseries hotplug workqueue")
    943db62c316c ("powerpc/pseries: Revert 'Auto-online hotplugged memory'")
    9dc512819e4b ("powerpc: Fix unused function warning 'lmb_to_memblock'")
    bdf5fc633804 ("powerpc/pseries: Update LMB associativity index during DLPAR add/remove")
    c21f515c7436 ("powerpc/pseries: Make the acquire/release of the drc for memory a seperate step")
    e70d59700fc3 ("powerpc/pseries: Introduce memory hotplug READD operation")
    e9d764f80396 ("powerpc/pseries: Enable kernel CPU dlpar from sysfs")
    ec999072442a ("powerpc/pseries: Auto-online hotplugged memory")
    f84775c2d5d9 ("powerpc/pseries: Fix build break when MEMORY_HOTREMOVE=n")
    fdb4f6e99ffa ("powerpc/pseries: Remove call to memblock_add()")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
