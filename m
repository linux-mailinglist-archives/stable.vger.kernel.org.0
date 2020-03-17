Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1F9B188344
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 13:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgCQMLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 08:11:31 -0400
Received: from sonic316-53.consmr.mail.ne1.yahoo.com ([66.163.187.179]:40211
        "EHLO sonic316-53.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726695AbgCQMLa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 08:11:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1584447089; bh=kcevCRoll2+Bsa3FDERpIV72LVcB1A4YV1b5N2AWYBk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=KCMlqjzzwS7inRC819loJS79mPsbkcFh304PAb108zZwC6pa8gLSwkQOksaUWCmP+DDcCZXF52527CmULpQ7BdSVkRvhUJMiVtnhmbC6psyu1gxYdCDQpVpfDeKnOh3/XDytGvhawq4PyZIBVX+wEvjRMk/56f1N94IPcKrSBIpS/0DLdnRtxGHw/FNjso/PBdeRhWRS9sQgDrVl5+tEASVIwm8jp8JWC8ugClr7LMOO3LOjAmg2UFQb2Sahl+KPsuJY7O8AhrKSA4JwwX0GH6Gk6PktJfj5KQ3w1pf43N7SjCqaVRWwwnWe8Z7v8Sw0RjsIoITDOH3HO6mtQxOXFw==
X-YMail-OSG: nwaTrt4VM1lDCPW_4pvlmdHAB4HAd8ObDxV2jblZS5yJaml5hQx8to41jpdTr.o
 6JoVPGukrqUvVKYJ6gZYVzuWzDI52hq6Rw5fdAZ_zBaw9aFChlLxFmd4omp.bcI2uxUdM.BDzeeN
 Y_hvEBIpkCPoCAm66xPD5jIBbZ0cj1xcDHRWJMhmt9MqOg27xEYgrfkdayuDTydo1p_1KfrBOEw3
 Cs5s1LGFDulJy2mMdarisTNG79jsqOxAN9t.nKTAkBRFiLCEOWQu2ZsECPjSbs9vvbocqSMdfwK8
 zkGSsD4wlCb8YiptM2I8udid3A4XpHHFbO6bqpfFSvKVY4J_FUMqZdiPniOBuzEGY.p6tuzAEmQR
 9whpr9f7kh9EQfFTTD.9l3nbDMjfplK_aik6oYKaNchOx1SygPXhjMKQnKk.AZOH2VlFT5_cMKpH
 Dr12NC9pKhCSOY0Ly4w.jvNAVjZYC9q1hO1G3Lmbn2.z8DfYfFOop5oZaBOJ7P6M4_dHZEOgoLrb
 baIsLMPAgID1yYPnNkmAy6SujtaA2q5SGYm3Aoq8Khb4HipsTrzoPuSzUM_Wy4Vk.J5_ecFkZSnx
 UDV4uwrsNL5hjpS9Dvk9hbcI2BhQ3RQs4HRNwUq24mvpmJL8onC2W2oH5Ib2HPgWr6tPEV18EN96
 qTLFCoQxRD9cTOmSa9MHPICEbt.yISk4YVtxOgNlrRkViPOTulYpjDRM2JJVxLoTyQi1crZiDmAl
 ID0CbX4UbJJfxm0_3guinQWPXF_UqJX39mZR5vhgcfW7aTzAFlQmuRx9XC4BFQMK6TBTJY7gH7.J
 79IJZ6JEm59ol7a6IDE.BOSkOBqtlvGzjLxCGhM6RTOfPqgcwze140Faq4fLNyXu77Xmnt9VCelv
 SbKazh3MHBrHO0fxT229tWoiEh2jWvgpBWPbPZL6ghCPspCfA90g63dMDidVXeTzVaON4txUHYI2
 rkwxE_Txwv0_WBvC.201Tn3rq_6ht1MOCUqhgjg6odqY_9ghnh0j9mggywGBwXwKhqyNzjuK7N2R
 qL6gBFODLt5qfK0Sc7fN435k_R_bti4D3Jt8bPzQEirIxTOPPx_XYvrR0cCvNDS3BRJ4Mq0r7ZGc
 qxsq0_qftRTdi6jr4Um_ci22FuoesgE9L_A45Is5kpevTQ1GwtAeGpH.ytMrONuERJ70lGsBPpPg
 MtW8WIXf.aSrdetjLNQ6a6uOvAFdrPqvaqXXCB46LMU.BUe6QcaF8d7YgtDunEtzlzaG68UP5cS.
 sVt0O8vZoU.FuxFxrK3VYR4OAARNv9Z9Mf0ggKFFAJY7wvSQKRVsZKWfBpRYK7REKQ5tNpALOFNu
 iNovnZRT4ecFBHoBIRBLkfKml6oyci_bdmw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Tue, 17 Mar 2020 12:11:29 +0000
Date:   Tue, 17 Mar 2020 12:09:27 +0000 (UTC)
From:   Stephen Li <stenn6@gabg.net>
Reply-To: stephli947701@gmail.com
Message-ID: <1348826789.1834294.1584446967790@mail.yahoo.com>
Subject: REF
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1348826789.1834294.1584446967790.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15342 YMailNodin Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Greetings,
I was searching through a local business directory when I found your
profile. I am Soliciting On-Behalf of my private client who is
interested in having a serious business investment in your country. If
you have a valid business, investment or project he can invest
back to me for more details. Your swift response is highly needed.
Sincerely
Stephen Li
Please response back to me with is my private email below for more details
stephli947701@gmail.com
