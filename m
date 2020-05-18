Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E15D1D7DF1
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 18:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgERQJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 12:09:40 -0400
Received: from sonic315-20.consmr.mail.ne1.yahoo.com ([66.163.190.146]:38740
        "EHLO sonic315-20.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727973AbgERQJk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 12:09:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1589818179; bh=TYgdp/zNeW9P5rVjVpFopjba7a+Fm8hxyemx2bQVZd8=; h=Date:From:Reply-To:Subject:References:From:Subject; b=qbq7109VonkIjXsBOdBsSphzPmGdIwzoUGT1410V2a3rRku3OWan15tXD1AQcKng6LRTyL5J7qGa4OI3Jeiuo+AlBsr8lWhcj/04VTU2M25KlF5jtzUFhDvzRxPyN6LEI19+Ueq3dDoPw1E/MCCULRJXRUb0y3ECmAhi7+Clu3Bjc28RsEBpfgwUDg6dSSw5Pw9axC9wXkD2E+E96dwQRZVw+KMUR9yksg9V3Lo11datrkoAb/VV+0COHok8lYCzxA/yEpDT/VXDKU6EldL3w1EEk3e6MVYtwnCioWRcF0pZRO6xCxJ0PtpqiwhrdhjvWWSlL0RzOtJW5iFiYrGAwA==
X-YMail-OSG: ClewnhEVM1n3PXdFkEpWkkXS0OTuTVRxz2qfymf1Ry11XHUr2zPBDypyqiddWPH
 5oYNen6_3w8.DsdXzWWBD0sJ0S0h4lZDu1ruXl9ffZ83wIxBZ9FS608eIX9.dgr12Hegv2K_3IQd
 qmlRWRUYZvNTV1jBPxNORSOMLQoflZItaB9qEmjANxJhIX.p37auyq5JKM.ox0xYOtxvuRXWy09J
 uueY9eSLhZgNJdtnqXErWzAwORpDUcMeMMrz2INfV8hbbGHKDFhWtGk9jgnzOb.c4_61ix6DE0Uc
 EpNnhX0Kfv.psBKc5PTp_m99s11k8gC4LGZHpz.mZQp4PL0ncOvS3_zVlsZeHSB6CvEPTGYlljDG
 DOrO0qGR2_xAPKL4wbxuGmifvNhDne0o4rRy6bSaQbVU2WTt9Ezju3t4Mq2EW0eXwqPExrNgElgk
 fRSHPXveZp6UoxIG1v5rgat6.zB3L3pI33Ya2af2ZQd8rZzUYY.nOFBTdEGsC7JsojqcYpCZmEhT
 RruSevqAKWcgK9grcFl8rGB1jV7pSYRYD.N.VHIBvREvK5bzenG1nJPjPvaVBvNFi8w4AVOSP_sv
 CzWTj9oivUAz0NhNNCkgNcglAwVZJ58jLXla_wgfAE4.mS2hRFEPmtgcH3a8yKftgIcaukTIgF6l
 mee6Jc7cLmCRP_GQfxVLRJAZ1cw2jRPV3J7RFA3qqUPhX1GgoPoXGcTRi.6lBderMkiChBTa2Mjn
 wH4KCLH_FmbEFIte8yA2SffQdRjRMkylOMDH.RZBOzcs2RKB_Q0bo3Dnn784HJrMr8SNHASzmtNC
 kJL2aCepzH6u74WncnkNTcTTWD2M39_FJ.d6if9XrgRmOpu.5tMumn_.ZTwIBas4JGyybGn9ylpG
 ClbaVEa8vJXqEXi9q2d1i0TaRzxuq3fLp0OKQS6www94qPrCMvrJxTX7SBXJOLSEmit4lUtEGyiw
 h6Kqk6KUBjfsv5yPN3nSyTc.duXhJWON4hgpZOkqT.4SFMa6wTwR3026HhLcP4vlL8WVKsECrlzr
 NPN.eDnR222kccukwaKnGVdbwumQX5seKQwLkFiim2sB3PseDCrw2DlthWgRUmpEQ8Lxr6wUIYfD
 tqWTzjLeEX94yT2tsmlEt3.nkdg8gyfNxipDvpfgO2ukb4lcO97I3m8L9PhC2fCTYrI6eKiHChVI
 WjaVE8IcBz8lkgihDO6_8Uve9acQJv5LkYzGRj3hBPcI895XRPdYv2yMcxBLfLlDwULvVXCDgBkq
 OxVDfe4yfshW.LAG2YJVM5sAv1WVLQQZKB1y98mcnJjg6yMIdPgpHmp73WF2AqtqmwWjoHpo1WOY
 hFPRML1nVO9YKcfu9BePKIalxIHBD6A--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.ne1.yahoo.com with HTTP; Mon, 18 May 2020 16:09:39 +0000
Date:   Mon, 18 May 2020 16:09:34 +0000 (UTC)
From:   "Mrs.mcompola" <mrs.qanbanden999@gmail.com>
Reply-To: mcompola444@gmail.com
Message-ID: <479963049.895935.1589818174329@mail.yahoo.com>
Subject: Dear Friend, My present internet connection is very slow in case
 you
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <479963049.895935.1589818174329.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15960 YMailNodin Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear Friend, My present internet connection is very slow in case you
received my email in your spam

How are you today?.With due respect to your person and much sincerity
of purpose,Well it is a pleasure to contact you on this regard and i
pray that this will turn out to be everlasting relationship for both
of us. However it's just my urgent need for a Foreign partner that
made me to contact you for this Transaction,I got your contact from
internet, while searching for a reliable someone that I can go into
partnership with. I am Mrs.mcompola, from BURKINA FASO, West
Africa .Presently i work in the Bank as bill and exchange manager.

I have the opportunity of transferring the left over fund $5.4 Million
us dollars of one of my Bank clients who died in the collapsing of the
world trade center on september 11th 2001.I have placed this fund to
and escrow account without name of beneficiary.i will use my position
here in the bank to effect a hitch free transfer of the fund to your
bank account and there will be no trace.

I agree that 40% of this money will be for you as my foriegn
partner,50% for me while 10% will be for the expenses that will occur
in this transaction .If you are really interested in my proposal
further details of the Transfer will be forwarded unto you as soon as
I receive your willingness mail for successful transfer.

Yours Faithfully,
Mrs.mcompola444@gmail.com
