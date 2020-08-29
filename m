Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277C125677F
	for <lists+stable@lfdr.de>; Sat, 29 Aug 2020 14:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgH2MhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Aug 2020 08:37:11 -0400
Received: from sonic313-56.consmr.mail.ne1.yahoo.com ([66.163.185.31]:38903
        "EHLO sonic313-56.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726876AbgH2MhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Aug 2020 08:37:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1598704628; bh=NajTNMrfMLb6UXcjRhYpYerQX8PtVBLz0oFgaMINSWY=; h=Date:From:Reply-To:Subject:References:From:Subject; b=j2LY3fSEoJVGcISH9qGCr3J8WZIoZSbkmA6xF9QGjo407spWJc//WqRc8XYqkqjMWg0l4khHgjJphx80oxdUXFy1S8AbI/g+nbpXSkKHBrqrpoABXYrPccWJNx/Veylily5JoONiIlkZ8QNUWNaA4kkUZqFmNIx11AwUjUF7cJur//XZ2/4+fbMQqhpVwgdWpe+dvKOBBX1SkzKbLYcyAekO55MqhL5jYckg6EqDoZbM4D5haag8GXi+XgurHt0iQ+AF74mxw54afl0KMlxrq2SRrA16/riSmtQ7vdgoODuQ8KX3DmHUqbst2BhyqsVdwEPfZ9tHYtC12rBDUTKNzw==
X-YMail-OSG: 4EF_f4AVM1nQxW628abvVRDfXF3cSWSIRHhOMQwqqUpJxcmxGdbsS1rURkRrZoN
 RS8ewcAPdmfrVvfqGBh3HkUYvHoDIemV1xqxoIxcGriJfZgdQyF1wx07QCPo07EHv4oJmyU3yVtd
 nH_Hu_wffVfInyliueZsgqhhNKvruIWZm1XMX.92vcBHO9iW5GS3OMklRmkX7sAkbfRada3suZMt
 nW.1ZKrjnIUtMxPrhi4.LuG8TNb63m7iffypPxBrasr_l2tXbZRp5ImX7QDDRmdAaRaOllTbq5gx
 5HtUIPblyUQLHhRKNyBC5ip7oLfq0gIed5Gf3NNdiAQxp1AcPSCnEQW2EHawvK_O0403vyzOUkUL
 u9FInVrdd47fqxUQXq6XWosWrkOHYM1wcKHjxcKekSnhUsQjBj6RVLRGdn1MD_qztQysY8d3HXbU
 swlidpp2KciqhttKLqzwBzZ_p1VpLHCxcoYL58u2p66NrTp.rRaB9eXF.kjrHpSA8AJvl43dImE1
 DagR47an8sTiJuVghnIdfIhLP.lJZ0VIODSLMCeyLqNPiJytxZt.gh_8VIyIY0LHu5z3f.lRwcbc
 PVPTqrrj8iP9ofZqK2HsKCH.pSZC_okB0Du8deHyzxZXhuUlcZSLtiVR1yiOajPCMvEdVhxPQy2f
 pY5_9S4mh.drcmvVk6VaOsNtqvKD_am1jFUrn.sdCB8vm2tQvWPXK3myQGTWJVdwHo_RDrxN_oVA
 nbjQ3riA4p.w6e9BmfRKQ_zySfYI7IIivEdQhI5a0OMhGuGeO5D93fMtspNB_VRAxGHIWgwm2i7c
 ui1Wy5tY0zdAZhYkh83OpRF.8pRGxEMY31D4Dmaa2MzdDkmvTPWVJP4qHyN3V6hVDiheoZ3.8XAo
 aIpv.Z.X2wBdcnPtTg38pVupfvWEvUyhLWo4.VXI_qT7QllCy1G4yw8Llx7elw1jZYracW7J9I1W
 aWeFerZ9z8OOfWEQ_rRWIOQwBvK.xEGJqexTrCMFsLjDVGXk019apg3W1hERhnoSY7x0M592cyrb
 x7DNAcinR.hGHToDCbVwH0uSSQ.r7WhmFNT_An.trHoSccHgchqgViqXazYdcIvgLrqZUz8Hw3VV
 r.ajBkyLImLb.NdswvC6l_ooaA_mk..jlUu9UB8EcCHlBMqewgBubkw0iPe55xkJAutHlX8.okvH
 _n_D4bDtdmEn099FxQBhkvWs7nAamsXq3Eo_MutIPZzOsa0y69uuZW.RP9WG7xtQWRRu7NQnRPJG
 ZzluySiut_MAqpwUTMYFBbevC4gWqWKl2S6D_07ln8hpL340nxwn_4dHsucN3Lzn2jf_kQnpxIl6
 jA2QY.r0AGgwcnTf6IsW0ID1ej2Ke9BXyMTn5DO.fKve4d5_SrwGUO.Y4pylAAoyth9BMF0JZnCz
 tqCgMfzk6ybVhey2Wqb.IJPlp.P3nrtjE4.TWgsL6uEJ9Ab94R2R_bw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Sat, 29 Aug 2020 12:37:08 +0000
Date:   Sat, 29 Aug 2020 12:37:06 +0000 (UTC)
From:   Ms Lisa Hugh <lisa.hugh111@gmail.com>
Reply-To: ms.lisahugh000@gmail.com
Message-ID: <470719146.119130.1598704626296@mail.yahoo.com>
Subject: REPLY TO MY EMAIL FOR BUSINESS(Ms Lisa hugh).
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <470719146.119130.1598704626296.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16565 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear Friend,

I am Ms Lisa hugh, work with the department of Audit and accounting manager here in the Bank(B.O.A).

Please i need your assistance for the transferring of thIs fund to your bank account for both of us benefit for life time investment, amount (US$4.5M DOLLARS).

I have every inquiry details to make the bank believe you and release the fund in within 5 banking working days with your full co-operation with me for success.

Note/ 50% for you why 50% for me after success of the transfer to your bank account.

Below information is what i need from you so will can be reaching each other

1)Full name ...
2)Private telephone number...
3)Age...
4)Nationality...
5)Occupation ...


Thanks.

Ms Lisa hugh.
