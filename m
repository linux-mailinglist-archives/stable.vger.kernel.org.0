Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0671F27A593
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 04:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgI1CyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Sep 2020 22:54:01 -0400
Received: from sonic303-1.consmr.mail.bf2.yahoo.com ([74.6.131.40]:44215 "EHLO
        sonic303-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726380AbgI1CyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Sep 2020 22:54:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1601261640; bh=DoOGMeT+rzDkU+yXqlGJSeN+NYryD3fNpUhnbWupp98=; h=Date:From:Reply-To:Subject:References:From:Subject; b=fOo9UAXP4QN/kMInEKx2gLE0guXUD9OLPnPTFPOQjd1mQ60cBKHSXqmAm58EBdgQdZHTe6XLuM6DC6k58KOveGtoP+Mbb7G8fc4OCx6/AUqGuBjTP9va+BaKe6hg3NfuqbVYAFOvbOmY7mce1AsA/L0ZTprmEhIDKPfzFlZEQgg6eix6rKWLLHgCCUAWO2uspFvvyetumCp0GoVmNfsSEN8yXObl8pwDfrSNdio1wupDD8QbqkpI2VEHfoW2S+YI68l6YumQ3rrM0VlRTgP478yEFoiUESI1h2n5rKVPU+2FkgnR0XXwO2qf5PX2zWBnCl7F9bdVq5Ik4S6SSr0C+A==
X-YMail-OSG: YgjJWuYVM1mxXKVNliwBWLd1zPOnSc0cnXaTTMUfR7mry81OF_CVycrIpBndeb1
 v7wT4Whk_3rZB2xLROwzaoOVgj5zHuluKEwHFe8ieTeRRYOPhhadgxyIOjGsVCUAolh.SkMnfZ7x
 AWBfCyR5LV73Q9HmzjpEXO8w8lxawY35tVsHqxG_SCLZoaMxhRes4RXmLTALo_F9tvdsjVAt7WkR
 t1cNTbBDhB4cxQ7qccUtRt_0t_Wt6RdPZoTI7IuITZ4z0J8Lvin_JpMZgRXXAxE.Be0LcrbSJkCI
 VqgN3PDI0ydFiLt8T7qbVPmbd3bAyxpYq0c4TUA_j04jKL_awizd90J8M2lhcVotKqOCvsHlsPj.
 k4p_WdmzKiD_QGeBmCWtRvpgM2zftwfdDlyEhg3irIizVLjzVY8PUEZtlWsRjd_PVcUZGoNtoPoH
 YJbg72p3z02lmVUrq4SNaUdzBERlg1NSANwxoAlh14dBks_qO218Zn9ZLeYu0WVQ63bovpYUS7tw
 1veevdhT.CzaR1_3JBrVzt9UJYjtcSPyA0uU1o13JKy4GRdpQY_SK7yeZxdzxTelFPkdN_R4EetC
 NAulmA4Jv4.of_4ifWCn22knLPL0Tzca1rQ.1DLXlrm4YBeC9jt7NaoP5YGbyq7xnbnDNY.u1wV.
 skVZCaxwRkyOU9UNYg2EEnIkrTAsVc8HafcOPBoxCcF2TnHNUW_Q.0xPcOHSInKmIilAq15o38rX
 3gtP9x0iZAvm0dLcmQbZd3ssy1ZjqPQ1mL0ZRsXRxkqrh1xLmbc2hUBZPb.gLrcOJrYlOdFAG..8
 rMPi_UFF792YAWwh6L_4_Z60HWQG8n1_UGjWw.rUpqHm3wJ2s9RmMPo3yJT5RC4MbA8V2lz7Mrmz
 IexUdmTWjv1H8jnPn._E4nbPySUBMECrBWosV7Y4Ws.YXOoOO5Uf0yN5IMb.Kb8xcnY51tmoODtq
 J6wf7e1StjyMrjMYuU7Bzy0U7r9Gax_jXe6_X_yuvolTn7AvbZ4G2SrnwRvgOhTsvIVE1Oapn6MR
 yLfo0aYDwfr.QR.r91QUxIhrSUJy376YJJMOTadj6uK8.OmK4tJQHNwHhSCA6xQDTrERRAVyChPk
 dfBcTkOPLNiHkFNKNI962U.ZfqbcS30h7GwLCav461Gt3yxi2VjO3NzA56xFjH1ZL_zSECv3O5wv
 DoHEnqVHMzyhG8r6pp40MoE4vpF5MfI1kBtplzqmYVifn9wwCi0vF0mXgL_UbDtWka4.SqBcjru4
 1djdz.MU.3nKNlmRBjGSzbeeNo3YfI5iNnV2Hm_NjmRFebYkHTnwrLY7nKG5y53FX9KTMIYBG6ci
 7Euia5FzmAXx6AlCjrzIxKZQ9Pk7U_syhk6wuGHwcDQq3tRmQaEGJkqMIuCb5ncuZLeNAfqNPOAF
 uFEV7ZjvajRy_.4IXGhhxUhqssuwM4sXUHCT13Fwt5_9LX9oD7DZnuxc0Sc0TFV3.s_8C4R6C8g4
 N2Q--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.bf2.yahoo.com with HTTP; Mon, 28 Sep 2020 02:54:00 +0000
Date:   Mon, 28 Sep 2020 02:53:57 +0000 (UTC)
From:   Sergeant Emad Alabbasi <mrschantal.sonian.kadi@gmail.com>
Reply-To: sergeantemad.alabbasi@gmail.com
Message-ID: <817146835.1308996.1601261637466@mail.yahoo.com>
Subject: Hello
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <817146835.1308996.1601261637466.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16674 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:81.0) Gecko/20100101 Firefox/81.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,
 Hope I can trust you with the huge money I recently shared with my colleague during our peace keeping mission recently in an Oil reach area in Lybia.

The sum of $13.5 million US Dollars is my share and already with the company that will bring it to you for us to share 50% for you and mine 50%. 
Kindly reply for me to tell you everything directly [sergeantemad.alabbasi@gmail.com]

Thanks

Sergeant Emad Alabbasi

