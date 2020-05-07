Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3A71C9EA8
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 00:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgEGWtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 18:49:21 -0400
Received: from sonic306-22.consmr.mail.ne1.yahoo.com ([66.163.189.84]:34786
        "EHLO sonic306-22.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726515AbgEGWtU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 18:49:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1588891759; bh=SGvvhU2UWXzbg2f9vxSHyVOB5gxWkye3IYlpV46W7BM=; h=Date:From:Reply-To:Subject:References:From:Subject; b=mIao2HGQOrbWuHEMM0ZJxGcYwpETQAaYMQuxxzbTqdplrdDqwd4NLRT4HqxTU2ENSwuubO1MnFafFpB8qbhdxjPyFRfesfZS+E8YZyQO/nNqm5YAiJGFwDZ5xlcwJ9c+esrMP4k4RCLqAK2reJ1mK32JGjJ2hgshw2tgsNp1gfm0voeKYApETzXSGRg034QRQfQPLHI/H2p90EmJZuXuQrR7CBjo2HyY5eXfHajZKHN8pGv/ZxVmVh1v1EvH4MB7KA7MqXb2N02lTHOMxCvS237tYn772Nesaj9TBOoVoIMaZh3w/LLozFDJf+fCnx7UxZewyxV8pJ41EshW4hBFXA==
X-YMail-OSG: Lv_qPKIVM1msqGQr.6wQLXAq2tjUvYOthGV.4cruywwZX6SWzuU0l5eu6..kgHO
 c_48LPr5S0eQzDHUZrOkUDsL7DGTCBxQcfhwo_omBe8gYSlNP16hU9jO7_UTevEjswNAKQwjIwnf
 uiooxc2UcpJcuK_zXaqqpbVOC24YyfbXZh3kiNXARPqGOfCQ9zs3bTgkroggup.8zr2lVlhO_W7Q
 bHspgPE0tDUeVLFvck63YbRnOo5LS55_gONY_JV7Qe.KH3kVMBdwx19F1DWOmJfTufS3ieLhxOkP
 xg0P2u2MvQT8Os.2C.ajxwJUrW8IfOEXjaRGLjf7QoHyjCozEbmgyqLwb9NzFyWYyrXjbc4Ys7hU
 7fMMLzS27p_bMgKoAy9prnC898.4cDXF_hI55jcH6xl70zCSPccW9jnyje5IKTkHqr2SvjumGFGE
 Pojkdfjg9M4U1WeLS4ICY.aKVwuQyLQjjVMSKBNMQ4KNONkeN74JhiuaSAdNTLjUH5ZkorfFEi8R
 qBAOPohWVf4D5eyR8ZROtrgXbK30n9yOpXck5I.3j38vfWPkF1fRef0Is2ToVR1v7b2mK6qlPx.e
 yLUZd0x6QBI_YVgmieJJHEC1Su6qckm_YTclBeXf3D2dthpYirn.rpUpBvXECbVPVsfvEBobSWTT
 gr8_16z8vNZh1BKK1ZeGQxdipE.BpwjAqIaI44_tHpRwTY8JVlhgacstFrIxVBObcCaxGeIQyz8s
 HVI1xeVEaNyQ58z5UJkdFczCSlzFQUhbzCyxJBQl.w1ATfKKm4OP79LQEASFOfxlihm3LgrQmzfk
 d.eh3PVlS1J9WtsqbRat9cmuvjfBwxEUSjKqxwNzctItyI7mQt754IzFvcPAJ8mtNztCS0y4R_yx
 hXVXQHoHq8PBGu71DM38ynLkUtL63zplrq2NbKT1q_rUpOFUMVzZayhobCtw2yUQKcduNq4FEgFs
 OokzOjIUVQ_I7IZF2O3SDd15s0oztJV9.duiqMKWSJuCSJnV0Mht1T9Q1o7Fzs_9GZbq9mDEjuAn
 6io6Rkx2WwXIMvoDWMUD3osSq5KY9GIFhrU_PGKu6YmLRT_2mWP8NzZYaeGGY.MlSrf5WKMYUzTo
 Umz_6Bg_U9C8HLbQCLJXg.yrzkhDufYmMwVqWpRrSidx2A8IbCGciRTZ1KgTUgKJrVh83d2m7kxG
 iavsCHfe8r0DPMEsOKpqorlXuLquYQzIVzGN..khcrdJGY0gtPLfQjyz7VvtLLZmVinTiVHB91fz
 Yred370mne4tV9Pt8YK1kTg8nxOcrTpw9psAmdb9xImmBtutb85Rdds3HtlItKjhp
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Thu, 7 May 2020 22:49:19 +0000
Date:   Thu, 7 May 2020 22:49:16 +0000 (UTC)
From:   Mrs Aisha Al-Qaddafi <ah1195485@gmail.com>
Reply-To: aishaqaddafi01@gmail.com
Message-ID: <145084380.3116125.1588891756464@mail.yahoo.com>
Subject: Dear I Need An Investment Partner
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <145084380.3116125.1588891756464.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15756 YMailNodin Mozilla/5.0 (Windows NT 6.1; ) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36
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
