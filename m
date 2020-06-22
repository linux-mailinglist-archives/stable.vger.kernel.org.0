Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD55203C30
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 18:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbgFVQHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 12:07:42 -0400
Received: from sonic308-9.consmr.mail.ne1.yahoo.com ([66.163.187.32]:35450
        "EHLO sonic308-9.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729229AbgFVQHm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 12:07:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1592842060; bh=cK2qy9Lv5SAgMg9nAvfVmkJPj46H3ss3vOVyjpHm6Nk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=B8Kwb0Y7onKrdQg/gDC3eTd/bgnbwoXfai6dsjD4BDyC5vlA1wJeGHSwyUVh7cHXDyS0gia9z2GCs+gbyN/NMjlHzB/TnHhm5NMghIqzUUY0mAKH01MVRzOuCduVcq9pdkQIoJQOqbNAdsdEZztaQV6BmDV8qVRDE59aNvQIcwTtzzAMWzTJ3nI+J5B/ACcZd1H02W8kC/gEmeeybVDYh2qL+uUvZXXbE4UNGY86zo7YUXdnHpYgqUYFvMWNhbOfcRKzYbZA7qE66UMxiCKW38NmZx+yk/G2kbFGyIRdcRLUZ4CdRvkVqnfvovF5hOqW1qpbN4tP2LYIimO3/HgFwg==
X-YMail-OSG: RondTvoVM1mzK2cLgb1s_bnHP7wXMwunXHKKKxejRf.pLGIBSZkqxszETHKfCyk
 Bcru782JIP5xqe7xUAaHjZ4e5AbOsr2znwUDrp4w4i67TMyo0FkgAjXWuwtfh8TvgYPJua19454Y
 c688jpxEp6CVV3AZ.0VVkMnfWIXZqwrySQGL7xEt949NdQetzBvtPl1ZahgZt_11RP6JdPkqbfVg
 M5nI2Cw7maG_bd4aDonoTPxlqN.K5_kVhHu4XmojBRfBpyf2g04Dg0Opgt8Oz7Nk2milxhAlCshU
 g5kCMbCt5wbzvMFr1c9QX.0PGw.KA7MV5TRzpI4tWqLXGF1tfqErI4wu3ZEbUdLVQANwRHqW7qYf
 iVMPb2w_vUFijaH0.U3g0acn0neWOjSkAKabSVeUCZFI5sP1v_IV34xE_DkzL68b2_wP4aelfO82
 ripNiCjlUtV04l9Plmg2bQcfzCnNI3StooYz5ZSQYB..57ak5dnsH2t8pc6lwcEL131m8qtOXeCE
 Nys4ntvsM1EECvGCiWAo2AuUyx1yWnl2oTqm_4ktCPPYFdE80dGb4ue.Q4oy6oK_M20kescYe.Hg
 uyrzJrRwTht6Vy7iOLUETrckyod98XoCbyDgAqyOfgHm92UHovvygDniknO1pOpOvpKdocjI5PTu
 gO9a9sOnzBj_5572aVxKYEDV6K9QvZ0EMNcJfuZKPFfDltdVA_FmU2Lqz4vQhomqEYNXib.Eadin
 aK5MAX7_6.iRtOzmrVoK45d2LKj5IUZBvHjBjj5SiLxRW0ssY4NImhb4o22Thzhtl0S070_B6SOe
 vfdAJ3nCJwiDmA86_oUXHMjwPxv6EETaZX_GX89LJStL1PaDAjxilWvjHpcwj8M2Agr1Z4opIPNz
 vz_Pz3MDmSDsSABsEPpCe5CArU.lVXsEwyHfNWGl7DREvmIP6eAvvRH5rZQ1raEW9nHOpef8MKhM
 o85RobaR28.gyexFfZcW_iuaPoqPRPDai2lgFnaBRJJuiTU2f8_syEPNHhFMhlxi6aGhGZEqPTTN
 _uojENg4mJQqb9GlqLAgkIQPsHsUFzGRyd5zv0Q7TaUVDdsEob2k24J8dkkzbBZD25ZHYjULZp3T
 hzFOdnTaumcfosejnVD6VvYIyrVuN6jOWzv.3AwYTbVglHV3sservsQ_pjiDlLiQzZ692PBPhicJ
 UgZVgAf5CRbBDhBj_Tkg5UXYzwy2Vs4Vmx5jtNz7L.541WYRZAPH0pVaL_7ipnexCo9qdUGs7_0X
 9zmchqGF8_OG8k8qa.AUBPVSoqxSuxD6UaxhE3_yy2k8dN1gubGYswEulDk3C
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Mon, 22 Jun 2020 16:07:40 +0000
Date:   Mon, 22 Jun 2020 16:07:39 +0000 (UTC)
From:   Karim Zakari <kariim1960z@gmail.com>
Reply-To: kzakari04@gmail.com
Message-ID: <330680018.1870360.1592842059497@mail.yahoo.com>
Subject: URGENT REPLY.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <330680018.1870360.1592842059497.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16138 YMailNodin Mozilla/5.0 (Windows NT 6.1; ) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.106 Safari/537.36
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
