Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185751EDD36
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 08:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgFDGeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 02:34:18 -0400
Received: from sonic303-1.consmr.mail.bf2.yahoo.com ([74.6.131.40]:39708 "EHLO
        sonic303-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725959AbgFDGeR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jun 2020 02:34:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1591252455; bh=eVWQE8aO6isO2IoHTAvouja63Qo1x862VnNlRn9e1Ww=; h=Date:From:Reply-To:Subject:References:From:Subject; b=ggWPsVfxKKF/MbqhellDq68IlKPnwKjGogh3JcvZerTal0t7blhkzC1mLyRbiTuOSM0bCDk038go/oDsK/lQAo7M9a+CtRbITfOW3xx3MRhdn18vV3mB8pU/zJvGwA/94tfZGrPEjEfupaehFV83fbo04lZOVD6tYgW9gWg/22iiBrHG4fLs3mou4qHbUBPVtG+luEZ/7ueTI3Uh83/vlyQ6GpqxtEUOkGeJemDFrFnoMee5dY/StLkBFO3WIHxQ1ggCQN9Fb09dqFRGEeV7YHrmB4FWNUDCVgBGR9Jf56V/IUjAyT8j8cbZplY4X/KgjONE5XPS2kOsutJh/6TMdw==
X-YMail-OSG: msU5.qMVM1mbsAbCo5kWJ2m5anHHU.jli.IOGnM1Ib7fAY6Vi5_TSqZp375EYmW
 N5erBonnYbIF0EmVtEPnUuMlSfOEgK9QvYEbd1SmyA4Oomxkj.UyykyenuWNrZxGUG5OwGsNO8T7
 _lkUlXYKZv4WGIVEchG9yETGqlfFfvPeQCsg295bc4jXX.GqXGEDCPSAjR404psCdC62NZheyERS
 D0uVyMcriPgUQFB.55urvyOE367F2o5zx4DfMPXuWNyvF_xlDHAnH7Vv6J_k2SuEGCsqHSQ4kKUA
 Sx4aNKJK604dFCK3DZboy6mxCqCusF5D2CH53sehV.MdLceCe54Rarc3.RfQWcAmnPy3N.pInrmv
 YTEr_umHHEqPvdlBBY8YSuquSIsSAM_YEKiI6KIBIXOnD5sE0TVpdm2.w8LiATNymUjc.bLEcUYd
 SBW.UAx3eB7vXNx_DEsU6KMW3.q81XoU0.IfStmMe6jTfwSPdUbx_nW1WHMTvt.XUtkDgh9.v963
 qnVmBrOAbRhhErcCSnOGeiCNLwMdP0Ont_K.PSsgcWbMoqaVtT6DjuYYaOFyqLjReJzcufkNVyuk
 KLl.dxDzSMvvOg3_PSULrMx.Oi19ss6sdnum4sfhz6z5hb1xxgLPYd6AEdbaXT.mrIzFb7aXBCaH
 SO5Ys1eU5vDXmlrwwMFfWmc6C7z0DGtXVdeWvJ3rZUvXYppGIizlZo7u.R55e1_IrZIgFfadIoty
 lZ_bTlIlN5qsxskYREryA4GiUpwsZhHTmhwgdGSMLnPi_jqfOqYndaV2z42Vk6WInUG57Kx6rbHN
 AlbIQu0PNn7Xnpxy4Si41G.DtottaxcF0F.x0dBeIFbZiBq2xvE_2ONqZ9p8uypwjbwr7LJKMheq
 zf5eoRop4uJWuNRtz4lwkU6Khr23kkFZumD7BaWIVSXgrsqARvFXuKti2_5qCo0rIt9JdgFIXOn_
 wVuLJ6DBOf0M26uyQ9K8NZ49at2VzLTtovBmKAA_.spsh4Q_P98ti8p3CIB7O8Qp5Fg8_CUF6kCV
 1WaJ7vxmW9dS6hDqZTO8nFytOl5w8dyR.sSNxLtxoNZPiJjqzBXGLPD650i.T.NuiYR5MBdmqiBE
 PAtLE9FoNgPXPwBDRzribJou0fV_qV_rv.yFDiM9TsBk5GBvihGG9EVBk1Ru1EFpCCMxTKAvj9ao
 q_9FXpmdmM4ppP7dMXzP2EQxFbsLpGO.ABqinp._DUN7OKnOVKotxmiJCaYV9JRgymYecXhMwW4O
 tcXLNkd4mgaibNcf99lNSkuR3Uh5M6MrmqLVxxkjtcvDdhLTmYo3aZmaK2KZ2QPd.IvPBzw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.bf2.yahoo.com with HTTP; Thu, 4 Jun 2020 06:34:15 +0000
Date:   Thu, 4 Jun 2020 06:34:12 +0000 (UTC)
From:   "Mr. KARIM TRAORE " <madelynjosh963@gmail.com>
Reply-To: karimore245@gmail.com
Message-ID: <1146322427.1746753.1591252452716@mail.yahoo.com>
Subject: BUSINESS PROPOSAL
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1146322427.1746753.1591252452716.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16037 YMailNodin Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3896.0 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org




Dear Friend,

I am Mr. KARIM TRAORE Working with a reputable bank here in Burkina Faso as the manager in audit department. During our last banking audits we discovered an abandoned account belongs to one of our deceased customer, late Mr. Hamid Amine Razzaq, a billionaire businessman.

Meanwhile, before i contacted you i have done personal investigation in locating any of his relatives who knows about the account, but i came out unsuccessful. I am writing to request your assistance in transferring the sum of 10.500.000.00 (Ten million Five Hundred Thousand Dollars) into your account.

I decided to contact you to act as his foreign business partner so that my bank will accord you the recognition and have the fund transfer into your account. More details information will be forwarded to you.

I am expecting to read from you soon.
Best Regards
Mr. KARIM TRAORE.
