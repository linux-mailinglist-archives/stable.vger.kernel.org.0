Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA25248205
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 11:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgHRJhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 05:37:40 -0400
Received: from sonic305-19.consmr.mail.ir2.yahoo.com ([77.238.177.81]:43220
        "EHLO sonic305-19.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726165AbgHRJhk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 05:37:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1597743458; bh=QDT11FSBX3UVcMqL/L7VsYO4wQOAHUBEusQIS5epyHo=; h=Date:From:Reply-To:Subject:References:From:Subject; b=stYQ0DRFOGlRCXJQTqSEJxNfs14/ccMwRVmjDEbPom1EH8VIZJsHjENm+lDxeaXNFT7LoG+ksEenaRyi94v8KkW3pIK6SlXkX+BN2WlDUqMFA2FIJsgXw4BZG0cmLqUnfxPv3vbltUgEyi0T0DCS88wI0Gsp4v8VUtjJSBmxHcF9EXTCbkPpKbdnAObAZwR71y1pdjum59+jUUeAdX1X/HrOZsJNmhUl26FDwy8nKfhTGVf/0H2H1LsljbmesK8sxJ5LtUuR3x0Cn++REqxcrfvDhDcqd5YX2/4SMFupD/p64GUZlaz6rwzodbDXWqSD2g/Xz8kumwwBWqPtAGY4Vw==
X-YMail-OSG: vhoZSSAVM1n54ZHRMW7V73NFlpuwNLainj1kIy0rZjHM0kbV.tw17RgPXYez3ik
 HEJodt_RBEESMGdswR3uBp7335YQCBl2jo60xLNlSN1xTr_k8_3YRiGxdeRP4PDQ.cDe6PWLbL3V
 oMwiWo13L7LBCFV94vIQlEP0YWaYaKmYm1_k9L.jL5rRc4hHLMsARMyGRzI4K4E_ObqqAJB.xb3v
 4xmuj1ufQHoUdB0Gi6DV0PrHwfsQkZIEFfMKFie7cITBXn8G.8nLN2_mrY7L2NXrd0CYp.oMC2ap
 q6Djas1Yi9hxYTT5P7sP3n73pKLsLle9yyDJqGIElWrpEe42ZleTOP0bHSVM9kBJsvWQ5DT_wK.I
 g0M0itQ4A2xtqSElMB0QQTHpsCvmbXGn9_CKk75lKhFLycMCWg4WNe3T58O9LlzhPmruqkoLR4S.
 3Tv_F1YWnZJLy0lZtM71A__Lq6e8BYDwySIcu2GmWGNQm5WmXSMFbarO_kqA3NZQ0yzt1GQha9fQ
 kB82jH3URKDOxJXnWWKt3fenmVtPHh80LNwM6V9U87xmdNGeoLU.t6wqn8A0R5HR4i9aDKk945PX
 X37zwKceObNUzFXdjvaBXfz9mOM2jgJcNCHqXSciTRisVKGgJfXzRr1HqtWHxt3aeN_09NYUYl3C
 lx2Yo23tre_8SJJ.UMMlmIh6_xg5DYtpj5Eyu3U2WX312pjOOtzlBCsobHV34.G_V78uU3PryWV6
 iHyFUH35IlDgnA2.CmCpOGAln1YrHJxC7wm7efrKC9cXxARG5VAzNGXdm_EaoHsLIUWBg.FlzvUK
 7yrkV9ptvg_7V5CuLhxWEA7GbJotjTg6k2H_7d1Pd2D2sf4i1nsSEZmE3FHS5l0doNMh8MnkQOIa
 LClZAUjzWveaS8lI8LqoQtoWa_E7ZyNZvR95PTEjFZ2rFc.SqAE9RHpCuKgmZsDHyZ2chaGBcMGJ
 HCIz8l9ZavqcWUxai.aPtIwd53OM33DAZe6cz_L_C.EA0Y2jsC72A0Q_77k8hPLkbt0IonX0gVMu
 dpvaephc9rU7D._JCXJ4nmJzXSex1IlmKZdKIu8Ewnub99s2XhW_9Onj8V6YI9iyIp4f7E78dmCg
 kuZyeUaBIVzrqqbildSdqn3k_J1.cXesE1RMXtnGq3VM9ODKHF4kuHPsWckVei_1cOKA7uku7jGR
 1mFeOqfEK2GOdsC0Ij6XKowFQjxRdmU0ewTcQQDE3MzzSy_F3qBqS9rJH9K8l9NuF9i.s.CpUSo9
 HotHIMjZPbsuAJrwO9bcz00iwaGMKqTk.UEXRg0NlupEtJ1S4uNeeE4GI9MtJDyOgdIvanxBmtBP
 nMixvoxIiB5TvlpSvxQaAsSLlB5OY7ECmURpkXCQttPfY1RMh
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.ir2.yahoo.com with HTTP; Tue, 18 Aug 2020 09:37:38 +0000
Date:   Tue, 18 Aug 2020 09:37:37 +0000 (UTC)
From:   "MRS.ALICE ARTHUR" <mrs.alicearthur232@gmail.com>
Reply-To: mrs.alicearthur12@gmail.com
Message-ID: <1372134597.4212108.1597743457897@mail.yahoo.com>
Subject: DEAR FRIEND
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1372134597.4212108.1597743457897.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16455 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



DEAR FRIEND


Compliment of the day to you. I am mrs.ALICE ARTHUR I am sending this brief
letter to solicit your partnership to transfer $9.3 Million US
Dollars.I shall send you more information and procedures when I receive
positive response From you. Please send me a message in My private
email address is ( mrs.alicearthur12@gmail.com )
Best Regards

mrs.ALICE ARTHUR.
