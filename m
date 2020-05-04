Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A24F1C39E2
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 14:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgEDMwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 08:52:06 -0400
Received: from sonic309-20.consmr.mail.gq1.yahoo.com ([98.137.65.146]:38617
        "EHLO sonic309-20.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726404AbgEDMwG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 08:52:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1588596725; bh=iacnFiNuwClBuBYRq2lTmctydZVIx7u3n0jKyEZOUEk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=fpkuY9ADcsy8Jqv/INgR7U3mfWI3Jyo3nd4MPbZATV3MxNvWZMhxujQViW7Oh8zzwFheS3HJoXPi2/EUE5gT1rL6IWWTAegyMNs1DAmRqZaGDzIudw3Ywm2MN5+NBeAFKVuz2pyyvfZcYWyYnCZUpLJMEQu009cAslr9fzfY1FyKLF9u6BDt6TQxyjGWcCiG2i+007Q528iKJ5I/m3ouv3YVid+gQ8zo6/oSoOSAro12ePUowOtIBc49nSxmLKZmV23x4YW0MZ/JBH6xlTuLnFdh/CtjdqHKwCPGRERBfrSAMiwBF4fl4pJgni/Y7czkczxW7In8CbjzeltuvDBvdQ==
X-YMail-OSG: kemq8CUVM1ka3Kx7PDICC_ZK8IttpYfgHGCMib0gO28hmR3Ph.WvWniER294vfQ
 C_YA5FTJOYyAxDR9b15JBDNgcwiX5W8tRzqvsGc4Fszh6ShI7CP9qSBTH8bV6nFpA09ftqqNVgML
 LLi7lgSzmtTPyGl8LkKzli2xrfpbHCaBwY_jtjrAuyxzVqbE9YMhTwLzeq02WZPO0w2ye17iV1Oj
 FOIckHcI55qm.DyFsL1eo3Bt_KkUpj51poagNWRbYtcjafm_AAJMKf9q__a1j24p1LAqq5kYLwz3
 7aUXEokiG6l.wENXqcIkdo71cxpEm9wsFS6bDd5hSlFaL8zQ3GyNni3DeTtr39scD8MLMwhzx9fm
 Y6Cl9cBkwKzxtlpBlr_KZlcZp008IJoHFiPcMdMYnPpo60HyYB6FZbE69YHl4P0zU5YQjKgQ9Znn
 E7VEjoOwoM1us2aNRIUZOqmccxhDynjrOyuj12XzMb5WnPPAWdw_lqlGtu9dUFXeQZKA630k.uLA
 g9z8xaYX8ne.SgQ3qZEVL6biqVjTt5lO0fFfZ2z5D7wrPBNvaQObuYS7qElUSw1Taa3_jGxPAL7H
 zlPxiiq1ripscaejy.iYvJsN6xOMbabNe_GQDIBCnMkbLM26oR.Xh_44AsV98ys6xl_iJzksLZbj
 fB_lBtyk5f5OTe9yr66KZCcmr1xUcGUDav9xa.o7tNnFFSrGTv_2vDWhmiCAcv24J5OD3C2jMTO7
 VmOEsGCcasGlaCw3XwEc7O2nS75bQUr6qBovIwUa5h3ryCV9cJEve0lNH1Xe454xg5O_sjRoaio8
 8fidBSt0OyhL_SFFmCcP.sUuQbV1O31efS2ib4FaFav7z4OK25Mt3rIfgzESE02HLZwJKBV9FFwV
 PMe4.T7rTh2ljt68UG6Ul2V.RSayNKLmqHbsCrjbitVx_RAFFaibaCE0nHiMKXwGqhvhGrZnJ0Em
 yoPmSz4W56wp81VlEN0r.6NnqOnqFABT3l_EIg3hddDh1_Qwp1HOJnFTZV6Pcmd5w9NQps1Ua4M0
 G2UFrDp3gQdqoBs5.hsNZLb7yUumvHSVfQKUzLd4gaJ3vbQWsz3Cqw3Ime0_6M04zo7LFlW_02uF
 NZvt.m.6dMzZb8A8pwWpkMkty.93syFbcpETduw7m6.tm38kj16LKJXeK4C4kbqFr3JIRgBlHnoh
 1AiIfRR1mc_6RG1AMNEP1cZexBIyjMj9xcaa79_Bt1_VU9eltd6aCJiQ4z.Y1tCUyzROeGUI2IBQ
 iRjEzX0434yo5o3brv42CFzFe4wNcFXCayilvmYShM0.7uioRr6DZCQOy0bY9XLb.4Zo1ZHY-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.gq1.yahoo.com with HTTP; Mon, 4 May 2020 12:52:05 +0000
Date:   Mon, 4 May 2020 12:52:04 +0000 (UTC)
From:   ABDUL MAJID <majidabdul55@aol.com>
Reply-To: majidabdul70@aol.com
Message-ID: <837319590.820893.1588596724866@mail.yahoo.com>
Subject: Hello Dear.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <837319590.820893.1588596724866.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15756 YMailNodin Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DR.ABDUL MAJID
AUDITING AND ACCOUNTING MANAGER,
AFRICAN DEVELOPMENT BANK
50-54 RUE DE THOMPSON,
OUAGADOUGOU, BURKINA FASO, WEST AFRICA
 
Dear Friend,
 
Greetings and how are you doing?
 
I want you to be my partner in the transfer of the sum of $38.6
Million dollars discovered in my department in a Bank here in West
Africa and I will give you more details on this when I get your reply
but be rest assured that I will give you 40% of the total sum once the
transfer is completed but you have to maintain secrecy of this deal if
you are ready to work with me.
 
Yours Sincerely,
 
Dr.Abdul Majid
Auditing and Accounting Manager.
