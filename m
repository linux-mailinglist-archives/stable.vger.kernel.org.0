Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2966D293901
	for <lists+stable@lfdr.de>; Tue, 20 Oct 2020 12:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733233AbgJTKQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Oct 2020 06:16:20 -0400
Received: from sonic310-13.consmr.mail.bf2.yahoo.com ([74.6.135.123]:42372
        "EHLO sonic310-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733138AbgJTKQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Oct 2020 06:16:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603188976; bh=TCEah6dQDVULXjjJd0DMU7TiZ3f8rT/CjPbt58XpL8M=; h=Date:From:Reply-To:Subject:References:From:Subject; b=PfpONXYWtL+oAOdzqbgCvugXjnOS2NJwovv+2Qnzg4JfKKLZKBdzrJOwyEg6A4jUh0hvVYzQ4uGycxWzm4XAG3brMFoUTrmyOiSQM1pZKW09PRGUrrrQG5kXoANhS98v3FZ2JwxaulbEoSeLwxqJBYMZ9u9KFyth3dhYJUUP8cA8jDY96swuR6QOgvN2l6pc3zM7kNhf3PvtasNnpP3F7uQ+JgtqZVCsfSlAgitl+VzWEEgMdWPFPXCTJ5jYGyZ+9muD56dwvDBCNEXZ6WYXsKZX/Hu3y+8eIqqs4t51fD9gSNnpwStmim0GobuEuE0szTQ38MVgN2ze2I9h/9y8PQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603188976; bh=by0/52nA7fLnU1VHozylCDHZ/dc8OEywhnxYMb+I8yk=; h=Date:From:Subject; b=fVK5e4q3JEa45rpFy2+Kdn5FNYNuPmQGbfWSiIDMPFx42YENdyNto1XK38R+00FGyUoxz3OT81bYtrHjhy6ewrUD+sXcduPHXuENHEgZe/LdKMOq9egVGn//C1pCIJSYIUW0wgePUJ/5z7vqGTSSX/b4e1XBxyUcF6zSTgO3SHMFf8pU2Evyf6m86FultQjNk2ZZ94hPCr2kdangIe4kc6a/SSaQy0ri7UDt+0Pvf7WjD5svzfyFk7fr1wywhNRqYltAsc9EhP90vUkbS9A7uviVB98QYrglLWrPkm3CRn/bonmDrXHkdtbQJpWqFsGfB/JNqa4EzftZBGOYHijKgA==
X-YMail-OSG: 0ElJSt8VM1lUscE60xx_PX2wLuLczDbwXemNoAZhh3crFcbN3vsKXad1wQkWBMW
 97oANQUyji0PDAEG_6gu9H3X3J6m.cXSM3vI4jVFJDynJ3owR08PgMj6eZWE7geAgsAfY.tIJZCX
 MN6zPJWmpxpr9DW9Q_3.wWLjECq2h_yj53qmLJssh0POnsVUsT.LAN_Vs82Cng2rloLdEYwNCEyH
 YBg8XHSzbF5UPrn0t82K87_MmBG6okcVwT1_OAPmDC._sPyk_c3Sqwy97KvkWmm1u1wdRdbGmdQH
 a_jwh8ggHy5.CGgXb9Vl.CsNIJM1cXUkCjXr_XBdPaBW91vWbReiPEhOBk.L8qIKBFCPxs6XMxzK
 K.DO_ecYLihJ6kWlTqjlT_nGsQ4s6WxqQI2ljqKPVjavUjQt2eDH1MrTrsP_.pHkf2B5LzYb5xm0
 WFW1fsscgFr8Q7XzZW97yaOlCoDal_lwdf01yRGhTltL3PhEVJRtS36BgL.qGDqqIBY69zveHUYI
 hV5157Alm.7WEe.9plwRFKj7y8pl7TdqFtuV9RURl7CKo3AXA4DGoBSca.9QdHxz.E8UBZ8ibER1
 nkWrVg9LrBa1jh2ume3QXhMbnEyL5GRcNv24K5gmuMuQK.7dvRf2A8VWpe.8oHyKdt5_lO_YRO8Y
 IESfIpNrKv0YBge8TxpgJsWnG6q2V5Jo_O3hMoJDP7VIV.FqtHP.biNj6YNsGHGx3ciEX7o2ccDZ
 5OI52OrcB4g6QDrpO9SLTMLcxLiFcXHD.H_JzpujGH11hBLBmLWxKP.Ac3Lhr_KJDsFtFD49poDQ
 LDtu6782IvWBLtZDmB5FN7O9hEW3hiw4uQrtNNsHOAXWQA6Btt2p0m.8g_zsyO86Q7wJRHjRIKa_
 ETucw_vbLfMQUkmNJtb1.KG1IYmm57uFpPdI6xww0SLbOSFeeab4m2NVEWbD7BrpXoUTnVe4Z.cD
 WTFeVXN6acBfAmkF65UpMpgFpRgRx.mtFfJEK4JlnA3kMglYmaWKmGFWTZi4HDif1sSPxWAuEIpD
 lZD6ANjpZyKc7Aljkp_Bd.sSueymjIuc3tiWUM.55sbmjytSAVUdQyUpdV73PsMS6mh5.0.4RE6m
 _IzK2UgGTqbGNuO3PkYOLRvdO..TujmXni3hnzygpZXZfJ4Bm4TIbAMQNqMeDgvHldq18kYsv9zm
 KPzcSUtkzYiU5wSY5DnTH4FPaE.t2Kkte6u7ShezDSwP02yVVpqF7dicg_DFIQkhNGIg1s8IJG.v
 pDbyw5Ee5ncEaEZigokvaet3_lts6J9FMEHz8CGyMvyReGVTieFFmNjX3eyYc_jR2G74ugtnEW5V
 6f7fkOMan.2n4OdG.OtMhHq8ejqNZwksm0QAOCoJggomYrUzB9XznXYMq5zw_yDZ9_NjlD3WV4K0
 Vs4PogAklLTKqFaCwaV_xJ6jr0duIsNjYUhoxGwj5iTzqKGgGkjxI
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.bf2.yahoo.com with HTTP; Tue, 20 Oct 2020 10:16:16 +0000
Date:   Tue, 20 Oct 2020 10:16:12 +0000 (UTC)
From:   "Mr. Mohamed Musa" <mrmohamedmusa739@gmail.com>
Reply-To: mohamedmusa1962@gmail.com
Message-ID: <1293359925.1002018.1603188972759@mail.yahoo.com>
Subject: REPLY ME IMMEDIATELY
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1293359925.1002018.1603188972759.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16868 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.75 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Assalamu alaikum

My name is Mr. Mohamed Musa, I am a staff working with the Bank of Africa here in Ouagadougou,Burkina Faso.

I want you to help me in receiving the sum of Twenty Seven Million Two Hundred thousand Dollars ($27,200,000) into your Bank Account. This fund was deposited in the bank here by a foreign customer who died accidentally alongside with his entire family members many years ago.

Nobody had asked for this fund till now please contact me through my private email address: (mohamedmusa1962@gmail.com) for more details.

Mr. Mohamed Musa.
