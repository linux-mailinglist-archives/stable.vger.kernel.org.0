Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C700297FD3
	for <lists+stable@lfdr.de>; Sun, 25 Oct 2020 02:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1766646AbgJYBmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 21:42:33 -0400
Received: from sonic308-21.consmr.mail.sg3.yahoo.com ([106.10.241.211]:43637
        "EHLO sonic308-21.consmr.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1766641AbgJYBmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 21:42:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603590139; bh=rL9Nereyf6z11xgF2Y4betqrYfTpmZ3zohYWpfFPbDg=; h=Date:From:Reply-To:Subject:References:From:Subject; b=Q6mCb/ZmXyC8YAe46zz6uP+MgvEx4slaTOwMKK3U7Js7HAO6MbTXq7DNSRrwX8QNv6lP35PiFjRolQ+u5G/5G1PGEKlxiK70u7lHo0XfxnzYPzJ0PV/BXl7IBtDcwGfWmtI6fFUZ+rQvuK4Fz+V2d5NZf2+lY0qAlQ7IkIa1grJYg51VXOrkPCSZkoyKksfIhuuTvTM9Ial8MldJ9xFL6GH9ygh3sFIBz/pWUnGhJYQ6Fv9yKyyZ4EGDIAUiiGnMiZWbwScNrcNEmQGaNMBd7kXiCjcmUWFu8phAqEO9KzFfemC6iR9FqoBbtZuvzTOLMlokQ9mI79aZhcpxBfmUyA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603590139; bh=YPc7rgfuUZuxJIlYp5jLZ3WkjMl06BzoitxEGX1deA3=; h=Date:From:Subject; b=JXTrfiB2ipfiUg0IVgjjceOvBg6fxbJOboLvZ6vkAAEIrLi89TnVqq9TnaOX/Nd6rJkZaMVzsKZfAfcYduUkSYS5f0zK0QFThEwG+gOd6TByDgxsnUIkOE94YxiGXeQYvAu8mun7wvYdfFvaPDGDvux/jV59ky23ixBKflB5/2Kix6dYCmua8ORq+ZwEgENEs5rTd0+W/ZPgZLkvhzsYKEwTb3mNLqIZIX16X+LUT8KvCJjoxd3y+MvCXFt+q+4wm+RbYYHVq/lvSW6HFPFkT9cBFn8cp1YMJESEWSPnVTQOR3ydcQGho2qepmoNtUEBz0fl7ZMYTFH/1kmJ2cPKPg==
X-YMail-OSG: 900A0S4VM1llUzYqysK_n1piQx_yPflrec.H9yEw2ym0X5Eyy.2UfVcKJRhTKnt
 0JgfEAdSC_mNbfdET70xaxvi2zbGVLVu92n_GMMTs7PyaEYE0SbKntueca8TyaQVYqCFMVTWHXIB
 CyLCMzklMZzgoguF6ZzEGpcvnaLFzmPPuprasHGmWQtpAjXQCJgpJL645xe4_YsbpSJLYZleUGGj
 iSnN2Fv5q_iaqGsJpF5MneLAsdmK_ojhdA8iDbabjR9PLxKIlLqdWwpwdK4l_ukuF1karHSnkZJ2
 pGDXmelHqm134g2Fi7ouI4VaHkHqo8wOzeXltdJAxNHnK5kZqDfRdfJHfHFE0Qwbci9BopEuEPVT
 m3n9rdekLBKxXaw8ZPc6Ss3DptEmxer.7Ry06obnEliaPKP8iH39jCElvBrtTz.1ZdG38GSsbDa3
 mHo2ViIk7Tgse4Cd1ozW7qSJr2RRy9gl5pT_Gg3ok6xAz24NvmYXZbSTWyJdxyKLdymuQpsgbCKV
 2vP66dkpkWmOMHqsWKsIFNVHvDKJmuCihgG6KUhJYe1uQ7yd7XWnfcSJLXtp4b6K2S2BLZleZOqy
 LGlCldMPzLX3mQtqPJz27utdFaeXbtVw.th60GpZxL8sfr7NEBbjd93qgVrUjnnwV2PR4EhsrVvc
 JgP_R03U3RXzVxSHt0hw3i8.ZnB8JDbeM0r39KAImQ2CRV4Eq.7zksQfzP8UYMx6T4dF_ewFviCB
 79KbYwErYt4yXyX9SGztR49kHQT5JbZKZ1zSbAwXu9LoUnBT8EyXHJzQs65OjGMJ2F_4txn32sDd
 _TRLoYhp85IOUW2NdwSGfZZDl3pG1H2E5yIcYzpRcJ0Jyg8NP1mcy66E7H3Zq6x5BlvqsOZ02dnM
 oFVxR8rjQhljwNDN1cLZisHaXBaJRv_83PTdXYd1fW4jsrUhdOT5hYS45S2dztLnzutdkDdzX.Lq
 vov_GIWuKbvI_s.TQ_CLydtkdTq7MqSvt2XBHi8A4mJxpEL82u77NbzZWX5VnbFM1XTVPjOi5A7F
 lettVqsoMi3KglGRsLwH46ShGgBHRxrkjYuNXLnXXhYHuJFvKZvYwfOpuUTG55JoKUdBsoza4yaI
 SURIyylvQuXF_H12XyXn7pan6N9mQwYqSN_DGoYoX68Mb8ajASEooHhsi0jHufGEUV1bywHk6pDP
 GomJBJ2fDfX4PJ9N9_HSL5tXzb8lPCJ2M9P2SMDJ5w9_9AKmWljXmNAzP_yojraO1bKqvkWf01Xi
 LUcZl4hXabAszanPBEul0vlXB9aBphce22HOpVMbXmQhMw7JFLjzmDTAhh9Hs7N_pGvwfnLOwX0t
 JzBCJK.rN0TTUzovkzhEQkDcIylk_waSnTCYHE2qAH9Wdd7in5iadWIDd0XJ8YiUenBM0YMhqTMU
 jhdaRXghRCpGGO7C5aIKdwkBNk75EYcbr7F5IVJamjggHp0rbbHnWEBI8GEvF9ulOcV3Tfn.kBYX
 yn43FOEMewb4ZhThLVVDg3P9tWgE3u.N5CZicIRm1Zo8OfZOcfCD.e6MKpvSJPpUGi33XF3WmJWm
 syiTw0K7qXdKe.Bz4MtOxYlgflzo2OmFAaS_3vxXixvYX2bh9azGD.CNRqLkyN7Bvzh6N3U5fu5u
 .9atx_BkrcuK6XEAu2VX4XGA0Szrc24sXwC4wmF62o8NDSuFVzCORDs_STplWD1cxF5eff1gsrhJ
 Mcs18Vc9We2sdx3XWmnuZPTEkOEKVPn7AhXXQ455IdKHFCdZx43.pxQZ_GotnoPNhvAfsOAj1now
 xDbw4SPKomguH4d6zMUGCUw1Qt.pjN2p5M0NKz25XfkeiPYe8Ch77uP9zPoa.HFNHgRyEDXd.i98
 wN9cveRtMiAjLSDUjcyl.TcKniWym4IDm0EbCP6r1jxIqvckiSS2QhIhdcUgQ_nFjyDh5t2bfdkY
 EBfFi1WMUeA3MWRCNrFSGTO5rwEHLtW0RPb0DZZA1W8sWFcuSlwB5j2LJyjEnAFvcaIIQ6BAwdL7
 JMrHM9VUvo8rn208d3I9Jph6Mk1z7LuBJw09Z6xGYLntwUsZq48OTt4SQOBvgi35sGXwzhxuPOB9
 EX.uhefRIGJSnvMlyI9wvL9oAsUVda6kuq.o_NNJP3uoHY2FmyG_R1doGRBbi8FwX1_DhUCNScrL
 zuj.ku4T.CnVg9irkG.Ni2QrotdGzWebf_Xvo9a6hKlVUCjPtg99Aka36n2MkLUc.7_7fjcGvYXL
 PXcSUoWfgSUtVF5xzzufKNFf3k3mGJU7UkcaxOvZXQswxJ_CVsb0nPNYBItIDZI01kt.ubdOB9ZH
 xfgg280mPUCeQIfbwpEsTQOawCCqRi3Ytr4uMUdpjF0O.8PNe_YcJ8hoCaHTgl83GJQCXFlRvAC1
 hQPMfPTJAZH1h7qJSX7E0g0POmRA9L5AIsHyHTTv.Ly3bem5Wgrd2.ZVR2Igp.ss1OqIv88lXjZM
 Vk7tXBYL_TTomRKb27btflyuJFGZKTIPD8Lt_0ELyOKOuqtjNTXKulMsDjVxUyAAmyUwnEtGNy1j
 OYOiFycTFkIs.F4rk2I24Fm15kvV4j7uU0oGl46FDz1ffmwNY_RECr2hVn1MhlCcR0smvDf.JcRw
 8DUIduNBQrGGCxpjVVuvu5wousuAa0TpnhUtFcn.lWcUvvKPpD4io8e09S_cPwM0RRktJ8ehLlq5
 mxJ88Tss7N8mEOxp.S3Tb8vLM6kaK_Yd9WE4DthyRRYZnAUeZlmMEv4HHp9FK9Yp5opOLtjRwR_m
 x2sYqLpFXyQrdS3281NNifFSok_6Nk8UEtGARCr7E9AJDVhD06WmooxUJr.n_zp4tA4vVjO_ex9k
 hDSwzT2yQTLYvlYO5wBitwftcs6Sdy46oXFWY1HG_U20YmCOX9Jfs9AuWuTxGczqZFJscakFjnHJ
 haORLWYmgxNIni9hyEdTquK92_1OFopgk5GFPMH6WNrcgBP9XOHgQknVdnjVLgXjXm39EmTmnUhQ
 O6Pw5HIvQ0HUKcFYbafoLYRqw8wvsgcWpYEz.0z9mHpuIKQOKvaKPcgcX4qXfkbmdLDa7TrxWB5M
 Xkqo9EMlg_gV1uaNAwfynrN03U1D7stMq6tmPHlyOB62V4SVTrJPXczUhAa2LX_u3tfLutj3ptun
 Kz2dWjqlcODXnuhozFk0Vu5df0GQFVWA7.Xv_nROE0CJS3tbZqPymtJQC84mSuGWhTJeYpKtaIHS
 _jgG_23LM7zm.lNsPsyQzzUBiABh0YDp.Z_IUcnhTMC3tFlBjbDv1zvE5Y9GvVTkUdUpOAbDhF7Q
 UsLywPjSAmx8RpyAwbu3uw9hkaE6MHNsL1uB8Ns0xxfH.5Hbz9Ylyli2LhaYg7tJXhGvXCHlNoox
 lq4OFF70DeWrkNHUYlgMxWpJrS8kN3N3A_ELQZzcdPxf2wrhNwlGukwV7DqRe.3E1T1dDgyGEW3x
 hDQPx8IAT43ujp.Zcyy1slK1USEHm58S8LfogivRFao76llqmHegVnhlro2vpUFyzdMzMU8dqoDR
 mdal3nr6yK_CrtXrK.CicuasWXG3Pp3S0aXTt3AGZQwxxZ22ORpi6M6w_VJQ3VbL5T5qYZ0QWwUC
 BNyDhohgyR3xxlttVTJWwR2mkwE7RZFxPZV3eKnNlOyyKvaj0uCS0K7UDibx0ULSu9fJVkqfWCCi
 6ZmtQLDg3w1RqEla61DOM.k8omTG7.2KWXHEycDoXfsuY6XyX3XotNOXwGMtzMYjKaGcw1u2np73
 CjrCUNd0B12gAj.zMF7h2frb3NCT2WUoIE639yg3oEwcYh_ghnrxUfGSsy4mfzKfocQj_0yvLoMs
 YaB5_kjBx6RyHqw5oLXUmZuUFILfQlX.2OlFmlaoHcVjFCiQ5YEFuhMtc7F07z9SOfjLsdTTR3ZZ
 VIzjrm9Nf2OcF9zNDpKzMi3cdSfx2L2DlouPGfek6oIYaITlGo8hRwm92d_xiqLiiQ_u3OTRbMze
 TqdDn5VSOGNMGhY7PnUiRjEJoL1loTIcgr3qEoHX6rsYFtkVUgUa2bHGS1WcCzn6_xdxe3tzLM5G
 k2ekw_OKJ1eTbgfenUDZky.TZ7CNaIihxHL5M0hT9yN8OZQ4curULyjDB8IsGAPSzxv.f4jL2tQ6
 pVpJLbzhhkBJDfGOpQECDYDJw14QA98GPEtae5uSbklodx0I.8D3fWlZHj97xdXMlsPsLmOnlSoY
 0SXgaVpm2b.FPcbNPIOiaSbj0vR4_bZJ0OeQLrTWCnCl6vjlpVbjyh_p1jRIggz8aruFzWsBHFJ5
 n8jDriVNE4p5OBA583XUfRm0grdDOPXcJU2lGL7Mp3QvFPAy0WNwrjf9PG49qFqwg6XXMVAqyDGZ
 B8fKyetGRk2JvPTNRAjKgDNdtaifjDc76pRkbBogwFWrGD6nhmAjAgupNQ8iRx.PWjNUvJuA7RCV
 VnBh256tiEgljKZWe3hGyK_SM5AgEIMbizTOFYcmzcNlJhGvlo2wmsfSiwZMskHjh_4SMsIBrWrb
 AwtgVYXoEtSkU9is9.Y39dNvmqPPkUbtOdlpaF.kNdTd5aEarL7xb0tcdFuTYTwVpLy6qBJcDvll
 ECycnPV._HbxZxo8ThdTQAuGnZBXTLewOeNgM68lxNHgnvuZAOdXjyMNfHfNUG8jtnIc9s1fZf90
 mGrJGCVaxN.j.5uzdDmUDEIPfTo0.MPijrDMe547T2zAfv4ihRQEXqG9NRUz5JbY1xUe9kH9I4.f
 KtKL9KtoUuJRLFoLj2fsVeMTwIFkq3UUgHEeFUbzrWfh_kdQXj7.tvop8MHQBBPFVVpIFfbtyDFM
 cGDrnEfwJnpYHVRB2rmlEekQDzvPaoLAGdy4lyZvfYiYHWcx0r9ZPXgUSzJgtDhNrjnWzGMWj9yA
 RE7toqPfVQ6CV7VavuOptswS4YE4jhsr.Tz.O150awhgeR6fpaow5ylJfCz2kgeruK3Mzj57Fkr.
 MLZaes7.hd1jKRKFbjqvv4CHoV8rh2vRPBsBSdxiTSu0zmLekYNUI3RCoBgjAdN3vNmb_cT1GwXr
 w.ZWaEAEjsbK3GkMqFJ_XjVmi0PsiDq8nx5MpFI_XFa9VkvbxBq.aCng7ikCleCYUDERbWUKzExf
 RO6FqiMF1q6GCl2dPTRuAxWm0qTfWefDyEUpXpeFAuPryW8s1hKD_V768_3iIN_j2uXp8aJvLnv1
 _K0hPS1WmCtEhDd6jjTTsU39bmWHJKQ.eulUKGTQl6kfreGdQpg0D_h.4ZGXdrTooSaS2iZqXXif
 QIrvllfnP3cDFPgNPr3zw7gd5Ui.HDXcz0hlh9mUsAbsLZ.0jOP0i1oD9xwt_RJELzor1b1DO.S6
 f22yf.LC9ppTZt.eiZDlLXAUsNN3gpSzso.2jQ39AXbN4neKozJd02L2pOG6ftP4uFN6OypHAFVF
 C4fWZl7N.zdtKkiH6skzToGgTmTqSyDW95yKACPpabDt3UN4FyEFXuYns73bfAr0cq5JAosM1oH6
 3bS9GEacEUv6XLs2vna710kTib6HjkOkmJBftJCnIfDh.z5IbtobuxqwiP_DLhu7faaHKgo4lbUd
 oS5xoYi9_Jfk65H92sG8fP6FuQ6Qt5A_AZdAR7kP3bEzWTlqfxc0o4ipt4SNa4FRHp.Lf4Z_KToI
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.sg3.yahoo.com with HTTP; Sun, 25 Oct 2020 01:42:19 +0000
Date:   Sun, 25 Oct 2020 01:42:15 +0000 (UTC)
From:   "Mr. Abdul Salam" <as6171099@gmail.com>
Reply-To: as6174759@gmail.com
Message-ID: <1075496489.2298083.1603590135376@mail.yahoo.com>
Subject: Greetings,With due respect
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1075496489.2298083.1603590135376.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16868 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



My Dear Friend,

Before I introduce myself, I wish to inform you that this letter is not a h=
oax mail and I urge you to treat it serious. This letter must come to you a=
s a big surprise, but I believe it is only a day that people meet and becom=
e great friends and business partners. Please I want you to read this lette=
r very carefully and I must apologize for barging this message into your ma=
il box without any formal introduction due to the urgency and confidentiali=
ty of this business and I know that this message will come to you as a surp=
rise. Please this is not a joke and I will not like you to joke with it ok,=
 with due respect to your person and much sincerity of purpose, I make this=
 contact with you as I believe that you can be of great assistance to me. M=
y name is Mr. Abdul Salam, from Burkina Faso, West Africa. I work in United=
 Bank for Africa (UBA) as telex manager, please see this as a confidential =
message and do not reveal it to another person and let me know whether you =
can be of assistance regarding my proposal below because it is top secret.

I am about to retire from active Banking service to start a new life but I =
am skeptical to reveal this particular secret to a stranger. You must assur=
e me that everything will be handled confidentially because we are not goin=
g to suffer again in life. It has been 10 years now that most of the greedy=
 African Politicians used our bank to launder money overseas through the he=
lp of their Political advisers. Most of the funds which they transferred ou=
t of the shores of Africa were gold and oil money that was supposed to have=
 been used to develop the continent. Their Political advisers always inflat=
ed the amounts before transferring to foreign accounts, so I also used the =
opportunity to divert part of the funds hence I am aware that there is no o=
fficial trace of how much was transferred as all the accounts used for such=
 transfers were being closed after transfer. I acted as the Bank Officer to=
 most of the politicians and when I discovered that they were using me to s=
ucceed in their greedy act; I also cleaned some of their banking records fr=
om the Bank files and no one cared to ask me because the money was too much=
 for them to control. They laundered over $5billion Dollars during the proc=
ess.

Before I send this message to you, I have already diverted ($10.5million Do=
llars) to an escrow account belonging to no one in the bank. The bank is an=
xious now to know who the beneficiary to the funds is because they have mad=
e a lot of profits with the funds. It is more than Eight years now and most=
 of the politicians are no longer using our bank to transfer funds overseas=
. The ($10.5million Dollars) has been laying waste in our bank and I don=E2=
=80=99t want to retire from the bank without transferring the funds to a fo=
reign account to enable me share the proceeds with the receiver (a foreigne=
r). The money will be shared 60% for me and 40% for you. There is no one co=
ming to ask you about the funds because I secured everything. I only want y=
ou to assist me by providing a reliable bank account where the funds can be=
 transferred.

You are not to face any difficulties or legal implications as I am going to=
 handle the transfer personally. If you are capable of receiving the funds,=
 do let me know immediately to enable me give you a detailed information on=
 what to do. For me, I have not stolen the money from anyone because the ot=
her people that took the whole money did not face any problems. This is my =
chance to grab my own life opportunity but you must keep the details of the=
 funds secret to avoid any leakages as no one in the bank knows about my pl=
ans. Please get back to me if you are interested and capable to handle this=
 project, I shall intimate you on what to do when I hear from your confirma=
tion and acceptance. If you are capable of being my trusted associate, do d=
eclare your consent to me I am looking forward to hear from you immediately=
 for further information.
Thanks with my best regards.
Mr. Abdul Salam,
Telex Manager
United Bank for Africa (UBA)
Burkina Faso
