Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C422137034
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 11:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbfFFJlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 05:41:35 -0400
Received: from sonic306-1.consmr.mail.bf2.yahoo.com ([74.6.132.40]:36797 "EHLO
        sonic306-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727875AbfFFJlf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 05:41:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1559814093; bh=tPMFdTY+0vCEHEJdls+8ad0RGQoZkRGbQBF0vnIRvYg=; h=Date:From:Reply-To:Subject:References:From:Subject; b=DeklLekNnGuNs8kOucuRZOZGAu7xE2R79KA1sEHfYFeiAVvBmjlhCnihfv7hPcvqUawJxmXz5TZbu2Fa0gkZ5e3kPWb2xu3uGJ/3dqV/x3Jk6Ch6w8JMEfRIVRkkaIg0HCOsjKx27XYXBGJLScpPl9PyTyhB8zG62kRWhBnfchZIp9pTpWerM9MHnVCXn73gxWJ1+bUelGxKKA0K/6JwitMxaQzfwR4mMnFXx819BED/I+WEwj97l1DhFaXHN3uHAo2razub/3FTElJFdctz1bgiOC3XJQBDi2Ceq3aYfwucv0JNNo+53Pc49qyCj07z8hbNkRzPQ6YcEKnfpu2YDA==
X-YMail-OSG: ri53uuwVM1k1Bfm3YnKgcmN9EkPYqRB1Uvwl.2FR8J5LbFdGG6gRbEUp0NSbqo.
 rsLSsRZwpeeKtHm8QLVujvTki4nMqzec023Y9a_CTbLJXZqG8OY939F3IUxEpLotfVy0oCvsaegs
 0AG_jaVQqZ89CwwRxCMbRJkcgW3LdmogDPyzbIDVwfe_OLX.W1TE4SgA3iWVpPMDbmM3gwWfCSYd
 XU2mR5Ov9qKZnu7h1_PLmQsEQulfA_DDb6iZuQ7m_1GkfIrZykWR1F3XchAI5h26oO7KjR70FTFi
 kp1Ot1MAFrCKriNFj8i_EZTrkGkYPSddcqzgAK6N_r9oeasyjKoYLAkeKfj63AEG_psHrrE21nIw
 yUISvFHDMToN3BFLUVLVo_ikMOUOnI6BkZ6jBTLQON13QOAmaOf29WLZQRRr8jP5JzN1sRtgjpRA
 OFAXZCxSVlwUq69qYlMVYAMMV5LxANWY_pc.bFNFVqOjyE8wSX1Hx7g0oyISqZWQAls9IMFPu8U2
 9Uwh.A665l9nPXN2DWza_ZL9GEaou.mpGvBAz5qgpYSGQrs6Zl379vHyWnoBJ6SyHdmkMlFUtx3P
 vf5YCC2NmkzOWgouLWXAHOUmij0C5dwxvINFiWRkOZZuD7pJ_lzBPcXgQlcc.xqZXZfcBdm51ENq
 OXJSYbhHmaF2pYuY9MtcIE8KENnD.5LiejMXlFV7y0xzIfkprQbe8juBxunGhdvqQRG_QSlbS4KO
 zvLUQPkKps9fCChM0uj.4R1qVimmnGPkbUp_wOL1pKgkGQUiZF8H.WaqCLONlh8dOlpOsJIpoTeG
 dVLQKA2MQZIBrj707PTa88TiOWGnNF8gj4s4OoM6KgbWwYEwHSHPbxWo2iJ3xlGZBmiTaZ7bHriL
 8i3HzFB91acyAuOvX5iNfN8mVP3YecCPMCMWghf0aUZubKNr2rPQ9CuprvkRKGQViHchKbUOen3D
 EAQACKNh2evG09cav_zZZRvTDbjgifNSzP4KYHlgDVCP_VmL6rgxKy8G4nQM.PldZ0e5fmVzHdZh
 5UwMaRxdsUKi4nbwm7UuEG.HU_uTHxblFnZ_.0CPtO57Y8cpTbJydMORIRFcEB4pAvf36ClA9ZxU
 jY6xxD3glkDmnoUo1cjsMnKSafMa8nWy2FH85Va4JP.4UBr.jOLRAhVVxm.XVXgjsCGojVr9ebem
 gqhQI8bcirF.B_PzGkPWaA69.AjDTqFuu57CdIjvA2BQvuGpOVJiicpLu1A--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.bf2.yahoo.com with HTTP; Thu, 6 Jun 2019 09:41:33 +0000
Date:   Thu, 6 Jun 2019 09:41:31 +0000 (UTC)
From:   DR Rhama David Benson <bensondrrdavid@gmail.com>
Reply-To: DR Rhama David Benson <bdrrhamadavid221@gmail.com>
Message-ID: <1722587008.734547.1559814091823@mail.yahoo.com>
Subject: Please read carefully,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1722587008.734547.1559814091823.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.13797 YahooMailBasic Mozilla/5.0 (Windows NT 6.1; rv:67.0) Gecko/20100101 Firefox/67.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



From: Dr Rhama David Benson,
Please read carefully,

This message might meet you in utmost surprise. However, it's just my
urgent need for foreign partner that made me to contact you for this
transaction. I got your contact from yahoo tourist search while I was
searching for a foreign partner. I am assured of your capability and
reliability to champion this business opportunity when I prayed about
you.

I am a banker by profession in Burkina-Faso, West Africa and currently
holding the post of manager in account and auditing department in our
bank. I have the opportunity of transferring the left over funds ($
5.5 Million Dollars) belonging to our deceased customer who died along
with his entire family in a plane crash

Hence; I am inviting you for a business deal where this money can be
shared between us in the ratio of 60/40 if you agree to my business
proposal. Further details of the transfer will be forwarded to you as
soon as I receive your return mail as soon as you receive this letter.

Please indicate your willingness by sending the below information for
more clarification and easy communication.
For more details, Contact me for more details.

(1) YOUR FULL NAME...............................
(2) YOUR AGE AND SEX............................
(3) YOUR CONTACT ADDRESS..................
(4) YOUR PRIVATE PHONE N0..........
(5) FAX NUMBER..............
(6) YOUR COUNTRY OF ORIGIN..................
(7) YOUR OCCUPATION.........................

Trusting to hear from you immediately.
Thanks & Best Regards,
 Dr Rhama David Benson.
