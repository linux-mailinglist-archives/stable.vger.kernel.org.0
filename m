Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B95F8319317
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 20:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhBKT24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 14:28:56 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:32261 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229935AbhBKT2z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 14:28:55 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4Dc69T145dz9tyqv;
        Thu, 11 Feb 2021 20:28:13 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id 0uIYbOGGZPH4; Thu, 11 Feb 2021 20:28:13 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4Dc69S6gFbz9tyqt;
        Thu, 11 Feb 2021 20:28:12 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id DEAB68B837;
        Thu, 11 Feb 2021 20:28:12 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 2d4JCZKR8itp; Thu, 11 Feb 2021 20:28:12 +0100 (CET)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 947888B835;
        Thu, 11 Feb 2021 20:28:12 +0100 (CET)
Subject: Re: Reporting stable build failure from commit bca9ca
To:     David Michael <fedora.dm0@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, mpe@ellerman.id.au
References: <CAEvUa7mYi9J6qUbnUJi9=_+AXeXOopYJkZb+Z4CD9enGEQaFBQ@mail.gmail.com>
 <YCI39srMrc8dmL+p@kroah.com>
 <CAEvUa7nBGwManydNPKFqVXQUugsDzx19nPv4Y2BaxrEqe6jFww@mail.gmail.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <90159c33-4ba7-038d-48d7-2722e5a6513a@csgroup.eu>
Date:   Thu, 11 Feb 2021 20:28:05 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAEvUa7nBGwManydNPKFqVXQUugsDzx19nPv4Y2BaxrEqe6jFww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 11/02/2021 à 19:18, David Michael a écrit :
> On Tue, Feb 9, 2021 at 2:21 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Mon, Feb 08, 2021 at 04:14:44PM -0500, David Michael wrote:
>>> Commit bca9ca[0] causes a build failure while building for a G4 system
>>> since 5.10.8:
>>>
>>> arch/powerpc/kernel/head_book3s_32.S: Assembler messages:
>>> arch/powerpc/kernel/head_book3s_32.S:296: Error: attempt to move .org backwards
>>> make[2]: *** [scripts/Makefile.build:360:
>>> arch/powerpc/kernel/head_book3s_32.o] Error 1
>>>
>>> Reverting the commit allows it to build.  I've uploaded the config[1],
>>> but let me know if you need other information.
>>
>> Do you also have the same build failure in Linus's tree with this commit
>> in it?  And why not cc: the authors of the offending patch?
> 
> No, 5.11-rc7 builds correctly with the same
> https://dpaste.com/7SZMWCU89.txt olddefconfiged.  I've CCed the commit
> authors.
> 

Should be fixed by following commit:

https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git/commit/?h=next&id=3642eb21256a317ac14e9ed560242c6d20cf06d9

Christophe
