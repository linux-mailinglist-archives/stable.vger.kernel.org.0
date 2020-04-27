Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96FF1BAD47
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 20:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgD0Sxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 14:53:31 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:35519 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbgD0Sxb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Apr 2020 14:53:31 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 499v7F67ftz9v1gf;
        Mon, 27 Apr 2020 20:53:29 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=SNv2hr7l; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id nAe7vz8k48q6; Mon, 27 Apr 2020 20:53:29 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 499v7F4vfDz9v1gd;
        Mon, 27 Apr 2020 20:53:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1588013609; bh=BupcFhT7ZunvDmElLbF5OwosQplCq7l5ERgMakDTm8E=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=SNv2hr7l6WlzRJjNAwVjLsVcSRhp2J0nYyRtyXj0JkozjSaskjJr1gXLKOq26Q6qK
         CUthv8BtCmAvvJ8kWVcwOYTPXguG1luFZzGDrQ/5lWO/ZMqubWxsl7Sn0Ja31zu470
         BKiljFaBlyk9cX4XnWIh0r3RjL1FoJ82upHPvxZs=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id B28B88B893;
        Mon, 27 Apr 2020 20:53:24 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id ftcAtgkAqQfa; Mon, 27 Apr 2020 20:53:24 +0200 (CEST)
Received: from pc16570vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 064538B7F6;
        Mon, 27 Apr 2020 20:53:23 +0200 (CEST)
Subject: Re: FAILED: patch "[PATCH] powerpc/mm: Fix CONFIG_PPC_KUAP_DEBUG on
 PPC32" failed to apply to 5.6-stable tree
To:     gregkh@linuxfoundation.org, mpe@ellerman.id.au
Cc:     stable@vger.kernel.org
References: <158800928720169@kroah.com>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <7c5cc5a7-99e6-6b14-2bcd-ffbdc09ac080@c-s.fr>
Date:   Mon, 27 Apr 2020 18:53:22 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <158800928720169@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 04/27/2020 05:41 PM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.6-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I think the easiest would be to apply 61da50b76b62 ("powerpc/kuap: 
PPC_KUAP_DEBUG should depend on PPC_KUAP") first.

Otherwise I can backport.

Christophe
