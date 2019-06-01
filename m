Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDED431AC6
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 11:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfFAJUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 05:20:34 -0400
Received: from sonic314-15.consmr.mail.bf2.yahoo.com ([74.6.132.125]:33422
        "EHLO sonic314-15.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726089AbfFAJUe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Jun 2019 05:20:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1559380833; bh=FCjWGTqDRXQUUN8ivg02MDhbiDKrvltOcpc7W52q/3U=; h=Date:From:Reply-To:Subject:References:From:Subject; b=UgvVVmqcAB1F8oqlwvpeAm7jJ/LYYd/4XKc0bbcfY/PupOuonSUeZ5ZrMv83o7vYYl9MXX3m1TWtgcFo/sr9ycl+WMm7caH3kAhqUEQmf6E3f0TuNG7FW21KWpck9X3gOmTGS0oQA1deXxlwMSPmgUi8ifxx2lVKRKY8glTVuLTz6y+X9uVkixpe1t8rOcH7zM9zMKQwUHi4pdpCvWEoeGYvI3utnWXxkwpW0H4OIPwWV16zCyUSQvMcTxc6hEfaWW615VjKxUY6FLHTTvL7KwhTGEDw8DR6iAp4JznORy4dKLiHKF+sqc54oTVCWwt9zxFIK9f//mhWC+NwWkk2Jg==
X-YMail-OSG: sqNUrMMVM1nzz14wP7Ta7z8Pz5shl035t2oazjm0JE461h9VcVYqlBDsWNk3eSQ
 R6hEUF8HRcRpBdxGjIlYo3o1rLfG2XnjZlZCF_GzbIEcw5wGytwXIKiIuP6S0Enhzmw3ZMxZAYeC
 psgm6QQSrGZhkKOvYz1iBRjtd8DYHUD0fAxCVEmgr4bJ4LcV4sjH4VLV1ebbXdADCZyW0L9z74gf
 pHjSiQ5tip_lgMuLqBKLFb8jBeCXjKyAo6BuDSikfb_QgyuQ_iPk3BXvE7ZjKWW9J94.IHlaAP4m
 buX81NSUcfxlXVNUCSJ7iYzw0bbA7uxKObGQIulU000w5dH52i9O9vZlkSvDO5holjNCaVNuwnEp
 .jd80vo6krwy_5OgUUhR1ScUR674kGN5NuYxuACeZ9PsOA0YkEl3Mc7NIQFhLhN3xVUMkmpEQd5c
 sfMgd0fZx63BSxdQM7ik8uLt9_bODY7VgVV94.qS5hx8fLODtan6SkSKs6D7XO.sC5jvj8TMPyFY
 2DULOyhMNSRnfoyRGPbcGkn1QL4BuejYE6_5pKWbBggbk5Zj93a_eU5jOlSAxoktD4uIW7WtJf0X
 Bm_oyreDRrBGdvIxNbL23kJs6Ire.2JFBc_hg0RM198yXuS5mir1FOldrRZLdykFDtqIY1ynqVLP
 8SER_ondx5TJELI_sXY0ojGqm6sw..PhSBu.0YDEMZhb0xYqzVFRPHdyl3_CyKS2.sd_ch6EiIKo
 AuhmZX4oIkIIvW.zYzXlQL3ggoycLK97ISWyH6cusMcbc_kWLgdqANOrtZPEMjo7MG.WEFiyy_P_
 C44H0KLwWKotT.PreFSx2rvHW91Zze3KIj_i_5iX5tC.C44TF4dYXXvMAsr8JLOhl9PmmhPEJHMD
 u3g7MschpFzvMTbpgwMe9mVF1tW8ipIb.rEZG.w6dXT_8pnSqmtUq2WhgC1_4iSm12RIt.PlfR6h
 f3eArVJxbhU0ZI5uj9ce8McOZy8ZOnqzh5M1Jw1m8TcstyjM_yPUEI53qAbjNvaj9ZmuCDcpjfh.
 zrz..rTZ1mbkwtC4ScNELY57GfaFFt7apEV9gknChkhq8esUmTNvtJhtX0FuOXNQ_cOVAFi56N6h
 HRMdjgJ.LYKODxpF1lxpePEsCw6eUIyslNQE84hRm2y5SdVIi_ipaPLjZXzqAOPZmHIk1LaJY3GX
 t6H.UfwNIRQ.Y37d0wdbOxDb8rG0Un1VFyPxHMWg0mpniy.KgxtnvuBUO
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.bf2.yahoo.com with HTTP; Sat, 1 Jun 2019 09:20:33 +0000
Date:   Sat, 1 Jun 2019 09:20:33 +0000 (UTC)
From:   Ms Lisa Hugh <lisa.hugh101@gmail.com>
Reply-To: Ms Lisa Hugh <ms.lisahugh000@gmail.com>
Message-ID: <820160251.7524107.1559380833088@mail.yahoo.com>
Subject: URGENT REPLY FOR THIS BUSINESS...
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <820160251.7524107.1559380833088.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.13634 YahooMailBasic Mozilla/5.0 (Windows NT 6.2; Win64; x64; rv:67.0) Gecko/20100101 Firefox/67.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear Friend,

I am  Ms Lisa Hugh work with the department of Audit and accounting manager here in the Bank,

There is this fund that was keep in my custody years ago,please i need your assistance for the transferring of thIs fund to your bank account for both of us benefit for life time investment and the amount is  (US$4.5M DOLLARS).

I have every inquiry details to make the bank believe you and release the fund in within 5 banking working days with your full co-operation with me after success.

Note/ 50% for you why 50% for me after success of the transfer to your bank account.

Below information is what i need from you so will can be reaching each other .

1)Full name ...
2)Private telephone number...
3)Age...
4)Nationality...
5)Occupation ...


Thanks.


Ms Lisa Hugh
