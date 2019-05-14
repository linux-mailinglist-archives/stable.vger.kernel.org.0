Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA2861C198
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 06:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbfENE4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 00:56:06 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:60739 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbfENE4G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 00:56:06 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4535440t15z9vDc3;
        Tue, 14 May 2019 06:56:04 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=WX4o2lBX; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id qf020Pzr2Js0; Tue, 14 May 2019 06:56:04 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4535436klGz9vDc2;
        Tue, 14 May 2019 06:56:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1557809763; bh=wHlxwdUQRb7PNqRjhqUrPI2/xBziGyhB/eqdQmbMZL0=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=WX4o2lBXErnAUvP5gmgyFefsMs5fH+zlTEuzotkwKpZfKtFXI2tVfFlw7fcNIffRQ
         fEd/Ht/NqP+4UDaxDRXyJ4xVCrWBBzMXWf6m9ojdhmul/gnE2VyemvVR/lyWdEpnTa
         mcvhrhwCSO64sJE25VzY27O4H2kpp0u2IrUSVmUU=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id B62118B784;
        Tue, 14 May 2019 06:56:04 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id Q26GoHaiqG4P; Tue, 14 May 2019 06:56:04 +0200 (CEST)
Received: from PO15451 (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 4F4678B76F;
        Tue, 14 May 2019 06:56:04 +0200 (CEST)
Subject: Re: [Bug 203597] New: kernel 4.9.175 fails to boot on a PowerMac G4
 3,6 at early stage
To:     Greg KH <gregkh@linuxfoundation.org>
References: <bug-203597-206035@https.bugzilla.kernel.org/>
Cc:     linuxppc-dev@lists.ozlabs.org, erhard_f@mailbox.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <e1a6f0c2-c93a-05bd-0623-ccffa733c5a7@c-s.fr>
Date:   Tue, 14 May 2019 06:56:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <bug-203597-206035@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Could you please apply b45ba4a51cde29b2939365ef0c07ad34c8321789 to 4.9 
since 51c3c62b58b357e8d35e4cc32f7b4ec907426fe3 was applied allthought 
marked for #4.13+

Thanks
Christophe

Le 13/05/2019 à 22:18, bugzilla-daemon@bugzilla.kernel.org a écrit :
> https://bugzilla.kernel.org/show_bug.cgi?id=203597
> 
>              Bug ID: 203597
>             Summary: kernel 4.9.175 fails to boot on a PowerMac G4 3,6 at
>                      early stage
>             Product: Platform Specific/Hardware
>             Version: 2.5
>      Kernel Version: 4.9.175
>            Hardware: PPC-32
>                  OS: Linux
>                Tree: Mainline
>              Status: NEW
>            Severity: normal
>            Priority: P1
>           Component: PPC-32
>            Assignee: platform_ppc-32@kernel-bugs.osdl.org
>            Reporter: erhard_f@mailbox.org
>          Regression: No
> 
> Created attachment 282743
>    --> https://bugzilla.kernel.org/attachment.cgi?id=282743&action=edit
> kernel .config (PowerMac G4 MDD)
> 
> Trying out older kernels on the G4 MDD I noticed recent 4.9.x freeze the
> machine. Only message displayed in black letters on a white screen:
> 
> done
> found display   : /pco@f0000000/ATY,AlteracParent@10/ATY,Alterac_B@1,
> opening...
> 
> 
> It's a hard freeze, RCU_CPU_STALL_TIMEOUT does not kick in.
> 
> Tried other stable kernels, which all worked:
> 4.19.37
> 4.14.114
> 4.4.179
> 
> So I suppose it's only a 4.9.x issue. Last working 4.9.x kernel I had in
> service was 4.9.161. First one I spotted freezing was 4.9.171. A bisect gave me
> the following commit:
> 
> 1c38a84d45862be06ac418618981631eddbda741 is the first bad commit
> commit 1c38a84d45862be06ac418618981631eddbda741
> Author: Michael Neuling <mikey@neuling.org>
> Date:   Thu Apr 11 21:45:59 2019 +1000
> 
>      powerpc: Avoid code patching freed init sections
> 
>      commit 51c3c62b58b357e8d35e4cc32f7b4ec907426fe3 upstream.
> 
>      This stops us from doing code patching in init sections after they've
>      been freed.
> 
>      In this chain:
>        kvm_guest_init() ->
>          kvm_use_magic_page() ->
>            fault_in_pages_readable() ->
>               __get_user() ->
>                 __get_user_nocheck() ->
>                   barrier_nospec();
> 
>      We have a code patching location at barrier_nospec() and
>      kvm_guest_init() is an init function. This whole chain gets inlined,
>      so when we free the init section (hence kvm_guest_init()), this code
>      goes away and hence should no longer be patched.
> 
>      We seen this as userspace memory corruption when using a memory
>      checker while doing partition migration testing on powervm (this
>      starts the code patching post migration via
>      /sys/kernel/mobility/migration). In theory, it could also happen when
>      using /sys/kernel/debug/powerpc/barrier_nospec.
> 
>      Cc: stable@vger.kernel.org # 4.13+
>      Signed-off-by: Michael Neuling <mikey@neuling.org>
>      Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
>      Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
>      Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>      Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
