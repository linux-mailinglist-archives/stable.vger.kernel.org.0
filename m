Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9221328621A
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 17:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgJGP0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 11:26:37 -0400
Received: from sonic310-24.consmr.mail.ne1.yahoo.com ([66.163.186.205]:40003
        "EHLO sonic310-24.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726138AbgJGP0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 11:26:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602084396; bh=1i59SxqEd1S24IzAGGijgbNT14gLI/TWFyZSuaW2n2U=; h=Date:From:Reply-To:Subject:References:From:Subject; b=LCvh/J6BxBZdm2ziJJUV4Z9HHoPx/C9WwAO91gri6wzdlA/wTH3JePtsDqJ7jteys+OtvwqpCbcvgpc++KFMYhpj/e7l24LVd8RVz57oNBNRx2cIbUz6+jxhIRvIFOSvrL28PsM0J2S2rv/RmwVK0yBZ1cnfQHloYbKfOPHhMhuSjvASe1n32Omph1Yjd2cjL7RIG9QmfMgz1KIOkuyZyRTyd8rfSUVMWzeyl7WF7YD99Ac6L+WGFVRJCd2sbqkXJF8RJ+7pOa7UawZ8JjYdZ558z7giIHTe/fgWU65cCs2iJ0RTKQuDHw9OdBv5SuSBfb6v4sT1UY2Hnx2bfnKGHw==
X-YMail-OSG: Emf51BwVM1mhFs5Asr4Cb4zg9rFxdBd52AK3kuuyyUxSKSshu8J.oNY.n_ItFT_
 Wx.uHyR1gwsF9lPViP6NWSlPHiVZJYtrpDaHQZnKmeUAAXmpywWIEU7kpkHvu6ncx72dkzYmyZ5J
 Jwim_EFGeLsUaN8Nnqa8f6yibEeL2PUFwBqI5zjLBBybNuvVZTBkKbeEkJr8AG2DixONLdmwN2Xu
 uj6w2tc3KOhipmGt5CJpnAqQXRiAX3m_DN7PJzGZ29il8JccHTOTAOWSacuBOP92LLVYj9R7tFUB
 fqIpSjNCksKLi3DXERaj_B5PD8OzKt3oS3qqtVgYc_dyyCtEPvHX9rJCGWC2E6.PDslY3WjIf.0G
 Xi263Q8shANEpLlfosxYJqCEt0pOmYAVvuMlEbhTcDHt3jGwFAT91pK.MsVDwbwVgCinm9UMLtIO
 XfoU_Rmg1MDZABAJIJRahcfdExxEDWTA1tjj2gQ3iea2yuqjrkJPq4._7GWI.vRBE_XIZX7z8yls
 ln5iK026IlJ00vXPYZkTVO7fGCcxpc5_XZ968EJziMEKAVblMlieF7qcZT9y4teN4H1zTI1n0NAX
 YRyAx2tpfDo.umcUcMclCRwePdEKUR3HFJ7HrG6g3ZuzGLoKgqXsDwEYgX.PLhAStW5fbePlA8vu
 NNBR6WDJ4Zw3dbNWI2Unu1kk__oUtN4IoUHdyj7B4KYPfBMbecBnT6626FE6Zd7EpbJYsv7r7j3j
 Nr8pwXUDTcFr4BXCRDfaCzqOyFp757BL7eH0fnmmbypQIo6ss1h_8zTXs06uAsPLL2onEmojKViX
 rHvtssNetyh2gncHXeKTwMzGoSte.9lvgbAi510_NlnTwwcuiOBmejlgn4Vs8TNUuxIMF7r6iuK5
 _wv7MK3jOCt.Ne5x14rXhSgDLUbo9lTKOm5iCbg..6WKpmR.xD.rijiLJBat9AEqd5SgT64yibgM
 U0fI7ZT6_6AJlO9SlkIi7fz3009bpqIUJ7DsP8TA2ZlY4uBPj94l_1hH.kUyakfnGSbwBuMaKzrW
 DQ.dBqkPK8L.l1_q32TU5QkhMncKsBvNh7QiktAgXn9SENMyf2kdl7T5_9tJA5FX.xUGFG1GtfwN
 IMDAoDWRnpqBbctk6B7GEoTbqRSiQ67bbzpQtaeydwJ4dZ2jQD.hC3VBCd8RECWbrMoRdbywT4Wl
 grwRYsIEPMZXCuOw8txr4Glmnnvg3lqLsRxKznfcUJ8lJh28e5Cbp5mV2_68b4bCD9T2_AWUvqhU
 a9SLB3fJLi1KOoMwOP0EUZcR7WAXyrFslPXfYNifRfkSCvyiRLR2uL_6c2ru6HIvO6nHkjxCJL61
 ez1WA2iLvMPU5VqLszZctQObeLEyVmZ3dsl.Zb5zmQY92ctSymucVoGdKDKD_jvSLi_QDnr5ulux
 SG4gGRBN8AnJCGBUwzEn37CentLUufnYEdMCS4JoHrafe3k8PcQ--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.ne1.yahoo.com with HTTP; Wed, 7 Oct 2020 15:26:36 +0000
Date:   Wed, 7 Oct 2020 15:26:35 +0000 (UTC)
From:   "Mr.Bennett Marcel" <bm6738965@gmail.com>
Reply-To: mr.bennettmar1960@gmail.com
Message-ID: <102414247.247968.1602084395048@mail.yahoo.com>
Subject: I need and In Investor management
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <102414247.247968.1602084395048.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16795 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:47.0) Gecko/20100101 Firefox/47.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Good Day,

I am Mr.Bennett Marcel, the Auditing and Accounting section manager in a
Bank , I have a business proposal of ( USD$8.5 Million US Dollars) to
your account for onward investment ( Hotel industries and Estate
building management,Factory and Textile Productions) or any profitable
Oriented business in your country.

All conformable documents to back up the claims will be made available
to you prior to your acceptance and as soon as I receive your return
mail. I Need you to stand as my foreign partner for investment in your
country and also next of kin to these fund am about to transfer to
you.

To enable me start the process and remittance of the fund into your
bank account successfully within 10 banking days, I need the following
information from you by e-mail:


(1) Full Names:
(2) Residential Address:
(3) Country of Residence:
(4) Age:
(5) Phone/Cell Number:
(6) Occupation:
May Almighty God Bless You!
Best Regards,
Mr.Bennett Marcel
