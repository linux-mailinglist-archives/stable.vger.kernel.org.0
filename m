Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B61E37B8B9
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 06:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfGaEc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 00:32:57 -0400
Received: from sonic306-3.consmr.mail.bf2.yahoo.com ([74.6.132.42]:43616 "EHLO
        sonic306-3.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726334AbfGaEc5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 00:32:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1564547575; bh=tPdyM4f7Tq8kspt5syr9wxbiHLUxanV8lkCr2Pkkkas=; h=Date:From:Reply-To:Subject:From:Subject; b=G7EE1wp15LCXlBx8mx3ywoGcOXENawY3co/k9BHsNOVI0J4GCLPH9orONNYB2AXZPjIBTa7o0S5gVJwhEbsF/1iB3EEklkiJSdVP5fAXLApSvliXsUHR+JeY0XK+0kb1zbIpuacEQuk5e4CqaRU0/yOERMEMNPqXutZRX/QvHg70f0ga3ZZYbxklO6IL6qe5UYE7E/IQubKAX6uxTaNldH9re4Dlfg8uteKt6dCMe2xoZAAN4Aw0bphUZloUn0OQbbCRcX04I2itSrVq+MoDZvydcyage6yW0nzVCxJ9srcsqXQnn9s/mFENs0WCWbx2NAy1KiiwBpPgihiIPAQ60g==
X-YMail-OSG: AiuxrGcVM1lCRdzQ0OTE9XSf1zDtNH02D2MegpYNsrORYH2X0WO6DgK4LdiPrBL
 t5fgcthOJCQ5lqWQpuxlWLV6_NdXK630h_T6x_Ywx3UWdKBeYxvtwTTpTrvesdnjOswByaY5TESY
 HyTvORuMlmc3Afw7iGBjiJ2cMLpaOwjbrkKuDdxvhm_Hn3bVB.WEruq8oyMMECVMyEyx7eS3eX.y
 aJXG88k4rBEGDXdkzYDBAg9Hp8UfjfnRnbOtTo.6nkcxe3OqE4VJ5xrIot7l3RVq3fcmhkSPnWJ8
 _CS38MFs61tQwc7LWr4aLP7R6Ft1QeJGnyvLxnLKtNYMqOu5AetjLrMET8UUgiXfmleU7Szwy6iC
 HKvsZQ0wMJSbhVAds6ezultMOyqYTVU_1cZSUxQgL3O7LxNOgyvmbC1JiV9dcuVYU1.VfPsyzT16
 iVEqvojkaRU8dNnKthwcKQIwvcXxGA1tRCGe4TQB3mabCbKbwvwbrFCKrmaFwbCBGKIHMlzqfUAM
 NPSr0teBf9.z9vqbTuoQLe4Dcv9xFsVU.HnA79KpnTjm6NHUrwhD5hDFx5FT3MEMDdry1ZAaS6oj
 w8jgj35BMw8_zRT_wpLi9I.aW.QAJAPULjrakKr8GlZtdMh0Suel_AeOSZZy.biywA8MlTD9i5tl
 9iU54tfhinZRwrZzSKce2Ke0koWbdBU5dPgjeDdX_kQ6v6aAxFTmc1XfJQgAzcld7zHenAIdZ8HU
 Bq1oghfOPA4hBlNTrEe7D7HBnUJAal_Fby1.scVb3GXG_k81m.fpkOiYjHKOcY_buVJAS2hb8FzF
 HDD25nSb1hAkNCkNjf.Ewtjk.LdRin3LrsXjGvs3k8bxHI7jGjiPVuIKKspx9Xhxr2coxcJsx2fr
 BOD4wD5ea9YIvTBEBbqTiOMgPI2vvOH5WLRy7A9rglXdq3jXUbsIiZF.qH9LkiA8EWtt4QkwfvC5
 HTR4G_83zyA62MbaYHkv5SgZKzLYjYKTyqwkeF8K6CFEAw3GFMV5ZkuEmLvkGyb28vVT0dWfiRGS
 KdRWk.kLQSM4Yg2yqdQqbOOrojFwu5FIIybU7B1FtT1rJaM1_HcG2ebSj35L10B2sfqIavx3P6Yc
 8DJMb0Q8n2ycB4o_i8PbeYuggWIeVNPoJ4SDwd92vEH_2YqF9_ttYbKc6LjfHtRlTGDx3dmLsuYf
 pE2j2jNKhb2LFaMZZeZFFlLSOrdtCcl5SPvyNKfwDsq6kLV_2Hf7k.Kp9hD28bQ--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.bf2.yahoo.com with HTTP; Wed, 31 Jul 2019 04:32:55 +0000
Date:   Wed, 31 Jul 2019 04:32:51 +0000 (UTC)
From:   Aisha Gaddafi <agaddafibb@gmail.com>
Reply-To: gaisha983@gmail.com
Message-ID: <192137693.66907.1564547571723@mail.yahoo.com>
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
