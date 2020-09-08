Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1440B261DC4
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731009AbgIHTmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:42:02 -0400
Received: from sonic310-20.consmr.mail.sg3.yahoo.com ([106.10.244.140]:45531
        "EHLO sonic310-20.consmr.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731669AbgIHTmB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 15:42:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1599594119; bh=Kmf4PGGAW4hFohRwP8VxB1XRE0jvKX4FRcFJqsGTJuM=; h=Date:From:Reply-To:Subject:References:From:Subject; b=qlH0Fvs+enc2nf0B5o+qbKogS8hKE6aC4yPX/YIKVFW+u2ic7Lwju+NSQYfLaRDJjcBdUT/0fLjrjIw6UjMCFshPOjhdlYz90hxfwcl7w4aGyI+G4AZddQpst3bAWxvuTUZ4gXho6ITRMQfNOTPExB/fm56UWyhHXtoC9+nNr1pK/6x5pDsOgd2NrOzAxLyXRq4p5mldVYyxUoxoZ8LFCkoEa7thf+3cgaWFo8kBXxxX08zWZPuqx+GvtkSNBtcryZpWwRcjYBl9vWYzCWuDbUiy8Zt3d6jYVyJo3oxAtkaiSnNFPZYrlHF6IJvd9WGCiJ7WJS9H9BWXEIy8UvhRdg==
X-YMail-OSG: rQcpOp8VM1kWelZjXphNpDOZJ3GbQeL.FGE6oJIex6u8X4Hi7m67gxAV8gvuwuH
 yZN.xwFE.AGn6bBj4HQq6R49o8EU.oK0zWjcrOs0pD58VuYy1HqYQihdzyokRDmTIdwT3wHo8.cL
 Yhbm33Lt.fVyNOrW_6NRc0BHymXANIAWcHmdwxUrIP4g_s.zdpuQ3vQ3K9M3fHqPLs_TEdm8VL6c
 bYtWBeBy8odZEjfQCulf3djPMR3XeKRmjau5Wl.gNqcle.nkBx75ntzw32c3a3VWd0SG3PJ5y6uJ
 N9UN8STJkwznpQp1k9dOiIso1yOd5lB1PZ6R0rxdqtsYPlk5nu9Ijg.U40DlzoOyHtW_QuEce7b7
 LngzBm5D6u7W1SkjD2FdTi4cgPNA8aJbFxcA7FXor1cBvC0BZL0onYMtdSmqb7pybs1XQmmoFuS8
 ILYdgM2GBNQKzzKXDqyqhUfuAIl7dmoja.bGZ52Qm79H4Phw73fUpD3iPfim8VnVeWcGQ0gL23hW
 2iJdkcMJta2Vg_Q8LnY3IAjBAjK2dlcEZZjnIyQEhOI7CRKv0smhAs2L8WYXpVoXl14EmPMAuC.K
 Pon8XzHHzOuvsxHoNsKdD3tJEH3Bo96GypHAIkC2QoURoKuWqoQMczuW9CA.c7L_3keQrEjEyMXV
 dawK9wWnvRBGm.Hp8VJWgbWXR5Zun0gOwG.K5.l20A8mrBPar0on.RGKElg.0rdG8YoSqWWd9N8x
 2C2ehG.qp_O64yRwipP429NaJkgBo6fuWn8AcLX77G4sykebW04ccGXiBJI9TFpuBVVSZtnWmuXr
 gr4TMxRHmV7MkEZKcmpYJu6IGaEJ5d7yV3deIAiHnIBhqTTKCdQi9N1WbYHLIEC5zBZmUWXlbpgA
 NbDv65cMdGmSxTuvEh_8nu_Yo5T.zzJ_plNyqGQnHihGeZimQHYtU2KGLyGXlp8KsG.hXnwImxKc
 YcolYPKwqb_d.IRyI_sLoq245QeoolmMb4SeR39QT6i.g7oU3LfA7wWmPKGhqFubOXVqJUFVJ6Mx
 pSyX_o9lj7sGtksTY92OOJ7nmzK4RH2aHgbMhTu5bfJ9OgB1JRc.F4AqJHmmWz_T_6GKb3.bpA_Y
 wQEAA.Xd3VjhYLPSwWwogJcf8WWO_GhGw_IndBiB3Eq0hxMTZHZKVX49MEjnJlAXEWTLTisQ9XRF
 QbTb0PuFpDb3aTA6wBNFT83Jbx0ysSXLgMj6iMHdnuKmyDG.BuNdhM7PNqt6fcU9GPKslE8aq5kM
 syMaiznaYXslsa0FwcZ99hGWXPPfkQ1ckSx_jpIynGgaugF_Gra3CaoNBa4lybTxnbwHBU.XF9qf
 5IUogiz0iOCLXhiOhrYOtXBrsVjXzf7wKQo.N2TsrxUES7EGElh.xRsEl.cKB1bD1oCNkM5iN.0i
 nrxQdr_fKinP9cWuNFLiwbyIQx7VYVeoJStNMnEV6yi7mJCNKClGc
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.sg3.yahoo.com with HTTP; Tue, 8 Sep 2020 19:41:59 +0000
Date:   Tue, 8 Sep 2020 19:41:55 +0000 (UTC)
From:   Celine Marchand <official017891@uymail.com>
Reply-To: celine88492@gmail.com
Message-ID: <1265728737.3047869.1599594115774@mail.yahoo.com>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1265728737.3047869.1599594115774.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16565 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:80.0) Gecko/20100101 Firefox/80.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Hello
Dearest, how are you? I am sorry for intruding your mailbox, but I need to =
talk to you. I got your email address in my dream and i wonder if it is cor=
rect because i emailed you earlier without any response. You should know th=
at my contact to you is by the special grace of God. I am in urgent need of=
 a reliable and reputable person and i believe you are a person of fine rep=
ute, hence the revelation of your email to me in the dream.
I am Mrs. Celine Marchand a citizen of France (French). But reside in Burki=
na Faso for business purposes. I need your collaboration to execute some pr=
ojects worth =E2=82=AC 2.800.000 Euro and it is very urgent as am presently=
 in very critical condition.
Please reply through this email address ( celine88492@gmail.com ) with your=
 full contact information for more private and confidential communication.

Thank you as i wait for your reply.
Mrs. Celine Marchand
