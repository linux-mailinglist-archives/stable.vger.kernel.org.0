Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBD629212D
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 04:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbgJSCl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 22:41:58 -0400
Received: from sonic302-1.consmr.mail.bf2.yahoo.com ([74.6.135.40]:46089 "EHLO
        sonic302-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728791AbgJSCl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Oct 2020 22:41:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.fr; s=a2048; t=1603075317; bh=RV9b3GJwjis4/CDAG9mHYbV/aXM/Sg4ZZGyU3uaGq1c=; h=Date:From:Reply-To:Subject:References:From:Subject; b=S2Ja3XT+cL8s1x9/P4oRPUYcpm6Ze/cDFksfrCjyWolN6mbC/dVSzlBoic9FrEnemtstQLWGi/SYDVNaQ/jRlL7NCdsCriphtA3JSnGDsE9A8mDU3AjT5N1C8PCiS5k+BJupfI++MdvKi13G8RpPSoaDSezFgAWtdAjiIvb9/K3hcQXM1xCG7vuCZGIletc+91n4EHJ9u5F6PaFdcbhuTbq5euX0qlq3xxi9yDxPg6zLX7hkDfQ0lEJSOjKUzNefgMJTWILaUYzO/4uizIbWeiuVpsJeHF19OURa+zcVOc3PhNa2+oazTKTrvaK+2rhB9wwPL5FirxU7USMzNU2nCA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.fr; s=a2048; t=1603075317; bh=8cziatw4PuWt/Th26wDE2uCGddsY4Sochkcek98dJbT=; h=Date:From:Subject; b=KGT9OoO6lsJoiPAM9uZGGF9rd62VlHgpIawd0fy0teooXQ3k2VgYx7WZVdDRyENn5IUxVdnrBdxFOk9WSN+avoQ4s82M6dw/rvP/hVJF2Lz6jfSbzJzgzt33ICYJonoPs4aWknrrHvmh1GC+G8j7KPypH47Jg0eGGLkAIzL05a1dC8rdHDFF7xq1VK3hNIjsMc75/MH6Ra8HEL7LcME74NjSlNoDtxTksB7zGGV6IIRZ45M3g//gh7UyU8n7sKR85zI50d12ELkFummKMugbzJvERcfikiWHcqnxTJwt2/kMhdVfguR2KNxrcMUh+lCZSVWyJBiijCmHInDFUINPcg==
X-YMail-OSG: pqjnpnQVM1mJ1fd_gR3NG.PfYMI.i1Hgr5ODcq1S1bRQ2L1PKRFvn4zceMm664E
 htAxJdb5bJhOx4PVU2A_Pe4_YQrXDn3HeAx5aD0UqIu133PMHlzOo5pFetsnZ9_2Ze1FjuVDk_sI
 G.eeDZMuPKVi0DmBcEwcLf5NE77Z3mHXPORJlSstMYNazLRixXAXCgVlMHttN_cGvy2LaNmQeb4T
 Wf5k9DrAUetMN19vLKC6moUIN.sJfZXzJIFI7WCUi5X7cnze54F5OuS39U8ul8f676UXn5c_c7d_
 8CaVtaqmYxiHM5ieDLciSgdkilrP_LZCLm47TdV2h51nl6gF_CbGNQ59_HNAgLejIyG6r20epnWa
 P5xfe3_oUvUFEHOyLJtdjoIX24tt6dsJgP1mtzpXOcdnRRVCvIugRSarYtxuedUN0UCS2X_4z1ZX
 SryoXje2pN.jFM8lQ8S3ZkYTpDSdxG7_I7_Sav6A.8ErXGCffZOXiNy_Lczp_o75O9k5eagHSLEn
 rRjAYY.5vtsysvoApW21NqLk1V5AL.I5ymNeu2UkLw_kBCHxguZ7J7EXfRPfRZrd5drGSvMruOIn
 GIHsMMoBZM7RPUeqH4Y5yG.SELazhgsXLyAPrFftX9rNjsuC803b5WaRQzVC8mrZDnSqR_rY6roC
 NMKSdEM3KrBc6.Qcv6tqRulmLB041.wiRB0DZSZqpbwvWCwYzmlrYZwGlGtwU.N5S6tLhj6r72Pi
 mJjg94JEfp7F.duPc5kYPuCLCUsht3RCqNbzrIFSU8DekYk.Tfo1R5yEhsahF0b63ziVWCcmdRA9
 xLeF69fDoUxib3OSrQmKC2M1LiNMlFn_Hg2GA2AwoPrBD3AWs9XYGF4nvBwxJRbfEe.0ZpmiGamF
 WM49.kQgGF61U_xbkJAwtHmYeWQQg48s9FiC0B8iaDBkGw9v.y1HZGi9EFqxbob15oHOhxI_95EF
 5KAARZKZZtTrE_nlT9VW9kVMlXNGEAD2TkL4VhQkl4.YMy6XZesf1yWEKhDu9MVSEk18iQwriZu2
 KZe5jWRLEqQ8Na.KmxGr1GkfTonKkl4tMqJ5TjiULq_84H0NAeKhMCYQb7RWcCjzLud8kDfdyo5s
 OWtC5nzRLkpXc2dkIyIP746h6Uao20lou_rCwfOiBDTUidiplCEq6QgocKP6KTOJDTSRx0c.jZa9
 8JZNeoqeVbrfiR6rD6ou2.s1Y5v_hyGOUvNDyuQq8jDDUCt54zsP3_9hQ3D94YAPPUqQ56fPJJBq
 LkCkBw2YBultdh_L1t4mDSrmzac9XYRwWF3P8hpuCt.i5lc52sdmWzNdDBQz7Q24w85PcHlzTv7Y
 jY2xycsClfW2ANrIo0h7amXfPGMK1y4ZD44B1fQxhDPnEJqTMBa.nXCjr7dIRJ2pJuEDEW5Hj_FV
 Hdr1TftuBdmPCXycYDmZBIT6k9I96ml9KI1VZZ7Tc
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.bf2.yahoo.com with HTTP; Mon, 19 Oct 2020 02:41:57 +0000
Date:   Mon, 19 Oct 2020 02:41:53 +0000 (UTC)
From:   Mrs Ruth Kipkalya <ruthkipkalya0001@aol.fr>
Reply-To: ruthkipkalya@mail.com
Message-ID: <1261436599.581058.1603075313809@mail.yahoo.com>
Subject: FROM: MRS  RUTH KIPKALYA,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1261436599.581058.1603075313809.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16868 YMailNodin Mozilla/5.0 (Windows NT 6.1; WOW64; rv:47.0) Gecko/20100101 Firefox/47.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

FROM: MRS  RUTH KIPKALYA,

This message might meet you in utmost surprise. However, it's just my urgent need for foreign partner that made me to contact you for this 

 
I am a banker by profession in Burkina-Faso, West Africa and currently
holding the post of manager in account and auditing department in our bank. I have the opportunity of transferring the left over funds ($ 10.5Million Dollars) to your account

Let me know;
1. Can you handle this project?
2. Can I give you this trust?

If Yes Then Send Me Your Informations;

1.Your Complete Name...
2.Your Country.......
3.Your Occupation...
4.Your Age.
5.Your Identification.
6.Tel/Mobile Numbers;

Looking forward to your urgent response, thanks for your co-operation. 
NOTE: If You Receive This Message in Your Junk or Spam Its Due To Your Internet Provider.
Thankings

Mrs Ruth Kipkalya
