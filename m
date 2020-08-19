Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8F224A961
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 00:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgHSW2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 18:28:47 -0400
Received: from sonic313-21.consmr.mail.ir2.yahoo.com ([77.238.179.188]:46820
        "EHLO sonic313-21.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726466AbgHSW2q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 18:28:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1597876125; bh=QDT11FSBX3UVcMqL/L7VsYO4wQOAHUBEusQIS5epyHo=; h=Date:From:Reply-To:Subject:References:From:Subject; b=G6l96R/gVkoCXXBhWoErKhJYeINrjpd6IytkJJrVDIXS1KCkY2dpRXgSupVB0ej1+iptxYw4j7T9BZ+5/etKRNCWF9AyYugzFZ4XMxajYyCvuoet7iz9tgALJhGPGFMUePbAW9z6OB9YqSDqEdGo6FtQWFnT1cZ2MKGRklXpbZXxDX8a4oC4XxL0GtFb+iwNrbNz9Xb6eBlDp5y12bpIgA+6HqTc5s/sgwuca6WEVZWu67gp7ng3b6iCO4ZHsplpP30SBBcCjpsi/6L3pLecFhLKwnNy0aPsLDMU4mgc0z3uLK37l5jlUEYODth6apaPym0S5a714sxKICNLtJ98Dg==
X-YMail-OSG: xawsMdgVM1nnOoIuzZBA.mRBcdHO0kW2NFHbUr.1VRXIoIGXtIA8x9TNFrf_SxO
 zkx3twyUFg.CkKw9yFVrmESiCOnXwTJw1DA2q5Jp8FfiyL_ALtVphPhnc5NSKebvG4jkCufiky2x
 GDkkAExmRnaUV9UZXax1tm24gsk440bVYeY5zgdcYrlA1bfv2Byhn2BmMP68AwWtZfpnrwx_OWyw
 6_GW1ledCsQgBAg3Fr7ozSyxgzJZF38C_karwIJlY9Vm.2refleMfMS7Qz_m7W59fPKuokaBeWpe
 jK5FCiKKOpgQZoo8f4_Beu5zObg_JOynCN6.skDVID0raCOBpCuMCTKdDCAHSgj7Pw_CdC4GI5Cw
 YsiQAyjPIwe8vdEpFilp3SXzb8oh1k6gIHKlx0s1IWgq.5nKnOMtdqoxbkv1HzuDLhIy8sPKeBCe
 B.IOJB5a8ZAiLSqRm9t2Et.TeY06_2nr0CziI1eWs47vXDqC.9s0XJy3.Ohn4cV992HbS8zPBELs
 2RTeg_o1MuqztrNiQZ2NKbMik.JNypSgFDANnRrhpg04IOIcm7Y5PBk5WNwtxfQ8RGjxK2sP6EC3
 woyDnzDV5iHGQWMp3tSoYmdhKoXrlecc6X5y2YH8UX841TtmoKDdbHdFv12ooIGFah4YBx6BmF33
 32CGk2dGAzxUDAnokEc.eIhvnbmlQLAgFwajrbW9JITQyO26EqDbvvk6CpLoMLInGzzW8ZvY4mns
 QUazGMiUz23NfZ4VYA6wBfLIJre464YlGeE2kSBKuAVKP4g4D2MVV5mToWFVKEm1AQuMYatqWSyO
 uuvKsssaO1o85cTsga79EGMdhtPmqe_4k8jS3wsAAfzx4K3DFNMbHeatu6g84yoDWNXz.EkuK91P
 jrfySy.3IuVqX.hYXo_jQrhRDpGpKUYErtgZjdAlL9sZncExghCglaTKGodShsON0_K08m3T8bPz
 WiaTi78sL1JSM.O7scfy.Hy3zR0PAQZ_MJWIIaUX5zw_qNjaxPDgzwckB5NDSzeT84.Xtc.UTTGE
 Pb5UD1pYcUi5vXXQnMoy0eA1cstna3vkrLUdah0GxZ0uc4vMcGdz3ucUy9ojeemcpv.5DxirSVWk
 qKzUgTZ0Q.VWmM_ZMiig_RxGNJF5q1NxyBxV_uoz4tPKJJk6m.7ULajwgcfUZSiItap6jpYULvxl
 0oHzCSk6DfEHJ95LR5RJK755QHhOIshFqu9j3CMJfgnvIqbYmVBOdVpTsgFg5O1tQCht25_EGWva
 p6lYAoxjOxwP1d7b0Knrn33yo2Y3me9P8HVhtxuvZL1WuPrv1ogvT2vO7JPHkSTaQJqeIbbGKHzw
 8JTnsZ2ZSXSZV8IXgyVvF78.v79Bbwh0jNwewWPqdxRHBrk2Vhjw-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ir2.yahoo.com with HTTP; Wed, 19 Aug 2020 22:28:45 +0000
Date:   Wed, 19 Aug 2020 22:28:43 +0000 (UTC)
From:   "mrs.ALICE ARTHUR" <mrs.alicearthur232@gmail.com>
Reply-To: mrs.alicearthur12@gmail.com
Message-ID: <1647906132.5348892.1597876123110@mail.yahoo.com>
Subject: DEAR FRIEND
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1647906132.5348892.1597876123110.ref@mail.yahoo.com>
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
