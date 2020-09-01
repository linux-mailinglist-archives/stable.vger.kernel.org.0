Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E084125985A
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732041AbgIAQZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:25:36 -0400
Received: from sonic310-24.consmr.mail.ne1.yahoo.com ([66.163.186.205]:35238
        "EHLO sonic310-24.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729161AbgIAQZ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 12:25:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1598977527; bh=k1yl2EIxSlw7hhqSSNsyo3JWxJqHL9iqJXZc99K49Wc=; h=Date:From:Reply-To:Subject:References:From:Subject; b=RWgbC4HdG2X+8VOo09srjY2G3x3D1MkfKggQSiWxhJNqbWhUsT9xQLJsI2XxEnMBmeElvmO1w+qU3mTJbjVpfAmu2ckBFm7p0yVlBgJ3ax3lY0hbbaL/szayfcxeCnqkFZ1I3q5jVpIVumbcsmg4i+D0/VTQVDDJp2NS2F7BKWEUD1rt4Y2vCChDn0r+MQHpqGT6jOvPK4cC4oSWa1gkKVXV5QJn6FlXLXwfrC5cQ6JlPR8RVwb0xtu2rM7AOT3/5MlR5f6xOfXi/R3L/21sN+2VyARKeFjAbrWWKu1J7sZgYaFBst2FWvYe9mrCDJFzMJuJOvLksTFknDO+v+69uA==
X-YMail-OSG: yXwCyH8VM1llw4uymdUdRV3EVTDL8H1n3BsvtJMWL2T_nPPpOk2p.lVwa5fQPjb
 s122nHckU.CsU7e4_PFRas_Gfg4YFD1eC.hh3dbF8Tpu2MAScuWs0I01upBxyRH2paRMfoCRZWJF
 KuUoM4Lbfmq0Vk1HWttoll1Z1y6vhPtvCYb9R42uA6aCmm8jSyZmZl1_m.JMY4SzsXfKtynONDfC
 aBb2W_o.Q3pmK9A9XZ6dwx.wxG2kyqlTl9yyQ0vrP0nIyzzu_9uFgY7Mmj1AUrn930zF5Mse5JPq
 MwsZkyo1N0pMpeZR6PcET0TRjYeMZK31TZJ7eZUL7YBa7Kj4Hos2gXRAcONUXIciWsiYJF1ng4RG
 KvNx.5gPmr5kj6DawDzsbjhUrgGPUD7yacwX9nZCoPBowMCf3_rt_s7KZx.OL3p4IG.vDdyAJH2u
 zgsn2CoK5lx90clBipgvsWju1N0t_B_KSJFjLTHEsa7kizGrTVWQXNDMIn3l_TEXMMEnMnppcwSY
 U7gG0uUL2U1fVKPfNStdXDkr1w7bHTFbWwhtv90HgCILQhTMefr5wcA6Vmt0YEV3PA1WzUwEqYj2
 vEyWNzZDDL3GUjyLCGegsPppDEJIyvQBRWbtJwRUBlqw2lnmQhUE3sS6U0i0vk8EnFf.CWiGP0_F
 L8Gf6oinAPW6WV8n0kRV3hYRf4OLzIoEgdDMuxy4cv2fSU8pNnFY9wuQawl0eJn2dgq0cBLfb1xR
 saO31YY0VlIjgy1amuaB9_w5TAf6QGDlmXFTpjBHLsYJTVntGN9ravJ3fjFmVxL.Oh.Qm_TIiw.U
 fUhl18LqQ_g5tNoLlKxgKrue8TJATt.ETMeABCi7t4_8uDo.MWzqRfVamOhOzKfyplpTBW.YnhAx
 LauLNl8Q9EBk7O37to79bRd29oRtETWJkqBtm.CN4dFKOTFzVpbyYGN6RFR9Qc1bdE_DVIn64Oj5
 k02AEyCQJ0u4DXId6UaqFN4fqelSwbdri63zo5mIGA4PP48aVkewksmlc.bdzhIdjbP_tEdocCjf
 EeCt4UItzh8BILHs9rKUHdIMEAFr4Ru70_W4TLIO4XZMrXDierZrQYeZkgk8DvlYY1RSjXsYjqL9
 b2LFqVmRATJniFr6oEy4qH7MhYH2_0wbUf6H4vomhv_J7SqynS.btZg_B.qolf0ldrv.rDa4OAZl
 cXBPvctO8R9uzyeO4arbwihpxqooLCaiYpAUiH0tOXhHpW_Z0bNsHyn8OHM1knWeYD_ULNfPM_SJ
 Ht3UWioqZfqHKwoU4UM5.DnQtKpB0LO3GZm.5adcJfgJuML.Wp_yfwpHv2l0cj43FJBr7rwf4NH.
 efu1kn3spCa1h6.ToVINBEuZET2Pvm5pqwSIlCsyQD.7CUNp2qXx8zDT2dtqkgdIawqNzlTP2Vvz
 fYa2BAS3XuxZXP93pTjwx8HV689IjscgKqbhc03_M6gmKIry96wD1kO97bojFmNrQXwx2vhVDU5c
 VjSF.xA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.ne1.yahoo.com with HTTP; Tue, 1 Sep 2020 16:25:27 +0000
Date:   Tue, 1 Sep 2020 16:25:22 +0000 (UTC)
From:   "Dr. Aisha Gaddafi" <aishagaddaf0dr@gmail.com>
Reply-To: aishagaddafi2dr@gmail.com
Message-ID: <1433873550.1537759.1598977522420@mail.yahoo.com>
Subject: I WANT TO INVEST IN YOUR COUNTRY
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1433873550.1537759.1598977522420.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16565 YMailNodin Mozilla/5.0 (Windows NT 5.1; rv:52.0) Gecko/20100101 Firefox/52.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



I WANT TO INVEST IN YOUR COUNTRY

Dear Friend (Assalamu Alaikum),

Please after reading this mail try and make sure you reply and contact me with this my private email address: {aaisihagaddafi@gmail.com}

I came across your e-mail contact prior a private search while in need of your assistance. My name is Aisha Al-Qaddafi a single Mother and a Widow with three Children. I am the only biological Daughter of late Libyan President (Late Colonel Muammar Gaddafi).

I have investment funds worth Twenty Seven Million Five Hundred Thousand United State Dollar ($27.500.000.00 ) and i need a trusted investment Manager/Partner because of my current refugee status, however, I am interested in you for investment project assistance in your country, may be from there, we can build business relationship in the nearest future.

I am willing to negotiate investment/business profit sharing ratio with you base on the future investment earning profits.

If you are willing to handle this project on my behalf kindly reply urgent to enable me provide you more information about the investment funds.

Please after reading this mail try and make sure you reply and contact me with this my private email address: {aaisihagaddafi@gmail.com}

so that I will see your mail and reply you without delaying, please note once again that it is necessary that you reply me through this my private email address: { aaisihagaddafi@gmail.com } if you really want me to see your respond and interest concerning this transaction


Best Regards
Mrs Aisha Al-Qaddafi
