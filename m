Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5CC22551C
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 02:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgGTA7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jul 2020 20:59:09 -0400
Received: from sonic315-21.consmr.mail.ne1.yahoo.com ([66.163.190.147]:46130
        "EHLO sonic315-21.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726699AbgGTA7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jul 2020 20:59:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1595206748; bh=cK2qy9Lv5SAgMg9nAvfVmkJPj46H3ss3vOVyjpHm6Nk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=orBUcPf9fTZ+OoUCjhils06UB+PCQkehs0tUuqWigA4tfJJdXXBI2cwLwZKGAE8JpWYTSnPscP3x3VKvyUCCZi1/n6KD9oaYf4wOY1bWQajp35Ojbz6eifSNINdMaA04aZbR6lndDx23Up/py279euygLwnoxB3dOlP/3z1wbP2tibdB8lfBqQeQGNQEEQJIHiXgTu+yVqWriXJCR0ho/TA2ABELymqbF9WeiB+W2JqM3yVQf/OpLvUaBAfs0n2Ezii5L8rr+DNFIFI5QKJDqogTqYHX5cBFlo6gT9ShS79KT0U02oAxF5aXdQZZEjl0Tl+isYLYpkRrlnRnxG3sCw==
X-YMail-OSG: n_OUd_IVM1kAs8C6veqIdIJ9O0yabusvX2kVbmiLYkZoIidaehtNerA3mpmgTcD
 DvoCGA3JkMZ1ddTSTDlHpqcAAPKxP9zOTX2AkCjj7NdyKi2cP.o6MYjEjG4HYIu4J4jFKz12Q2gi
 97yNlcrpefTmR6QhHABd1NIsPwbsPCZibvDAjUNWJbGU9wDPaoPhRNrBCJQTDUCRoSrqB67zKqD7
 y9wW4Apq4jW8Rl0BBcs8BNnKVHi2PKPbwI4NbXjhT5LVQKiwveMveszZctdHtPHd9aU4PZvRLRJE
 fW_EDq4uLTUByPOnZD3gO.yCAEkXLorgUlqBgTw6HMutS5YEnqA5xQzanhn_mmi8d19fI6hPnV3o
 m5dP8LkrOhUZD1eBWeT49tRR97WmjVPk00bzIk5ik4uL4LWY4gm_7c.1K4S8hoNz.2JkZSmdDSPu
 feAcVgtXDsXMrhkuJKrmSMX15g8L1D5ExC7YhIcTW7S2ghDnCxaY81GXVv4EqWdQlwqv6h.RQyfy
 kMaYBFXbl0qRYJbe.tfyBHSimOUvxc6NRlBuzYu0CyXB023lE3kwUfuOhhLHORVgl0x1o7lviB6S
 kvJgA7NcjcPx2ev1bXMk2AIuXxbaOhIVfY5vGcmEW9ttdjk3VAjjbVwab9c.K2DuNQyGebFpOEbU
 LC__.9yx8F_0FpqOat_YHcZGXtu.eDzhB.eCbaPPAdpUzKpfKHSaMrcWb5GyJpmARQ6XGb4WRyo4
 fFS8qG5a6ppC5_y0OvjnQWeIwJ4yAk36H0TysvAOOH49Swz52wok3OcMBaZwL9MEFLvL6OmBLn45
 MUpapElt78FFzPw7ASnWSQOjzuT1s0yQqPfLKbpMO39RgvSpBCC.v8KLQ2uVxYL_lrs.sJsrHJxU
 kl3mDGs7KFFUaxoaje1js2PXe2SlQ_wVnnoD_iT6xFEMBfJNL0ivtJA6TMp85mdVSkyrXDCOrB7.
 KaPc0oFFYaXER0q2f3fahgOG_jIQ_k52vnhj5xSFzx8jgdC5C7fhgLEcUT9Dg0S.Qx97LQdKqMSK
 com1wPuTlHd1.3RE3UBDymp3sWkiiv19NShdC0Me.mzA__VuxuMs2krm4QR95xnXS.1L2yR_0xkL
 boP9d3dtr3QUTJr9t3IpbHXUY5HZroCtGv.C4r05Gm9s3Ur0kJrJj_1.fx1NNr9cblcWjr7QiG0r
 F2e2dJaT2M5lyInrv6NGH3NBXCHPBCcz36C1zpnN7IPj_A4VNYJXdK4.IHFFWqJaYrLwoYSe4iUZ
 cphjE6ILmoZ4CX4aJhnu6dAKRulOpX.oVWxC_NhaFwvGvoTL2D3xmjdj1aiq20vulR_yc7pWW
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.ne1.yahoo.com with HTTP; Mon, 20 Jul 2020 00:59:08 +0000
Date:   Mon, 20 Jul 2020 00:59:07 +0000 (UTC)
From:   Karim Zakari <kariim1960z@gmail.com>
Reply-To: kzakari04@gmail.com
Message-ID: <398505926.4060905.1595206747209@mail.yahoo.com>
Subject: URGENT REPLY.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <398505926.4060905.1595206747209.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16271 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Good-Day Friend,

 Hope you are doing great Today. I have a proposed business deal worthy (US$16.5 Million Dollars) that will benefit both parties. This is legitimate' legal and your personality will not be compromised.

Waiting for your response for more details, As you are willing to execute this business opportunity with me.

Sincerely Yours,
Mr. Karim Zakari.
