Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D624E164285
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 11:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgBSKsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 05:48:07 -0500
Received: from sonic309-13.consmr.mail.bf2.yahoo.com ([74.6.129.123]:40915
        "EHLO sonic309-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726530AbgBSKsG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Feb 2020 05:48:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1582109285; bh=5nOAZyR+jaVMBirCRjMazu9Y5eDH3luxBZuwlwvAAvY=; h=Date:From:Reply-To:Subject:References:From:Subject; b=rbOADzNvjD8B+3YPnipFrzNvNFX5RBn6KqgYiEvjca6tMkg6pKOJkpxfmrLlMHOmU0PyDanhbKITReUEddQ4YDiN1OoHCAFiCGVixsJLMbXMK1CqUyHw1lqdoHcckw4Ami64G2X5HEoJ8OvCFAnCuiKciuza4XlmfdrU8q23eh6NsCGoo5kq/qh1z1VZx0LcNwny0S6CC2dbFbFNxymCtv/HPQj+6UHvltAu/aUufzyT7Iq/oxD8oQ+A14zuAPQlcrVye7kVdgTOnXramr4anm942G8MjOB5gTCbhwM1+9YSRcWyZ4cCmi/Rdh41FAZZGB33UHpPqKBOObu6ia0Oqw==
X-YMail-OSG: P.LDtNMVM1mX__wyozbWOw1ZjbTHvhhwbFSX8bh.HwomiE0PehQzYHYtYBrVm2b
 wMBwWG..u21PDiGEeUd2OeqDqLOiJKEt4ufA75GXU_9DxFoXGiCF0lXuRXnJFsH5ZAYW2L2irkdD
 t2hexITPdGJrR7HsoO4_q10k9chn3k2O7uksxgMMew2yj62P0AJG2oGCOXV4FdnamieRfBowvA0V
 cW5ydl2EiCIhpvdR7Mi61E0Wf6T0ug8jgBY91B5bqoxKaFy6v5Rj2lLZQGl0vvFDvPiuoUcoaR7N
 E13crbECuGeOP3lYI.pY7f.hcPzVegXGshnSp8c71VYXsmq.YEhoqPiZstfvmRYPHwMbv8cjW1lH
 4tePj.bI_2tBneLL3mbUGYmETKhxA7knDtyKeJQqOUqQusFRod6GI0__BvptC5WZB6sthdaJ0KnH
 NFp7iUHoGMKJVo2z0_AwIm.p8yKKc5NZKcona82DaLT._NyznJ.JLTwA.4fR9.3Hpz5hmnyRKgG_
 CjkajVXCFOI4ECaum8OPSG7PcFhYnr2cUtU76NL_7ziVypxRPb2mjUrhAJD35J_yipo_igXnXs1x
 Be_hAOw8awJntr8_dZtek.fHMkEsJ.uTAGzJoZCx93cvmURLUnXmz.jburd0pSv5d9iiMaXcioO9
 VFpFTjSACx9TnHS4dFgwevz8osD_AkbMtR2XkY40RJ98Xo1.KncislIwVdmwTqx1KUifAruORycx
 lf8uhfBJZrb47GOy9HTX3XYNIM_3fUvhk8rkt3TRPanCwn1U57ryE4uVYvxgrW7pz2cAvN2s8Bd7
 vdlTUBnsH1qJFwtL0GHsA3B7oaTKWtvwt.2y0n63h86IvyG8cJa281cbt.n3Hcb6pBb.hDfum6lL
 ptvLONhAUozq06D7FcSUOl9EgjQObCNlCceHICuKwkZDq8Y.vpw7qcVnnS8cBumOiZSKg7BzWXKY
 VSx4K5SqsvtePN8O72b2fXejA5d_3VYssP0o1Uz3CZlVeoseWEO4D8YO2HvzBzdDZhyhON0FlPtr
 BsQ4pwDkRfVw_6jbr4S_ACoQjF4oeoCOoPP8uaEzKRG84QoqsKoUa18gkMneen6y1BEve182hHCb
 yRithppEI5JRd6SRDyCm.t06_MrLtz1G5cCZI.1UDCUDanwWp3Sbw50TczSxlt7zqVuBO5hnM8Zq
 7eF4dZ9geaakWSf5x2f3MbuUHhd4U.v0mDN04mDDxSQMHLUCoT40385oUgbMyOUooCO6FF_vUgla
 CI0Fqxm4pvU0TBH.k8FQTZhh1XWfQDberz68CBuHLwll03CqtGYmWBIMVWGxRE5QJuX.3NKz1vw-
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.bf2.yahoo.com with HTTP; Wed, 19 Feb 2020 10:48:05 +0000
Date:   Wed, 19 Feb 2020 10:48:05 +0000 (UTC)
From:   jerom Njitap <jeromenjitap10@aol.com>
Reply-To: jeromenjitap100@gmail.com
Message-ID: <182788186.3634579.1582109285005@mail.yahoo.com>
Subject: SESAME SEED SUPPLY BURKINA FASO
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <182788186.3634579.1582109285005.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15199 YMailNodin Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:73.0) Gecko/20100101 Firefox/73.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Sir,

This is to bring to your notice that we can supply your needs for
quality Sesame seeds and other products listed below :


Cashew nut
Raw cotton
Sesame seed
Copper cathode
Copper wire scraps
Mazut 100 oil,D6
Used rails
HMS 1/2

We offer the best quality at reasonable prices both on CIF and FOB,
depending on the nature of your offer. Our company has been in this
line of business for over a decade so you you can expect nothing but a
top-notch professional touch and guarantee when you deal or trade with
us.all communication should be through this email address for
confidencial purpose(jeromenjitap100@gmail.com)and your whatsaap number.

Look forward to your response.

Regards
Mr Jerome
