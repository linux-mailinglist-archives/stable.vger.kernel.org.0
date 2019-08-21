Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C70497532
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 10:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfHUIm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 04:42:26 -0400
Received: from sonic307-56.consmr.mail.ne1.yahoo.com ([66.163.190.31]:39899
        "EHLO sonic307-56.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726828AbfHUIm0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Aug 2019 04:42:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1566376945; bh=tPdyM4f7Tq8kspt5syr9wxbiHLUxanV8lkCr2Pkkkas=; h=Date:From:Reply-To:Subject:From:Subject; b=pMowMsraqCCzwUTkeRfShlFyBTgxV/juCU2nI6sdoQOrn6LnKGk0jNbG8sC2RUknspSiYWP9MxGrjf7BDqCLFlbKg6VOhIBMelVV+tBxYqCZY1Q9iES9czOMXjdXrh9BushijSb7LpJw6MrtKUJF9PWc5q0CL1dCEcdDrczCzfCt2n0SBDV9dU64aE4sLTRZ3FkmK6oFnZZOEemcepntF6MHxzUIYdJHXE63n39EuaEbXTppa41fXqcyLs3t+jlBG4nRV9eG3Z9f7ukHTv/MU8n8SVQIa+5Vc9UMubDXZbCpGCS+kWt4f7Sn1o1xXPqevNhDPY5pxfhWGFPIfqf7dw==
X-YMail-OSG: jW4EU.EVM1kxjhsMRPrhBnkOsKCHh3y7NvEl8fKOpnoMnEB3Z5vp3kr4rJUp0ka
 giT_sc9YbztpMkqSCDFuzOECR3iISpO05iJAx1H73AdzxHacVNIwoXHoJfdfzq01mDlOU2UI1_eN
 g8gx1X.3ElLiCiwpXYnLb9T164VMXDrIboEDEK6P0cwqOM21AqU50plzm5hirGcHG2vIUvkEKsUo
 hrmxHk3dcTzVVjQgBeoEyb2k4P75uQB4PQH4VUyeo6HMWHcgIkbFA9qKZ60VISalgaogtBjy82r9
 sSBq6O.Lcdj23LaueBH7mqf41ZtfFuDBlXjS1YNXzkXfQJrF7lyaVXRWonfBV0h6xTvUt4Vfixmf
 OjG3XmUJXm8srqhbfl67i9MCRx8xPhxF85fuR_9lN6RhCbINYtizZGmSLSpqO6gnWIHOVYMaO19V
 sVxPFQ6Z2DVEcy22ByJyRe1tNiZptbbNthi_V.TBuYvaKILqh9tU6fGCF8a9D0rXfJTb8rdDvcl.
 K61RD9LWEigPrBTAFciL_yS_6j1DCkB19UyTUBiN4EdCPKXSERyQL617pWLYqlLIWQhV8G0hMPJv
 o64MvNIIhO0Qt90zGEC2sVTUX2ssreuBjyoKNl4Z5UqrP5OTQ0RQ66lbWr1JxnyfVAdjQ5oJnUDq
 X8f7DE7Yk6eKo1N9qitNWd7AOOLmtN0P5kCpu3jRq2kfnHlrGMbdnu23brxMQga1GwDXDWaF.GPs
 p9VciIPTF4HGtRnS9Rxo6iBwd2h50AxpgqfXvvv6SK3.rMCs5TYCsK1cBsnRTS4X8wvbipWp9doI
 74kQXEamXe_58veYr.PTs9R72RuOm2g0IuLoQDrtZxo4CweEO0kAv54PrsaWOumByFL06Q71x2pz
 ftHXiaREuYzgrZDaa.bKK067_gVUaHcR2GxNzwAD2vH7vj9Ijck2AYwkeabWxTmZ.9duIOhjkZLW
 z0nq41SZvbKT7pOfbZdgqG7VGbskdXWbBoxirWLgDaDb6V.iPCF6vUpetBO_LB30qdLbuNmi8Ubi
 aAgJ9KXrMleoRcnE6reLof7_9wOjubihUo1oX6q3vetKK1LLzoILqAvYqp_HJZqd_gqlRn7uhAXi
 l4eU7nwehhTl87wJk78fMoZTrXUHf7PhI5G0miNLFGoSr5vcx5i8eiCn5j5JV7fInAcD7JdvZFJB
 vtd7LDH4q0Odore9KbOoiBIvgewyKorYc.IhQSqsFRECp9fij72P9cyxD4FFZuUuU7U7MqoCfBLN
 0qamyoq4-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Wed, 21 Aug 2019 08:42:25 +0000
Date:   Wed, 21 Aug 2019 08:42:24 +0000 (UTC)
From:   Aisha Gaddafi <gaddafi661@gmail.com>
Reply-To: gaisha983@gmail.com
Message-ID: <1694556640.111166.1566376944499@mail.yahoo.com>
Subject: Dear Friend,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Friend,

I came across your e-mail contact prior a private search while in need of 
your assistance. My name is Aisha  Gaddafi a single Mother and a Widow with 
three Children. I am the only biological Daughter of late Libyan President 
(Late Colonel Muammar Gaddafi).

I have investment funds worth Twenty Seven Million Five Hundred Thousand 
United State Dollar ($27.500.000.00 ) and i need a trusted investment 
Manager/Partner because of my current refugee status, however, I am 
interested in you for investment project assistance in your country, may be 
from there, we can build business relationship in the nearest future.

I am willing to negotiate investment/business profit sharing ratio with you 
base on the future investment earning profits.

If you are willing to handle this project on my behalf kindly reply urgent 
to enable me provide you more information about the investment funds.

Your Urgent Reply Will Be Appreciated.

Best Regards
Mrs Aisha Gaddafi
(gaisha983@gmail.com)
