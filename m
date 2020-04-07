Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBE51A09AE
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 11:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgDGJBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 05:01:41 -0400
Received: from sonic303-1.consmr.mail.bf2.yahoo.com ([74.6.131.40]:46857 "EHLO
        sonic303-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726353AbgDGJBl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 05:01:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1586250100; bh=SGvvhU2UWXzbg2f9vxSHyVOB5gxWkye3IYlpV46W7BM=; h=Date:From:Reply-To:Subject:References:From:Subject; b=S+v/0QFy/687WTaIbOIBT96q0//KKIsUfi6PuEv7ajKYAAGVSgcivCvLOA2ZDNggop+cITWm0mJ+7AM563svniAEuh+2wZodZrisI1ZH45pwck0oQQs3gYe7Nw+5RKZ05alS7dHPy9nDW1B5RzKjBGb/+VPA1LYwQTEDcEsKAVLGaufU7B3zK2Kv/8TNQTBBSNSHV9UfnWC/opr+11eKM0sFLCysf3HRXFjHqWbUS24hX2me2GGSG1ZkGxR2tprKA2pWDh6hCTrxAy2BF4/zOPhqJ60jQLHE7g6W6+BlwCb76/HRiSx9MnhifgwZf51os32kDNhNHgTu7IZDhDHh6Q==
X-YMail-OSG: EJbC_SkVM1mS.rNOpYOLWnd4hVAnQO5fXeZDKgPpJSKEdJ0i3iEd4yZSnkyPpp4
 M91neVF917PDMPqkQ.Gh4HVTFeTK1vTychXyGD1SZrbnygJForajmo.b6jde5JBHqOOPljNjGZ7E
 hw9iMz.dQmx8E74wGYV.dOuGa1sCRv_Sihtym.BEl144GysP7OJaqSskwhydrMcIELdli1cnLn9t
 SrjUHi5t6BPsZF_H__B62_IfwLZKKhYwl4y2vkVehwB3f9GLc58svFhu7_yVkFD5KybSGwre_RKh
 LT8BAp1EyWPlEwGubFItw531qEmPSM29hKa.RWL4Qat4KckHUhbpj5cmdQyAJ2AFXCn4oLwconQM
 lc_XCU32impMRSyY4SLJfJPRbrrrmcuilKGQOCI4wv98_O8dG7oqefnouCVzLn.8BQ2.H..GhDD8
 6vjk9XXiqcP1Juv9asqfD39XSOS6QUk.Mnv5mKFpOImi0AcxChvqdBrbjhfvMV4pxEI.m.OdhWam
 OLn.E1RVa6TJ3qcm09_JW_g3GtIItCZ3aiQx.4gnOaLS2sGvsMlixXc2ldonaKDed_Cp3uSXRjlB
 kxroxI1Is7SNm.CpT_nKyhWqKXbFW_dmBVvF8iIfym_i_r23jBEn65RfFwu2a5pp5ykZUBx2DpPw
 2K8skbIyCPbzronrOQMDLYYEj4Mv0J6teigULOi3o7UwE2d587rVYaKyYFHBf1Z7W316Jv2eiq1z
 xHkfAZLOJUgMV6v3PzXrYQGMhIYDw.J8IeqUd_kQYfrevDcogIDDeQLLiEt9WrsbwwBnYuJ.c.CF
 uAUnZAy6C8MWjx3eSspgCWbtQuW6ThAkq18RVhIKfhmveyd8QqgSnpEmd6LIJ1xh1iMzywhbGyIw
 FVj1h3MRX3dJDUBSTfeC7BoTeb.QTc0F6Sz.9rCl92Zyu2vfew6A.STI16FWmd1XItSHMHgjhPxe
 _mWax2LtA1yXM2bbfp0PbpQqFOt.xhlxg2bPL6vvoXwi5O3MkzmC4D2Wbm8MPxZH6HdW8TpFqdSZ
 gCFKjw.sYAVaLMVvkkvfsSo7dacEVzhDc28vhC55kreHfviPtkUYhCTdWEULqsv_nl2w4eN.LL0.
 yvYlDeaAnwOIY4OUFDhlDoSykI1zTQtK8lyz8exPqlXiql1d9V2x0o3iO_SrqhDeFdwifVasYMTf
 TxLSlZucMgggJaGJNrHRii5Ht0xDmWUOyZiQWOglt8CKp9ThrEZgbQMypJxt0rfCbGYUSWE0pIlD
 flZ0Lac8rfR6qhoFtYoQXEsWr_4pnj7peCWCEue7.yrAed9CifmWYH6sPapQ.
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.bf2.yahoo.com with HTTP; Tue, 7 Apr 2020 09:01:40 +0000
Date:   Tue, 7 Apr 2020 09:01:38 +0000 (UTC)
From:   Mrs Aisha Al-Qaddafi <ah6149133@gmail.com>
Reply-To: aishaqaddafi01@gmail.com
Message-ID: <294481577.1193490.1586250098805@mail.yahoo.com>
Subject: Dear I Need An Investment Partner
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <294481577.1193490.1586250098805.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15620 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Assalamu Alaikum Wa Rahmatullahi Wa Barakatuh

Dear Friend,

I came across your e-mail contact prior a private search while in need of your assistance. I am Aisha Al-Qaddafi, the only biological Daughter of Former President of Libya Col. Muammar Al-Qaddafi. Am a single Mother and a Widow with three Children.

I have investment funds worth Twenty Seven Million Five Hundred Thousand United State Dollar ($27.500.000.00 ) and i need a trusted investment Manager/Partner because of my current refugee status, however, I am interested in you for investment project assistance in your country, may be from there, we can build business relationship in the nearest future.

I am willing to negotiate investment/business profit sharing ratio with you base on the future investment earning profits.

If you are willing to handle this project on my behalf kindly reply urgent to enable me provide you more information about the investment funds.

Your Urgent Reply Will Be Appreciated

Best Regards
Mrs Aisha Al-Qaddafi
