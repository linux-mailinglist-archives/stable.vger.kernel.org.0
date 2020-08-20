Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC6824AC70
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 02:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgHTAxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 20:53:44 -0400
Received: from sonic306-21.consmr.mail.ir2.yahoo.com ([77.238.176.207]:43999
        "EHLO sonic306-21.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726617AbgHTAxn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 20:53:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1597884821; bh=cjAgTy4mmtHrGWQX9CiI5HArwv5SkYft/WjuuSpsn/w=; h=Date:From:Reply-To:Subject:References:From:Subject; b=c48MH7ZET/h5jqcLD8Gb5/hFfhyAkwb0xivMKf0C5Z6OHwJC+F9XRchEVKIQaVWmDafCs49LFaivCNoQi6v6FWSWRTed7nhGDkFGtx6uQ1JImDRaqrz6k/9S9sVnopqPDtIU3Z0/G4aL16I4Ss1g0XVKLL0YudlKzf4+zkhhbK+omZvXvax61dznpXjSbhKOioVcfZQk3+5vS1QddwZ+Em0gFfM3X1OZelf9za9/r2vgfBGYZMZl2Pmb5GBsZdHx29CPn7X9kqFqpmafdNxVPjYwmhD3I2cbexi1uwRla7hFJa31TDqHM/Pe3/LwXJefgAoUYA7HRK2VcfUPQR7cDw==
X-YMail-OSG: 6nxbodkVM1n7RZPnhGt_yumvr96BZUuvO9K7c5e2uh.pjzeFFa_4y5u1fYuMo9y
 KX.qKTps6mrLQkq50J5Iietkb5ns1plDs_h7alLc69IeB0nMdob2gRZNzEYx.fASZ_lS1uaEQMh7
 AHG1jL6g9z13FYn8j.Co1SyC8gkgio6vmSnlv1BwFFSbtiwBqKexAUaXfBtutgnpNKlihtGYCN5n
 QW_sgk02QKZXoFxRDbo_QeUPm4krbaMsKy_YB0i4hautQaOqos8oUdM_MBG7o45HqTRWVAJaxCOT
 cZLhAxiKVnB.rXX5SAeL19ToSqm_IkdgcE.GUiOCVUd_rGd6NuXdiLbhK0Ak5xvgD_Nv6K8Y_Jtb
 BtbV8QjtDsyTnPsK2KS51W3MJFSv9jbAN6sUnW9YMKljoVqjhgHpkrzf9idBOhOoqxM8gq401jNQ
 3z1p4G24Qwpsj.sBFHASjHBduWk3gRC2Y2k_AzTXAvQePMbLiS2DxQbSrEtqcBmdIZ8lxP2OHixp
 2ZQx1px4Qs3Kh2_67Dg4ssDkTrLuzgLPMHz3ha.2yxC5vd.dqFPgvrIRUER9aA1Ff7OiCYlF8x4K
 7hykN2grVsRklG2SZp6PwWjjQrs_DogNeDrDqxCYc079xMQX7l3XO4Bom81HW7vIQlNePpkddBUc
 IzyE7O2jkSNLsd1qjzJ5P1uQbUucU.xRf1fnSMM0P85TMZj9.lXUennR56QPx5nXTdkWG4f2bnoa
 e1rJT_ohAnXkG0YBmPU6oT9.Ecz8ZY5qIlttx6FIk0TBUF8lK5gmFXne0isR5Cyllvfz6mZ.tGpf
 153E0d.zUExDnpXnYZSRczvkNILAzFCZlzq0Ix8ebpd12jYbM3ltQDaCD0BGQClkgEc2TMcHdjSh
 MTEURsCFdtbfrbjzsfQblH_KbhTE4A9RsCNz1IHA0jM_FnuCcdVVlpl_7BRbOFsqAjpTiIfJPQ5h
 5wPQ_qlauTZNjoM8rXoDr9ngsouldfatsnEei8ewDAfsLea6Ov6xb0zWo7QDhUbih2Io8S8wHDqK
 nNNu_f.bME1Z7wytVa2ChRNcADzG0JFovVm9xI.rPJlUmzHV_JosxXuertsUbwQHfp1Pij69MwPy
 xofGaoAyXxAWxMg3Kg8zlR1.58O_OjGiLCB_BZeuZAhhLw5Au89hxLqF8_fzPIZBemtadLfgbErw
 nyqPaW3jTEFk1G9b2YGI5pyZ77HTMsUoKbWveSYXkISxeU8wuPJnyKcwTrd7jI1vdpNLCu.kMhYO
 s9fZj2kMlQTG4rPDQ4xKT8ZQH0myvGYeqRaQksXE6zVz2_GrJQbXdDTHb6bT8oDeNrc.7v_5mm4A
 84Vdr5OPe7yce0mwgAwKbMEpO26VRJcTbqJpeOYoOn0f78M8-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ir2.yahoo.com with HTTP; Thu, 20 Aug 2020 00:53:41 +0000
Date:   Thu, 20 Aug 2020 00:53:37 +0000 (UTC)
From:   Mr mohamed Musa <mrmohamedmusa@seznam.cz>
Reply-To: mrmohamedmusa5@gmail.com
Message-ID: <1310561081.5355565.1597884817710@mail.yahoo.com>
Subject: I NEED YOUR URGENT RESPONSE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1310561081.5355565.1597884817710.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16455 YMailNodin Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Assalamu alaikum 

My name is Mr. Mohamed Musa, I am a staff working with the Bank Of Africa here in Ouagadougou,Burkina Faso.

I want you to help me in receiving the sum of Twenty Seven Million Two Hundred thousand Dollars ($27,200,000) into your Bank Account. This fund was deposited in the bank here by a foreign customer who died accidentally alongside with his entire family members many years ago. Nobody had asked for this fund till now waitting to hear from you for more details thanks.


Mr. Mohamed Musa
