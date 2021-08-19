Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD9E3F1883
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 13:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238256AbhHSLvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 07:51:41 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:54737 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238105AbhHSLvl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Aug 2021 07:51:41 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4Gr34l5TcZz9sVF;
        Thu, 19 Aug 2021 13:51:03 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8ARKzqg-cxod; Thu, 19 Aug 2021 13:51:03 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4Gr34l4VMRz9sV3;
        Thu, 19 Aug 2021 13:51:03 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 3ED028B764;
        Thu, 19 Aug 2021 13:51:03 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id IQcQ15z_cd96; Thu, 19 Aug 2021 13:51:03 +0200 (CEST)
Received: from [172.25.230.102] (po15451.idsi0.si.c-s.fr [172.25.230.102])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id E94A48B836;
        Thu, 19 Aug 2021 13:51:02 +0200 (CEST)
Subject: Re: [PATCH v2 0/2] Kconfig symbol fixes on powerpc
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Neuling <mikey@neuling.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     stable@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210819113954.17515-1-lukas.bulwahn@gmail.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <2784c69e-898d-3a40-a0f7-b7769a57980b@csgroup.eu>
Date:   Thu, 19 Aug 2021 13:50:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210819113954.17515-1-lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 19/08/2021 à 13:39, Lukas Bulwahn a écrit :
> Dear powerpc maintainers,
> 
> The script ./scripts/checkkconfigsymbols.py warns on invalid references to
> Kconfig symbols (often, minor typos, name confusions or outdated references).
> 
> This patch series addresses all issues reported by
> ./scripts/checkkconfigsymbols.py in ./drivers/usb/ for Kconfig and Makefile
> files. Issues in the Kconfig and Makefile files indicate some shortcomings in
> the overall build definitions, and often are true actionable issues to address.
> 
> These issues can be identified and filtered by:
> 
>    ./scripts/checkkconfigsymbols.py | grep -E "arch/powerpc/.*(Kconfig|Makefile)" -B 1 -A 1
> 
> After applying this patch series on linux-next (next-20210817), the command
> above yields just two false positives (SHELL, r13) due to tool shortcomings.
> 
> As these two patches are fixes, please consider if they are suitable for
> backporting to stable.
> 
> v1 -> v2:
>    Followed Christophe Leroy's comment and drop the obsolete select.
> 


No need to change anything now, but as your two patches are completely independent, you could have 
submitted them separately. That would have avoided to resend both when changing the first one only.
