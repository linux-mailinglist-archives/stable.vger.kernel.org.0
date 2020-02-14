Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB3215D78E
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 13:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgBNMlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 07:41:02 -0500
Received: from sonic303-21.consmr.mail.ne1.yahoo.com ([66.163.188.147]:41045
        "EHLO sonic303-21.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726191AbgBNMlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 07:41:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1581684061; bh=E+ks7AydzaUb4ISZTuxin7s0E6gVmk5020fTLYVYB5E=; h=Date:From:Reply-To:Subject:References:From:Subject; b=X9twa8nNvfHXAmzVXKwF2J4carRIPS6P7imf9QwEVmTkw1vK+6OknjCy/qESHsmPMZHXfNDzAYBnFrVFi0sBsr52fqqURnKovhwx6a0vTNnhmPHBPSl3eZKR5JVXXeb6MCImi6tUzNGJUzBK3zN5vUDb6LAwz0/+CVV+TBqTn4ZLwYjV04oKI4fAwNw3U8I8pd7+o/S0n/lrA2xa3BaUGhhRkkRec1r0GEZtdwKxx+bd6myjChrNpYDJ7wyY7oHd1AQZ9Hq3qkA8oShPxYn0EA6eqmZNcx2ItFBoflwSWvLEzRG3764a6qeZG1Rccvbt9CfspvyOE+0B+EHfrpMUwg==
X-YMail-OSG: Z_U4Z4sVM1mWvYaEetaFLcbAeTe76PZGBg.ZPz1LsqIty_TFyMQFeiyom53fdyX
 DYCghbyEHc0dDo2qF3zPAL4sZVUtzNXuHO0.GXOYNVgA1cI94fvTG9ySeWlE_9.rn1njxDRTcssZ
 FgIoyZPbFH62y8P_loJqBIzmuD5OlOrQjsCD2immTnPVK1OHyu9ArO5P8d_vnRTCxMQXXntRZ8l0
 h2GIFlD.MO3xZw6nZZDtuLnqyDLzR_duj08K4saWwgdBdbtbxs3QyniG_KPUoVWBUjmEIPRz.nLo
 j_PY9ULFnzeBX9QLDpSsK8LBqYqluxuOI4zdWG3bwhFgDgBRQw809koArl_RndZmfyzbTaEADFc4
 nvOFrCZDXufX0IjPTqNehLQTBrLzF.rZeWd3imopt9i5QPFb9YHPQEN7.pKjXb2upfiIewMMAKt9
 UEkueBqUlk1SxwKDnv6A3KJ7TkRYSP4HkHMDzbLGVotFdIJp8KdVhTX.ni_DFJSWj84gpnfgj0KU
 uuMTMKNYWIffqY5TkrPSWNSopUQOo2wHUgma6tQGLN_iqwiyEbx22fk9AxMW8AcG_vU8ovR3tbh0
 9NOa7.vXx47I9jFAWzcrh1rxoMCfowwqAQ_uCAo7HnTYxeDmagYlZFrlHZAadyj5AMqVD5C34GpS
 dbqg5EN2r5mWBwBTIXxNS3ShP9KLRE9NMGKm6Aw5Opn72v2ZT93ZJd1vQKQ2ywq3R50KdwMuideX
 gWddKPy3k2p5CZwyx.KK9ccv8fcYFbfD4jhRtmC1YwnK9j9jZPuBOjytm30laQuO9MwibNCetZT3
 1_SoGDfXOBZ5MRc4ij5cuk_O0vPncFrLfjSQ6Nxk_I7o73r6PTDnu1a1_Wz5._qxuoj_GoBn9MrK
 ZDkSY8MfzmJTF_KwkI_u.CQBbo3NcCFlFUubtJ7F12K1HGKut6sgt9fq538P5gbjp7OSvohmoqMc
 ka5uwLXb87kscxceVmyAW6USSVhT5usbHw9.trUSn6_nn.yjFaT.2Vn_wISHW_uJRJFrerL_RtHl
 WALap968Z_WibQ.utVctbuyk9BCXRO8jZ7GD9stcX.mSvxjLL.1lofVvHCXN6Tmr3zk3f_Zupr5t
 319bbc1ie44aY3xL7tflYtsw4K6KkKYTmf5ERnTz2lm3EBdzXcYuAOPTcaOEoZVNTJa_pZGEGVQY
 wwU413d9Kd4nDL4abQajuYKG9nHvddnuKthAtI6Uoi3EnPg9zN66.VkmBDEt19XWPjy16ODwP2KF
 Rc5Jx1GQgHwyQDDCxlPh8e_JH3B_1Dc62FskVgnk_P.nP1KzuehndVgAraeFQmdbK1236wElxY88
 l8AAOvQ--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.ne1.yahoo.com with HTTP; Fri, 14 Feb 2020 12:41:01 +0000
Date:   Fri, 14 Feb 2020 12:40:59 +0000 (UTC)
From:   Aisha Gaddafi <aishagaddafi23477@aol.com>
Reply-To: gaddafia504@gmail.com
Message-ID: <1900379801.2997926.1581684059165@mail.yahoo.com>
Subject: Dear Friend,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1900379801.2997926.1581684059165.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15199 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:43.0) Gecko/20100101 Firefox/43.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Friend,

I came across your e-mail contact prior a private search while in need of 
your assistance. My name is Aisha  Gaddafi a single Mother and a Widow with 
three Children. I am the only biological Daughter of late Libyan President 
(Late Colonel Muammar Gaddafi).

I have investment funds worth Twenty Seven Million Five Hundred Thousand 
United State Dollar ($27.500.000.00 ) and i need a trusted investment 
Manager/Partner because of my current refugee status, however, I am 
interested in you for investment project assistance in your country, may be 
from there, we can build business relationship in the nearest future.

I am willing to negotiate investment/business profit sharing ratio with you 
base on the future investment earning profits.

If you are willing to handle this project on my behalf kindly reply urgent 
to enable me provide you more information about the investment funds.

Your Urgent Reply Will Be Appreciated.

Best Regards
Mrs Aisha Gaddafi
(gaddafia504@gmail.com)
