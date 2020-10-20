Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAC9293F38
	for <lists+stable@lfdr.de>; Tue, 20 Oct 2020 17:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406956AbgJTPGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Oct 2020 11:06:10 -0400
Received: from sonic305-2.consmr.mail.bf2.yahoo.com ([74.6.133.41]:32928 "EHLO
        sonic305-2.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727760AbgJTPGK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Oct 2020 11:06:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603206369; bh=8orKaYfnLOuvEXtLL/BuUKhkuI5qDLCKTV67QIOFeG8=; h=Date:From:Reply-To:Subject:References:From:Subject; b=f5mLScu1NnqMPusqGrQOBlqXnIkBXUErfFQszXo/wBsy4BbjcT5eIskI2GJCaZra5nrd7aUVS6bcANMt9xNwL+14LaF4obdH3hz9nuF66OcQkWeoOXE7oCIGdD0QnXNDiJJF4+n4VsYhL6hPzkaQhXTL2R6BpJyECpmX5Dc6dLRf8BBaBxZiqOoZuRtXmRhmpwPA36RAcCRidlpC7PRtKy8E+VdCieR5f/jQc1BJlOmwd/oBDpXbHAkr5wrXaKoauoOGohvT+R0Zg6naXSgqpoYON+pB4WvlIfrjHZ+VZyHWlm6Ybmw1UvyRvleJRHEslOV4/D4pHYNCq+YsWf6s0A==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603206369; bh=FvbJyS25DUP7eyKYuJVKzugzwVvE1PpHDRvUKbNiBgm=; h=Date:From:Subject; b=djbHNWztpqqmzZZxXjzyvdAIpNnzzX7szQ2ZXHJ+7U4I9Ur3iiNShFK0r1qyK5LjFIR6h71FFlT78RMzE0pMnaYRPma8mDQ0GOQMnJKsSFKO9c4GRcWe9YpPIp+CbcIY2pmpcCWsIphDiqKkb/RWoQCap97BrCdGVB4d784j5CBb+iXdcljRGJA7HtY9X4Au/OZyKTEkYridxXWMYs8Z+NCxfjgTmVv6pjvbkkH71KLeTRYL+LEJm+CUTXBVfVwTh+HJAhH1dvGY0pfxg1wTA/L4RULsYFm3wWJvtml+pMpMenVzUzei++oVrdS+7ohhHAETdIxnHJDDzheDePhzrw==
X-YMail-OSG: s5W1x5AVM1lpwzkOR0.1osKkjKLUBBoWjC40stMlscCQJbJPqnk_vYsslSfde8h
 vcK.2fl3ywVAlqDPQwvudDbnUKUlrs4NQNj_6Tl9iHD5OMHODLM9Xv0n.KQ6AUly3zS1QvOyhQ77
 U7cDHrw0W16neobgnNtoDRaEnCWyR3eksg1TLanaSHcYT9_KeHGf81MroSSYMWZ1smD3b9EooBI0
 EhrxTlYvszKmcxPndHcokjo1SL5Uw8jQPDbk6JqCHrg4qfzlyPSxB72mWBV1O5Zm1tZVXDPnkmcW
 jceyNbXcuCcNFit9FsibWf7nBAS33n5E6Sd_a_WKPeI2XuDdP_HN1Xbxt6JIkYdOOcUOXHys9F.0
 NyGl7kud9UxhEtcaE_CQHP.Xn8xaztN8Wo1hUo_gHBi_5_nllFDnKXpbZnyiaGrgrxqMxalc1ijn
 nLqpFVbOcTzxeyCNVld8eV8.E0tHiRnM1q1Xz6QMVXrlvRRXlcuLWXsZB_BqJgtO6gTRnMtD5bX5
 tK8zmN7DZ9Q1XY4X5780QmMG4c40AqcSNbHwcFCUGaYWrubxKiM3QS2S8tENTvc.F1oEvpC0juiY
 cu0lJPUzbmkqaEaiRePcx5.6G4oBS781sToGFSIxwAsvGHaGu7aZW6CkBvKDNWcNcxopKvbWs8dR
 Wlf9Q3A6YtdONAz7Ugul9IGdGrESCqrXxLaDI3X5UjQyyH8DhAzPKYUZsDSuOrAs3afhpFVdNYjE
 1pK8qtNxwvWnSaT48CXdaocUaHnVZiFXGC39Y2gghp6DqKY2uJJQmHfwSy5Xmo1nXFiV5JUYnHJ.
 LnlAgFtwQ8cFQU3KTD7nMynVGPifXsjHMbFWLsORL60rBZ8NDZBL9UDObIyLYtwfSXmh1ynhNA6f
 O1GuLLKpV.uoHmTQOXYO2x6f5iUxLSxiST42RqhbNymCR7arjgGKf9eayvVsquBNChTuuwhRFuWq
 mwXh9OgYM2VbZ5_MT2JL2NyItBulsNbdmrfGu9w6I8iVuqs9a6uw8RKxPv03xhSDATbBvJF6OzEI
 7R0ipsuvAeVDoPG5BU5AKK0IADAkkfs44iAgGleBvVGX8MMM7htxRts6vPbD9qCN72eUF9apIN2I
 aP9HLtPGManyBziSVxsYIDOLP3zauDLDQDiQDvpUc2L97lGMYwaBiFl0BR1ihpdONaZAsAfb48eT
 uixyRKpEzvvDWvUuDaSteheYcyVcORIEP4jAAZKRW8edb3FO5bDBUt19yy.LcglsmFBDGZ5E1low
 Mgn9sZeqgaTpCn517C_U760MJ_7fcp.ClyU8KO4h9wf37MztceTNWeHjvJk4Dhi45tEeRobUBHOj
 0bHKFpVomdiHQYZcFS7oAblJRSjTMDBOOaSJU85qiZGfo81mVlOBjciNGv3k7pznbroBl2aA7yuc
 4Xx0pG7eiS65SXXTBY09J0VME_0pogsclb8yrS8sJZC4XbdFzstU-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.bf2.yahoo.com with HTTP; Tue, 20 Oct 2020 15:06:09 +0000
Date:   Tue, 20 Oct 2020 15:06:08 +0000 (UTC)
From:   "Dr. Aisha gaddafi" <gaddafi283@gmail.com>
Reply-To: draishagaddafi92@gmail.com
Message-ID: <2084640904.1067432.1603206368208@mail.yahoo.com>
Subject: Hello dear I am Dr. Aisha Gaddafi.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <2084640904.1067432.1603206368208.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16868 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:81.0) Gecko/20100101 Firefox/81.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Hello dear I am Dr. Aisha Gaddafi.

I am Dr. Aisha Gaddafi, the daughter of late Libyan president, am contacting you because I need a Partner or an investor that will help me in investing the sum of $27.5 Million USD in his or her country. the funds is deposited here in Burkina Faso where I am living for the moment with my children as my husband is late.

I would like to hear your kind interest towards the investment of the total sum mentioned Above, as my partner and beneficiary of the funds I want to inform you that you will receive 30% share of the total sum after the transfer of the said funds $27.5 Million USD is completed into your bank account, while the balance as my own share will be used for the investment in your country.

Please after reading this mail try and make sure you reply and contact me with this my private email address: {draishagaddafi92@gmail.com} so that I will see your mail and reply you without delaying, please note once again that it is necessary that you reply me through this my private email address: {draishagaddafi92@gmail.com} if you really want me to see your respond and interest concerning the transaction.

Thanks with my best regards
Dr. Aisha Gaddafi.
