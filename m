Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C49E2CC676
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 20:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbgLBTVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 14:21:03 -0500
Received: from sonic308-2.consmr.mail.bf2.yahoo.com ([74.6.130.41]:42201 "EHLO
        sonic308-2.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727012AbgLBTVD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 14:21:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1606936820; bh=cWD1IT1Oza05+yuI9cRN8J5nQz3aMJ3JMjpwr0v4Ab0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=UuRdhuj7GJEx7l1xDGh5FLac9OE323BdvLp+3RqFNDeyGZZpuq6OZ0gKMNmafSpfdAdKAm89UffjdnvWQdyiwaZiFcLRnhCiK+d9jF+yDlSUjKvH9+9bniLuElNp4uxwclyH4pz3IVkI9Ar9pQZbVmyK6Q7o0LUYzWEsQ9mzOLskPLcf3/O0DEtYb5rsU2D/Bcd53D6qDP6x+CtRkdGA5lcDUI+B7jIgEB6v4BGuRoj0B0u2lDZdI6JHMXtqu2pSSIS5ufNB6V0zxPNLkV3VULBI+uhIVzOnP0kz4jMShHB7VtCdDCcynr2aJe9oXhHtpckc4TkeMSgtnKEVoWWwYw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1606936820; bh=2cFRojzN3ReJdlQT8zUGV56cqGtCdU6HuiWhzu3kK+0=; h=Date:From:Subject:From:Subject; b=pKgWQLWospbUjieRApXGJPJCjFiADHX0GB719ceZZ7xip714e0sgHb7rvt3eikzFZdzvLiZuCR8Yi9IMV7BXIXoyLCeQwoS3Sbgtt5/zgn/0ZoHpvsf56QJg5AqgrdvxROOoCv0UTiWwUrpWYNqblQK0i3t1y2Dqn5f7tb9QrNbGmV241Un9AaS23HtB/mas5gWyQEFKCk1seXwJ19HTCsC6OK0V1dAPZNMNv9xwCsMr0hXzG0780KWaQikufIvM3N+EUxb8UuZT//VIrYB093R4ZtRKYG4X1Fk0djtTb7bIeMeIkaixIhsc9TwjV92GdVzYI5Um1qexNgdTs1tzSg==
X-YMail-OSG: 7ApdkWQVM1nArvW2XVKH8YxD3KCWIFJ.ufz6GNjokc37XCC8uy2CvgdCbTppVX7
 kD7E5bXNWR724urarpoFpTtFMiw9PSVnHyey2GU_CfZRcxKC2FYNGcAUwb283iVjz1AqN8bhQ_aa
 fB6II8u.vgOeWzeXFdzSmytkQ72ZF.gCDoNkpE5hYjwPHTU2Dv4iMOJ4JdTb34q8P4S2_LzMNDfN
 8lwENHZY24GxmOt3hFsmfPJmQfyulEUupzOwIb_XleC1napOrz.m0u00nAC4TS8PUogqpBsQDa2m
 7BnGuhyANom2S8AM4k0Fqi9OP2O3os2dZfDxzj7hkR5L1iirofwVzwd6Vd_l6Gy3oUJvv9aILs3Y
 SY9E8IZcgLR2P8GRgGcGwuAVSrF1VUvevBf8loUfaYSbH1qe5FRCw1dhoBQKOiIWsJz8U0GvqhrX
 lDYC9JzS9pxuGWFsr1n0Nu4rwwzBzfS_pcx6orSeZR.sUMWChoYXCLnI5CDxVVPvPETKZZVeGYZ1
 CG6pkOsuZq5MC4qBy9cAYh.1UFjPovWJ8V8WGblMPHkKMpSqe.TTerOwSMP.l3QINrB99xvmPS5t
 RGwhwtP4YpuNhFmLtY3eNgEkQls8kZknwxd6W38rLl3JifWmVU7OPWNybM6KvJgGAe7t.1g7i9oG
 d2DSu6mS5XWRSXflqtmFaTOmMUD0.6Jz3tc_IIM895079OiWo6lB7XSIhALQSbvtCjBoQ8uVA_jd
 TtjO5uNgrTRwr6hi2pj7ItwDQNAacR0PPoP2SWTxcT03yrlFxoavhiJCo0NvTRZWA42rCEpLFzOK
 O7fF7Hw8oIXyX4MGkZ8DsZvAO09qMtqkiK5s__rPP9BZDthThjHZcMLn8AubmvpxzPneYEZkarV1
 CkHoOSZTQhsOwi_95jtYekU9_xS4UAb_F8e0M7LaZmc3PIwAf0jT858UUlP5OTS.l4jyVDR0aIII
 dM80mbJhP3p93Qku6QkvIW0K3shPx6H.Wg0nlmLhJmq7kdEJFsUtznFpR8JiPq4MYByhMLYaukuR
 _CSr1lT2Avv8z2vUnH2g16HypSqtfzv3ciVEAX6h4TJ9okEjIm51NFPmVc4HmpHwvGlvu3StyG.u
 yzcP1roIql5dtyztEcMJecamM.lB4ZzFLmy5vJvAIOhwFvfhpVB7BseO0lN1v4RKZ26RpKoTizPK
 utneKc0KOTS0zZPBudFqhM438yvjF335C95FykHc1fmBIyDOgpA_REDbyZV7TtulvV7bnAZgpmKC
 11_Pwqof2DNjTY5GOqNP1qEQ0Y7sRc6V348aKYCJO9DkMxHnz08LPRaScPxrQ_bLh1K1aeFq_hUk
 ZtSse7RRUtRSxsn5zkaQVmNXLxJmMiyGfkumgYSBKesn.Ovq2qcLLSdWI0r9Euk5NhJD_GMu9.LY
 ZVcW27vgirhAK_VbrEucWW3aA1QUAuSpO8hqfj9TaWZF8vudqGkq1upbhVENqaLYEd0TDptylLh7
 OIorwme_MBAgY3cc6T_9uUC.dUpVevVCOUdWff_IOEAfSFDTesmsiaOZyqn0TkCZepg4DTw2hBsU
 lnj1nxoFbw3mvRUC2ntEEtoTAMMdpZ.XDOZldbKj.R9duNU0mNvC9QTd1xTF1EXdCbixYOe23h_0
 5hKzq7dO6BYGOuf9mX9TnSYQt.ERcFFcakzlzvl1OfFH7Jpb3pIxdLrffSLzjf8Ccn10zZP_aq4E
 JgU5IzmZ2PgMnX5F7r8g.YNeKYnjMmuHFefnK4Q96Th_J7rWBYxcTqCsfJPM6gKCNIBO0zE_svkp
 HGPgAAl_n6ECIL5V6ZZhxG8qqRrkUQKSSUNZxPr02k4QeNWh7oizpf8yZqdhr5FDC8Ih4f482UvI
 B9fjCM5.XDT3CedngETYgtRmlyUufUAsJAHyQB88jjQf.JfFnwMqI1FzueDf6nXxu_EOKWrfYRwi
 .wO1EP0GxaXZMWb5VWIlrQgBEMjUxTdP8bIzwYapeTR2XhD76PmTr8R6qMHv2Mt2Zw805EfUH2R_
 hmR2CDNEmxzy4h5NpQoIdSNOx77Dyvem9_TJWEzgZ1PFnKhhjkf1uVmfmF0_53T9aKRSByVl.Fwa
 Ke_bAwP08v688LpeOBcwB3qdOHKpbJzJt0GXL77743XFFUKGBsMUfeNz4ekNQSPFNPPRhNjuSxi4
 9RcyFJeTd0HsfbBdyXWqyC6s4Uaoied8EBfWyOl_oJQF2PMNBvqWJSALjVs5kkkBl4nwTVS10dKW
 NJoVxF7H25Cv45kxcoP9tNcAFXOj63IgkR8sGJI4I.J9iWZQqoRLaAstvjsxJ.gPr7U2DAhrZNuW
 6WcFA4ic6EZAS0sjTFjWqJ.3wqs3A6kY7TvdYPxZC5GwZ2dFjzjm9F3F2Dxwz.dbFt7JOydIhDGI
 WzYE1xN1g6E4V514n5nL5vGtPAP2Tc.a5B_xqiDtjMATTi40YvBuijssUH1AMo.yaCS5BM41uRH6
 lRXzXTe6QkQM6J1025DWfbUgK7eYdommpJb8MqQGkR0iPhfBm3oEsrQUozEkfxjpjkNLrY1bWEAV
 l5UB9L4yVHzR4iPgzctfPduav11kgTot7NDhjN6sSmq.7X.kpcqjdjSszaRPq3vmULvxJlYX4B_n
 KGHhM9Ltvz0cLqVME60dTQ9Fs7H8a_PM4XELhoeed4EtCvVsEx_3Bqz6McKRGU9thoLblqDXIvwE
 L.0r86KWXmz3wO.Ecx9AsFOLzeWEI89lTK.rhdVQNXYVuUJ8cvcRvGbhfLxbhK.xDz1PmEQSyvvv
 o2vQcdgJy1BmnmJ2DHffYw5GgHpZ17kBO0zRmb2TKiyckNtGVsyN05CN0ryk8lndbA1y5oMF6USX
 yyeaRQyfAFmUsz9Km00VoNC8HEgZKSF8.n31fmouKVBkSCeuhN4puQZ42a7OArMkoPy6tVM67wxS
 TqkLgkQbpTrxr0pKznPINifYgtYPFN3V3Df.j3FrCfeMbHM8Kri6eh.wef5i6prwGcBY7rfKAvAa
 uVn1TTJYH1MF1kBLc_yV77pUS7aq_YX1IqhlUM1hfy_OOy.ol1IpC1OkCheL_2qKI7HiTadX4kkI
 oeKufb_N7x.0FVd2O8KZaBBJHCjcC1068frnCEDIZdUN7CusxVYwbQ9DVrsMWJ.nfZknaT5MDAo9
 68fVzd75GQ0.GykOLrvWeNHtrMR5hvIP73htDAqzZd7BOhg4KMJPO.kgLAzYilyG.Wh4alnroUSX
 Y59d2UdRUP.yf3GIZD4Va4.igCx8cslcouSEcvwuqxHKMm5UYuba6YAC3ZPw8HMRP9mV75rbs.JC
 UFZIXtNeD_XqG5c43lFeWGoiUAr621.dviZC881FKifK.DLV9B7PVmk3aZYWo0R5nk9LseVbketb
 dgCAsvO3p3NfQFl__8zSJQeusGcFT4Zl_9VoGFPMrwxhsecqGf0dENsCcpmWbKPto5YLvexs1ilc
 __Uhu0LB7tZO_24i8oqNE.mGEle3_gUUTw_hckBrcR7yAmYXMhTrVY7tkEiyOD4_e7ouAZqd7vri
 0lM.aWLogXIBwwSXONv_yToEpZFSZBgOr_3PhwsNzXuH6u8LLdeatA30a_wKiAqn6bQNMNwDEIEz
 xce.Wbc3lkkph7wcRXMatzc227TQRfA9D3osGSDU0VYSajgHDqOMzT9Ln6LlHkSofE7f6.zJNsS.
 K8sFS0Q1dZdlER1tVdNcUMjI52lPRMPfOpOa_261g38NIJziL7h9pPlJ79crznPwFboH_kbTLGPx
 8gxtXZkcjPkcm.jtwjfFAwEK2qlQDklf1eDw6m86khyGJv63N0n.cxvqMhtOAfvocmZfpzIOOz_Y
 HVoyzJcsWEq9b4M3d6Llv4aMTBAnfIbKZVixHhU8pceQnD2p5WMRI_d2Ime5fkS5XrjWkgvOeGrB
 YAyfCpWAYfmEymaljXVx4fGpQwxqzPlbDZUucO5knS_Zmsi_sRgtD_FrokO30z5gTLa23gPE0nRe
 8NsVZbFNqMgTihRvNLsEc2_G5ByUejwR4cRXwmvTCyACYUk1rAR6g4F8DMz.U51lbbHgVHcFArol
 gy4FrWRYIyMBaSvMHGl1_Qswx2k0Ize4p0vSistkF1LY.ieGrn0cMalM7VD0DJTgSYRcy_pCuV2T
 lXSoDAJDIJaGngEPJ8zN9KBpjZMwzScHNb_PEXBWMWBAO74FUJ6Nd2Wugs5UhDGCaMRynlHz9cFb
 O16iKboEZNadl3myzJEa75CA42o77YwFFUqUjSVansn_y45SetJkYsQejZCXvn4783JwpTapwrcE
 1X55VsmmLFXuRMofM0N2tSdGSv.S1j8lWgSrlKamXjiKH8oI_RBUOXKi862Vafm864OCTaeC0on6
 cauzLtrav79Fv0B8.nD5MO21xAYAoufXPU.ytexN59ChZ_z5iS3HINBTumCcQcrt22BCI9aWsAka
 fGFPH2DOfnoMMiBdCTIXiTAbo3oeIubqYqL8Jf2.vX5R40BYErJ6SUBHtnt9y3mV5nBI65GYy3VF
 3cML0u4v1KA9yXacQmJZxFcpYwucJykZTocTiPv.BOzaC6wasxg7brAr_L5.paQlBG1_pOFFSFyh
 5te2y0RUQkec0AJkmI0xDC.XxH6Z6M1bqg7qi5kYrdv6zNXoSAVtXrqz1FMG71BiAkah0sUawJvo
 _Da8INC3UAR0lGA.WJVqnS_ZZo.vD5DpOLdCTl4oHWj8HSqlqTZ4sylIqowrkHY.TsSvEFgXnG0z
 3RUaF3YYqzZoYNwArTTeMj1BtHtkHnivBe2Z7dGAALDVPE94YpWb7euO3bO2A1MhViwFGn9RfkXa
 vFigE8YdYGjZURy9izJjjdmGVFB.fS6.TqUajkcCNn26ZGzAp7t54f.vOhL3xQrGyK8SmqKqJ0VT
 7QXIuz2hgrYX690Ds1M47UmJnjWC5q_uRFi8a9WHRo2OBvBml8xucYR0TYWfhBN8__7ntmXHyZie
 iIDDtI4HZorwhcStBmtlMrK_Ux9K4iC6mncDlx7AFtF3OdrJ7fyDVLCA9LWw3WBYlZZpVbSILhJ5
 _PfTWZKNDIQ7CPEzY86xxcGWc5QIuGjj8eR4vgQo_VoWsFJGzlfIO0XDEwK9KcNaa4CoIZ1aCqT9
 xL2drJQWPrzgiXDS1hk2IYLm5tx39jGmrFoCfsO0k4TQr7punlhDuouTMViLPsrbz_52v7c.rL5A
 8FssbANxPWEtcTiHQdmmbKc3yHR73LTrlpT4rEy6Ha3bgijezFC6HV1ZnwcJTH7W.3nAUKgHx.GZ
 mmVV2igaOfDNZz83bs7pYU3HkMu0DWJhyYQV8tnF_n2scCXiMcFeSJSmqGQuNxYKbJjY0jmT5W4l
 nVjW1Y5XtJODmFQkPGG3LUcNg2Xpz.P11fdxKmdeokOR8IzkKRVl0jhALWcLlui8x8p6cltp47j8
 _GhO1_uEYY1PGuP7CDa854QrbNo0eMoujihUm2vZqIijcbL4v.mYVDhCadWRGnxwnpqId8_pSWSU
 Ru_H2PPegQt8QdkIDOfcsfQBJaKbw
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.bf2.yahoo.com with HTTP; Wed, 2 Dec 2020 19:20:20 +0000
Date:   Wed, 2 Dec 2020 19:20:20 +0000 (UTC)
From:   "MR, ABDERAZACK ZEBDANI." <mrabderazackzebdanni@gmail.com>
Reply-To: mrabderazackzebdanni@gmail.com
Message-ID: <566025194.2365883.1606936820272@mail.yahoo.com>
Subject: I WANT YOU TO READ CAREFULLY
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <566025194.2365883.1606936820272.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.17111 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Greetings My Dear Friend,
Before I introduce myself, I wish to inform you that this letter is not a h=
oax mail and I urge you to treat it serious.This letter will come to you as=
 a big surprise, but I believe it is only a day that people meet and become=
 great friends and business partners. Please I want you to read this letter=
 very carefully and I must apologize for barging this message into your mai=
l box without any formal introduction due to the urgency and confidentialit=
y of this business. I make this contact with you as I believe that you can =
be of great assistance to me. My name is MR,ABDERAZACK ZEBDANI, from Burkin=
a Faso, West Africa. I work in Bank Of Africa (BOA) as telex manager, pleas=
e see this as a confidential message and do not reveal it to another person=
 and let me know whether you can be of assistance regarding my proposal bel=
ow because it is top secret. I am about to retire from active Banking servi=
ce to start a new life but I am skeptical to reveal this particular secret =
to a stranger. You must assure me that everything will be handled confident=
ially because we are not going to suffer again in life. It has been 10 year=
s now that most of the greedy African Politicians used our bank to launder =
money overseas through the help of their Political advisers. Most of the fu=
nds which they transferred out of the shores of Africa were gold and oil mo=
ney that was supposed to have been used to develop the continent. Their Pol=
itical advisers always inflated the amounts before transferring to foreign =
accounts, so I also used the opportunity to divert part of the funds hence =
I am aware that there is no official trace of how much was transferred as a=
ll the accounts used for such transfers were being closed after transfer. I=
 acted as the Bank Officer to most of the politicians and when I discovered=
 that they were using me to succeed in their greedy act I also cleaned some=
 of their banking records from the Bank files and no one cared to ask me be=
cause the money was too much for them to control. They laundered over Five(=
5)Billion US DOLLARS during the process. Before I send this message to you,=
 I have already diverted ($10.500 Ten Million, Five Hundred US DOLLARS) to =
an escrow account belonging to no one in the bank. The bank is anxious now =
to know who the beneficiary to the funds because they have made a lot of pr=
ofits with the funds. It is more than Eight years now and most of the polit=
icians are no longer using our bank to transfer funds overseas. The ($10.50=
0 Ten Million. Five Hundred US DOLLARS) has been laying waste in our bank a=
nd I don=E2=80=99t want to retire from the bank without transferring the fu=
nds to a foreign account to enable me share the proceeds with the receiver =
(a foreigner). The money will be shared 60% for me and 40% for you. There i=
s no one coming to ask you about the funds because I secured everything. I =
only want you to assist me by providing a reliable bank account where the f=
unds can be transferred. You are not to face any difficulties or legal impl=
ications as I am going to handle the transfer personally. If you are capabl=
e of receiving the funds, do let me know immediately to enable me give you =
a detailed information on what to do. For me, I have not stolen the money f=
rom anyone because the other people that took the whole money did not face =
any problems. This is my chance to grab my own life opportunity but you mus=
t keep the details of the funds secret to avoid any leakages as no one in t=
he bank knows about my plans. Please get back to me if you are interested a=
nd capable to handle this project, I am looking forward to hear from you im=
mediately for further information. thanks with my best regards.
Your's sincerely
MR,ABDERAZACK ZEBDANI.
Telex Manager
Bank Of Africa (BOA)
Burkina Faso.
Contact Me through this my email addrest only at
(mrabderazackzebdanni@gmail.com)
because off some protocols
