Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7A9B56B4
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 22:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbfIQUJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 16:09:46 -0400
Received: from sonic311-14.consmr.mail.bf2.yahoo.com ([74.6.131.124]:44571
        "EHLO sonic311-14.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726404AbfIQUJq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Sep 2019 16:09:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1568750984; bh=zPC9p8T5S06DA73PD5F75wViZ/EpBpeYylTS7OqjCU4=; h=Date:From:Reply-To:Subject:From:Subject; b=NaXpheSwXMKmcwRzgSXJmUdYilChewQp/K4B0rBgxYtVJypEXq+0atsXlcdIauWWcn52FI30r6F9rJWBMfrga+woGN9fL9wVv/vBlbVK6k5KioTrNO7MHwPLWDym61wxp6Y7eEND6QrOP3QHERYueuD8of3G4tzo/ZpA5kd+pZvINmiTnBJivCV2/3ZMcIna+Vpa39CiPACPbHJX1zUwWECATsfOzAFm3ZkS8gxZDSFgxhFVVvovifmN0B3bbd2+z9oKfYwNImTflJCCm+nZqWJP47Ob+okNDnzGvc5i2r8lFZ2ETAcjsxmpFfusU9d9WYT6qnyXSGhM3yhAn5zM5A==
X-YMail-OSG: roMQr9UVM1keC6uahDtjgY109R4UODMxCKlNVYJzo61V39Xwh0BtS1fFKisPqRK
 wDaMzbnL.F7oQBQq7Rj.hixL8j7EJYHpQyxXGcLmb4fDgw011a.M2n8lFZZSynBs7L8rQnShOYLX
 eFBzRM.GTYvb843009JY4ZHt_F9bcZ9OnDG0MkajrmtApKYg04U5gdAYxprKvjyMLLvdPOcL4q5r
 viJZTp4sZnw4I0.ltrpygUNI.XMVmQLu0saLYVXSrfeL1IEWr5PhVhdfEpIBujU26obUI8xmGtWM
 cZh99zTFp27QCgy6YaGLZtQBi.yFW5GBR5KGV82LrtibAB2WLFR65olTn1csh26GaXd13XkmPv5o
 BJ8ZPnt0Xv0oaJhYc1qqNHmg8dYUsoo8PW.O5KabJpBQLquYlyNVLrX5ZtRTnppn4E06SqGmlARa
 1BK4LsYIAHyCjXj0FnXp2Vny0p4eQ7r1EzSSdIjgKxDpZ4wmbl8vPtBmUbyle6AjqFjEsHaofYCm
 XaPHoPENN_R08MoRR4R_vAdW7Rm0nySBuXKrKx0fYROYfYkXAHGpWu728iO2GdUZwhUJF0fzE3M0
 7U_xfaVtB7vKuHn93fNP8yk.XVnMwAl2u4gOxIQoRylDEOUU5ACuIuVDLd56Ycj6B2LD7_9GFT8K
 thvzmIJIQq30sV4n2PtLy.BqBkhzF1wclqpMzly8550ThVwPmbHgz4zJOByXV1uwuZacVsoDTjfr
 pigiwWvie.65iD7YwiCewME21cpZ2GOjLi3_Pesepa8D5JGz7UEMq5NxXzGUkaqySPas095umPWb
 7OJI31E6cvKI2k5b6mrZun30g9yGVvgIR9BOeP0LTJB5YhPj0taAo0xgeX9n90NO8bDM11Hzy7f5
 gi48fv0f0ALzgCyppTfXzJluJiNn564YePtMgDWxTK1EJqeqcpJJNFok5p596yIaMsVwYBqDYY4_
 J5vVU8SMLw1ZeKGncjfr_nFG1qBejVpfpVJEmRxg2dSrKXhXAkd55Fnu_n2k.PTwE_ZMcTCBUygx
 _DbiIIxCAUVS3Gqq67b3Rn2JYi89V4DcFI9XF46K4rC3j8MBNoH8OV5r0o2FBIILT0ufHJXw1Y8l
 eatv6AYUjHWyc.xUMcqBcfxIa.0OqmroJ1hc5yy6C_FscRN6_EF3gWSQH9GMtJSbGGBGmdVPwTt9
 PE.6OquYwUwkKlWtLOS3G7QDmEy1NnD6CqTz8ph0_Nn4WlyLOBLP4_TNWMS17rcnZfBmPonZCROb
 tivUaW7AavlPeA1rNbfFcrZ7.3N4VvQ--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.bf2.yahoo.com with HTTP; Tue, 17 Sep 2019 20:09:44 +0000
Date:   Tue, 17 Sep 2019 20:09:40 +0000 (UTC)
From:   Ms Lisa Hugh <lisa.hugh101@gmail.com>
Reply-To: ms.lisahugh000@gmail.com
Message-ID: <359899449.5899392.1568750980803@mail.yahoo.com>
Subject: CONFIDENTIAL FROM MS LISA HUGH(BUSINESS)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear Friend,

I am Ms Lisa Hugh work with the department of Audit and accounting manager here in the Bank(B.O.A).

Please i need your assistance for the transferring of thIs fund to your bank account for both of us benefit for life time investment, amount (US$4.5M DOLLARS).

I have every inquiry details to make the bank believe you and release the fund in within 5 banking working days with your full co-operation with me forsuccess.

Note/ 50% for you why 50% for me after success of the transfer to your bank
account.

Below information is what i need from you so will can be reaching each
other

1)Full name ...
2)Private telephone number...
3)Age...
4)Nationality...
5)Occupation ...


Thanks.

Ms Lisa Hugh
