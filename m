Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E822967E6
	for <lists+stable@lfdr.de>; Fri, 23 Oct 2020 02:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373746AbgJWARe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Oct 2020 20:17:34 -0400
Received: from sonic314-20.consmr.mail.sg3.yahoo.com ([106.10.240.144]:38713
        "EHLO sonic314-20.consmr.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S373745AbgJWARe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Oct 2020 20:17:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603412250; bh=RchYhSnUH4D8ir65x6OKK1yxktPnAGhcFCbackPivPM=; h=Date:From:Reply-To:Subject:References:From:Subject; b=YM+x8DnO+n7QJiITRiC+WhV5Zu9BfJRFgdEc58KJ3ZZ7D4u4d0AoUUiVoJxghxIQdymorm7AI9JBmTfgJ2Un0ZS3cZpaLk50xkxHjBG5vYTBq3Q4i19dP4FTDJL048dL7ivv5LxO6Zy2scSkTKjJ7Ap2XvhlovKt2JuoxiKhGi4LswcSfBTweSq0jQ0dT8sk/4UhKZ5XdVK0P3YGWSzFSvLRBJ8NLJIT9QLAuZ0Tpx6v89o3fNIm+65Ld/Nh+BfSNlM6CeFOuEfx6C0q8eYqv23FoXEVio0voQedATCmysgjjRjsI8/x/+qMBTomsnzJzamdhw4lDbgqHZgzMqGClg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603412250; bh=sHwykC+PWD8yDAxPs1I0QrA1QmW33+Wrs3DrHN7anzJ=; h=Date:From:Subject; b=svqJzePm0XcTrK5Vb09lciT1YiRJrH6TbKkoWj72XDTL2mZWY08Kn7HfoDInLasueMxeDfrkppggSGvGA1KQGqoQ7uQUIIJ/yCUirRRw7hP43WUdMMMQFeDxR10jJdWu7VjmuPJKYpLpxnCCGLHxsADI0s60XKlJPqXLORcx1GN45v1YNjfZTUDZ8+ZcIiZsY8C9bSLgOLTXu1MnDeI3ucnTsAGEF7vKETMgNOeGZvW97wWgwEzPveWY4XHFXHbEMxcQWntX7WH3FXs/17bDjBNYKPBe9mi2oOIyrLhPTNDKyWVUH4rqRn7hzcq0z7BB3cfZY3/il8HAlZVZW+TR2w==
X-YMail-OSG: P.pyQX4VM1lCW2FOxwiaAj5VDGheKdGWNqobLA0wzebohvZJ3xENBNbqCRc__e4
 68HppchPAtKyUfIhEQcVdpKhoJqvlNGw9ynx2isJ68JxzD5mRDS3fQPAeEoTn8FMMuMfUfDVlxkC
 bxkzTxvos8CQE_BlvmJOi4UV0NgyXAEUbEtUfoYACgNOtklmiMxMZeHof970vPBbZGZyi4lwxVMz
 VzuHkiLbkbNxbihjNT5Lpv978yp0l.L47dcnFbN6nq8XH1SSZJFdrxWf_eqRjH5j6dkrTsTmbzfw
 e94IqiDtu5O.7cSkfrWwRKHHMdr4NCcmwoFzVbHm0CCh3chFesJ8aUMfYb6QuMdrZhm7XlOuK1tl
 jjdIRLAtykTSJOSLTmihILqEGx8u9euIO6ExawnSCfUJjruSCE.5j_afbJ4uRNRuQJPrlgt0hi_c
 gElwYzMyRRobZ3EsmoJ7XHvoq4x9fuGeglLgbX0EFS5ydxkBKXawwFPlwunHkAXKb6UDcEyNpBh7
 Nm4TrMiOYF9Qd5jpGPhMDemngptxZ_965Bi7BNfIsdV4OoT49c6mUGlKRgyBHotBa4imKRbbvNSN
 uhvazCveMtBUba9tY7L0L42tPc.XNdZYNVmPdC0cv.1TzeVQQfNbOfXDVzltwExAlr.vuKkkTybM
 166BIHG9TDLHiIpb3MqL3mzMAxklAk4d0yYqQZqlpf_oyrLdx94yteXZ7p6o_z7tTBr9bOWu96Iw
 PUE87bCzOfQ6aAhdZs0BuqFi9JimwrlReCREIwUkwi5yqBOCr.frbdbMOy1we8Y02HGOMmaitJCJ
 AUecy84CwNDJdM69zDarthxWVEWZnC1YyHORR.2Us_Gs4H2t4JjmH1MWmjDT6NhTIUwRckyZvFGA
 Q7qvCzP7eM8yq9XbgydZ7MiR0PlaVl7aiBIPGvUUk8TguksAgVx6EVMbH_oG2X4zzJOSBUBt4YcZ
 cigEFjGuOF2ivj03pYNAYKYMntGXPpGCH3KiB7RGNVZ5e0cAtaHD3fNY9zW2k56uWhiCAd7ZW_R8
 io6mQWDioQ84eKgd0y.yO_OE2.FTwxlj_5ETpalxwb1YG73eHWv2nxr0INDgMWGb_CvNo4rv7eSK
 WJO.OcKYyBD7xeZYAivJ5lEHSdKpOCVEk19bfH8w6Rel8h7VZlziLbXu.SWNCY38eAut3Edtov9M
 g1_udBtqY4n2KVCFZDZnFAB5Iaq9nYarthh9xaIMUMHdnem7z7CoXNGjstNVSwjRmQpzUfvcf_5S
 pOO2O1B9PgpK04DTz6fdrYPhra0Xg1apMhpvmv36oRB96NcVVYyHHBNqu4ytsBiDCJFKyFv82OIh
 KmjykxJ8oGUSiAQynbWh0HoJ48djtEWjwbuQLCIhcMO.n53hgWvFlpB1YQdSzgen1lSFU5s3zXJc
 oI1YW3XhWX8tAisVFD.TymLNseDfAuQ2ihqk.atmOdRnU.SRuQN1yWmxxl7GVZ.CcRPRAp9mJvf5
 vTOT9t_TFK7UmV1kglZ0g3906qX0iubxQUuIshVMaQL6LJJ5.ShewzPrtc45LIAJnL1bJJLjPa1z
 W5A5gkXz_s4gvJycQ8P.znk2WDVZPYZXRxEZtfLnSFnHOqiJeEI3CJlXLoCwaH7BZy1I18V2Qdeh
 JmWCui.jTWE.0_71B.mJJVULQu4lRKxaPM0Wf8ngtvQinqaFBhGFlKfyTO92R4CVB.FipUmZY_jr
 osCkL_TXRlVJ117ALJpZTUF98OxK.ogAT3Yj155zmyzbierIFS8sFQ9GTI.z.TstyMa6JLGhvQ0u
 odw_u.SsGLxNYvjSMNBGw7NYR2XNpT91w00ufxhz14FWyH7_aOd1T80Y4vhE3dgJMFQb13Mg1gzP
 mgbUAVJWvn5aMSyG3JGplXYEqG07IV4DILKdStQIuzo_qcAgEMQkJ3ESXN_9apo70.Boy3mdeDs5
 nfoEjLt1ZIIKHJKwJgxLcvvDfzHwiD0XdhMejqgv.AZXNiDjGq.FfU_9Ued0cspo1xwKrZy1FVgs
 tjEFNDlY3.ogiihKPChce9ao7A2CsRBSh0atNpZta2OUwC9IsaAWP5gQAblZn784VxspGdYBqdDr
 7eXrIlASYJQosXZ8FZULLg2JLG5.FmT2gWD4YyfTTKfo3S_NiIttxj3X0newjrdEP6Dr3US04Uro
 RpXoLHKMyAdoBO3Z53edG4WGZmMA.HziWBQI5yyYDuMfBLGTfIxVAEMn0.e8HP_cc4f4BV4NB9d6
 dRhtFkBVu0aU0EsfLvcu7.BYKIOkhAorp8mXbQkDkUcdLFQkG4nU2wu9sM0DWqFhxMjbzSqUIMlk
 y2ieVqukongIbCh4IosXI7TJPaAKEYgLVwXHDts1GfmOTV44iXe.ZLEWrLs__r2Tcy23Ny.8Clmi
 ldMUUD_KUKRWT2mpkoBRZYOBkSgIGXkb9ED1H5XqvNwIm4.Xd5OYZLNMGpkDS2xtOeUAxxZPGvLT
 3WugDfW1mjc2lbrB_M4dMZ4X.LX64qtZf5lH_7sPSSPruvW2sKaMHYA23LEM4xsKoebryR3nn2nA
 w9Jhow5w32XEFlcKgvYEjDME.FMISkFbdHqYIZIn24g3ORDe3i1v2m8jCr188qDaN7pXBeS3j4Z8
 dIk2wXi.CF.4NmROSp12tK3MQafkjHztAs4PkQnxWZWx4Obz3WnMh0ZNmPOGdX2iQZ72pqapRd6h
 gGdDy_gNWr5NM83HoyZNVV2Yq9GKq4Dz2d_8za0ZyQYTTYmh5mWhROM5OWDMPBd1Pa_WCQfwUA.v
 fgWpV669H5xzwJ4siawpaurmpqjtEl_F8ty7oIbaAU8bu34HKvHOacdjOrIHJh7N9QVUVkOjShiu
 4Q._pRvwRlBfBooXdKQ07wRy4Z7DviDxfNd9e_To5O2oMFt3r9RbjzvROZ_Lgm_3vyp8bqsITgm0
 HHRml.LsoIsEX3Yi1UO_SW9MdX6Wk58umPvpDlk83iyKQytgWrbOCGzvGyegMmcMRLPd2Ws6zoJh
 JExbaVWoq.zrR0zeIIi3BoInx3ZdFtWeQttUKH3x7AVFEMna5Af9Sr6z4DpLQWBXFD9mslm7y1rb
 OKwHo2Ym3_eYe_z8O1F7RSz0iY_vukYWyUbAnGu6MOl8RA3j6fu0a6.Mt2R.d9ZHHjTQ73InFHId
 k1Q_jU2rqLC7sYtrdmbpBGTdJvUggdWpwSR8PwnrmtH__RfXbby6p42jx_VO86_M8Zs3stkJdtHH
 3BToVU_9r6xseg8uZWiKxnXddAZaL98wqtQB1wXlAIK0rIar6Or0AwVP1GEzhldSA0ARvmpQmnOA
 EJLq7gGbr5ZtoFDgXbWBtXCulmIrhUt3rC9KRaMFvLALVR3cFc_LwGOAtX_h.ipB5oIpNEDIdjqd
 .zK8ZChO7eFEc4R77CBdjpNSTgV0xNl.7negp1DRF.A63gOUHfLLwU0bRamE4kUUEp4iSCFHzTty
 fu9qNKG4f_x3vKqkzuUvP4PulERn6n.QUp.K6_sIEfOSCXUScnuY2Ex3.mlULu3oce1ySRUFd488
 PIvjIyESbTEW6I4zyTLKtahGZvhgDCkTBxDEU9jgVfF9U83tFWZvAOEy1yYJ9zRLlTxCOS_lDPkd
 EVdX2saO911e5Jku_UZBJnNKsxMX1asORq.U__Dxw_yzrNHiPXpOhzLGFCSuNcQmZNGMvW1JqGFD
 MDlLlN5f4ev0tR7KSge7ddi3WQ_AsVF7XHAr8YgeQTDquK_6tb6uZUQS1bxKHUifWRyeNhhFjIKm
 zbKSVobEuMsgAgLjX_KFJLTjP9p1ggcl4TSj7uLhFkNFP7ChCnirN2ydsImIiJ_m488Rb5_Dm_Xw
 2rriDCVXp5orKnIFCaxuNrBZg.exsCXAIqu_b4kOd4B8mC8qPIIrC_OoCBc3pweBVY3eSzUMNwFD
 7_uCHZcUQ7yA0iYuC_.a7csC.8y5PwBsgX5dEpLFJwg7w147llMCTydQQUJFOg.xfgIT2E7GO5qb
 4qshF0HMjtL4ogJPB94KJSRSyP_qaW3V.3Y8y.cLr9K4Gc.2MsJWp0_.Jv0yEENw6nGpTrnlIu9S
 K4ip5LMF_Zz6ZDl2vJntW6pa99HtdgQMWRQtjDR4stXX_NYBoaWci.7Z9pAoHH0kkPJXavDV2un_
 knetkEGggobUs9kvDS9Be7Gc3s0aJJ2LM911h6IaWuA8d57g_eLcut57ci3TiApj1730RaHdpGnD
 tkoHAEPQsDVkGxs0Bg6Lq.wv8V__5VcoO0PZfK4XWJkk.asfD5r71hCYfA3vkkAshPgU7Stsz555
 8h033MhxGrrFdaacRZVHzRghsW_svTGOMdb_w3FM5ewjovq1QblD_p_vfMKPwQ5giyBCAREV3wB0
 G8VAsynbSUtnEaFkaS4eX9b9_flWFczib6Y4m9eU.UR01kbcmCE.5bFTUvmcpbgOAHTAJo_6RtFX
 jH1hnfMrAWUpD1FLo89uYEQaKCVD3.wvxY29qfQnoeFylzLSnZb.EYK1tGEYmqNTldHh8bHPTY2B
 sCs8Ly1R.Tm2cz8W2ecEv_NJM3T846Gl4pUaZmUPIGl_DJq3vFbyUMUesg83OUfqBAGNsKv5T5dz
 a_OvXop792snZwPTQA740tQPjTqKxoy9hCpAm_EeXeYDiMeizHIHyCb7Zhly0tIOGl8oBPfNJ44y
 f3.0XQ5sBCFG5pLKOYwY22Ny_98xP9E.RcvjXiAY8s_8izbOEuMSVvXqpCCSe278nZpwl3CWPCjj
 86DFeTSqB3myuMlOxHcPZr_GumTkoUIZXEdCGrUsf9YI_Wi9JFkaWaCd9WYcgGlTsSQDa.U7RsRd
 dBlS6aa776WkU64AVFeAowkBEEV1nFpmxKKyyVn6RG_EOT09DMLXV2tiaI3oO2kH6LNAnzK7qovY
 3maCV1yO1K6Z6dOy6zYwt3eeL1GF8Aw4Q4YQm8hvrSIBAHIPnhEzK5oUCT1dHVcgvmqcKWq7Cgec
 xQqW_OSRQPmqMsQTiZ_dYFyjaZDaZqFHhsiU4vs.0bn_Nq12Tzcslac13EtKos9W3EejOyLMKVFw
 IvFtqqKJ5A3Me0B5J8RuysoRhFmbPkWrZopeA5wc2atzqAllkxypU2E3kxygnPFVCZATHR.PHEbT
 s3fLJDsSA_9Zf6gJRIX55CiMb_xa2dBWULkywcsfH2snPpyxFgmaWwl3FYHslPIBWz2qy0QKFO1s
 _pT9uO7YtQ25I0So7ToSv.ExXEXk34441uN2CbITexxnCmTfcHZv9Vbn.KZrqApqTAuOcvrjveH7
 6P6.Vk138uUNHqtu.SrcAIGnnfxvLXHUx_3J9zYczR5jMXs3LUg6sCY1jVZziXGhVhTv_C5m2dqr
 Y3b8dPUbZRwxmQFDvm_r3Hqrk_xpisqkToVs1y_j5oQve4HQ4yZEIqQdmq84.xVcw4i08.5WXXwh
 onMXCbYTHcXSZ.rHDjVadRGh.DZiqdz0IDAs1Swct7D14gZfMZpxOtxlhLjLW4VVqAZmixWwY5Xh
 6mFOsxtG3PjPhNtkiu..CBPBOhQXdwB35n6J_SGaA5qHn3EejEXZXBbFZY3PMfT8r9WM6qNuA2pN
 P42.lUyp75CAU9IW0GyEK4rESSnXw0zNVYoCK1T06gezuUdKVpehjKOuFR1fz5shPONtUD1Tpgcp
 I5rt1UtyqM76yTK.i8M44nwF4jjTPO.7H04mxfGN7MxFr3ePXaPUXwv.ZOA6N98rfDNXWlmH4d.9
 nGjX__mdS1lblrqKEIcK5
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.sg3.yahoo.com with HTTP; Fri, 23 Oct 2020 00:17:30 +0000
Date:   Fri, 23 Oct 2020 00:17:26 +0000 (UTC)
From:   "Mrs. Grace Williams" <gw78986@gmail.com>
Reply-To: gw78986@gmail.com
Message-ID: <824483916.1839177.1603412246333@mail.yahoo.com>
Subject: FORM MRS.GRACE WILLIAMS
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <824483916.1839177.1603412246333.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16868 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.75 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello To Whom It May Concern,
Dear Friend,

Please forgive me for stressing you with my predicaments as I know
that this letter may come to you as big surprise. Actually, as my
pastor advised me to reject earthly reward and thanks by handing the
project to someone I have never seen or met for a greater reward in
heaven waits for whoever can give such a costly donation. I came
across your E-mail from my personal search, and I decided to email you
directly believing that you will be honest to fulfill my final wish
before or after my death.

Meanwhile, I am Madam Grace Williams, 53 years, am from UK, married
JO Williams my mother she from South Korea, we live together in USA
before he dead. I am suffering from Adenocarcinoma Cancer of the lungs
for the past 8 years and from all indication my condition is really
deteriorating as my doctors have confirmed and courageously advised me
that I may not live beyond 2 weeks from now for the reason that my
tumor has reached a critical stage which has defiled all forms of
medical treatment.

Since my days are numbered, I=E2=80=99ve decided willingly to fulfill my
long-time vow to donate to the underprivileged the sum of Eight
Million Five Hundred Thousand Dollars I deposited in a different
account over 10 years now because I have tried to handle this project
by myself but I have seen that my health could not allow me to do so
anymore. My promise for the poor includes building of well-equipped
charity foundation hospital and a technical school for their survival.

If you will be honest, kind and willing to assist me handle this
charity project as I=E2=80=99ve mentioned here, I will like you to Contact =
me
through this email address (gracewillia01@gmail.com).

Best Regards!
Mrs. Grace Williams
