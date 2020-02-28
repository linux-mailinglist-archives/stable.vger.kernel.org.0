Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F10A5172F6B
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 04:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730822AbgB1Dhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 22:37:31 -0500
Received: from sonic301-1.consmr.mail.bf2.yahoo.com ([74.6.129.40]:36557 "EHLO
        sonic301-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730638AbgB1Dha (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 22:37:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1582861049; bh=G1fMyS8am+J1/STVKNHKmd7z39uvHyFMJPDIymAP8E8=; h=Date:From:Reply-To:Subject:References:From:Subject; b=f2JOaIa9Y/ZltWemjNnO6jRgSLnmAp6xQ3m+h8RnbOP1rxrjbU55EmkX+QsiG92ZPwC0FINMUacb7bQu97oV0aynUdzX4MyuQHHhF8TndT9XqwoRsfCXA3fqDsLR+dRW4rZurxMJBATbqEokXBKK6cisdNKB8E3ee44n6R8EKcZe9vXv1cvMbldTVar1JiWtj0owhPc8kNV4admLcRRz70XZNMn4qyVKL1/jQeSZle/OdbZNPrY4ceXbxbHgxmAwqEoCPGvwm5RTmf/EXQiJ+nbKkCPqvZR9kHoON7LQBqck+QojJw3t0ZnLwdYLYyIfG3ywceb3Ok4kOUYWg2mQVQ==
X-YMail-OSG: 06.IWBUVM1nVX4znASCi6qiKXpSpniTl_wkqhhnjd0aPUJBbkQ.8Hg39pmLNv_w
 P2DbIQGn8VzgWsthbm_F1yAfbJl_gUMelqQRt8OgGjXsX93Lr84pn35iLJh.R58h_2yDgvJ1J3AZ
 XT7bOymgfdmyaIloh0WL9R62A5DIR18hnY_MrNEKKv.5oiFsctEDHm5w3a9tNG1KVahggd8vVa2Y
 tMKNCZ2KYkyKj1TlSPpW0Z6S_8OZGZT5dyCoUWtYywiDtWCKtsHtcIIUijBwmxofNpZ56Epk05qj
 rIV.lMiI2Ab7RbCZ5hh_umBcP8fEuNlAfq7QB_MGXvpwevgAg5usk_5kA8bOc6nZnSVIZ7Q9UyDk
 3Xxjk7rDNV8tsrMNF9w89fjUwkqb_JqFhdzMES1uz38di.4sllKaRmEoQSY7Xl_oyvZQYbbdws8e
 mR8T6_TiXwu_TNGQpqSdik4SY4i0nuEUnO6mOQVyPD1DcDKQjIwbayfU.FNZs1jAWXZHWTe9b.Rf
 OPfjPTOIe37pyBtOFEqOaQMiThltC8ub44j3BIUwbbuecOWrOP.5PJdN1zJT_qqDcuuOllZT1pOe
 yyURVjp1.KdwWfZRMxSukwpHeFwY2GUK5juuAoe2tyU_7T91cmQ.caO3TBheEGb3r7KHZlDQRpKH
 CoHI7m99svfTq3AIyo7ZwHT45ysTuhhRyA5JYmYp4c.pcbfjcgBPFpdP5vg1efpwAxUi.OCi0twj
 y8QL0yeSuQenKzb2gmYnR5GdKW4gfIi3F1n9cXhO2g4oh2KkeDn8MPE1xVeHWTGDS51V0UXJB_Ch
 pBIh4RXmGJOLab5VNpinJtmkPlurGFcC_dbSPidYMOqdZuJ6LGgzIbFOrHMlNRNtveBvgRX6li7M
 Q1LOEffCvuOATSfQV4tZUPQMK.P27t2RWZKZ3gYKPC6sYFgusylMJRvBsM07kfK6rleFHe9GEMu4
 yMo6hAV6bH1ZqYG61MczHXO.CZLfbPZY64txw_RDT878MX.eDMpnc7DtuGeYhd9CbLSAnPqQQWRp
 3vXLGBPsV5mo3Ku1H9hDpzQ.zqt5_DF32PCGeZb6EX8Vjfh730eJHjLuAsMCz_RWmJZmVxdfjfAV
 qm0.aZ.2xP8EK7t.Z09yhiIauWL3Gdesz46PmlCM9JQE_xqFqED2tYYcf3OPma3LSNrbSkqd8H51
 EKKfxKz5VhAdMobD4V.voGyd5p6CX.QVP3sTs5tYxwUY_XFodxgUsc1BpvwH3HUWfda0.tnhrph8
 inaCHrzoRWkxFHBKpIK1tPtRsTP8eADw76IcDcHN28APuMS2llH3Ns1MJ.ogYGgKIPeu1bvqpu6H
 isQInQ1zVkSqQ3JW4UGbP8PMBEB_Jg_w-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.bf2.yahoo.com with HTTP; Fri, 28 Feb 2020 03:37:29 +0000
Date:   Fri, 28 Feb 2020 03:37:27 +0000 (UTC)
From:   " MRS AMINA KADI." <mrsamina.kadi11@gmail.com>
Reply-To: mrsamina.kadi33@gmail.com
Message-ID: <1869579348.1214294.1582861047263@mail.yahoo.com>
Subject:  COMPLEMENT OF THE DAY TO YOU DEAR FRIEND.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1869579348.1214294.1582861047263.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15302 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.122 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org




COMPLEMENT OF THE DAY TO YOU DEAR FRIEND.

 I am MRS AMINA KADI. i want your assisstant to transfer the sum of 5.5USD into your account, I will give you more details when i hear positive responesd from you,

 Please contact me with your below information to proceed for more details awaitin your positive response.

1::Your full name::
2::Your home address::
3::Current occupation::
4::Age::
5::Your Country::
6::Your current telephone number/mobile phone

 contact me with this my private emails I.D (mrsamina.kadi33@gmail.com)

From

MRS AMINA KADI.
