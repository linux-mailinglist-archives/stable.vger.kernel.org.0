Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61694220534
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 08:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgGOGiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 02:38:02 -0400
Received: from sonic302-19.consmr.mail.ir2.yahoo.com ([87.248.110.82]:46004
        "EHLO sonic302-19.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728871AbgGOGiB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 02:38:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1594795079; bh=TYgdp/zNeW9P5rVjVpFopjba7a+Fm8hxyemx2bQVZd8=; h=Date:From:Reply-To:Subject:References:From:Subject; b=VjofQRkaxLQglJ5GK6l9tbQzZ7pymSm5/o7/olWu9g9nkoKOICiVkDiwVySX15kdy+8vsxT2pnblsPglRqL8gMn7RBaBX/nyZc7W/7eHRMb4e6Cmf87sHqmmDSvmaBJNRZocx6gUBCJtsjGEuyufbgMOfJUySrLs7Zw08Fxo98iSpQzIb4+28i+mSWJ6bZlmr7xYEnKiY7Hl2PLM20gtRFqqcC2t0M7hS7Rbr68U9Du09uLJ/6z3h7e0cgiYckIO6RpJupanmz/T5GAvBw25dIqubaVz7bs/KXUtSAtuhDPtqF5e8i8ni/gplF1dFn3jds2UVIt6yDSnAABmiXV7LQ==
X-YMail-OSG: d5dfEn4VM1mmV8BswBPABReLLiAzaWvH8nBEQ0pCZ29lVzxRXqih8PCh8eINnBm
 HEMOrlj8cKYUM2LWLPwKo4AcV47gixL07069cgGAmjtbfVlVImTnRs5eGAK5YMmXIh4KLQInEDo5
 3Jb2s8pnbA8Tflmv3FUyeOFkYbjVf3CapmjPd_WviTOyi4YmPAasJo135kNCjCN6BNYNA6UFzqQ5
 3mooIAOpJ01vNI3HtPP0raKmBRFZWYwdMS56ylV2CIRlv4az5ZgWXHqKt_Qyvt_dsvszgtIBOm2j
 tX7IpgpFX9fWQ2zS7nMTk2MWVipjNgIHA4QfiT_eE40GbPHUeVpr4asupOojx6n7WmCf1EMNn8d6
 RQRi0EWaNbBDD8z3Qpd3o4rpKNXewnARHqnwdULu.1yAGx129BIwGrsKlUzMjC4DbmtoRW.GpBw6
 mtkpMnIij__ZW6i61DRrEsniioC14qLe5fmfXBYeJnCIzNREKk7UrBYGugw3c3vzV7i7k2sPiroc
 UP4CKhT2YN3.s2SnnubKgYQAjjTVsqK418ijDWbIqHIx2n388XMrTifwzUKgb88haVviKjub21D6
 bDUsEGv7iIqK6cLv6PP1ApuVg38_uwoc7FwsUBkoM4rreYvkKrkQT8PIVgPJAxu5moXorjUY1loi
 sOkM_Q7VaUgNyOEViSKCAJ_.nsrXhnIcvuvl5FhyLlKyMM3upbbbJ6YG4UpjIVxh.FpDp1oTPCQ3
 UQFJkBAy4QyXwjhctc4ERH3tuefUB3LCjYpRHoOIbeBuGPhFhVZZdS51l6xjE8mJcdr7YhJ7mGky
 Em7MXK228OAKnqU8V6YaQK4UbkF1DORufSCSVKaQvdFLdN2TpHC2rnZnSJNA9SzLw1Pcr3A1dutm
 rD0MRxZr1vNhwigia4Qm2kX81E_ane7hclUOZRG0zzi.pKnWz3uABS5X.0fmuIve2Wa4rCFa4Tin
 .xemRw0c_RcAbx.HlAnZaevCu0OGPhX50CssPPApVlJDociMlPdL6HmLFSf7oaVdbkafx9jlRD_2
 ujtLE4rTJoDaigC.blcL9KbA5sXnTu6q5BQUFStNuEyvp7XubS3tHW.W7ZLczgmr0C0_oRFwmeeN
 6XbJu0p8DpVIoG5TDGzjq.4tCeSsvbjarZNlxoIgakuXXlQj2ULDRo_JTsZTGkawN2wO9cj2BMfr
 iDP3ZD6u6Jm4vzh8I5J7rMZuwx2iGpwF0WWiVxvnwWAd3tZUR7YECVHeqMmiKNKjc4HwAMr4w7Sx
 _dJhh9hvhhVAsL2XFgQeU4Ip9TMm9TUDnoYeUZzmuaPLLTquMa.LMWXxHoK6mo7v6i_Wmsw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ir2.yahoo.com with HTTP; Wed, 15 Jul 2020 06:37:59 +0000
Date:   Wed, 15 Jul 2020 06:37:54 +0000 (UTC)
From:   mcompola <visacarddapartbf@gmail.com>
Reply-To: mcompola444@gmail.com
Message-ID: <316054178.2708732.1594795074832@mail.yahoo.com>
Subject: Dear Friend, My present internet connection is very slow in case
 you
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <316054178.2708732.1594795074832.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16271 YMailNodin Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36
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
