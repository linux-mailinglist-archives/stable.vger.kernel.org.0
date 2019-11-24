Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A0A1083C1
	for <lists+stable@lfdr.de>; Sun, 24 Nov 2019 15:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfKXOOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Nov 2019 09:14:37 -0500
Received: from sonic312-20.consmr.mail.bf2.yahoo.com ([74.6.128.82]:44625 "EHLO
        sonic312-20.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726779AbfKXOOh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Nov 2019 09:14:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1574604874; bh=E+ks7AydzaUb4ISZTuxin7s0E6gVmk5020fTLYVYB5E=; h=Date:From:Reply-To:Subject:From:Subject; b=ZU8s0AEpuZnmMErojuCXFkuWLBl93xzgZE08frpO8SRcsybeSdE6S7SH6pUS0n73sn4J0a5O7pv0SDZPcoaxMIg+/PzQzBrXu/Kn/dFQ/mMAFWMZgyUXjupGHGHSbbxmD2Ee+lHnSDi1ho7Ha38QcAhSWipbcfgspTMuI3MfipOvRXymN/AcTubDMyiWSHSMJVj8hM6viZeK81xEcvSrZ0AhDcQdIbBh14GO1pdFgRdEluSovbIvBB1pEqXnUIMjP8KjEDyyJSw/b6vRBFjBjBLG0LKVglNck4GOuy1fldhzvqKT+fXBkKY+fRS6IjF4ZyLr4uxXyCZpjz2wtIRJeg==
X-YMail-OSG: 4r5gtjoVM1kNL4SDoJ.cR.Mg31rqVJkx_2Mr70VQXDqNK3cNnZD.GrcuqW4Fygo
 GmyCkGR9.FzD3ihq2_y_LyhvW0BHNmIQnhJ7iPGflxWWZOzGzjmt8S6qtfIW94T6vP3i5eIw18i9
 FDC.5iE5IFWFNMpgsdACu06DLu_tPVWf22v4E_hXQ15ce8q5tvCDqLspd7yrZ9gTLuUNJk0qpWyk
 Liq_POJKB6uyM5rBDClV.SOABlfmGo2qUOJ9Xd3RntdHrX3JCIcuAHz.V4WH.pUkjDQGJ9KVhZkx
 Amvw_HDoHi5o85LjdbpU_QH4uMcYyPlI_80wxwsjGToMj2qOofYpHZRQcrsNuZUqdW9S.QWsbcbW
 xS6FsY6iS66qwlkGS.77B9Mfmzw3c9Px9hVJo3YGj1aSKVrPnkL44mF9bEhBLivpe_fE.CRVdaKJ
 iH9l2RmYTdjwmxZRaXMiAxbpG9VbS8YRphO8Y2pzHGsBfM3S871GuHGUzlCXVUq_NrAULi4WcDhU
 jnpY8tAyaVWN4zB29jzQaG5_FeBgRelp0ANI9hCHJwoKOMF70ZOrWpqm1PacQJootI9kuVDaitz_
 SRxWmbhmFCJEESe4WxpghkFZmbsfRULwbsabrEqxHIilBJmgdo4_oHCln_iZe0zcyvWHGe_A5B1M
 A1p6xRRS72RkKx3xKGEHPjRMIVMr2jdcnN4wJN0ieDkrk3sspk5nDw_J5yA7ICLMlllGv3C6Omrb
 1Sn_9fADaXNGCRXr57csDg6vZNEhtABxJ52QHp9h3.ChYAH70JFDhOl242iGJsbvYlLNfkf_x.N6
 Z9k9LdSIBcYiBvCdO5ongvCfjtDTT0OjNeRFe7Jd1SsM.4mT6EmjFDNUBI0hSUGzUNZoqYYl0Lus
 rlmN9hIowREqJQSKu5lDtWExshMEmSrQkHZ1N3A2Igk1V0dwt7ZTAmQ5vcWlW7k0dB2KKTNUZsyr
 nuwnPl0hM3YJKZueI7mmSakORIxSspha9goyUEKnu1aFBW1WVyxjp_H1FfhGwq8ALEceBDmcDipY
 NUGJ8eokfXa4inbegaD8L6v5w7OzzEW4vGS49WX2XbVVIQx.X.OaaytK5gQ2PNrHcpMdciKknkcT
 _b5eqn6GfdxQZ8KLDIo4Rif1FkLkpRaFJtPBzNW86LcB._YTNVH28OfO3ygkhdvUNWb9IZoaY3nY
 K8obBT.jew_fjZJz7tfavJcjOab6E.VrFDRCdo5sECf1Ey8qupp0wamD.MBTu8.f6iAtvz.CYmD1
 ckkqnP54aS1slcHkwt8ozGMKb7jpvn0zpUAeGD7DtFygA72dGvzJNnJqgQ73yHRW3jTf3b6Pu6CU
 GHIVwlKx3j9_L4wEfsFTbRlmxVKif
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.bf2.yahoo.com with HTTP; Sun, 24 Nov 2019 14:14:34 +0000
Date:   Sun, 24 Nov 2019 14:14:32 +0000 (UTC)
From:   Aisha Gaddafi <agaddafibb@gmail.com>
Reply-To: gaddafia504@gmail.com
Message-ID: <1915827318.3032794.1574604872619@mail.yahoo.com>
Subject: Dear Friend,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Friend,

I came across your e-mail contact prior a private search while in need of 
your assistance. My name is Aisha  Gaddafi a single Mother and a Widow with 
three Children. I am the only biological Daughter of late Libyan President 
(Late Colonel Muammar Gaddafi).

I have investment funds worth Twenty Seven Million Five Hundred Thousand 
United State Dollar ($27.500.000.00 ) and i need a trusted investment 
Manager/Partner because of my current refugee status, however, I am 
interested in you for investment project assistance in your country, may be 
from there, we can build business relationship in the nearest future.

I am willing to negotiate investment/business profit sharing ratio with you 
base on the future investment earning profits.

If you are willing to handle this project on my behalf kindly reply urgent 
to enable me provide you more information about the investment funds.

Your Urgent Reply Will Be Appreciated.

Best Regards
Mrs Aisha Gaddafi
(gaddafia504@gmail.com)
