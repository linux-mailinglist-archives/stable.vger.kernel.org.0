Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17B6253086
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 15:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbgHZNyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 09:54:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730467AbgHZNyE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 09:54:04 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A842722BF3;
        Wed, 26 Aug 2020 13:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598450043;
        bh=kU7ge/9mQ72oSrg06PTJXEX3RAeejjof4qtPaDRKe8s=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=bpI5KGjzPsjGUZY+w2ellC84h7zobWVqKQYZbEKfg/4OWpMw1MaD+j/69d8p+S7mq
         EgNpRbzFsmXl4MSKjslWgZyKuVZAh7edsrlCTs/F8yLCtrKTQak1XUKcpDrNTsEEMF
         Y29zhjyhl+Q67NaSXFDnAiAKPkES/BE03imF07+Q=
Date:   Wed, 26 Aug 2020 13:54:03 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] powerpc/pseries: Do not initiate shutdown when system is running on UPS
In-Reply-To: <20200818105424.234108-1-hegdevasant@linux.vnet.ibm.com>
References: <20200818105424.234108-1-hegdevasant@linux.vnet.ibm.com>
Message-Id: <20200826135403.A842722BF3@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 79872e35469b ("powerpc/pseries: All events of EPOW_SYSTEM_SHUTDOWN must initiate shutdown").

The bot has tested the following trees: v5.8.2, v5.7.16, v5.4.59, v4.19.140, v4.14.193, v4.9.232, v4.4.232.

v5.8.2: Build OK!
v5.7.16: Build OK!
v5.4.59: Build OK!
v4.19.140: Build OK!
v4.14.193: Build OK!
v4.9.232: Build OK!
v4.4.232: Failed to apply! Possible dependencies:
    b4af279a7cba ("powerpc/pseries: Limit EPOW reset event warnings")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
