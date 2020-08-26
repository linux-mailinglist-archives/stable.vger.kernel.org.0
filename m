Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7874A2532FC
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 17:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgHZPJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 11:09:38 -0400
Received: from sonic303-20.consmr.mail.ir2.yahoo.com ([77.238.178.201]:35746
        "EHLO sonic303-20.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727116AbgHZPJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 11:09:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1598454575; bh=+NKq2YP/4c3bLm2HmGhxa/KCZOXr0NIUKHs/ECuC0yk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=Vq2Ool3ICYtSx3U5mwhsRu9wv2NftIue2C/hQREtUclp/+FjCXhbN+VWK4vIiEhBBV4jsOeGsfucCQTA6gTuvmwSptgNI6duKXoHxSllejGagVAgX0zlnlk9vcRLHCzT62y8nUzMlN+Y24hu2JORO2tksRFElYdVt6OmAmvivlObLuvVHYWvPW0FCf2XoSXUqmMdLfiCY3iqbXLeNw0OFzcel8fjwH2N4J163rPZZR4tm8szJqX5h6dzvBVAD0cATU+BRx8metjkLschXd2SGKsrEGRUlQPAicDctoseHrTBbDPZI9jcnXGEoIgIUKG4NTvjf5yOyWboKlF5SQXYHw==
X-YMail-OSG: iwBqoo0VM1mg8RAJvYOzwBCMgH6eCWZRVPsFPpuNAF63s4FlN2lpWDi1GH9Kwkq
 J4VOUcei38igFJMHmTf7V.WQeFoQWjJEZlh4x5AsRyC5TFGlLOsaQUJEWU3GtYVG4yXmxy2qN.Ko
 zPjtFHVGXu_Qb._D05QpGxcRydkuofFxhTY1eiz9rZzIk0u4ILDMsJ.OXZnpZr9yQJwm3H1T7mI0
 AQFBp5G.f3HUCZJ5xxtWAGAlaHSPkJwRVt8F09SgDtan8IXfq3VZcbUwKrygsJpLgstIf6ELzbPY
 Rt05wPrboeuDkMH3zB4Dz5ab32F3BAdNwhezIY3hs.5nobn5gk_t_Gk_30CqXdMSXEsCqAi09ONU
 ptPNhj.xpFZDtWJzTR.1KkB9iDtCe53EFps1XfHEveDzScfvTPLXBR7RCj5hZcyjdJGwxLo65Usc
 a7DoPsLPmvuqdrTkOn7DPhhZS8h.rZ2LC.JXT93O4zAIJHgAiGxsgpG02AAO29o5AEfLH7SBz3fd
 Ad2PNkv_slw2HLJ2TltXXg4z2kKV1Fxgyu8kFYhatweT3UuhPr0zDQVYJObStgsbmT0TdNMVNco_
 BkRRsQzA3ORT.sVwXnjTVA_bTYL5OmB6_7jWfacGAZ7WXGMHhezeQSxpeH6GytsEG3GLgZK.wxjT
 9lpRHaz9UlTFbBvA50xiCZVAyBNM9wUEI4d8.Tc.bjCgov3ye6mOlszdQqYW67gZfa_G0hZNgj0q
 Mzr7Gvv1iIkj9_0SwMrGVYqL2S70_HJlUscsNrxdTEdlbfzL9SZydd5hrAWWb5pIv9QPAUQUpaJP
 BUYlzQzi_7FKrMIaaIwWK6RaUNNtpvf1yfsQNbIUH.vo5CzE2m0AMaUMSqmSBGibOSexuycOx_mj
 BXZSfKyoOGnS5c.Ts7IqhKqJS17YvswAXKMsM0OIGCbKw4LAk_vvaQhADu__jsJPF4j6ZELfTbNv
 jOLI3OjoJNMWHnUhHWsMdU0bIJQE8SNeVclfAui5GlAcnAgKa3pa..2u3_EbExNFdShybbcbWalk
 Wbsg0i0YuY_gwK_1B6hZ_Y2JZkhFfHvn9g8Hvvn1NS7U10H7GJZ224PB5vkHEKLR7_Avcvy2Waq5
 HutAYCl65dDGE1cMMZ7UBIX47uL2NeEUu8JOrSSs0FIZq_wZm_GU0aomZDAOf5m1kPYMv8ha3Ypm
 3xXREt55kHiwU9cMqP2V1kOng3SFRWPwuGqqfjFR7.6gh15Htf8zZTZlHH3iZ1JIUP8B6jk_uEPs
 XEPDZZxh2HqOLYOaO.vnUB.YY6FljRYaVZbvJBEn2lKSgZqzyAh08mVddlyuP.MZukJNE7es3vL1
 O80XKpZvaWXtxFjbfMMzpbGKi0kR0aGTBPz_ynlY2aBVCkFZWHky3cGLGuMQ8HMzasCwfp9huH2j
 Lhw7dnQU2hsiVAgxtyOaUOcesSEM9.9CsWDQXfqDBSjhtrwBi5Q--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.ir2.yahoo.com with HTTP; Wed, 26 Aug 2020 15:09:35 +0000
Date:   Wed, 26 Aug 2020 15:08:56 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <mbrunel896@aol.com>
Reply-To: mrsminaabrunel@myself.com
Message-ID: <229377726.9754475.1598454536449@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <229377726.9754475.1598454536449.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16455 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



My Dear in the lord


My name is Mrs. Mina A. Brunel I am a Norway Citizen who is living in Burki=
na Faso, I am married to Mr. Brunel Patrice, a politician who owns a small =
gold company in Burkina Faso; He died of Leprosy and Radesyge, in the year =
February 2010, During his lifetime he deposited the sum of =E2=82=AC 8.5 Mi=
llion Euro) Eight million, Five hundred thousand Euros in a bank in Ouagado=
ugou the capital city of Burkina Faso in West Africa. The money was from th=
e sale of his company and death benefits payment and entitlements of my dec=
eased husband by his company.

I am sending you this message with heavy tears in my eyes and great sorrow =
in my heart, and also praying that it will reach you in good health because=
 I am not in good health, I sleep every night without knowing if I may be a=
live to see the next day. I am suffering from long time cancer and presentl=
y I am partially suffering from Leprosy, which has become difficult for me =
to move around. I was married to my late husband for more than 6 years with=
out having a child and my doctor confided that I have less chance to live, =
having to know when the cup of death will come, I decided to contact you to=
 claim the fund since I don't have any relation I grew up from an orphanage=
 home.

I have decided to donate this money for the support of helping Motherless b=
abies/Less privileged/Widows and churches also to build the house of God be=
cause I am dying and diagnosed with cancer for about 3 years ago. I have de=
cided to donate from what I have inherited from my late husband to you for =
the good work of Almighty God; I will be going in for an operation surgery =
soon.

Now I want you to stand as my next of kin to claim the funds for charity pu=
rposes. Because of this money remains unclaimed after my death, the bank ex=
ecutives or the government will take the money as unclaimed fund and maybe =
use it for selfishness and worthless ventures, I need a very honest person =
who can claim this money and use it for Charity works, for orphanages, wido=
ws and also build schools and churches for less privilege that will be name=
d after my late husband and my name.

I need your urgent answer to know if you will be able to execute this proje=
ct, and I will give you more information on how the fund will be transferre=
d to your bank account or online banking.

Thanks
Mrs. Mina A. Brunel
