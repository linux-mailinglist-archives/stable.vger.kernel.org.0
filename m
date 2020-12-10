Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C972D504C
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 02:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732232AbgLJBXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 20:23:52 -0500
Received: from sonic304-21.consmr.mail.sg3.yahoo.com ([106.10.242.211]:44232
        "EHLO sonic304-21.consmr.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732279AbgLJBXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 20:23:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1607563375; bh=0uheJ2Ma86lRYmOGjKZPL53KWrgqYym3ZYzfEsoGXLY=; h=Date:From:Reply-To:Subject:References:From:Subject; b=AKEo8vIv9M18SVZHz492RsQlontsKo3y0zEyHSX7okJwElUGljR+vWma9s6tlFr+Z7r4YWQTHziueNETsulclh7CTSjIE0VyMuxZMaG8fd55ER1521v+FqO/+w7fmhhwV7sGuyhWANyG7C7h/2o4Ox/ahypJp8zAL2DC6ImtlPMqI1VwPJdxHaHJog3mytwo03O0D6LFwRrbX1FTMZbwwECoWZr7DGNJz36obrwd0TAz84smIIqoYmEgnHWx20Qo8Ht/kLtIN2Kx+UILIhELmF/9D48PSbfG24xWCFLypbqr36nIp/iAOUQGifdmgMi8Tz7x+YdCSp7flgdZu9mh5Q==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1607563375; bh=oeTmpDhxmvTKtTjm6uqO1T+J62dGDTlGpKldccTtqrJ=; h=Date:From:Subject:From:Subject; b=hi2qwTdxwn+8sH8uUZRg0oe1L34AizKG44PJqHA95JTC3rjORi18Ef6nJ88th+q1VJOS2ziicYG7l4bBo0tPcDZntrZFtmzJhuVJ3RybUk4AZhUBZ6BmeJcRNjseP9+P6xBx5a+JWDz9fieCBgB7Zkve0qodq/6Qtu3L8mPXPgpfbyYhGSnNfaU9y3f2Sfvj+xr8GZjgsBS67yWqGv4sXBzGLQexx3GzO0qEdYIH8jwk2xHGSN2VhlvXbFggWhHGzJ10sotfjmbqullZoQgGjRxvZ9b8ZlN0flHAslwPpgpWnlUKQuHmOQKdkEd+9EYEZ6OPum/Yoaj31dYXEwoXng==
X-YMail-OSG: WLcyipsVM1lyzxsmBNZiJumMEoCb2tz68RBAj2a9QvG0UGq8.Zm1K5yWTJ0h0a0
 1RnBtjT8ZUhdoQx2asbdqZGxWLxb2Wf0eGL7ojUFevy1EKpoOJGGQlP6pL__sQ4NDo0_x66qJH8n
 .r5KdSwGCCM7HTkBVHwvexVlUKuO08X0fVziQ.QBQY3wArl_J4HIF4LkWjJVw6atEdHYnH_gyFHf
 5Qp_yw8yxxxsCEMPxEQFJbtZq9Bl02vqHkcYHOwYGNtFItFmH8dgkDesxiGfuL87xd09CGZOR98j
 EOn_cn6jb45L1b8vZsyGNUqfn48vDf76sLtwB4mi.qgQP1RdlrIxEH4oTfL1H7iLJfYzahKxabAp
 F_Of28.IRMduSucHkzbGhZKcxpUPLjh6zDklt5w7tTcbl3WjqqHxCE5hxqc8zF2HxQ5SsycloTe.
 m0BrEnJ.kBDWMfQEDNw32wHkmuXe1JvAhPfsmVLDfWlqolaeeo1qgzsxAouxg0xqz.q2YGr4RRC5
 NOpyGtjKHpKngOyuB4zNsWkUT1cQNgBGYquRuNaFpoH_v5IKDHX.3N45ozXlh8PAXNxz_TyH1TDf
 4hLo30bwsP5FYs_FU5VNMp_SDCRqHp.qTahqnsFTTmIUFup2uZI6Dc3VTh3zL96C8xIufE.SaSLq
 osqcsMCkIsBn8X1IoQyyc.0wigjkd_MTS9_H7ck86SFlQB4_0BetYSwwVuvEfRWVC_rlGkkRuQJ8
 .ihwmqTVCVjrcIYP_RJuvfXt1EKcwmEj_tpBXxOd6cov2VqetXPlRG1xklmAmZTyWgp6K0G.Sq1E
 rifWVz0l6apTbdTSqJ7goNQZD3Lgm9_P0oFbQZiYv2HSy44n.T1mhZe96uDVWnY8LZv60omNlIpU
 U7L5zwcJ771Eswhu5u9ZFR6DvMr4LEzjJGtQqgNnBkA8HvCgpDc0KLx0PvafJlQts4N8YpWOJ4Tz
 FsBHf0ukLizYbiId1v0ohI0DXtAnV6XVM3anFg3Q_sF75ZuL7OTwDH25_n7S5VU36oeEH2VqOQ9F
 8h598tqTAOPhxZuyxf2A9XTWd1pRMIayhlqRP.4eqskjoeWEWHDUWcwQEf3pL4fQMWpp79ylL5p1
 gfGDHB0lGMLLoQdRKKf9hFtyJK9nScHw101ZQfOD5TbqOm8TLC1iTkP2B24dKLngFWnSY4SDX8Vl
 l9feheYEEdbQA9vg5RTIM56bz9a5AanyHAb.vKfIDps9KGYHm0bl5JhDiwFkXfZUNBfKlQv_BGlh
 a_4ciljzAKx29HitOzA6zHl_Dew.Cp4X2cm7vKM.scArYAjamU5JgAKpTh.3kwKsiWSle7rhzLd7
 LB5LqPfG5fTyoWZdYgy_5FXSRJWnya0rR9idssavDZqmAHYPpZ0u43W76RG6xjgvn5b8lgUbwkN5
 qPzSxL6Feg4XSSSOZ90neoYZ8smJe19a6VBfdgmxZ2CmESPlz5GOajCOx84MrvGofMJ0fMRb1r6b
 nzgJZf6X23jx4zbAN4FI_dsA2byiRuxlvIBcEu6FXT4CZceUGb12eww86ohdi_K.Ni_6s.qOcsj_
 _OL7c1qdFtwyJngB1ttbPCVhHB452m.eFAUiP93sFFXrgIK66a8lU4YVdJAgif4kebTmvNbW0zlj
 qISvjg00V6Ga_oxHExRh9pB_BLF_liUgtFoUcRqqC1IdXD1GF0QAoLIIytkDrYRGGdH.R7OnOhcI
 P7ogEzK_GjtYcYKWfnTszTQTzXtpuSxAjwbn36SpF8YBeTi9gE4bK3ho0REECq84xIIXJdacjI9U
 s5nNCrpUwSl9OrrLsD04kOiuXjGyzKyY4bYpfYEa3zPvmf9JFTCsd3U7U3KcXEO7uYm5RnwuXhqn
 XLV1jivqmnZ1FvlD2JDZIsdMmiUjdBqb2rLv1d9jSTzqfb9l1Xp4pesroPOq536oE7wulXS87rUE
 TImwJCUl10J7rYIlTc9APmW6cQXmUvebwYeNehomLVbah6Q94s4773k1skOisg5Wd9NY9vAnZVcM
 BClzG8DaGE1D6QjxRm1GcM.OaFE8UHuWumDyamUT4CbTbKUCS35E0xWCm1Bd861CazhVDtozEK5Y
 M_aUAAz6cYdxRfjj5bPjDJpwRX5I2Q6QZOfO6rI0Fqm1OT8Pu7RC3msZMK4IAhu5KLQWdQ2lFoWR
 0TPsAiX9GWtnOpXHXAKwurknxXQzf1Cf.Scln1JDnLLj1i3c57DEBJUKYh5VxkqG9eJKB_z947cz
 M17HIUurCgaRrBYfJ1eJ5Pba6_dTypKq44fsRlBwQ3_lJAPnAahnA6gtHNK9p1eWzbSRnSiVCvOc
 sIvm9MjoCsFfIamkHvhxjf0YQVuwBulLaBap8NpviRqa7XcsyLfheyWqLAZX1w3cdSQdd.gHtXF2
 jeMLHCLw1YPPgmZKgr5xbzyuGUVQ7agCkbjJHG64v51CIeYfzq4JxNsUXgL4NC_irXUb8zwoWHHh
 UOPsvGZqOdyGY5h17lO2XpFHzcmLCZgdQG1LEq1wvvyf7pN9xkCgxjDd5EebzifOcr9uWeg4j2ZT
 RFoNyPclRTYjlJdyrURpW_G9RCsx9maO8QM_lOxpIfdkbUNeHwFL9xap.lH61rpArQ.wT_mThiRi
 .hxv55UEZvH.KgfHe9U7bpgvnWiTFlDdh10CWemmoel9VFlity2RM5wSaB8lhAUgniK_wNqPBXqf
 MRNtdSVYbXTTlj2lI.8h.CrKra9wTWBImbKd6yNFT17T8CAoCdOZ3slpAh52QIHCOH1uPzoKURyU
 ZWPxKtpeZmTbmu8js3XQ9Tkr_Ak5BGS_Ok3mOL4dPIGHj5fSrnv7sgaiDg5w3pv2gWDkZ8e9U1v7
 A_9il3sT7VWm3Sutc6U4lgHnzWi2EEy1QHErcy35Kv7_MqfyAYgYgAbTE6UslWUVtlgwwyGF544u
 6i4GzahqNMJFE1ccwg59A8mQ5QL53SgQL.J6u4Br68T3xsz230UooU75dPE8WNthhb.Eo5TRn07i
 CKi3VtmjBkoupd1c39xU88lTWWiQkyrdUfoNvFkuEV.2eOmLSNRyiwe5DIL5rkhlG52gh3aDcCTl
 voAsre50S55Vr_.9mA5smqXVg1LByiYhrwVPKDZZAFWyJzqQCah87mhovpXyv2DuvAjCKCDZKATS
 ekbzaTXh581Y2y0EuDNRE83Ku1KZBHH40l5Vq7dcmOU0hegs_ptT9UiMbUZMDDbU6CAHF1uPhP1a
 xAegKBdOAfpCEnO6cavtr9cN936GxP_Ik1HrVb1seMqBo.8tAiUDIZkFp6eY3oz0cx3ZfqIZf81z
 hUjzuyOGKihvfySidSbLG0f7Qo9Aslf.aScbio6Lmi2CheAr8jy21H0OKDoiumXxm0tGJsmweXXs
 AHb9tBk0VJGwf9WB82vM6SOloCrIDCYJ0Hn0871jEueZ8a_fV_f73RVFU4C.hC.0KjaKg8JM6Z.X
 GLTHAz6MmMYaqVMBFu1WGagLg214uMRdF_w0jY7BuP53RmfJu7uATRhdzu4huKxxC3etg7R7vMSm
 TlxFHA0xA8Gjs4jBuMagersVvbqwatdKozdxj6kseiAPBl6HJit9u3wbyThhnEXVxTC9s7.aeMqD
 aXgrLE0NUdB4xB9AlIg4xdyiCS0ursLg_gJXOP1pvBloBxD5q3eTCMxnj_dVkv7ZVINZvVB50gFl
 NWkPZeIOvyPQ5jaAVatYA3_UbDGHGUwcVzXZlKd61NLj1cRmyEzIUg4j995O2lR5hojPgOO.vWs5
 v._ZVExmVCu9QN8q.I4u6qWTJOG7NGbzKXCqilbCtyPVDN1LTdMJNGhTkTaRL0Goeial55dFqBhm
 pB4pjiyt9Pnt6wDNJuWK6n8WWJZGJ9w0Bk4L2aDdAQBFWXut7dLvuHTDGdu9wjJWwhXz4_A7R5Ok
 t0NG9GVJGAi9AaGISb6DQtjnEycecq4ILQo6SUsLF62fHEvMHQ6liQI4dDnCOdSOnUajjEf0F2kg
 AfqDzDFfTcSUegDWxhT7XO6QkLCGvF4gOMjVQIHVlLlFMpz2FbDFEccXGlKBbqVe6Q62aVd41pTN
 Jy6kCXiZ4gY2KEFIXkLDOukS4fUtk9ET.Gh.WZBuJhYcEhQfTMc2OuaSCMFHyl_FftlPC8nJfNIV
 fQmodC02aNPfdFPtXgtexkhKKfLJmkgp7dXKKvUkjIq7uhISzRaHvYmIPkGyAUs.JkyCpDJaBX2z
 .I2uvEE0_r9xmyefwr1bLOCAZQWeRUXskxE8lJX8S6ny8Avj7nL0XU8t1umMw2_TN3a.2PgbIyw1
 .xV.c6fdm9ApF8jZRzRpxCvXcRFC97u0nakLvNtS6AnYodXJuTxyG7Jhn3XPagUjWPZoFEIPX5xc
 tEWui0.zaAbuV3a2BBM4INRb_eOuif3Qovj1WDzbGHBpTIO8xK7M9ersc8WHAKF7vTam4ZHXr0yV
 8ub8HBHaVoGFYJgcfBNLzToohbZQyYKGxXAjTaGIyH6ZWTTZYtK8sp05pM0P0HuAt92cJZOy2rTd
 Z0wrivQYpwNDQUmQp93ozwhd_NzZ_OkOOaxvcqIIpUGE4hGcSz3XSwXID9BKuNNjECsr1HYoj91R
 Y.2TB8A3IMSZbx.WwSZxbNzIdxWjk2zQsqLmZqdh6lulLYBK_hwLg5LlgJvTQfeo48FmGPk6lUvb
 4zHfycBC9TDri46bC_pF0cJcP4nPLa24UlgxyACYFeZOJuSNc4UrcfEa2EA4T5oxRDYuwHMm4izi
 txKK3.wQtY_EtGa.Xa.Q7ceR8yIVjczFBdYD3sDQlGrLcKuySX7KeAKi4BYVClseeibdCbY7UC40
 79uPRqaMNh53IC9slbKIJrnB4IxM7haaNDS9O1GYtgdGJ.evXNygoA_agJmzN7CtxDtpLKcm88CY
 yhvB4jYcnBwuvXZKi6NabXcgIZLta2Z7ZvWIthjfJaAqR7OiHPTG1_xWNAAQ9dkNKmm6lT7cafCk
 46APSN9OItCl.2Idnr4haaSwDS0ym1xTRu_eJ1QcKuQt9vBeXpSzzAkA8D1ZNEC6JldLf8OXk_ld
 VtjqEwGmyS.Zo2npUM7E004hsVMIjpcaISjvkwhnf3Ka0cF6mhz3vaUZhL.D1t5Yp8Kbzb9T149C
 0PT779MWq1DMqyfVsghvdOQb6OYQpyhSyLxyx0Vf3ikvSFw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.sg3.yahoo.com with HTTP; Thu, 10 Dec 2020 01:22:55 +0000
Date:   Thu, 10 Dec 2020 01:22:52 +0000 (UTC)
From:   Rabiu Usman <rabiuusman@barid.com>
Reply-To: rabiuusman64@hotmail.com
Message-ID: <1282135669.5263597.1607563372835@mail.yahoo.com>
Subject: TREAT AS URGENT PLEASE,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1282135669.5263597.1607563372835.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.17111 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Friend

Greetings,

How are you doing today?

I came across your e-mail contact prior a private search while in need of your assistance. My name is Rabiu Usman I work with the department of Audit and accounting manager here in the Bank of Africa, There is this fund that was keep in my custody years ago and I need your assistance for the transferring of this fund to your bank account for both of us benefit for life time investment and the amount is (US $18,500. Million Dollars).

I have every inquiry details to make the bank believe you and release the fund to your bank account in within 7 banking working days with your full co-operation with me after success Note 40% for you while
60% for me after success of the transfer of the funds to your bank account.

Below information is what I need from you so we can be reaching each other,
1) Full name ...
2) Private telephone number....,
Receiver Country..,
Occupation..,

THANKS.
MR. RABIU USMAN.
