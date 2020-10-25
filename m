Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A30B2980ED
	for <lists+stable@lfdr.de>; Sun, 25 Oct 2020 10:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1414696AbgJYJIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Oct 2020 05:08:12 -0400
Received: from sonic304-2.consmr.mail.bf2.yahoo.com ([74.6.128.121]:40741 "EHLO
        sonic304-2.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729656AbgJYJIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Oct 2020 05:08:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603616890; bh=VQV+To5S2gWVZyYzSF6aVVNoKJSf7fw7hH7Ff0SULss=; h=Date:From:Reply-To:Subject:References:From:Subject; b=O2gTeqeh+++DViIK5rJdld4wCl8oXO78NCNlfcigxlBhHzYYpEnAui7Tc7VNqDhzxjsm+g0sXuz85b26PJsu/ADV5zgOeSZRqUYkLOcTSwu7ThEBiXDhd99hJ6d8zBMaLNJjy/OTc0gR1Y0YdyhooCc0vkdWwFrXdwg1SQ5/Tlzqt5ZYB2rwPdCT8fwyjPQQhom7op4qIj2KgeyfL/qQXo1WdJhrFmfe14Ry5hXOdj0RNTiaI11dSXhgvF4ksTpGUmRzkRN7ieY8mSEkPKTSl2BFIKUFBqJPFOSvrJQwkuhWAgCuUa4kq3UMp01XBU8ZYr0a2e0c+iiw72GLGWfsVQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603616890; bh=Q/Py0VP9Nv3IrbRIhL4R4L8RLW7lz3X98ndWD+PBfwD=; h=Date:From:Subject; b=lRyi9Zvv4W4Q2IJQNyf+JL682o67kdVS9sAfRWEweXSB/PZV1e/ss8FZFK3rYKL3DLQzO9YAvqBwX7c33QNKkq+DQ75LDgVILPqQtr6QPzQANMvCoi6F8PNZntV6/ghFXzKTYo/TG0u0WIaPtTk/VPrqDXvGD2yjqmbJ3Q1e0MO0j6HtRf46jXv4YRaUXzHGWyvNAMQuvXjrobuu/4aaoOyws4qx7fXjEEiZX9+9NcR/FjcgHNxETx4sqxdyOUBmq8uolpWF006G7+YNZgKLE58BlobAVtRpouK3kxGCXLf/+449577BW78LqVbn9beHe4Q80dKr6R5igYNJijOMxQ==
X-YMail-OSG: 4C0oTdgVM1lLbQSIHLHuVA5rIFxP8jIee4V14.YdzDbAOqgvq4NVHfDGsliguJa
 9m57GBDvmFp0F7FRmvVXOmVA8IBLJzNVTXN5.GFrPZLAMuhTVDgoT.Bj29Fettgs62NNFQYbtgNB
 wu8Ft6b8s7wc8DG1ZxwAMSc_jfKux4B4GVm7YMq8gfinTekTzZzBUJ_fJlmXhJcidBcHnT9quEPy
 zAHZtoLQVvc3Fe0XE5_6skRNWlamdI81ce7jIzgxTfnjDFEj_OhGAMX5ZSurHWrDz0bS9.T8o7GD
 ar7BeF9VKvWlxIO_wRAlOit1J_x8cF32ugxjNCy0hF4q5Id6xvizN31.VkM.CxXGXv2rYjAfeUt1
 d522JduAr3XJAounDoMtMTtRYxMHUGVzdYaq0_07Y.9QGD7JTdYuX9_1L0LBUgoxsxFbKumwi16i
 yVOo6WElSmKyp_OlA8ojhRfgv6VRswtT4Em1DlqvMEVJXVnz0luRkjnC2DnlO_3p0gp.Gekis.qS
 QIYwWG0BZZ5Pd_JFwfmM5ymPWDE0GwLmH3Nooo2yeASoqswbQOuQ1d_opS_PdQ..3TVdfWn0aDLK
 ZIdeeAE.cuhjablSZaTieZ1iNkUAav.Q18sR02JEq.iJKxGrhs0LvWZB9fAqUFdRWw7LlVCJYDSi
 fdvocLp05XFlPfTNXhyFAsVFX.dgFQJgAkFvMIFhVPlxPPQsmapOaJfgGwnlekYWlYzCuiK_8di2
 MiKtGUzMnuywBtGl9bcnz0B_yfsUtPnzYKYprEggzuKfxtcQEJdH7WVw61I8ht1WGQajSuwEDGle
 NR471Lv0TCHa_EHr3Q1xkrgtPuyA6.0OlFoI6siz8BnXnYB.Zw9ora8MhPZeeftjrHYu2H2fes68
 fOgcD3cgmK84G1HmRR2Qp78yGBLiy.mAiveGUIuWkIHpHo4ECVfPgXnUoWvunMK.3IR5iHGf0IjO
 24Dg4uzYlyb4VHfwP2edxnoHrJAjuwOz39aOsqdWFXow2GCXryjJSv0tPD4kMc5DKTB9Bx8uv36w
 4ZIJiguuadSamf5opIdVJg730cNu67JpPZp6GRKiSKgiqgiv3N3AxhOQskPutogz0.BRzzewDGrg
 yYpfpNY4k2zHPPCYw8XM5dlFsy2RuslvjbZAvjB3rRiBmg0WO0dk7gUATS6ps.S155.VI3CqUVKy
 Ts7mXauawMog_AE0adszbyw2KvA71NFSL4KwizoGhCllepkdco4ApCmTfgQy0R_DY_dA5UGBNKE7
 7M0cDsln90iTPNoU_LMcLVGFchj2Wf6wuQiAzF0alAFOkbTQCc850RSgQdgRCcknmXB7qgesMiVX
 0MjJ4WotvtCLShNOTh5LmE3M7GLeHGIYo1HiW793jB1n8lNWLleHfEVCFp_jqkF2c3lmId.C4yVF
 5S40GTmXDEYM3OR09eu.7FfTEvqCkdJRtJfW9ZaVbGW6gh8D84pborEUwdW88lmONs.ulbWjO5Gg
 NyiCOnvrf4Ww37MZuQkOB3Wxf0G1dRtTA97Bo2I2mMR2xumW5XRMrn3n9_o0y59icpYv23edXvVF
 K18gg4y9dyiGXNYccpuB7k77i1g8zQHf3VxEn.o5WCiiqTNzW9aoUDOA647xxgn_FRgP7.r3A9wq
 n6SuuQWSZ5n9q.DfY0Dj3tXZoPcbYI9fxukAMj9eKrSzjcimBF0ZBrnL1Eid94fXkYs_m7C7Q.Kr
 j08aZjDeIEbRil4A0Pt1IWebg5qPK8Z2DtRWr_in5p4QGce8fMTHAIz4T2ASMU0QCfd4dqV9_cRB
 WleLQjDQC.AvlcIRaSfWcmj86JpnK1dyuutYeICNZKb3SMli2jb7a87qrHs21Wya8.YYJv49TG2K
 JUglXlnTav9wFRjVSDiHJNj2gha0k09TXsLMsIMtDdo2h25Yc3m9J.tKYh9X7OpHy6FbKiGhE7QW
 L763AzmJ97W4fDElCAQHswGdn3SEDW0.dLjGw_8paWnUABCCaK96f7DdCk7VE6xzmbXBfxAbFm22
 Uc7OxEVBPC7ieTZ.DnUSWwelOamZ1m8yd7z8VZRrre5FZzxWqM40dH6Cy8UJI7iuD8QRccBXTDYT
 IWlUiyHfppgrRbcWLdegmbiEGdD8jh4ZkfBKVhE73D3e.STCrVF2_yENfM.q5DZ56KsvJEDIMwaV
 FYR0WEAIEVwGBAIwdgTNJUsT_N71WWqJYFR_bSnMiU7UlCQ_imekQ_8CzmodTVC7s04kiDVHBvbl
 8l6H3nNlDfQOqQB3_MrjXyvDopWdVzEsR9opLiOYXNeo3bABHVq4ytsWby4CswlWr_IgKmDvXR1C
 bUtSJMWQ8blZgqSQtHdVoQD4HH2SzQDrmtf.Ktgr.slbeSKi.ure.eOfqydisMzqpS.U.YYCMeRO
 aNn4auYesd3LaWGaG7QNmaJIFOW8evGNLAKVlXAf5lCYp46nOjq1spVQp94e5VUjCnwONFpKfrw7
 fMr82RGnv_Su_OQdsYerwWfn3etwVVVXOjhmHw2MYEECkDxAcB8lxN3UQrHHn.JC8u.yVYAWK0Lo
 dyUociVpwEOAYj2pjFk_mV5RFnUJ_RctDGIMh1BuickCyKV95xG23bnCbQa0KJWcpylgewDdhxL7
 FlbZVkR8RxVS9vq3bJImjzKFW50N4zFmVU8_j8NeocXGUo4t3kWt0Oi5PEB_Yx8qkjQUyCh7sbpi
 deLCbce6t6xB3D_ahMPKSvvOLWIf7KX3qxE7aMQqkBh0_qdj_0efcuAYvM3epTy6FIGr3YoxT8Vi
 FFPcNLvUACadugoc1MbW0ke0gcB63f0qA2rHzNHDsoi9IABx.tQdCXLYKto4c3MZbMsG2z0ar5Gj
 .XA2Zp_e8NY7Vk2WifHA6iEN74krhrKL7z0usToqEsEv2enteDK6zDvzdpyitcA1ZAoUEKXHxAWc
 OlW1hq_.sL9UuV8UQlR6jaIJppklwLuLGscN9AlvrNRzPje12upEIMlSCx1O8PphS8GAmtnpekz3
 z_Ctv3cxDPVIfFIL.SToP5ctyfeBpNxHdoyIPlHsteN1tMJVCs4v6XibUxZ.iTU7db6bNXw88qtt
 qPfZDyx0Zif4GlgT6WwvgdcJmqpWFE6d6GaBt8cd2sR_t5k6okX5rfEZakOjAX5yL3t0YBiWXnEs
 GxEwilYkBxEzISTw7Jlr0qVbYeItF9h4mUlCPCJCaX3EEPeXGsVGMb3NXryc9egDTHP6ElLlmqS9
 70J.uBQEiFRF4UdQrQLzwNy_YnQuQOwVZn.meNmsn._rk_75g_sjMllRY2NG2WL4F5WN0.f4P6tt
 M681t4PvU9gU7NiNzrwFhVTcqvW3pRmoODebszYRUY559hXmx_MizV9hsIxq_RD4.Jn1ZpAWCDez
 jA3Wb4vVoh432EO4qjUYJW2TXPaxvPBo_N5lAW7yQ5gKxfez.vJ7AeSn14yUvqnhjTD1Rh_sdkDe
 d7SOj.I.4F67PKo0zjI1YHV9XrL.zjPTBsPwIYTdv2oVGjwev2iyG8MRW9faBj1rQPQ0iRBG6nxW
 q9jRk50deKsfB5GcGdbMFnYIGv2ioACw80kwJjrXuIxv0MyiGlZ3IeQPV6zuPz_XDMOt7BEXetHd
 h2kiLDl8VNdhdDaS5gI7dfrq8UaVTbvP6l5qK_KtnlgXX1WID1qVJt.kLfwDvt3rc0QBM6ICmNKA
 .HDn8CDpJWDdzbUYbDMG.f.1ueMvL5wJWxo_rJAedHYkMBZslga2SVKc2mSqgXwhoEuD5vdN9x91
 6G6pGuEwsGEjCMIL0kgYDc_Uoj5IHWBDfG7tF1KO3l99gVivOq4csaq350MY_O_6A.83aI86jMRy
 BscEprct7XgTXjXN5dks4AS7GTbAB.IgUl5D52FlypgMMMP2avPuceAz.ol6d3YaIDnsdbW4tkwk
 Ayr1DO.9RMZFj_x6W0oW3Uc0cVJVZiar18yr4nRRZQyxmuBlR9KpsReu_t_NQLVZSMFT_XDy5dRA
 MaYjea.NmzSIRCTOL_J3TklNVxvuPbRIydhREX3JiF2fITsQy9AX7UFGFM8Yu7Ri4xDaw6rve32m
 BBRKJHJqu6iCVfKwxmJ3TmXgCOs22qZtH7UCjilegJAAfi1V8tqtWdIEJERKFvele0L549_RDNAV
 WvGrSSsgl
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.bf2.yahoo.com with HTTP; Sun, 25 Oct 2020 09:08:10 +0000
Date:   Sun, 25 Oct 2020 09:06:09 +0000 (UTC)
From:   Wang Xiu Ying <sed4313@gvxfz.org.in>
Reply-To: wying353@yahoo.com
Message-ID: <1479134557.2367999.1603616769297@mail.yahoo.com>
Subject: My business Proposal
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1479134557.2367999.1603616769297.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16868 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:60.0) Gecko/20100101 Firefox/60.0 SeaMonkey/2.53.4
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Good Day,
I am Wang Xiu Ying, the Director for Credit & Marketing Chong Hing Bank, Hong Kong, Chong Hing Bank Center, 24 Des Voeux Road Central, Hong Kong. I have a business proposal of USD$13,991,674 All confirmable documents to back up the claims will be made availableto you prior to your acceptance and as soon as I receive your return mail.
Best Regards,
Wang Xiu Ying
