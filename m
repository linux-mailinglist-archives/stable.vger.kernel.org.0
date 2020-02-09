Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9CF156AE5
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 15:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbgBIOzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 09:55:00 -0500
Received: from sonic313-56.consmr.mail.ne1.yahoo.com ([66.163.185.31]:45894
        "EHLO sonic313-56.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727514AbgBIOzA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 09:55:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1581260099; bh=zI0m+DRhZDm01EKX+YHsQU600DuE8AwybL7Vu4lblwE=; h=Date:From:Reply-To:Subject:References:From:Subject; b=Cw0DyaNDxMHzLkgPfJZrsTpqn4XedV/97YGPrUzn9+sujTFfjlmwwkx8N1gEKueqQCMs0SnhnDCY5xdX4dsW4XUUGA6qmmwBv4oLmdxLs8sFOFSiocxEIQMtP9oAgJVUnpvLZo0lyqS13VM5eUMP1W3o8VFlYMoPY/zeCzEZlpdMPA4bxwb/yfxN1nFHpF0RQcXwvtH1/A0E0TuuW/S8zVjFvBQSHEaAO4EInRxlOd5XZecSJnoXBD1RddgUr2TWJ52MuXWLmp+2lpp9Sj3C0VEf4Tq2EmgakcvE43wsOliVJO/ZUChKj+LmrDZWxGwBXiEe3LvWENOnwsGF7pRs8Q==
X-YMail-OSG: D4L5ZUMVM1kX7aAvejykAM_f3zf6qOm87XuPkjFYgBtgHAGcdmaaW4q74J5dX1.
 dneaTfUgQ5BLMvMjdPki7hgU.djaAGcCPj5FfiXX19TSSFsDzrA7kABN70Pt2jzo6kuz05oIW7ZC
 Aycuf_Fet9NpMPEZ61k9I.3oWcr3yICBweaReOeao3RFSrYCqovx_4mP.VdvMnBlQl2QwZTp0dX7
 1BFBDHMIlio9_9slEHct19Jc6CYBeM.Tcd3TTSw23_.pdZooH.M2PkL56coEKG2_A60b.hI0EyoM
 2IhMpp1.SOMpSGy6uSLq0FWufKUbd81lon3C69t8Y9UvS9ixDVfxane4Luad4syjfwFC3wtvFpfm
 Dcs1ZL0rHM.UpGn6GKb_gDm3ezs4HhXI6Oe9JNShKN4kbQXTH8xxqDrk8KRzealmQZ_17L7mqGMQ
 HdHtc6kF1Uvb2l8MLdBnfy1PfHUdvHCvfK19KDuU3bVmhhGTpvFML6lJoVxAPYLNpe.Jgm0171fR
 hextr8_OZorS.1OOaB83XuU5VUalvM8Frxx58gg.Ly2qfzGSprFrFH0INAfZO8T0ZVpNpTdmyrvf
 4AClrrZeK8Ua9syieYZEBeND.Avjn.q0rxsW6P5fgHju_HRD8n4wi61w4GLvRXaQSfkJ4cFkO4ab
 MflqSfaED0A94kVNRrUacJXxMEZZfJTEtqsRSTZt5uN4PWR8NXVseJqq7gOBEd8q2S6NRpnMFtSn
 FcJ6Z_FZGQx5KhWKQWkRu0.IC_KQA3hJpW2FDUx_wiLV9e2nmvXlflyYWqYRU638zTInGQi8Ri9K
 kRKK2R8T1z29aFCqBhkIPgkXmwW55pMdQO1k0EVlTRbXlapdTmszwaq9xcZfb56itF3gofjzAeUo
 8FSMX3oI6eIwP9_OujqtSFUsi9iuXrhoCVGgwiKNd7pZ6yhrdiwcRz38vx4JcBkK80FSjLbKUi1F
 e6xWTclCyQMzfeeyhfbfTK6zhGkEj5XWK0gNVXdxRo.m8ypKS9PW2zuGp2CXgLh5bsc9iwwikJIv
 lsTNg3U5mdy1fWe7QYf5pwXujuvJSXOgxSItKBFfLqGQ5dcl3lYt1moXHHOLFFmNEwdS_yOq8ZzL
 qL.o8ZVYQwH4P15uoDdSKTZ.TjqWxsfmqtP_rN.fzeftfIC_SryVXsKCFRjfvCoAYr2d8PN9R2_Z
 OsXkvH4JRpuvwt2MauPQDAhROLZoZHLqmkXQ4X4skhMKMQldfGHaI0Mw1TTguxIu9uqULAdgKOBA
 TRcvQ9xZoDB_q6d8wZC.Rblmw9RKd104d_rVdgNEiaP3P8R6brjPFdvqfBQ2iZtzNRHrlk_un0uC
 W7mucuQ--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Sun, 9 Feb 2020 14:54:59 +0000
Date:   Sun, 9 Feb 2020 14:54:58 +0000 (UTC)
From:   Lisa Williams <wlisa2633@gmail.com>
Reply-To: lisawilam@yahoo.com
Message-ID: <1424333018.423971.1581260098616@mail.yahoo.com>
Subject: Hi Dear
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1424333018.423971.1581260098616.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15199 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:72.0) Gecko/20100101 Firefox/72.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Hi Dear,

 How are you doing hope you are fine and OK?

I was just going through the Internet search when I found your email address, I want to make a new and special friend, so I decided to contact you to see how we can make it work out if we can. Please I wish you will have the desire with me so that we can get to know each other better and see what happens in future.

My name is Lisa Williams, I am an American, but presently I live in the UK, I will be glad to see your reply for us to know each other better to exchange pictures and details about us.

Yours
Lisa
