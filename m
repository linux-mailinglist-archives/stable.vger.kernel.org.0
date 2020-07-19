Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E223C225204
	for <lists+stable@lfdr.de>; Sun, 19 Jul 2020 15:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgGSNqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jul 2020 09:46:14 -0400
Received: from sonic304-9.consmr.mail.bf2.yahoo.com ([74.6.128.32]:34889 "EHLO
        sonic304-9.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725988AbgGSNqO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jul 2020 09:46:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1595166373; bh=qXBWf2EoWT9gmJgm/3NiogFnv3V/rxlq5ApKE+Dow4k=; h=Date:From:Reply-To:Subject:References:From:Subject; b=OeUOK9LhsASj7a3MU/gaoBtCuDjZhge+gYx+i7OU7mbn0l85XZP/OEeiR/R9ITg1IWQD4ka+1wFSpZsFmBuQKLhSQAxcxHAVVBVyQeVljrwuwwIhjGiE8j5UIihqyQyzmZ+3/KRnZFnAXcFXanul7La/ZKU/mYdbMClXb2FLqcYdkHOPXw4TBTL9DsEvWNkMsUU2RL5pScnNvsjVwkdC/rzPtdVsH3LxWtNcR1SP8i2fHRrXrC1z9rtIkllURhGMaPm27Uryn4UK3aqBcjtnbuuONvnwCUqc9QYS2IGAXbXeHBqPnaa3k+ozPvXTr/TwYZqg5XJgDYbKp+W2hmIQhw==
X-YMail-OSG: G3FSzkEVM1lkJ5aBO68YKoEl5xNc31EoxUt1YNK4tv2QSxwKvt5g5y5_579WKJT
 j1RjkLn2OL9pxI97IMRkUCvmFMsLOjxdJABsuQ_Z09Xiu7m9RoLO50g6CR8wvoVnkolRlDfep7Kf
 kn_Be3GHE1egXADQ9K3aQZGI81MBSleRoDpTnWrdqkS4WrFEnVH2mbm9A3f0Iti14SefpiRTFLRz
 a096FmgixP4h10EzYqVRi9fYdooiWN.9sbcWn8DbFLPM9mUsD_L0y4z.zyDZaAbLNIgWZkM_DVrI
 Pm8J3xbl5MAW9tenUjQeM_wjtcrpTnsRgXI69OWOFVeKYj8bxlYTyScATLFU4gd3vPrgGujtRtIg
 pihKeIyg1jhyaiCX0q2aqxvhVas7ZHmauaps1qZf2IRmHj8WmLFYxUJzWsOZwpuYotCZLDQXjjD2
 _8LhsQp8NXLY2P7UAXwKQdg12x0A7.tFJthoZZG.cBBUVv.rt5OxOS3uewO0dcO.hA4MhOaRKNqL
 iUl9zk40F3E3roEQz_U3EPeHrUXMPU9WbfZQ3FIrAb08Zby2P0LsE.IIW7vvTBU2WL4vOBWBKgVg
 ocHSgpqic2okPle5p9R_bdL7wNxb1HRK0M_zu8Hy9dnk212jI7Xwoma.l5B3IyiceghQA1sGOfk_
 0tDwAPGhpCVB1A8xaSs8sQmYXdcFBGp0SQyaGDMAYetqBhsiodrE6._hfaN2EaC1Yst4w7UdEiyk
 Q31WE8PQaQwcnfcWFQdirWvM_zIQel1twMgK_yKSiWS.uEgPd6bz7z6UumNUHlUKCuXf3ghJUES1
 yPIkP.YAM9Vnus6VVGxHpDr_zx7dxDEViWJqJe12Atqf60zhBzsFKm0k_5Py20De.eNK4qzILLAJ
 amPCQxm6QN8laSFtmPqyRyeE94XjhQx2yO52s3juotNI2xThp_H74cqMsYtv6AbG.cggr55Dmaux
 fsipMiVBFzM1cibahAREpQmkia5lMK7RHpEXV_cIUe8GPJE8THlgVjXT16tQ53h4m3iamQZVjfHv
 z69EmFa.q1cdbkxsud_2oVb3jzYXYbMXBnlxEDGdkevMozQynSeLEb9ZFcblmCFIgUGswFER6EpS
 QRRlskCM95KVjAFCbdD1uzjOgJuTPS0VwODIo7S0zeSoz9IPI6BtPobv3rdWVqKDOPffuWZHP_zl
 yIKguJ_o2dMJCKUAh5PyjReE1TUWJBaamYMyKyQj18e.cZSp1nEqxqBupXV4XwODYQngnkXuPprU
 cdS0R3T9aOYd3ENsFvLpTp.WGicm1cf8IwSvu6EgnV803WdJl3IgwEvutA7ziiUVXSbnAj2VeKKd
 F7rbG
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.bf2.yahoo.com with HTTP; Sun, 19 Jul 2020 13:46:13 +0000
Date:   Sun, 19 Jul 2020 13:46:10 +0000 (UTC)
From:   Monica Render <prender1226@gmx.com>
Reply-To: mrender377@gmail.com
Message-ID: <31365565.2734437.1595166370174@mail.yahoo.com>
Subject: Nice to meet you!
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <31365565.2734437.1595166370174.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16271 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:77.0) Gecko/20100101 Firefox/77.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please do you speak english?
