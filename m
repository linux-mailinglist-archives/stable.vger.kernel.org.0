Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B112846F1
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 09:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgJFHQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 03:16:32 -0400
Received: from sonic312-25.consmr.mail.ne1.yahoo.com ([66.163.191.206]:40305
        "EHLO sonic312-25.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725912AbgJFHQc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 03:16:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1601968591; bh=NajTNMrfMLb6UXcjRhYpYerQX8PtVBLz0oFgaMINSWY=; h=Date:From:Reply-To:Subject:References:From:Subject; b=RcWdhIrmDDCTISr2kcrbsjS+wdBGdsiMOd+Vz7RyXK0yOC/dKyhaZ7oDaKTprxsiAHzf0QkZsoHoV+RhEe+h9p+oex1lQNb/0NLo2l25b5z9iVYXee1K4LM2fiJivZXTdANRvou1E7DZgsfrHXzTzv28kSvEdT08RCUn9L71l83hlInQ21vGD8d7ATfms5DfqrTpa/Q6plhAj+qVEMMaLh+tuiuZJlzawz/tVj0iSOS77wCabIx2pbx7DVHXHvbjOdccBmf8hYDwSF4Mzq/c5i9Tk0vnTRG3Voaxkn7J2dQq4f62UyuJJMLhj+5MzkiMTxe3OuI6iIdO52i3X9FlUw==
X-YMail-OSG: gY7Np10VM1kroi2QMh0WcrxKmEv0ERBsMS3XKfrnzMsgbCIjXmcpPzYRI107EZS
 ecIBwD067WR4hzJAEvoj9gy5efqbTakIP_sLGMPulym1S5alRwKviB2aLslCd_lF.LW5Sb0Y2qy5
 8mWVQBpoNVo1G4nDPU96S.Q0lzliIR0trnOSgN.k2rXajI3XMZPaYbMxXIUY3yNz45kWYevdf3Qq
 9TcOud0wxY9fv_s2u78cOiE2C2n2DypMZh2o9_12G.fN30eLwOh7jSR1EJ25GZls.wHcLQ0fTGii
 SMKQgwFzBmzH_3uJR9GfqTv2k34ao7lN8qGWt4j6B.6B9Iq5sfFA15wUqhaFgRDVTnotz6PL8TyS
 .EMqBI8eA4ivEQHajmMmoY27n_GUoUd.CXkI6T_OOcWkc2D3zATRPiUH5c1FUvGjICYvjY9gz13X
 at.iLozHnlNU6.3eg7WJOfI7ZxdNzRLqdBk53Rf.6yRrF3ZAXDEFs5qGDCsLlvaFGLet7ucENyha
 GeRcTxYy0ZW.qoXotVl0FnhSDk119bfUQbS_.9dI5iLEiJw7RTw7pTREuZbtFMrEpyeVpw7.oTHk
 f9sp6su6ocoUkI.cUHHLFYyYtipHvahiyq.wo8pGASKKWpMji5S.yxOo_B.lTWyULOknCmgDzIGw
 cxTWJg1tnT2pEahMrbJVV01O7_pJSx11wHZ3gxe9NtiIf7juvsq.XHrU35ki0kTC.QgV1t9JA3Ub
 Ypf0kidVljG8uWX6ylofLbFAJykRi6ZA29j_P2uMeZ2lv5FYPdGO9EE7mAExbNhgW29k5rDL3m6m
 IjJ9n4xqgoCZFHZHW2A14baJ1vK8hcjvGLLVthQbJEA_Jjpz916wyhdR6Cnc59Usy3vjL1raKzw8
 2X8T3Jx.RBKEQZAvlBE4.qPmrhiEXm2MT0G2hyC0Y_d3dtd0k.rJKnQN5jt8qVmICNfUnyKlajUX
 Zfrx1vZ38jLTh1Uy5go5Hzdw8daBeE2JMzQzKWx0RbvHJwLVSKkObaRPxw_iJtVaC6kLI4y_P6Ag
 ddXbBh9WjzzOtiFvDK.gtqEAxr09TsaucpzZJn5tMeyScsZkBGL.g5dTTtqSghvDu8PAFSEuR57s
 BM4VGPcn8iBFWE1_xtvSrHu.w1mlKktsIsfniaDCNbogAFcPs02m2yZy7gHRFh4_VlQQL6ohfSzv
 bL3fBRV0mFK8ZzWWflEmG3sAl2fq_QdPE3tA6wVT3SMSKM0VzwaFo2wnEJDEi5Lz8UGY..qPr7KI
 WvlXAiqa1I4use_Vc6QCropmgEBTqR8lxoGMgVJ1gHwPMp49ndshLRaTqCylHmsIMIvitQVjbJDt
 M4qhraygMlQZ8EMfS9dNum0Yi057fEMcT_mASd0DVlXsE9Yvqe1YEa3K9xd9QbCeH1rcs6wa9G2p
 KtNU2bxSl15LsVzsJynmZF3NHJNfdO5fCJW0zUm6L4C35Og--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.ne1.yahoo.com with HTTP; Tue, 6 Oct 2020 07:16:31 +0000
Date:   Tue, 6 Oct 2020 07:16:27 +0000 (UTC)
From:   Ms Lisa Hugh <lisa.hugh0000@gmail.com>
Reply-To: ms.lisahugh000@gmail.com
Message-ID: <1632008888.2403828.1601968587078@mail.yahoo.com>
Subject: BUSINESS CO-OPERATION BENEFIT(Ms Lisa Hugh).
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1632008888.2403828.1601968587078.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16718 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:81.0) Gecko/20100101 Firefox/81.0
To:     unlisted-recipients:; (no To-header on input)
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
