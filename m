Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607EC256BD3
	for <lists+stable@lfdr.de>; Sun, 30 Aug 2020 07:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgH3FBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Aug 2020 01:01:01 -0400
Received: from sonic305-35.consmr.mail.bf2.yahoo.com ([74.6.133.234]:34107
        "EHLO sonic305-35.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725825AbgH3FBA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Aug 2020 01:01:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1598763659; bh=aQBm+9Bca4ejs9ftzYnk89bfX4ekoPZ6NeQWeQKD++E=; h=Date:From:Reply-To:Subject:References:From:Subject; b=hMiOt3pfjYbQIYL1vuGJGPsJrBElG4OFie/BGxr3oU95fRk/8SXwnSwPIbo36T5rkGKo+SpCOvLVOMlE6zfk406IwaI2DKE9wqYcOdEa95DwBJxNixR+AwHv+X9/hf+5cCA/88tBYs2HzPEGK5Bcu61K8ZIFfPoG7AcDEgcXDjygozIxRhRyaUb0e0l9roKrK0ZcEfkHa5h4Dp2Kv8yhIFsVrIuqUv2DbLMEgwDYDmVA1ep0OugLvpU6CdD2mq2yjxvr+0mcp91vVKXkJ9Qo8GJa/7GhAZJtPzBsDamCuks0a020qeiuNt1Sb6tYNp9O0DDT81Fh3gZiXfKVywMtRg==
X-YMail-OSG: rm1Am_UVM1lznkkxlL0.LC1hcRfieqvUfh38pDhBxzNJgro_H2z_dh.2I.H2E.2
 3ZsoJPyqcNRf5vWBVBSSINc7LT2scqL8hJ8JXsdxX39UqrINL17iVf_8WHYJDl3vMdEHpp05lvPU
 m4XxQ04dEDRb8yZbFDXuFny45jAwLIalwg8Bv_zbnQtgbcCS4rGDrOqJZf.GI_yG4E9LwAoAiAt6
 lIYje6GgQMDaSrEGoD_4qXFAjf_HZDm5ZnJu.3bJdoTQXMCrPUud47X_LMis2m1dS0GL06UtR4Ma
 LBvezibCLcFcO.uhTXEb.o4x8u1THvBFSx6XNcqXj7xbF_pm9so823ELCvHp1R8cU2h4N.qFoSY8
 5baxN0CVhTOAhEM8plo4enzTHaHzizf2OPmPTYi84l_AehqC30t2wMFREmHD5GjTUZKy2fd__Cop
 baAuOYRdOgTzN3aP.LGKibuRIRVnbkbUWDbnOrybcHaAHY7bl9QEZZf0n2rBAx25iIFpE17ATmGs
 9lad6lPP1KbU5LLjHbIbjjl1sK3rkb91ovNcvi7nS5IGRlUqDUDYS_kDoAWBx4qylQlNsz1Cgdas
 Jsyhq9ZBAOxBDyrvr4DfW9p2jsysZi0Aql5bBQo_XbPSc36ULjQAE5EBsNi1GmTPPMsG7VQy8I6w
 pOpRVQQR1xxFYNhDT5mfZz6ZZ2PknuEu1POVArWMRmz1bRJVaG0iyBf.WoMNUU3pbAVypK3Hol27
 MzZmgbvsdqm5cAZ8jPHWPvdBpEzFO9QttEm8lDNWkyV9iKrZLYA9sCQmylg4zLHItsy8nKr49R21
 CrGRzPwEGXBpe3lWqIcw3Pf9nBaYcp.NBvhpa1WgGnwQBTUMMu6AGukzkEmNSrFIl7qEX1HwofA0
 QNITZXscFClHRGjlCw2kwiQ8I.ACDMmYO4isOgI0MAo53CLrfEuhAZ09xzYyEj8u3gbytMYP8slC
 8Tyo9u43r0v4x6x9_4_uAfjusu3uz5UiQcFLICK.MMfvvo3hWlTQpHmP_U8_h2K9gRqCaH0l_jc3
 S5IbdXaa7mG.tTa6gzBh3mWQTU9.aSMfjBJ_02070NxJNjkKHqrpwej6lZDEOQPXVUdJ54WSSAa1
 rp9c.KVS1QvCJz9hmuZ6yWVyDNtAQsl5KD39jhlYdUAi06Iikj7ZfRltKt0ZhKLF1iiurkZCGvZq
 NVjq8d922Af83kY5m.6ZyaH.sy4StkfBuaPRkJWBKN0.LPpBTIrAl72fgkXsbB_JVtwv3KxzBVQ0
 j6TSX1eNmAh.u_WkXQiaW2NULdyabkA8Lip8Usuyek3qImZohDoccd9KyfUeRO2_FDy1TrmysbRw
 BA_v0Ko2eQKRipUQ.tVkPTdXPebD3ZRT0LWf2NjGOGmeBezajTtmwCULqG5fRhwMhYJmK6.nfqK6
 pUS2QuUU_sqx9rSkfC11yLYSkqcOUuCogMMPvwQxBAXSTGnJshgco69IeGLOSEhsUGnTrga3tDtW
 wczXARA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.bf2.yahoo.com with HTTP; Sun, 30 Aug 2020 05:00:59 +0000
Date:   Sun, 30 Aug 2020 04:58:58 +0000 (UTC)
From:   "Mrs. Maureen Hinckley" <mau90@gcfta.in>
Reply-To: maurhinck5@gmail.com
Message-ID: <1156233307.262214.1598763538680@mail.yahoo.com>
Subject: RE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1156233307.262214.1598763538680.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16565 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



I am Maureen Hinckley and my foundation is donating (Five hundred and fifty=
 thousand USD) to you. Contact us via my email at (maurhinck5@gmail.com) fo=
r further details.

Best Regards,
Mrs. Maureen Hinckley,
Copyright =C2=A92020 The Maureen Hinckley Foundation All Rights Reserved.
