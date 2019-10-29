Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48CE4E86A5
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 12:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbfJ2LVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 07:21:17 -0400
Received: from sonic310-23.consmr.mail.ne1.yahoo.com ([66.163.186.204]:39706
        "EHLO sonic310-23.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbfJ2LVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 07:21:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1572348075; bh=Acg6cR0d4icHEW7zNvIWmQRAFY+LtLbaox2Ux1TaSkE=; h=Date:From:Reply-To:Subject:From:Subject; b=L9mHsQN0RmhgwYF9jIEnWqd2qF6CCwDjas/3gb0/AftY1CI84QOjeevq9kTaeLunjzH7EISDQIrYSDLeYnfM88HJuMLh8ND+bLtc27GmKm6JOGRJmw5AulCd4sEto3NeoDOJ93VrAda2kneOVa/bV4w8MrpBaxnpy61VShQ1+Z627dDIgK5WQKJI6WJpFPq9O9w7Nep4+/JFSTf11TFr3CjJAhwn2bhy0PFyCavS9fa3lisF3sbzP4AbeHp/BWL1nIoQ5EXv6eYMOhBqdrDbhvj6FG+GMLTV+1PjkKHLzuEdPXiiFDyRjyqhq+7PwEkKxmPK4UBWLt8xJABfWbMfOA==
X-YMail-OSG: fpNsm2kVM1mlDQVGWTx0ls6bsQDGO6l.gYFzFuhyPjv62qHwZp7bVQxqF.NL36f
 CF345.Gzboan60Gzv4RmTsuusWe.etci2W5E2zQqdX0FT3HcqtNzSWACNz8q7JaMi7Wz2P29vV6T
 Rnr_K.FlH5mcol1p__Bwo8t4n05EBx23naliKZsN_5aHEH.tppu7tGK7OOEDWWMisO9KuIrOTyIF
 6svvqOmx4jdb3zi3KCcVbIzifw28dj9gf9HdySESB2SLzaPFyCWSSpeU.MIeNq8sPqcBK0o1y3j_
 y9H0b2U_wYe8L2kU9XxF0KYqPyr4GJqAa.js9uMZaVsnzwuoflvmqWHhUe556POOLvmx_a.dk7.P
 xNK0uaIko4eN5J39MR9nomNsp__vqR1vEsqbyXfCbMMzyev15AW7zYJ6kdArO6UUzzvMhelAii7E
 n8MG0178E6f8qXSAxEiIySDAGKDqkeDRzK1T60LHQKh9HYzY5pKZUEyW7FhAQBUCEPiP2_ZUTAZP
 C95FEQkebdQDbRzkIUWqkXYJ8Bp7t38O5KGSK6Qke81EpJL1lWFAql5tnr54iNr28DLOsncElYVM
 jVIvDWaCAtbtCLrUwbvZNCgbVU06hjAQpSb8aMPhP08AWe_lYN76DlzK6m_nDeCWwaZNOwII2BTG
 v5iV0kGOMIAyD62bNRXfbeLzQnUiDYf8HzWisXoO_0kPrhy6KCzaM2yR2EIlIfg23OQod81OWYng
 zm5WL753r6pm5eXtTI_grUsbZiypqhZOCD7jmk_AG9p8lfZ_TT3MrGl6558YRY.PwDrYjphcnGZU
 WltszSTKccMsJLuTwdx.kR2svISCMHFs5mAzFVb9kD0Ogu.vFd.qX.OIEgPpS6bMLaPIQr.YQmlY
 tgfTkNvjqxYBcdppj7HoyJXiT6TIq531HOtSyx9vMZiq4Cv39uPLYqAkja8tt9X3co1mlhvaLyS6
 Fu0NyfkBc6YcSWqZQvpSlumXHsLnMtUzHvwem._77zn8UyzPogsJSGsXdHX3IVyIY.ZFar7VpyOf
 biXYLIWEVonljguFp7E3uuvtCDf.SaWCoM.8HdYcSvQj3Puwbq.3YwxqORADtKRHHL0g7Yd5Ij0c
 8sk_VGdIODdUIs1nF9adjhrBisbB_S0swmp.Anekxjd9cqtIZc6vgVpiXq4.e1fkeDAkcffp1sji
 tezDpD2nHoiSBR5MKTTphsbl1qFb34rLEMH57ls2ifryNTq0KDYK9Fsa1iIkoBwiOFH1OZnHqjHS
 YjrnU15Z.XZN2OX4lZwd62TEEX83EXnOYelvBKfsrySW_JhLcMF1DELqHsZ_3DGVPqjRPfmCpUCb
 W17BpseV4
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.ne1.yahoo.com with HTTP; Tue, 29 Oct 2019 11:21:15 +0000
Date:   Tue, 29 Oct 2019 11:21:11 +0000 (UTC)
From:   Aisha Gaddafi <gaddffiaaisha@gmail.com>
Reply-To: aishagaddffia@gmail.com
Message-ID: <1155810190.3719453.1572348071053@mail.yahoo.com>
Subject: Inquiry for Investment.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Inquiry for Investment.

Assalamu Alaikum Wa Rahmatullahi Wa Barakatuh,

Dear Friend,

I came across your e-mail contact prior a private search while in need of your assistance. My name is Aisha Gaddafi a single Mother and a Widow with three Children. I am the only biological Daughter of late Libyan President (Late Colonel Muammar Gaddafi).

I have an investment funds worth Twenty Seven Million Five Hundred Thousand United State Dollar ($27,500,000.00 ) and i need an investment Manager/Partner and because of the asylum status i will authorize you the ownership of the funds, however, I am interested in you for investment project assistance in your country, may be from there, we can build a business relationship in the near future.

I am willing to negotiate investment/business profit sharing ratio with you base on the future investment earning profits.

If you are willing to handle this project kindly reply urgent to enable me provide you more information about the investment funds.

Your Urgent Reply Will Be Appreciated
Best Regards
Mrs Aisha Gaddafi
