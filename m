Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF602289F00
	for <lists+stable@lfdr.de>; Sat, 10 Oct 2020 09:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729128AbgJJHrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Oct 2020 03:47:16 -0400
Received: from sonic317-34.consmr.mail.ne1.yahoo.com ([66.163.184.45]:46028
        "EHLO sonic317-34.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725959AbgJJHrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Oct 2020 03:47:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602316034; bh=NajTNMrfMLb6UXcjRhYpYerQX8PtVBLz0oFgaMINSWY=; h=Date:From:Reply-To:Subject:References:From:Subject; b=LfSBagVU/31KdafJU1oEt+53tbbnhd7GA4p+GD3tQOwpWoJdSK8oqsFt//DsOeVD6M2KTMHEfvXHt8RK7v2LbfMNlZPyIc7qhs9YPNCynFuXkDXotMBQyZD78dE73aYw8uR3B275jkqMw9YMVWvBgaTtKPB4NBNY+G4kGvGZqHHwK6YJo7IpevdzPC7wW24Mowd2tQ9KRJ9VeJDNF+rNz6OocnyCyTon6vCx4ane1pOwXDFXg8SXg5GMcbJbW7iuduzT0UuBHfP8aSUEgnWqUYOryfj1ErOnczFOuOkWgKiksNKRrA9kX/qtxjdJ9ad7yU99eI+ejn0V8OPoohqVGQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602316034; bh=fPJ9FzAhJ0eVhzrtknGjVw2FvPdmTk5I6Ofegv5tpM7=; h=Date:From:Subject; b=U3B4DBMx3UXxyW/q9dYu/08I6ovXENbGpCuqnAvFVSmgX7+Psp3X+U+I2DCOHybO+usoxts+yLB+WjOI2n5GT6e2s/VaUV1oU9FpMOsTdscSRA5Sj3cv8nhueyZxFf47ywlF4shG2untSWzTC/pgPODjEXo2/8KOjHXYSngXqigjVhfIv2/KyeFUM/12sOImw4XnL+94TToMrldRCQs3mR1F+uwxHe7xirUrW9hpORXnSm7c7Xc9nfUauT+sjVt+1D5ZXwguNIpxohf3NKqeQWc5rJmWtv1yX0mrQJ1o3rnwMbRVMsXYjj74w3aU26LWbauyD+kEQr7+UA8vz23ECg==
X-YMail-OSG: vNBVOk0VM1nozMFsIIV4V80WAIRvJ1Ya_PAsHG.YYYcjJZnZC5IUr7WfjrcU4.6
 u0byOc5kDsYYZOlMW4lGda3qIAzoP0Xoe6Rl3ot4WVf_Ikdf6WFmJNiDuXyt7AmBSzU.Jfn.xJ.T
 2EaINKhwRqVrUCRFlmk8DiU1E3ZgZUscIQl2NjvidG1SBNSfDaR5wSCLkKrO4XMO4ybr3Gc4vT27
 eKvE0kwMU8JBlVKDJge29x3xxJ7NZo9Rb7oZ6RGqdSfmtpsNQj_hwJQJIlUPZwUPm5K0gY3gavV2
 beCbkFx3zI3NjK_GD1_GsWOQAzn64TpAFNIEV7BvYRldqcnBhflIfvStg.y.f8LXnPSlGJIPeeAn
 PLk416Nd9LYNXDgGadNTRxDXR1y1qVItNiCzBSkEzzozC_JmtfwH5i7z9oVDczXFvq1kUd1XH4Do
 EKzD9K64Sdm9V9vNy4YsOeOL03hVstZJVCewpWHSJkcPklEVoCb7xSBPEZunkBPiTIAVQ1csbrYM
 l4MPb3KwRUMDAjZPoPxv7RuSFokNu3hXWQt4DbJM0DePhrgjDk6jS2AJ12o2RtbaMaeYf2xvc7.q
 YWHfQ5tGNZnJ5hGz4nilDQAGfLpfJBC3lpwp5iaprb_chCHcIFQV_PD9oMuew7dqhMc2cyjwhAyo
 w7KqIbpG8uZ8vQIw9vsuBYOUodpt10r94.iwCewexeeI3tnbU324O6fepR4ZA1T1pUeS0wKD9nj6
 xwnENpHrzyQUp42DAYcLqioQL3emw2L19zhqFcjBh6IqJh4H2BVkVA4KF_Afo8IcoH38TJEwqg1f
 bSV63qTlnOCwweQqVMC9.1GikjTyaaOGxG2XiNn3ciiQZI8l0AQt4gF5VsEu812h9uUBdCQXtPZz
 0fhG_5s8x_YcSrAxvgpJ9GbzMV_bTvT6F10EEh52qi2_r6P.2eE2XHRBBvL8wKx3Pn8bz2bD3Cew
 _NRHZ3APoeknp9OzgsDHqapBQlx4KGhBEJqzaNuULauHw1Dr6HxW9hEnrrr.QCnnnYlTq0JI3J6m
 xuzarCNGCdoZClSeB6MVoEgbakkEtrXMv8fCnF_JwKR6LnmzirXBPf_TDgicHCcwExF6qQ54p.v9
 lBbYUrrfPIA8eaRLt6aQF8RWadr5s7DFM47sm_MzC33PkNT1i.N60Y7IqGb6x2DcFyXd6IGdhSU0
 wbA4e.jOvk0JA6.VXiGFDc_lcHO4vNMKSPjtkZnehaR_Dp9Q5iIp6A0etf8He0eEm.c0s0s4jcH0
 u5Zlj2pgjAjPg9dpd6NC6uAdNPJzrTGfMUhnMZnFgN5qPfOWOKN7SBsEcaPGBhKxr6UCeevNZk7B
 duTeGSP4HU7X8G6D6ypLChvHnAYpQ57os8HFrsX0cAlvkujtFr3MwSeYmwRAdPxkCa29xkgwcDxy
 9gzhGZlg0kxv7NSjxLp_fl1EESQjqHr1qOzzg7CQ-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Sat, 10 Oct 2020 07:47:14 +0000
Date:   Sat, 10 Oct 2020 07:47:13 +0000 (UTC)
From:   Ms Lisa Hugh <lisa.hugh111@gmail.com>
Reply-To: ms.lisahugh000@gmail.com
Message-ID: <281384331.40722.1602316033443@mail.yahoo.com>
Subject: BUSINESS CO-OPERATION FROM (Ms Lisa Hugh).
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <281384331.40722.1602316033443.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16795 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:81.0) Gecko/20100101 Firefox/81.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear Friend,

I am Ms Lisa hugh, work with the department of Audit and accounting manager here in the Bank(B.O.A).

Please i need your assistance for the transferring of thIs fund to your bank account for both of us benefit for life time investment, amount (US$4.5M DOLLARS).

I have every inquiry details to make the bank believe you and release the fund in within 5 banking working days with your full co-operation with me for success.

Note/ 50% for you why 50% for me after success of the transfer to your bank account.

Below information is what i need from you so will can be reaching each other

1)Full name ...
2)Private telephone number...
3)Age...
4)Nationality...
5)Occupation ...


Thanks.

Ms Lisa hugh.
