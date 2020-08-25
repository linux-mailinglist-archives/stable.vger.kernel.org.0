Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425FA251F8C
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 21:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbgHYTIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 15:08:43 -0400
Received: from sonic314-14.consmr.mail.bf2.yahoo.com ([74.6.132.124]:38660
        "EHLO sonic314-14.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726119AbgHYTIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 15:08:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1598382522; bh=vSZ7gQ8F13hDNYtYk6t77g8qrdmtAY1S6LJUlA/r/r4=; h=Date:From:Reply-To:Subject:References:From:Subject; b=IGTlJH9SVhK29SiK79ilLLW09Usigs4r96JCAEov+jNgdhrBebMg4UDnxXrerCM+adgRtyUWTjVjqRZUbIP/RADYMqFgAP+U0Cqj1sytnYeOC2f0EsuiVwKnqslDFE7g6cxjlMubyv14ieqD6Wv5isEjkP7D6uu1GjMnPrvRP19ZJR7jkmzZWz0UHph/PrIpoIAAXu1kecLEFV4OSA0O/g4IdMsWuI7XvIQ1+06FcQdVdsKaL/gTuHc9Tc7OUohmblekIzjIsz9waK7Ypo4GTsVSWc/mdyxFJaXWz3nkhoOf7diGXFwCdxagW847mvFDRopbH8/zz/6NYmDYaasr7Q==
X-YMail-OSG: 46OTz5gVM1kzDMyMYWqEfD.4xN2dLG_.4SFRxaTLLeX3KOhPBiq5XQT95gfVBeD
 uYS8mw5xQ677qJSjwTaWZk6Ss.Y3cnGCTs6L8SsaNqUOBRj.Ywpc..QMtiOwfWRIGWeceBY0zn46
 eUp1y_dzQi.wIhtXp_M89kqowD07wm3tpMWgCS83quUtXhY9FI2mwwmb_6ihmE9t9Tb.xN2MFj8K
 06JBZb9K5hi_9nHMX_De8pTBqym7eK0XHMeh_3zyTfnG8e1252wIl3sw_lDeu2yhA8xnFLtHdRkt
 CgGBIfM.lFCdXf6qLevWJuu583Fo_MiN85i4MkV6wWqly_uaO_IBzhEo7LXhn9UAQrzW2jhYJfyt
 ADUEUrSdgamPyaYaNj0l7ht_wGnwP4Y5yKwQS1bXmyw7Q5p0ju9g0P.VVjwGAddE_EcUcw4JJDXe
 ZPYoapGorkrd3N6bCU30kePtI1p4p4lRJ9VSghc8oEzD.K9uVSC0HrHFwrJyGm1dx9fkNQy0oi0O
 ccvlluONEy6qDgpbvJ8Te4x.gWlSQMZmACUkUFHmPPNpuX9I8VIYoog1Smkh5YLLvGc3qqDY_r9f
 qLH.H48LJD54nv0fuG9GWRuThG47yC7V95mTHIz23_ZGopElPrHI1kd0sA7Y2LCTJE41wzTU4TaP
 emp6fcVDmugx4L1byitIT2o8lVa6en3EId2SV4wp6gW9znD8JEoQLnIeMvwyQRUG6rtUFHBFfLOx
 kkoPm0wDpwJ5WpwjPrGTyt4RDfGTn_1xgi3nuJzl0Ou1Evk7IiZ67xg.OgWe6GdcEJ61okQW6FHL
 XYYEeW.qp6EdSAjSgRIoNEZh3o1vQ0Li95ZHaahn5JMpWKRzYWTVebnJS0bGuCV.jT6A6t2QtDot
 qXF_dD4UO6yeG1VE_y61AG0R_y7nWHGAUiwXLUskAYYbZB4T_3T81yJRtr80JCAD8clk8lytt.VJ
 HOG9.MrbioY7FqfnxUWk4Ez3zVxyPOy3x11BhIA7JkaOeednGJokZ.5Ykaziy_Ooths7QXPwt96o
 1Aq8iE6z4drs0nDl5SF4wG8eBT9ynYaaHVNBcKgIrTzS2fEqYn8a5.j9Mhpdjc5mopUSbkMNYEUf
 gIjy39DMruasy1atDcmYLK.Z4.UtjpbmCwSEUuGKHborWO9bBjPwIYfj6H_VyUb4ScJhSKcdiZaQ
 fuOmtupy2w6D8wlYUPBa6qG_zlEgCrvX_h1fE0nypNP3j4loV2wRthyYuc6QhKXRMmZThSnoLrwo
 il6yXyUz7EOaWzCkomLp8z9r1Rf6rpkgOrqHeBR2fi6jGfRRYLHYhJ6objXrGxsd.RjoiPdvRlip
 _2JMb5b3svZ9vnZsEUd0qmZhCYCK10wqWA_EW6mNNRx59IAk_uHEG3Yv1GL9Svm.dEby.iLraxFK
 d0yoKsX8O80VuXAjcDRepsPi.yIEBge8PMfJZS87XAogR3h1RmJbTrgE-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.bf2.yahoo.com with HTTP; Tue, 25 Aug 2020 19:08:42 +0000
Date:   Tue, 25 Aug 2020 19:08:38 +0000 (UTC)
From:   Mrs Faiza Mohammed <faizamo501@gmail.com>
Reply-To: faiza_mo303@yahoo.com
Message-ID: <1271663647.5488993.1598382518469@mail.yahoo.com>
Subject: Hello My Dear,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1271663647.5488993.1598382518469.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16455 YMailNodin Mozilla/5.0 (Windows NT 5.1; rv:52.0) Gecko/20100101 Firefox/52.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Hello My Dear,

Please do not feel disturbed for contacting you, based on the critical condition I find mine self though, it's not financial problem, but my health you might have know that cancer is not what to talk home about, I am married to Mr.Umair Mohammed who worked with Tunisia embassy in Burkina Faso for nine years before he died in the year 2012.We were married for eleven years without a child. He died after a brief illness that lasted for five days.

Since his death I decided not to remarry, When my late husband was alive he deposited the sum of US$ 9.2m (Nine million two hundred thousand dollars) in a bank in Burkina Faso, Presently this money is still in bank. And My Doctor told me that I don't have much time to live because of the cancer problem, Having known my condition I decided to hand you over this fond to take care of the less-privileged people, you will utilize this money the way I am going to instruct herein. I want you to take 30 Percent of the total money for your personal use While 70% of the money will go to charity" people and helping the orphanage.

I don't want my husband's efforts to be used by the Government. I grew up as an Orphan and I don't have anybody as my family member,

I am expecting your response to private faiza_mo303@yahoo.com

Regards,

Mrs.Faiza Mohammed.
written from Hospital.
