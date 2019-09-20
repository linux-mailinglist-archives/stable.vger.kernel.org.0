Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFED4B9854
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 22:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbfITUPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 16:15:23 -0400
Received: from sonic301-3.consmr.mail.bf2.yahoo.com ([74.6.129.42]:45692 "EHLO
        sonic301-3.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725842AbfITUPW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 16:15:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1569010520; bh=zPC9p8T5S06DA73PD5F75wViZ/EpBpeYylTS7OqjCU4=; h=Date:From:Reply-To:Subject:From:Subject; b=G/jsFxhAlCzJeomuPXHbVOi8HBOYtEkdaz2Som3znaYlrPHvbkmG+9gEEpTY0hlIgTeqtz9gT5SpC8X1nZYZwXj3onjpqcv92TSr5R7KHwxQl3xWr+focUAOCOw3S04/tKfsjlWWejnjZKn04qSfIodZCt0JxnIipQeee1G2BxzNq2hmAMQCEV/YqwORvEgTL9aM6V7TaBQERBk75kwV/JxJfLOMTNmeO7ll9HAi6ZhQggRiYLEtiqYawxOgQA6prvXvJcyERZl/+80tW9vtpzOs8dxHM7Wh+MR8ygAmQ9DvqhKxwItBuUpXcIqOeYfcqe9tMtNyXDXhzESbj6zKaQ==
X-YMail-OSG: QTi4B9QVM1l64dtLHMfmYSsLjRTKoQTUAcJVrzj2PciJIMq9OTlm.adMwVy9ntC
 mQacRjuVLTHH8ZM2I5UrmdWKHboJBR.lwr7I.X.Rf1TVuulTEmIgMGFdJgO8CMyVQFGkYAVVvOty
 LtD9yTfZVTJplwh3yLCZRZHuCmXYnDfZItiK_zmeOq3QUYxBu0YZZEBKJtysA75EZoWtH3Q7rdRz
 wMmgtzt8cXEhFszj6ONWjqNWBjrH9.lCw5r_e2MgvtT2ECdyLBD3x0U8CsJzOCLmgpm6LcFsk2BP
 9q5gMfcUMbg9f_kKnWgSfK6zfw81q7zIncKaOhzS86P1fn5u9lIKmpBhDTfPqeWT0VOGzLRxCnQc
 9mtI_0GNpdFc5X1fdxyMbGQkpx4xnKQEZ9qp5knf1jRRi6vU5J.WhkUPJVWknPeDuNBtCVjuMIWL
 U._LjKuiO0Dx5WAjFGvQfM1sLI1yDzr8rbdG3sTgyAbRDKeDuRK065VJJeeHYRS5qgXlVF2cjuT.
 RB5GnwWWJGMsWnrvzqJ5OF1QbreB4QWFUeZIpOYFkcnAEFwNL7p_9Jutr584ECs71aFohf5d5GvH
 GOUGff9X_MSdU6Hrjklo.XKAQzwyN3JgentsLZU.ymbndkBvDdKb8HPDkNvrYKQMwuXD3o.Qnx8M
 ZYTOSPWWq3mbiKQOxuvzptfT4dHJkhF..AWdYoJHMhcUyYk2HPrzgbHy0QbaqogrdGUPbAj0giMy
 wUd437PW0uksv4Y2VetBiY_m0.0cu1m5nr6xqZVhKwofHAZPfozZql8Qov2AGqX5lt58GmmS_rcd
 SPPPzsQXzoJZlHf2RnHccDjWmaqb3OZ2djb1TB9.3.jgu2hwlHeGj0Y2P0_kzVwT1Wshpk8LA_13
 ._wi9Z19nBWiT9R4SsuI6ff7EY88jLBwUjCipY_3nBYrLEyFuuojims9OiZxphCzO2pa3ZkkA_XD
 QN5HcJyN8pXB.ngToenkbvtWl2WFrPkJ60kPc1W6jZ.Fs11GY0qAc7K1jRnzmratQTTKvd2Oi6hy
 PD_COq1R7hopy.qMGP2hOdse_NIVrT2mX6DkUYwdaWAxp8uZKTq9jEHrNisnkSPwY0AQ0YogTtcV
 VOK31aVwufHuakoD2z3QVCzw7fGC3ATqKP67m4Vpyk9x9_iLNAy5oan9EdWbbcZ5vu.lQXOcewR3
 ERrOpxMyonQ1UpieQyDtJu6IFgfQs02.cYgVjz1jgATIRICE4WMYbaOE.INqTplKVC7o3f4o9P7w
 WK7laWZsauhl54MxmSWzP6GY6I1ORIOe0sw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.bf2.yahoo.com with HTTP; Fri, 20 Sep 2019 20:15:20 +0000
Date:   Fri, 20 Sep 2019 20:15:17 +0000 (UTC)
From:   Ms Lisa Hugh <lisa.hugh222@gmail.com>
Reply-To: ms.lisahugh000@gmail.com
Message-ID: <332130844.7097265.1569010517544@mail.yahoo.com>
Subject: FROM MS LISA HUGH(BUSINESS).
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear Friend,

I am Ms Lisa Hugh work with the department of Audit and accounting manager here in the Bank(B.O.A).

Please i need your assistance for the transferring of thIs fund to your bank account for both of us benefit for life time investment, amount (US$4.5M DOLLARS).

I have every inquiry details to make the bank believe you and release the fund in within 5 banking working days with your full co-operation with me forsuccess.

Note/ 50% for you why 50% for me after success of the transfer to your bank
account.

Below information is what i need from you so will can be reaching each
other

1)Full name ...
2)Private telephone number...
3)Age...
4)Nationality...
5)Occupation ...


Thanks.

Ms Lisa Hugh
