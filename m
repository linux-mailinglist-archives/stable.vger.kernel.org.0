Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8542AC2B2
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 18:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731470AbgKIRmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 12:42:53 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:42962 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731430AbgKIRmx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 12:42:53 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4CVJH94wMnz9tyQK;
        Mon,  9 Nov 2020 18:42:45 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id l6b6qDLjhcSt; Mon,  9 Nov 2020 18:42:45 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4CVJH93DNgz9tyTH;
        Mon,  9 Nov 2020 18:42:45 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 042CC8B7C5;
        Mon,  9 Nov 2020 18:42:51 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id d3X1WSDldTiN; Mon,  9 Nov 2020 18:42:50 +0100 (CET)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id B1D5C8B7C4;
        Mon,  9 Nov 2020 18:42:50 +0100 (CET)
Subject: Re: FAILED: patch "[PATCH] powerpc/603: Always fault when
 _PAGE_ACCESSED is not set" failed to apply to 5.9-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     mpe@ellerman.id.au, stable@vger.kernel.org
References: <1604916596142143@kroah.com>
 <e53550ea-761f-14b1-f74f-627b77f7caf9@csgroup.eu>
 <20201109173707.GA2381714@kroah.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <f8aa4426-88af-6f77-17bf-60573cd95e59@csgroup.eu>
Date:   Mon, 9 Nov 2020 18:42:50 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <20201109173707.GA2381714@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 09/11/2020 à 18:37, Greg KH a écrit :
> On Mon, Nov 09, 2020 at 06:23:42PM +0100, Christophe Leroy wrote:
>> Hi,
>>
>> It does apply, but you have to increase your merge.renamelimit, that's
>> because the file name changed recently.
> 
> I do not use git to apply patches this way, I use quilt, which does not
> handle renames :)
> 
> Can you send a backported patch with the correct file rename?
> 

Ok
