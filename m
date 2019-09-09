Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE1D0ADF0F
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 20:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732236AbfIISft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 14:35:49 -0400
Received: from sonic309-14.consmr.mail.bf2.yahoo.com ([74.6.129.124]:43005
        "EHLO sonic309-14.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727070AbfIISfs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 14:35:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1568054147; bh=Acg6cR0d4icHEW7zNvIWmQRAFY+LtLbaox2Ux1TaSkE=; h=Date:From:Reply-To:Subject:From:Subject; b=EtADtT1WASgHIjx51RQ96t8OE0Z+ovtWbVl2LT0xY3kBtYMRilzhHgs60dtRqe0S7UftlwiBopWQDrJsrRa9uvdJX1jVGTQSkOI09uS6Ho+1PfawCkF9X4A4MtRtQ2kLbEZmWdp5ilHf3nIQD91xHxbd5z1PY9XAlUZ6RVj9w20ErkxN9glAWJTQ0p3JY0X01ERQibhi+EE6vlnqn7+tx61agXOnjdqzcmNSwFHP51Q5yS+3oB6d73EGLezbiEsmnecb8zfZFY55cWksa7r+WC6Bt07zLjuzaEBhkP/oK8U6GAr3+Ftbdt5vAtWxWoU8sMNfnr3OhGkSplZU1qCr7w==
X-YMail-OSG: iUdzdK0VM1l_ztbi4Aa_CAdgq3sC_iII4ZJaO5GYcPFLksu8CQIKNvdujNnTo4O
 nF4VhKuZYP8iZYAYjdk3iODL1R7.ihPhVHNHF3uKlUQwYhMx.i.FHiNKwTqkWuvcuKrl9KiuxSfn
 onxvvzx8j4kMPsIHxYa1W_YJdwsI9ccCHfSBAsaLkVO7nrGTDg2eN9247JLhxKt1oe9ZafuQdKvc
 OQy2dOzUNq1B1sZqSj2FkMT93FDIw9cITyEwTTce2jEGwJcHb7oHGF4TFSx6SeZwJvLIviG5.EQ5
 hVrRk4L0YHcDo6DdTFsfK8g0w2YutH.2.XThnBt37FBiOLAcu1oTA8gZhWJbxwnE05ktNFpJ2Fqu
 kO1k_YhVNAaIiSkYJfIAa9Ej9pBIdWYDgrAeFYQCFXZNtLoqsEPn_ujcvdoPDBCFNKUr_k3zpK9g
 I9_eRh_1IVKWofuTIGLABZrRDehoZIka602ZWFK8RbLKJoAZnx3OuneoYELJUO977nsL4dpDj3TT
 4BKqkv.pNmmToOVU5MQaAd_SaM5w4upZf8N66.8ay3PxvKm1pWLMfo3waHu8RuvQyUGAvVXNAO2h
 TwZ69FDslWk_wV964tn4df35gGny56Q67hGVqE4YqIY0d2JFewBhxNptJVGsKiHvVZLi6Vjbw49y
 okJxWkgYbe25QFqBZUNQG7K0kx0hcIGKz5ybWqslChWlJpqfbF9UZGpRgRkV3MHWZz15Xz_3vj_K
 fnKOKboLCvjgoRrV8arYzUUH8.tEAJUtoLOxos1UEoyZrepFpfo.NLJkvpLBWoKG5hKdtidbfiuW
 olUI_QfX4PqS7nEn53u8NvOW27XPoOLbn0A9OUgN3zUki8zP5D43FGtkfQSfVHAGMVYojEBfSkwK
 eeig1ImjP3Nc0vk_DVeyObYPWCv5us8YMo2yRPYBp05vbjo1Hv9LHsrfrAvHWdzHKfmBnqO9uDTF
 _4ZQNXaPhRCjkGODxQzhcffL1UAvBTy58f56MgCdeeh04NAez1p54pz2mAzqhTzVEagfTBedHQml
 PmLgcL06kPdEDxOlbrDCfO3t06bnyK6crriCcL5XBDUeTetOqv_DIik7CYcd4cWextfk_x5JHEjt
 3.oCEZQLD_Tr0bV9jvGQ0Fr94zOUUspjgYpWI8ip45FLBvs8X3RV934QjXyW3XTo4n7HAQmaQs99
 2NblUBqOTedXfgU17WJw6qQn3odjpzDikAGkxXdwJ5JEPRRh_jixINXweGkCwPO_52WsC9WdbTOI
 wCnDC21j.ahGz_3.tHhBxHFM8ow--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.bf2.yahoo.com with HTTP; Mon, 9 Sep 2019 18:35:47 +0000
Date:   Mon, 9 Sep 2019 18:35:43 +0000 (UTC)
From:   Aisha Gaddafi <gaddffiaaisha@gmail.com>
Reply-To: aishagaddffia@gmail.com
Message-ID: <508393378.3088626.1568054143335@mail.yahoo.com>
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
