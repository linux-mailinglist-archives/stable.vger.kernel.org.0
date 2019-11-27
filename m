Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A556710AB55
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbfK0Hzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:55:33 -0500
Received: from sonic307-1.consmr.mail.bf2.yahoo.com ([74.6.134.40]:35056 "EHLO
        sonic307-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726111AbfK0Hzd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:55:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1574841332; bh=vdONypa+pmkSCxMpJ481zxWsfmYXdIIKq3bhYsM38cE=; h=Date:From:Reply-To:Subject:From:Subject; b=FiAQq47RO/7oAbyzHnNPknrZlp5ggZHxd3j2TghBufZkx1wI/6pKN3p83YQJ4/CFYY77hp0W6ClIQNuhSxEIqvM3YH6HRyUu6QQR9bdf9hgKyxlzSdrFJh3fscSfhijevVg02FecIiEJ5c52QD4dLLd7O4ORW4rTdizI6eapDrT9RHdmvVnLUmrB7s4m0ZX3+oaIwpwVX2boSJnSRaVsWuPJdd2ZcrqUjtuLn5otngHTc3zUu0JJIjGb96TeFRJj41kn5Mlyr6JZwJlN5IqNeGiry/CB1gO847sYiEnsRJaupKQT6K6bajv92qYZ4y5P75OHqEF108GBNReFHmv3Pw==
X-YMail-OSG: 7SYPjIMVM1mqHYAt_SlRv1m4n7wo5jYp3EJ5SNhEa_JmSOgeVjXdAbCNxaiku62
 12THJxrxB0Oxj.Y3HxJH.rfhNslo8XWnznEHrA_BZbF4w31O2Dgl.mlmGs_6lCabml9boIqSOrWm
 34NV4YGn3zmyZ7BNrGf8W5PiPJ_G6_IO6MKq28OklMTO7.9Fcd7p800yE_j0EAdZabtL7aXqRpG0
 11Avway3qCpsODJnYjL.qekCrSSIKYX4CwffWlke0hev9r8VqEOvikXGvx2rWBKoFfcwr_yiPqW5
 qoQUs_94juciA598M.b8SLZMLFBidZKMJhG0BNZpD8LPIMGzJRVSolZBoSf.Cr.UBKV6zdIpltjm
 erob3scEOsBGS2ls4gEs7A1LHoUiSbZNZmbcqspzGTrR2Tuo8RnYU8EVHIg_euTqWkA9oMLLclsb
 ocA8DUJN8Pg26goffsqwyENcP_TBDbWvr1dai4TOzOv35tjcpDI3d5jAA8hI2gV3LdbtET7S4Tdf
 6fEag5PBzK0ZDJuK9ZOD.G3QZCBnv6o4OMn267qmALkdoj9jaJERUkYKnomyo4XSKTLswmhOSnwJ
 X3umYWB8kvSNf0Y7Lm6vnxKbpVOp5Tt53oeluTuXPwUNxlnihn0rNbZ9zc6.yOSV6V4o11TMn4sR
 HOFcqtAuSc4PXI4_govEzelyXI.HuQ3the1UFzl752Rht3egRa1iu3dN9i_aXWDRDFsKP631n9xe
 ZzwrkJr2I_jEkmN7uAMHHV0U_nc7vywMI6O7Jw0F1e54x.iNAP8lKXTi_OeCVMat2vtgTjQamhTj
 Rp0mIicxakA52ngOFWDfroA_YTPROwWHV9ITdmJLNLuMYRK.9UG.S9VVbBxeHY466fdAT66JSC2c
 r9h00SRCP.BkrdCvYyD9yo_ue0WCfa3s_hImoynupIKhfgkhCDs_I5_zu6hEMQ9UJOSxEOosWYoq
 w9l3F0LFrBB0Qrg8SCpJ4VKG0vn1G2HVnEvfbbkHUjCA3ZihHoWg.lJR0_8sLCTrQjVreDYsrFAU
 _sTvw3Kk5eRr.8xsW1dLx7UJuutafcbGgV3ToJ9ql4Bn5.Hx9VDYaaxhQ_jd61YcDi05ep2.Ot9u
 JT7YuncCDtuPLZE6krZi6h8qhmaVI5safbqe6mU0Xme.7lIq8PUI5wLdav7gwB3vZ3AupOxwf6np
 ITdVse5gEx6oaPE8Hp26.QeBLSoeeJ2WKAq4E8U1bkHoPv0VoldcZu3XtHWnOn3xYKh4wxi8obGa
 bxYwLn6CjJ0FVgElecW09X9qbeLiQA4pi5hmZGAwD7Ay2CP_7JKYLC9pUiMhRE_RPJY4TZl2wCgG
 8JzuQ
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.bf2.yahoo.com with HTTP; Wed, 27 Nov 2019 07:55:32 +0000
Date:   Wed, 27 Nov 2019 07:55:29 +0000 (UTC)
From:   Mrs Elodie Antoine <elodieantoine423@gmail.com>
Reply-To: elodiem97@yahoo.com
Message-ID: <790109907.3893614.1574841329106@mail.yahoo.com>
Subject: Greetings From Mrs Elodie,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Greetings From Mrs Elodie,

Calvary Greetings in the name of the LORD Almighty and Our LORD JESUS CHRIST the giver of every good thing. Good day,i know this letter will definitely come to you as a huge surprise, but I implore you to take the time to go through it carefully as the decision you make will go off a long way to determine my future and continued existence. I am Mrs Elodie Antoine
aging widow of 59 years old suffering from long time illness. I have some funds I inherited from my late husband,

The sum of (US$4.5 Million Dollars) and I needed a very honest and God fearing who can withdraw this money then use the funds for Charity works. I WISH TO GIVE THIS FUNDS TO YOU FOR CHARITY WORKS. I found your email address from the internet after honest prayers to the LORD to bring me a helper and i decided to contact you if you may be willing and interested to handle these trust funds in good faith before anything happens to me.
I accept this decision because I do not have any child who will inherit this money after I die. I want your urgent reply to me so that I will give you the deposit receipt which the COMPANY issued to me as next of kin for immediate transfer of the money to your account in your country, to start the good work of God, I want you to use the 15/percent of the total amount to help yourself in doing the project.


I am desperately in keen need of assistance and I have summoned up courage to contact you for this task, you must not fail me and the millions of the poor people in our todays WORLD. This is no stolen money and there are no dangers involved,100% RISK FREE with full legal proof. Please if you would be able to use the funds for the Charity works kindly let me know immediately.I will appreciate your utmost confidentiality and trust in this matter to accomplish my heart desire, as I don't want anything that will jeopardize my last wish. I want you to take 15 percent of the total money for your personal use while 85% of the money will go to charity.I will appreciate your utmost confidentiality and trust in this matter to accomplish my heart desire, as I don't want anything that will jeopardize my last wish.


kindly respond for further details.

Thanks and God bless you,

Mrs Elodie Antoine
