Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A32E322C8C
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 15:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbhBWOkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 09:40:13 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:61430 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229886AbhBWOkK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 09:40:10 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4DlMBc1zF8z9v03w;
        Tue, 23 Feb 2021 15:39:20 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id GvmprBS3eRvr; Tue, 23 Feb 2021 15:39:20 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4DlMBc0wYkz9v03t;
        Tue, 23 Feb 2021 15:39:20 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id CC93A8B81F;
        Tue, 23 Feb 2021 15:39:21 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id hGfLDZpiA6Q7; Tue, 23 Feb 2021 15:39:21 +0100 (CET)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 1520C8B80B;
        Tue, 23 Feb 2021 15:39:21 +0100 (CET)
Subject: Re: [PATCH for 5.10] powerpc/32: Preserve cr1 in exception prolog
 stack check to fix build error
To:     Greg KH <greg@kroah.com>
Cc:     fedora.dm0@gmail.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <f6d16f3321f1dc89b77ada1c7d961fae4089766e.1613120077.git.christophe.leroy@csgroup.eu>
 <YCqFn/4YuT+445xW@kroah.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <d0b1ff43-59e0-29a4-1bd0-47bcfff8effa@csgroup.eu>
Date:   Tue, 23 Feb 2021 15:39:20 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YCqFn/4YuT+445xW@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 15/02/2021 à 15:30, Greg KH a écrit :
> On Fri, Feb 12, 2021 at 08:57:14AM +0000, Christophe Leroy wrote:
>> This is backport of 3642eb21256a ("powerpc/32: Preserve cr1 in
>> exception prolog stack check to fix build error") for kernel 5.10
>>
>> It fixes the build failure on v5.10 reported by kernel test robot
>> and by David Michael.
>>
>> This fix is not in Linux tree yet, it is in next branch in powerpc tree.
> 
> Then there's nothing I can do about it until that happens :(
> 

It now is in Linus' tree, see 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3642eb21256a317ac14e9ed560242c6d20cf06d9

Thanks
Christophe
