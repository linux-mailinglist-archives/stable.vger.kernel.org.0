Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B50B316717
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 13:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhBJMtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 07:49:47 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:41975 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhBJMsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 07:48:52 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4DbKKk2nstz1qs0V;
        Wed, 10 Feb 2021 13:47:38 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4DbKKk0wQyz1t6pp;
        Wed, 10 Feb 2021 13:47:38 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id Ul3ytJQpfjMS; Wed, 10 Feb 2021 13:47:36 +0100 (CET)
X-Auth-Info: RuUU4Nm21+ZCGrYnw5dh1sqjchZK5Zl5bOvlUvzxcO9GF0ovy/0kftXqixYAQR7M
Received: from igel.home (ppp-46-244-165-216.dynamic.mnet-online.de [46.244.165.216])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed, 10 Feb 2021 13:47:36 +0100 (CET)
Received: by igel.home (Postfix, from userid 1000)
        id 799A32C31E1; Wed, 10 Feb 2021 13:47:34 +0100 (CET)
From:   Andreas Schwab <schwab@linux-m68k.org>
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     devicetree@vger.kernel.org, aou@eecs.berkeley.edu,
        anup@brainfault.org, Palmer Dabbelt <palmerdabbelt@google.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        yash.shah@sifive.com, robh+dt@kernel.org, sagar.kadam@sifive.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        linux-riscv@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH] Revert "dts: phy: add GPIO number and active state used
 for phy reset"
References: <20210205034112.2147142-1-palmer@dabbelt.com>
X-Yow:  Will it improve my CASH FLOW?
Date:   Wed, 10 Feb 2021 13:47:34 +0100
In-Reply-To: <20210205034112.2147142-1-palmer@dabbelt.com> (Palmer Dabbelt's
        message of "Thu, 4 Feb 2021 19:41:12 -0800")
Message-ID: <877dngjdi1.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Feb 04 2021, Palmer Dabbelt wrote:

> From: Palmer Dabbelt <palmerdabbelt@google.com>
>
> VSC8541 phys need a special reset sequence, which the driver doesn't
> currentlny support.  As a result enabling the reset via GPIO essentially
> guarnteees that the device won't work correctly.
>
> This reverts commit a0fa9d727043da2238432471e85de0bdb8a8df65.
>
> Fixes: a0fa9d727043 ("dts: phy: add GPIO number and active state used for phy reset")
> Cc: stable@vger.kernel.org
> Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>

This fixes ethernet on the HiFive Unleashed with 5.10.12.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."
