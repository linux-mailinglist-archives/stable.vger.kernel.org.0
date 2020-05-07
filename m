Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB6D1C87DB
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 13:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgEGLQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 07:16:01 -0400
Received: from sonic303-21.consmr.mail.ne1.yahoo.com ([66.163.188.147]:35049
        "EHLO sonic303-21.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726514AbgEGLQA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 07:16:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1588850159; bh=TYgdp/zNeW9P5rVjVpFopjba7a+Fm8hxyemx2bQVZd8=; h=Date:From:Reply-To:Subject:References:From:Subject; b=MqelGNtJCVzjE/+ycb5pigdhlqSaYKVR7ElyruoLuhSn3lWgOFGz3yZhkJvPUR3Vu882k85hWjwM7OOO5vWc2wizDh53yrvk25g55KdP0vHPjxSsGwWZPsyIJGwNr1UQiFmrpxAozQKyo5yhgDyLa+TW4dxCebZ4sQ9gVwjNHSKLVpHRAc9RqxIf4piexTFcGy4L/TJqD+K5M4w0f9JloMuX6qJ7qwh7+mZnlneRvemdfAvfOg5j4WYI0jBpUV7PiqavznD+CFki7DKWpdr8p72NRZqzAGFwx15kJ06aGI2FyobZfZebZ42qG+n1j9ErA3BGNeIgZPFw+kzUq7RiJQ==
X-YMail-OSG: 9XMnjMUVM1ldicnI9_eU7Xe3U8QV0k0qFQG.hVPR1VuRz5ZNT0eNFtuwDRK5l1C
 e4808l2plev1D2p1acew5TNKconFw7G80p1rXfCPhBTgI96.6Hq66SpZb1RHOj8irf0hvZ1SwaE0
 yJTavZKN.QCMCMpWuL1982HKkN5JDtbqMh2Va2rcs5t5u9zy6gSE.3y6E7B8TpCq6EgjLQ9ugGtc
 wCs9G.MdIOwP0BfElzpejYk8qzfPVSj7qdHYv0nDSp7W6I449Iwo2S.g1Q8uy4yy8aWmQUk_BXDu
 OJ9_OC0OdDnUSLd.Y7Ch11KCV.RL0sJC_gP8LL6ecPhYsU7k3QJ5mocdqYf3AwAZ_6GFl1tjPBkQ
 WJ0nxIIKq74Uto0ESFn_ngDbxK5a9F.pzyQvYX0P94VszqRgti8G4xltS0FB4VLOAVzUl.FlSYeO
 2PwT2xLXQMpQ_maQ3ISmBlZg4BiwGsG5yfX6dqAZzls9hHMP0iz6M42zPafjOBvTB50jFHiHXpvX
 xlq0VhBNXFf_w7JP756WY72zIuaCLbIwe57xbvrf8jytIBqTlMWNQqySlbC1xk6NwABJPs2mRJEh
 on9x3TdYUcDu2UOr7fmWPab1pH06jlMJ9j5AFfW8_zdXDQAazYznhQ.YPB8y1.zf49byICVx55.C
 6yErjkDjHVXEWFviVRiuDurx_4qZDlEASPz3VfjzW.QIYAMDWPwDfVBBolKJZRn29XtrYQFiqcBD
 i08dDwIZy9Y4IVZCax8LKnQaeUxTVgKGFkrEI719aNj3dy5vfxMHl5acCFnjvf6WBqE3hWVWGNeX
 p6NVgTmbCUni_Nb6ORHzQo0eV6Hw5XcANyCcXKCmdI3owKHAnP3jwbIs5tcbR8Clvt.E1D8VGAuS
 Ypq3cPFeZGP4hsUXkK_02DmLS0X9Zw.dmhLnNzb57X4ZJU8Espi7XTJh1P81FnvJljKcy2hGxvwO
 1pXI0DHC6PkADhvr.23wSjVZaJrURzQeubwBVUD.BFEfpAvYknN8EdsZjocNjQuvylvRLu10ACpd
 aurkD5_jiAWCl3N28nFvaMrnaaLB7Xn3DISXyt0hBsH5e0Y7WH_ZQE0ydrzmH4NZVGnopU_S4qVV
 a1pJG50FPEcaiejgN6MghuM8ijYpQElmmY7MM69sZlWe5rAoZTZvw5jTNSEf1BE.iZbSMgS6Ly5F
 9BsdIh0hW7B8N0OZ3BADzDQFii9MHjKE2HBdm3I7EKt8SFZV7c57P1yE9x59bylMWIcMcAWOB5M.
 U.v3KTL3p2ECNHNhkePgzRa2zU3KbpZFO_jnCmZ1Gil.RXFqC0EDUPvfvpxkPE_DUFdWsbOl1wyU
 lxh20vpgE7gL4pE1hkLVoDw7b6dTX5Hhg
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.ne1.yahoo.com with HTTP; Thu, 7 May 2020 11:15:59 +0000
Date:   Thu, 7 May 2020 11:15:59 +0000 (UTC)
From:   Mrs m compola <mmrsgrorvinte@gmail.com>
Reply-To: mcompola444@gmail.com
Message-ID: <742590058.2692410.1588850159186@mail.yahoo.com>
Subject: Dear Friend, My present internet connection is very slow in case
 you
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <742590058.2692410.1588850159186.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15756 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0
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
