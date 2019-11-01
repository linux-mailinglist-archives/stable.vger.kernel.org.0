Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD91EC99D
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 21:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfKAU3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 16:29:47 -0400
Received: from sonic303-3.consmr.mail.bf2.yahoo.com ([74.6.131.42]:45490 "EHLO
        sonic303-3.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726701AbfKAU3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Nov 2019 16:29:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1572640185; bh=tnR598H/QqPT1Ph/+p7nVdpgic7bknwMcbeRQcbc5RI=; h=Date:From:Reply-To:Subject:From:Subject; b=GOA2YUqD/1BYfHoJBAW3pIR5wUfz2t5zMiYPSzcZ+25c6Fyx5Bj0lFaiWX4u4uVRVf7AvF+BqgVb4Vj+3/+xF2ECoYj6tfANuoZ1Dv9soMc2pQtox7JfvhQo0KfVYJGolqQC7DTPgsyYctIk/bHGRWeAZXdXYrD6u2CU88UKvc2J8sErKdXYqxA0CHdluxSz8D5497p0LKJYBtI/cl1dw9b8ZCSAEgb5pTW8iHNf3w0oldY/ufckIHn+abyVzkLyNNq1xYwR6RvuA0qgJSpu6BGZUEtETwOIef5afLXqlEB6rdunyTHSCIh1tQQHbstBEqG2dNy0iNohW3P0E73fdA==
X-YMail-OSG: SDoa_2IVM1kgX4_thRO5McQh4k9EsH5EKXKSLsVhy0_LkVHLEo100iNdMuCO5El
 TBl1ZEdTUUG9.v.uggnenn6Qi9hu7eml319Yd5sblzyioPFNqODowyi68M2GOzp2p7N_sVpF08cs
 tYjR5oK3FKXscUmD_AZoHoTLgY1NFKvWp0sfameMdz.0DBZDVBDPAW0ffhfymmXAnbsXAif2QyGh
 3knB33ur1IU6x0SLNWxhJlMWkAI7Mxz3okRDb8ZlSqCd7jMwfEo3j404XLSkczdgNSrgzz_m5jEd
 ahB8Y4IVk03ofOs5GmcGbTquI1ja5P4t0AXFKMLRGninlVlf6tOOwaST04F5s2yAn5V1ivuVU28i
 1rQZYlYFOnTbIXJUg.ll7SDMqeRIaYmC3hvG1WlQVOHCwkuZXMCE1zHcu2bRqOPqDE65lv.5.BMD
 UHZf.fqCQIDXlIGgk5i_gaVyD_MXJm4AFmsTNAZUXudJ0J_5K2iQsHp5VTuWrDelwu_WxOOEuVeQ
 Bu2somHQX5FlH7gjOyRwiCGDg7O6SykHzCxGyrGFXWJ9cfBNXn7Rv8UraDewIAJRxX27hs17mr0E
 ZvXpNq.2ThIg1Wd0A3Zr0HcJ_saw2XjItOsvzLyFFzHZvg6MevRnBnKh4X_sKxhvBqIQkTssnjEj
 s8qAtRY12zlgHDSSdWTNbS93pxaHCXK8c2TrKpo5ug2CR5bKPebK5icCPuyv8rAoUR60S28HWC8a
 PSspVH5PtyOMAoH6Xca_wRmH_XEIu3Zfri1E22RSsgL56hhKNBRjo6Hkj1V_fYwC_Q2ngVpBVmOv
 wNszIDeHhaFA3rhkgFXDPcVVAPyXn8absB.RaZGjKV6qmFr_uIVm5HAKZ5qVnMEDP92dueHAe1wi
 Bgp7hziXCkYUehVuzp_u6ScMvKKwoHjhm6aNjd_xAw4qpounVmjMVjpCnjffxfl.T1Do6gxHHABB
 SMIxbQraN6TlmIUrykYyKJIwYd26BI6wFiR4yc9HYZTwXKtQ.tBj9DpDKBn9McNvvU6JzY1TBa3R
 SAo_RZdzCmoI.WiVzROj81JMei12yp0GdSW.zg0PpbvHo4DG3RjefnY_9xPgRHUuUVddV8g_Iozc
 8cuKuLq5Tgm.VJcIFKj0rwuI5PFqooQU9jum7yKHlInrxgdruqzXZFE.teYE3RYpFKJ4prtqPYxo
 65O7natLi8gRzqhqr.FGKKlb7D3j9uGQ7p.rVIlt8W3cF..gilklD0MxvpumxUlJdN8R_arLVg.3
 wT0_Q5LCReuOdxeacgb58pZ8hUVybAeWeBIc9dGy_A6C6y_2JvSGVXIdQgM1wxfOZo41fHPkDO1O
 Y5nMJHdw-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.bf2.yahoo.com with HTTP; Fri, 1 Nov 2019 20:29:45 +0000
Date:   Fri, 1 Nov 2019 20:29:41 +0000 (UTC)
From:   Mrs Elodie Antoine <elodieantoine890@gmail.com>
Reply-To: elodiem97@yahoo.com
Message-ID: <1979087302.5122.1572640181002@mail.yahoo.com>
Subject: Greetings From Mrs Elodie,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Greetings From Mrs Elodie,

Calvary Greetings in the name of the LORD Almighty and Our LORD JESUS CHRIST the giver of every good thing. Good day,i know this letter will definitely come to you as a huge surprise, but I implore you to take the time to go through it carefully as the decision you make will go off a long way to determine my future and continued existence. I am Mrs Elodie Antoine
aging widow of 59 years old suffering from long time illness. I have some funds I inherited from my late husband,

The sum of (US$4.5 Million Dollars) and I needed a very honest and God fearing who can withdraw this money then use the funds for Charity works. I WISH TO GIVE THIS FUNDS TO YOU FOR CHARITY WORKS. I found your email address from the internet after honest prayers to the LORD to bring me a helper and i decided to contact you if you may be willing and interested to handle these trust funds in good faith before anything happens to me.
I accept this decision because I do not have any child who will inherit this money after I die. I want your urgent reply to me so that I will give you the deposit receipt which the COMPANY issued to me as next of kin for immediate transfer of the money to your account in your country, to start the good work of God, I want you to use the 15/percent of the total amount to help yourself in doing the project.


I am desperately in keen need of assistance and I have summoned up courage to contact you for this task, you must not fail me and the millions of the poor people in our todays WORLD. This is no stolen money and there are no dangers involved,100% RISK FREE with full legal proof. Please if you would be able to use the funds for the Charity works kindly let me know immediately.I will appreciate your utmost confidentiality and trust in this matter to accomplish my heart desire, as I don't want anything that will jeopardize my last wish. I want you to take 15 percent of the total money for your personal use while 85% of the money will go to charity.I will appreciate your utmost confidentiality and trust in this matter to accomplish my heart desire, as I don't want anything that will jeopardize my last wish.


kindly respond for further details.


Thanks and God bless you,

Mrs Elodie Antoine
