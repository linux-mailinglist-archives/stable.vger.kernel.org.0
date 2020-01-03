Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4719112F79B
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 12:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgACLmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 06:42:38 -0500
Received: from sonic307-29.consmr.mail.bf2.yahoo.com ([74.6.134.228]:37410
        "EHLO sonic307-29.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727507AbgACLmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 06:42:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1578051756; bh=MJdpASvZnpj3gXKZxrNskiGAl+hYYwdjGUMDZ9fMpsI=; h=Date:From:Reply-To:Subject:References:From:Subject; b=QLQZpaSd1S2+G+qROuf+203AjHmHN7jLGP+oTiOqoucNA18mg4qNxKJPYYuIh9t/3TH3FinRucHfQ1WH/VMb8wh+kEEnW4O/q2MiY1QnSCPPwW7mSOHWYiRtH4y4JOpdn6EH8SHb97eEuvPC49ILBBvP50Cj4iaX/NiWO8dIlpaLGQvW6AP4ZOsKRS3ADCnVdk5BTTyh4+4wPOON0/H+o79/BKlU6FBjifJaVH8GJ1QSCEeI2ctvRPrRH2IwSeYGBYB+sVMYrMEpTx2hCy43xgmFQGWQJJOEdPdO8/7MpQG4XOM/p+YBR2SYA1VGU7CTxqM5zCWPIFQb4Hc0JwczAQ==
X-YMail-OSG: XKzOFK4VM1ngtHVHdcRGsscRes6gEfJuQ_3wS3mjhIPZ6s13U_dbpPpStFxcG3n
 q30A8TxNR66d4RrlZBBUHqlgHk1WEOYpZSYAQOxT1c4ClsGtAlKBE60OT3aQMZKFULmHcqTtV_kR
 W1.8.JgUGMVZd7nL_qMHnXKfrrt.AAZACBvmM7KsxoUp__KZH2BheoIuzptQS67qIvysM6VsV6eC
 sT8EXXDYlXfyBRldoh19lmW130aG.nTfCagYTipEqLwn0G0UxvQp_UdWfG6q.YMHuwGH9q09GODG
 CkVTmajSXRbyYxOtqdLleRyRNog6DetBT3d.qxW5Dg.rCG4p2nCsUczGYeTDDdbtjKfTpyg0_L3w
 miZ0x4AtA66efI3N.6qyGcJa9ea8AcEUWk3xGgL0a.utCB.DMR9X2iNTuiDtddi11s3Xf15WWxm2
 1nNmsYwOerwFfYSeonUt01Vuxdl2hsy9bhlqSB1st5Z8DT0jEblbQf1U5F2mShkb09hgoViplQHv
 cprfLAp35wzcbPq3I4XUPgcwzt8WCGnht5tfYMyImvH3J.twOJrPqONSIJ1QOuo3XnO2xWhNbG0k
 XufiPxJfevPDMtWcNJgCNQBtzerC4h7T9jbYkgoPVZ4zFyyZkqKyb7QNlMPjFuzeghfxdLrpoPbd
 ttwca9wv1sc2nfHbYByanxWuO7ZCpI.V75l8zLb.SGCyXjrniENrQrCBiGXx9anITNujcLJS7JCh
 26OkKcci1wNF.NrMro3nRPhI.5DNYFntU0K60NBfn_hjOP05XJ4XhW6CxBCOLMEH6b4lmq.DoCOW
 Wvq.XqK35uweQhs5xwVgmU4LpYniYcjh7RBoo6033_pjN.pARwESY0F9BOS.VdKxI_QOZ39kpsvf
 wgTm4Lj5my1oRIKtV6gq.afk1qsGI58dxB3K8oMX3LelWbdEERuAcQjcrgyl8hyPcc0Sfx0_i8aj
 p2jCIPhuSNW0HoeMbjVsV6DthnZ90Ai7wLwGxXALa8UVorj4dKWPN7tmnIpVuBUJuoaNQcw3PAu0
 UacZTVzYvwZVrYolLywyl7MhsvtSloEtgVRav.EJDGrL6dRc3NIPbaqCS5HROpch7QwLyQAen7WQ
 Zh9FofD6c9l_ZhGXCXtx9I5._uvyBxWm_70IapFx3iEJ7YzUv4NAA1tyc7GPKT166P8oojZO48NI
 _254P4yXbyCLgMrTTDCv4nvjpYF3a7AULt41lBFA1UnWyEi1LqnnycgVYHdKNH2x_hhNfpmk9UWo
 XrJsObiYG4bU1ZHIlcGFX37iDmjdziCmcpCj5rMrJRIFwy4fcVCzP.Nt8tgqU0C7hqobvK29HibZ
 yzKGJXFjQ4uRkBbAbVdODE3fv.xRD7GY0RFZcHHw-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.bf2.yahoo.com with HTTP; Fri, 3 Jan 2020 11:42:36 +0000
Date:   Fri, 3 Jan 2020 11:40:36 +0000 (UTC)
From:   Brian Gilvary <1brian.gilvary@gmail.com>
Reply-To: gilvarybrian@aol.com
Message-ID: <366851621.4061922.1578051636621@mail.yahoo.com>
Subject: Happy New Year For Our Mutual Benefits
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <366851621.4061922.1578051636621.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.14873 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:71.0) Gecko/20100101 Firefox/71.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

As the Chief Financial Officer, British Petroleum Company plc (BP), I am in=
 a position to facilitate immediate transfer of =C2=A3 48,000,000.00 (Forty=
 Eight Million British Pounds Sterling), to any of your nominated Bank Acco=
unt.

Source of Funds: An over-invoiced payment from a past project executed in m=
y department. I cannot successfully achieve this transaction without presen=
ting you as foreign contractor who will provide the bank account to receive=
 the funds. Every documentation for the claim of the funds will be legally =
processed and documented, so I will need your full co-operation for our mut=
ual benefits.

We will discuss details if you are interested to work with me to secure thi=
s funds, as I said for our mutual benefits. I will be looking forward to yo=
ur prompt response.

Best regards
Brian Gilvary
Chief financial officer
BP, Plc.
