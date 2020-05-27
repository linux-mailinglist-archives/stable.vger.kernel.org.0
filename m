Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B85A1E4BBC
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 19:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730221AbgE0RUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 13:20:38 -0400
Received: from sonic304-9.consmr.mail.bf2.yahoo.com ([74.6.128.32]:43416 "EHLO
        sonic304-9.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730056AbgE0RUi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 13:20:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1590600037; bh=TYgdp/zNeW9P5rVjVpFopjba7a+Fm8hxyemx2bQVZd8=; h=Date:From:Reply-To:Subject:References:From:Subject; b=nqHdXEdeB4WtgsDkwSBiZZMYsowJEWNOlPmiWmdavdKg6oAfkHr3pZ4xIQOKYPtSwzgzEu4FP6rJS7WagHq7wq1ifc7JLuTDRWjbTc9r2RLx/W45Dz/E0d3jp/+N+tdipGstS+LcnSAsal67R8ggXjTEV86FmMQezkbPJw+LpBqrtc5zaLYpnL+CnmVNKNCOLGjTpPqIm56GhuzcqQodvgBdWevbSZPo9PZCRKCA0cqvaj+2ijtxl7WlnSu9os1F+8ZFNJiRUUyXApbfzu7e/ao3FqQhVxbEefV2H9VidHeu1qeSpd8DqUR9LUUa+FMVJBhPibNgQnAmbs+km896hQ==
X-YMail-OSG: hAl1AwsVM1nj8FHqIKWtZ1JM6YaVP.M8znpsQZBoI97GbybtXj2BTzzZeQWaOgk
 ctdAbXMRMDt20BHkjIA9qHQlomlIUPWrQB0K7s8WiY_qq8Ffh0h9V9JX.7CtW421drPPayZp1peA
 x6dSgGoHyS0sk7mJRm28FDl4zMoaV_bprEzCc_AUft5q83c.0yCuDX79o60hPnTl._1xz2y1DIwb
 wZiVVGTNfz6C64PSEF43MRiE0cE1qjJm9OQt4wBLo3vRS07gNCxy1PlMXO5iwr7ex6C557OEfTMH
 0K0wev51A3mUBsBBqbP6UcRDa5G7s.hRfmCH1jQVNynoTrbiwxBfY8KVXWzVO.bK7xTyyywdZDbU
 Bosm2kqzMY19e1rjs0DANBIeXTlkO3BUcK9stpuNd8EwEt0d5EGviDxs11ftj.u4hGlZK8ei6GIG
 m785KcqaSaUwEvSNaNfmKzVrqTubCo.DZ.gjhTaCi3DgDnVc1zcKWnHjevNz9UlECkpdGOOXssUM
 P8npyTO41wgtcmvYuunRIrioQbCQPEXB_5ofIOnvXCeov9Yc7dQPzBRylSzWK.iDh3N0HdyhS4la
 doTrPMqpxgCQBAgEyvZAABjXroEEUAix9.MUllBIMwJrHmhRyMH6IHq_qh14Uvqm.7MPkPdwbZZ_
 6.kuGDBFErmt0WhM85LsaKiDqFvHBP6MgrWdG5f_TsoXyDUYr0mVkcc7CsS1.QAhy7bg3x8zmodc
 Z8GAFVmA8bxqLrwVuJ2sEqWN7LqnR24Mkz_d.h25W_L08CC9f43.xLsUM4zM0KVdze63FuXOWze6
 gdY_bz4CsG2Sr3lSDLgpFc8dL7p.P4rY2jAGhlfnJHcxhgpMLqAAEQ4krf_whMmQ2UMh9s4q6xOk
 rN5WxuESSzmIeA1SPralsJKC_narP77NceZjPU0iSlP3EguWtdVoGHB6pwGfFCAbhTM40X3eTHpv
 ADqm77_U_5BfXry2t_6A3feWSQMmvMZFspz.iftOYHcDrSTYb1NuDXTLZvKIbXGdS5OLM74LayAx
 xKrT1LM0gnkNbllbVlbN3XuUnQz2mndULt0xsVFcYdxguNqR.3gO3FePbBcfxMNvaTkMVFSMd9Jm
 OfgiFxMzouA.gV7cKZDzXYNEMkZN6y2rMAMpm_C_MEgi.QIPM0KBkLxKgaSEj2L0oXTLPzSkquyS
 KoxXc0PWTSiYAR_N05za4tyPZXGM1IJu21Zl4p6tSjoswNLFAMRnPK1eS5g1nxo6UZRRLlgNBcay
 Crtn4HQ3gtcF8Qxp4zhdl49dMU4RvG2HopHmj_aNtid7LNBROS9LkR19dZtbuuyVLUimUhhFXzWe
 RF0saUuFvKXqWQFpyruyaRw1onO8Bdw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.bf2.yahoo.com with HTTP; Wed, 27 May 2020 17:20:37 +0000
Date:   Wed, 27 May 2020 17:20:36 +0000 (UTC)
From:   Mrs m compola <mmrsgrorvinte@gmail.com>
Reply-To: mcompola444@gmail.com
Message-ID: <1325121832.351121.1590600036682@mail.yahoo.com>
Subject: Dear Friend, My present internet connection is very slow in case
 you
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1325121832.351121.1590600036682.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15959 YMailNodin Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear Friend, My present internet connection is very slow in case you
received my email in your spam

How are you today?.With due respect to your person and much sincerity
of purpose,Well it is a pleasure to contact you on this regard and i
pray that this will turn out to be everlasting relationship for both
of us. However it's just my urgent need for a Foreign partner that
made me to contact you for this Transaction,I got your contact from
internet, while searching for a reliable someone that I can go into
partnership with. I am Mrs.mcompola, from BURKINA FASO, West
Africa .Presently i work in the Bank as bill and exchange manager.

I have the opportunity of transferring the left over fund $5.4 Million
us dollars of one of my Bank clients who died in the collapsing of the
world trade center on september 11th 2001.I have placed this fund to
and escrow account without name of beneficiary.i will use my position
here in the bank to effect a hitch free transfer of the fund to your
bank account and there will be no trace.

I agree that 40% of this money will be for you as my foriegn
partner,50% for me while 10% will be for the expenses that will occur
in this transaction .If you are really interested in my proposal
further details of the Transfer will be forwarded unto you as soon as
I receive your willingness mail for successful transfer.

Yours Faithfully,
Mrs.mcompola444@gmail.com
