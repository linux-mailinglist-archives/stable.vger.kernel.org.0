Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7D3711F8D5
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 17:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfLOQT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 11:19:27 -0500
Received: from sonic303-21.consmr.mail.ne1.yahoo.com ([66.163.188.147]:38743
        "EHLO sonic303-21.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726118AbfLOQT1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 11:19:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1576426766; bh=E+ks7AydzaUb4ISZTuxin7s0E6gVmk5020fTLYVYB5E=; h=Date:From:Reply-To:Subject:From:Subject; b=NlRDeyYrfw65YV7RRcqcWBSkIguA8Jox1Vp8FaOPrKZOpM9ewmB2YH72U9+OI3rH3LBlfUkZ6jgfoFD5jg9mbdT5p/bfR/ODWTrqeREf4dzY/rmoU2+esLwa7JEJ3iuLa412lKVYiwmLxEVqTaDeWDcuXPrLgD5VOVzSmQ7lib9C5RUc9tUMYOwZuEpv+c8/FYMRzYdoR1dNXolE6ZRBcLeCZ/0lyrtGQNpn3Yfh8Il11YjXO5zBYq3DBxyIr+Bnqaw80+IenBU7vCGDMsSQgI3Cz6H7eJ2dSrMl1ee3P++6gCQ6TvRTaDKU7MZxas+SMjDQu+bNKvcb7jDEq1GVtQ==
X-YMail-OSG: 50Rj4ggVM1n3ln_YdmTa4qx.G7_4bJMC.kQYI702ZaDCCEpNkzph5.w_7W3MnrX
 ZOJmdY3mt.c3BUmhWZxzBqNp_OXpwQ9w3QUAOHeW9zx9HN1_dslDBRs9eNkS7ATnnvgj6D3Th6zX
 KUwdG7TyhiXfgl6yV.uhc4Uk38eF4K_u9gY5eE3KB6hfaDQGvFREu.FPhxJF7CCTH4e8ym8rfNGU
 N6gyodpFz.uFNOs9LLWfnnErUVtbbYmSVV1lWIMz408AFlT7894iRm.m5SrgrPyb55mGfUbWpXCY
 t0aK5aewACBSHnhyJBLEmYKu3OJZi1I_lY33_1H75v.CyyH1lNu96NjiYI41mh3Y2ko9.pld2l.f
 afd_cs2q7XUz1wp9INOWgcunamsaSk92CuRMsURid7MmRVuZeB5Kxpg7n_HKCRTLPTVqsLCcchY0
 TVFWvkftSTwBlCzqtsRCVDE_bOzpnQKzx3Uh55HGj2atlpsqp3sK.jOyf9gPUucH_ronix.ry5t2
 nNqw7__Y8nxwQlK61fObsu1lkiO2S.J50veqStJ21uRcI6wwlzCYkDhe2s6pFdhytQ00B19FLnFq
 urcvkujtVkt32sjm4Al8DyBzLUMvH9HGNzzymwh9rVm61e1qe.Q7Im6qp2MgWDJuCxsdufcb0Wwm
 FbPYpxNOeTU0.o2rmNIoDv8wOpte4KcXyYAJyM_oEwGBhHUWKp4sSZVayeieZkcFdYc2iP84iu_b
 YCCabmBBr7RuSShRPVcuOfcik4.xyzqB7t7oamtFLjLhbHzwgCvYUAeFVmuMXwW34VzO0OQ.Ue4_
 GPf73pnDvxDa1lweSATzkW8U8tfMkGUSB3jcmrAZTQg9tTwtMNR3V3OB10TQbVQVGeeJcexVRZ_B
 Frh8.Rnacoq_RHqiK_Dg69TblkqRXODrGn6lZLgmYdasmKTAkZ9Jo3kWfGPt4vsP2SLje842C_d6
 8SPZcOimVCklzpowIoa9VvU2Eju0Un34_LzOGVyUf8hj63TlUCCdIMZQVSkXWzA8y8BxiWyGECyb
 t0t0koWUAlypokKLLaKCFZehZzOfvdz5wzaWLCIbNGJAVkS7z7kvDqdcD8mqr7CSu9MKpOYXFCAB
 RacN5toGSLCk6poZtXJj5WVVO2eu9kGDgbAn9VKQw4.MxzEf8i7uSGQ8LXp.d2cvUm_zYjnSp43a
 jb9meSAChGgg3DEz89yWD_GQ5jllQOI9ws7Zqy9vJ.zHJiynWjQxf.Y1ctpCsYYn2H16UP8qrQlB
 sfljrrJTn1fiz5HB22YD3gZm6mascW534jARO6abQfpCuYBzoaaRCiOy15I7hJ5c8jaPbcvbN_Gf
 oIm2Xc0bTU2WDUZw.KVWSR7PQsLPzlz_N
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.ne1.yahoo.com with HTTP; Sun, 15 Dec 2019 16:19:26 +0000
Date:   Sun, 15 Dec 2019 16:19:24 +0000 (UTC)
From:   Aisha Gaddafi <gaddafi661@gmail.com>
Reply-To: gaddafia504@gmail.com
Message-ID: <422300716.7930446.1576426764276@mail.yahoo.com>
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
