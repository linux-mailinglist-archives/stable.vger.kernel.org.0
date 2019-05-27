Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD0B2B279
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 12:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfE0Kvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 06:51:47 -0400
Received: from sonic309-48.consmr.mail.bf2.yahoo.com ([74.6.129.222]:40791
        "EHLO sonic309-48.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725814AbfE0Kvr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 06:51:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1558954305; bh=hm2eWSdcZt5qZGI06OGG2BnJIZ3Akb6O3ATKED243Uc=; h=Date:From:Reply-To:Subject:References:From:Subject; b=S30ApymA8PUbAvLAMI/yQ+W5WAOord4HipF9jySKNywe3+nsmt+VSflz7sMzGs+Ipo8ZQfyoOeH8RPpTjTdAln8nJl93XAsZuHfVN/53vE4fNfv4g6HHi800fhTD/liPBcfBvVL5qBIbZQs1/wqCSNV2xSZ0K0KYB8raOVK3YK1y7+ctynD89/BJSL9pBSI9YMmvHZj8TacAr9W642L96YNgkRJNMIYhu3q7myBbWFTVjRpbYno/P1aAqLcuZAqsT50/ekznn4J+McttOHcBNvhMBY2ayM4e4wHyIl3AvOnKDTf8ul+O0vnrLilujtPAKBOqNRt9x/47rFBrlEP7MA==
X-YMail-OSG: gbizDwsVM1mxdatLpB6W6Dg1rIDJcLW0VqJHOapaTSFMJtb5UHka0jiOCsoAb8z
 vCkVj0GcnOxUKWLD06IzScSiI3IPUtMOJDZlNEM7vt.p26QoaBTCzjQgQR8GSTdl44rkTfKYBUnR
 2ah3eoaUSKKKaNdziDKMXQObeNzKB_h.qWmiI.oUlV6.U9wNBCQFwcGI9SdI1rTQv25khNU5wQVX
 FQN01aneEnzChkz1.Q70DQHig5PHCll0srKvKuLBOj7VuyKbmNFngWm42JFJj2BROP02lb09nNED
 JEb8dg8SL6zsgVrFC4ydlJ0OYPSAi7y4MGe.cDgpNJCRJr6LACobatnI2JU7MM9uKBkuETEN6ky7
 5ZbI0PiHwBUrI8W_yE9pPSEQFNZUo1iEu3nlWGC2haS9hwAGJsOvju2A1z6ASxHivgAIQGu73tgV
 uhsg00dgLchk8JwjJweHmG9xOzrJcLvAoHUWQuGkC602haO6ddvffBAub_dOM3BuT0ODD0F5mREf
 DoXjcOD8g3bx24s6BNrG6XKgvj2zuTG3qz4pJ8TiMFhpf1Rmb2O06MguXZu5cwWDHEhY44TAy0HM
 GxvnmSnpIwxRPoFqCEjQYf2ExUBgSIZ0j8tt_eNDqB_8Vx2d1ThxB7LBYa5AVHtveRQ6EOk77YuD
 W74ymTFYlFinym6Cv5jKe4hjnPJZKghWZ95MTnC491LYBJFnoO0rMSUcTScDrhyosJVpfdp8g9yn
 BemDTrsRsHJlVkL7npG2_V5eUtSwKElmQnNCG7uiVxGebcMPIPrqpfhTXw5dmBZWX5DrIi63lnHC
 y6DjYGRANmKrNWntWv0adb74Lv5TwiLeit2LkWlk6Th5I7BKncSjYRONB.2MoX4JnmfpdTrZg2NP
 uJBoF9IsEU.wxS5Q0oJESLw7ENXJWfqY4cBpcfjpB19esfHnEchANzQNLlQ6mYRQ5EpsPAZkwOcJ
 Jr4aEFmzmpsUYXfMjaHsuQVGzATA8d81A17YNqslUaPiq9KuAAOMZNseg7lIrSUGT.M.hVuSMgSL
 y9EwvJtT58Wtt0ZTMr0WqbTN2Id6OIxxPW05k1j.QjZlS9UbqVQBlyvW7xtHhvo23qlS0SUjZhPC
 YSP._QLjh4mdP_1Jay1wL166Mrwi0D1lQP12_M9Zqs1.Dus_hhhUGG1aR1O8C9oyaWLjx_VirouN
 gbxVOQXQWAOKOySoujRsl89DNxAxV5eP0Ovu4VRYw9zx9pAhPrZLwAam.LivCO2IFQ37E
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.bf2.yahoo.com with HTTP; Mon, 27 May 2019 10:51:45 +0000
Date:   Mon, 27 May 2019 10:49:44 +0000 (UTC)
From:   Major Dennis Hornbeck <gh88@labourza.online>
Reply-To: Major Dennis Hornbeck <hornbeckmajordennis637@gmail.com>
Message-ID: <683765893.5228721.1558954184964@mail.yahoo.com>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <683765893.5228721.1558954184964.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.13634 YahooMailBasic Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


I am in the military unit here in Afghanistan, we have some amount of funds that we want to move out of the country. My partners and I need a good partner someone we can trust. It is risk free and legal. Reply to this email: hornbeckmajordennis637@gmail.com

Regards,
Major Dennis Hornbeck.
