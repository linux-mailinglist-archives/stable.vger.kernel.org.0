Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 964B85FB21
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 17:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbfGDPmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 11:42:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbfGDPmU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jul 2019 11:42:20 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21C76218A0;
        Thu,  4 Jul 2019 15:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562254939;
        bh=90IAYIDOi1QLPVnEcO0dm7ZhGHvdD+D6IPMs+IlKMPY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZsFy9TFiADal2GkIJAsYBiyxKopXv0CDLglzBOYTdMIt/BxyAxb8Rcg9OwHh/VjNs
         OP5Ed+OW1Lx7W9TpIc8Mx/0Cr4ZZ0qZwlgYq82LXF4bp0vwJ3cFDPRhA8+uh/YlUlI
         Ko37OfEBmK677yVVKD0e7dotTKpmZhTw7Qpp4now=
Date:   Thu, 4 Jul 2019 11:42:18 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "# 5.1.x" <stable@vger.kernel.org>,
        Kernel Build Reports Mailman List 
        <kernel-build-reports@lists.linaro.org>,
        Olof's autobuilder <build@lixom.net>
Subject: Re: stable-rc build: 78 warnings 1 failures
 (stable-rc/v5.1.16-8-g57f5b343cdf95)
Message-ID: <20190704154218.GE10104@sasha-vm>
References: <5d1dd15d.1c69fb81.90003.b2ac@mx.google.com>
 <CAK8P3a1aTHOGOgRjHgFHS+vuDV2Kv2aY7-bEUBa2nx5aF_vVCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAK8P3a1aTHOGOgRjHgFHS+vuDV2Kv2aY7-bEUBa2nx5aF_vVCA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 04, 2019 at 01:46:36PM +0200, Arnd Bergmann wrote:
>> arch/arm/mm/init.c:471:13: warning: unused variable 'itcm_end' [-Wunused-variable]
>> arch/arm/mm/init.c:470:13: warning: unused variable 'dtcm_end' [-Wunused-variable]
>
>Please backport this to 5.1-stable:
>
>e6c4375f7c92 ("ARM: 8865/1: mm: remove unused variables")

It's not in mainline yet.

>> include/linux/module.h:132:6: warning: 'init_module' specifies less restrictive attribute than its target 'rp_init': 'cold' [-Wmissing-attributes]
>
>Please backport this to all stable kernels (2.6.39+):
>
>423ea3255424 ("tty: rocket: fix incorrect forward declaration of 'rp_init()'"

I've queued this one for all trees, thanks.

--
Thanks,
Sasha
