Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0B30128EA5
	for <lists+stable@lfdr.de>; Sun, 22 Dec 2019 16:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbfLVPdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Dec 2019 10:33:20 -0500
Received: from sonic315-13.consmr.mail.bf2.yahoo.com ([74.6.134.123]:46271
        "EHLO sonic315-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725852AbfLVPdU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Dec 2019 10:33:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1577028799; bh=xrje189WLKki2NTFyBo4ly20J41zowdV6CGcREfeFLA=; h=Date:From:Reply-To:Subject:References:From:Subject; b=R+IPZl5aBq3Gcm1atnWxsz5dRM9R0W8ZEqddHLA+LlC8MJw0nIS3jwTI5SmGuodE45di0syP98x2P8Gv6QNVOU9l3g09UvBYvW+o+v5KEZq7dNqSvfDyjSUyHrcr5pWxernzfoSE8ddcRo2m0koYNgUl42/1eQx9+YLL2kP3okWgsAqNHAcd83RZTXzDr6ULvvIRiNWVkeRfViyiz2M/qomzSJWHjlZQk3J/XLTnJp5nmhRMd2yhg4fzu6mMo3LBabEIUihsWjuW1jU2ey7CwvIw2qxj5i9nesQ+wwzfZDkMPi8zBCdj9tE+uM1KyzaWsy4npshgqnhDR9Q6DuH5iA==
X-YMail-OSG: ER3YEXYVM1kQONhHoXG.8Yts41l3MV59ibA0CJopZ31vOmv7F0sht6ndU6xc7j9
 41.53Vi2SQk4yQY8HTaFVF7ksBhC2_opZo7QvM1aT77k_J.GCnb5OjA_efVTjq200RGjD7oPd6I2
 QU3UbfzIeul3vyakRrd3SSwoUvTzlSjqBeIShIZ8xBz23BV8RS3mCDHMtzQAoz2ukGT63SFAOP6j
 Cc7Jbd8Ya0efuqSWMFJluyjEAhZobvJ9Tjsxe7Q5z0Do3QBdsDlhmHCVyYkcdXlO13ccRRTF0TeX
 6Ue45MFktdicyZqUPkFvLFIMygv28yDZPPSWP195ZBmpFSu4RS_wvkO50ob3PLFvjFVyTpQugtSb
 cJWy5z8JIxH6LI02AjGZJemtYllqM.o33.bYHwfIVcEwLdf0Y3H7ZY6IA_YyAs6pB9vcNHHNhjWo
 LCxDTadzODqeDxDt9MJttRBe70mFgUlCUS4R_qPl8w9uXNrvKJKNQhd6H0Le2niNb9wPMkCLe7du
 JhRjKEoHT_ObudEbsjLbuqN_ze0q6gGMzJ.JDY65axVCiuu9BJ.COBqsJyE8VsrW2wxEwvhG4hxz
 R1SHvBo7LbDsWgkstNjFZ0vGJ6fzj8l5nqVX7YTKBQKjLEkvF0RPKYH1u7hJZmItA0PIqDaQ4o.B
 z.CX3ospHBAPYO277qBRdpCqgiyd_t4mcNRHDvqATZoq2_c7jyF43CEVM84AocIPuyGbfXqhJ1te
 ELPeahsLYeKVPRE964VNwj.B8cqaWEZNgqmIzRislVfr84kbHa0X5Vpj.hbokFdzHZWh4qC7iuhc
 ysZGe9l3K0EgbcRdwBAXkYY57qSAYp7hCydeu6elc6qJu3emcic2EkMBRD011rEtxExkIPUJiOdY
 foW.PFILXtzALrlAx7R.afMpPiUtHp.gmHf3SM2TOR5GzpzDM1YuO_FodV2XrYcfPAZ1fthcKH2y
 GmocW9ZpjiHISmTVfF5oiRqrUnOa8PgeJ1Yif_9Zlgs3eqheGagPe0.EpjdMyZKr.ycvGheq59ZR
 Dzb094hOWxX9Ml00IOmmOvvwoDpq5lt1vley6RH3iRt5l9F15GyC6CJ3Y0.mCn5L04w2rqLRiWJI
 IgsnlodEu3ul.YjZ0fNXLjughQloXfLCE1N9zpPCIcENSXvFQvstDBn_B5CyfbCFDYB.b6.KGK3I
 kefiJ3mlU_ftpw26bTstOaIi2.zMf_CJoRfWSguGSsb0wdtGVE7yOIwiDQgp.F6gf.1BYAGJIf1a
 2NrIwNKnEVhbYoPupAilZc1RAwbxh1WhuQCt22qWuHExUtSVVme4aSmPfYtuSJplf34_LqwaF5vx
 Wk7PX
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.bf2.yahoo.com with HTTP; Sun, 22 Dec 2019 15:33:19 +0000
Date:   Sun, 22 Dec 2019 15:33:16 +0000 (UTC)
From:   Lisa Williams <ah7790043@gmail.com>
Reply-To: lisawilliams003@yahoo.com
Message-ID: <987510639.1607258.1577028796096@mail.yahoo.com>
Subject: Hello
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <987510639.1607258.1577028796096.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.14873 YMailNodin Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.2)
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Hi Dear,

I was just going through the Internet search when I found your email address, I want to make a new and special friend, so I decided to contact you to see how we can make it work out if we can. Please I wish you will have the desire with me so that we can get to know each other better and see what happens in future.

My name is Lisa Williams, I am an American, but presently I live in the UK, I will be glad to see your reply for us to know each other better to exchange pictures and details about us

Yours

Lisa
