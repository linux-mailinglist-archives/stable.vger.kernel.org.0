Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7921EF70D
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 14:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgFEMIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 08:08:05 -0400
Received: from sonic304-20.consmr.mail.sg3.yahoo.com ([106.10.242.210]:45475
        "EHLO sonic304-20.consmr.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726404AbgFEMIF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 08:08:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1591358881; bh=ymRF8bJ+M3trxzdWPwq/27Qe0+bVMhuhvq5GHhnaWi8=; h=Date:From:Reply-To:Subject:References:From:Subject; b=VnG8Wd5RW4SuT6NwWZyk3BHJEv3BaF0kur7W5SHP/LE3sPD7n5n2EL1F8Ax/BdyPf4IM6zm67GI3CwhXUambHDsg8/QQFfSyM9hCUKiw9d+ahaubb7zSwsg7Vy0Jh69wIdBkyJiEcDQiWzlgzdeazYXvwcpB/sTmvU1uq/EpLdWn/P+E5hlE8iT5Bcykb4GQnMtqew2SArC47VZNA5OIidnHEeRH+ydZVV5x0Stm71X6AQyKA0qROG3rDmBN9q7W7MEpEYls7uPTkIb/Qe76B/o0oaP4IER6L+MXW4S3onWRiz8AADJNuD/Is6oSLYc0zz9+a9GxMkY3D4u3gRnhSg==
X-YMail-OSG: zfcNcdQVM1kzLzQd4rWV19jHqeQ7T_iU69aPviETUTbEfzA9SDfIYssu6OTvjUC
 Tx538_KnsEVqFsQNKOUAias8q8ZQ8d5yU1yeTvKX6J_x9.YyLGM9mxI6NZlcLsA37xh6i_6Mbs8G
 KVIqxI7l2l1j9r6sTEJ4ZVjtDo.OEaUk3cOj8o6Jfk7O8OTrGePBSYz15.i.ND1z14PJ2.ITsCkx
 OAKOGxrzlvi0Z0TXX6JDPDwjyVfdnzB5gR29.4VwCVj8iA_w1_PjEwv_7MbyO_kb0yc65ZVlPd3j
 42Oq6AfDvryi9rd7KjDi1HECTDGwRzn9V4AJs6qT3fEkCPY_WwCYIzh1XnRv.LRaH9W7A20quvjc
 SwFw_.nDtnOu_zMGiSHwKqWYbjK9vRCxMG2pHTmkny.DaDFD_4B4vws8VvR6eWNwGYUS8ny1zNWG
 6VTAhUI_kpWo87yVGVav3MpQYkfuBuFkoVbhi6MloG9T8Uu9syJv6m8e9yXmTN4OkVVdwa.hyGG3
 pO6uys9u6M4qrHSIq9fErT1MsAkgw4IfEzkasUzg2XOT2uV4vddVzJ3DkDSZ66Fm9MteyVlahKlr
 2eEkpn3vJVCmo0UMv8uR0hRfw43bx6Uy7cj0bQM0ITYqtQpWDqWCn33k1qcUAP7ksSDiRk_kUJ0v
 eWTcuVsZYnIxkEceeoLD.44YD9bcFzfnmiwaUXmbKd1LffSHRhb5p2Bg05U.7qX.kfdrwiyonP9j
 FQ5_dL_aoC6115Sb5kM4LK4a94OfffRG0o02LW4lF.CYaE9LM1kiBWReSNDdlleNkXzj3WKw5jq4
 p9K7B982SLAoXwlOBRdhPppMv1CY7AlsM8eYaGWgmjrLbExvXarjQCgGVHXhlS3G1rufyIcYVZYR
 79rNmZuowpYpKf6SI061z25qYtt5SB5xU__QdI6tkJW4D5d9ZLV_JNx0uKaCcCIbjwxwWIhHidDV
 BSFztkvdyuh2ajsIPdiwE89lsFBG1DeVR915bo.EZkoy78sZ3VSNLJ0W59m0GdMpAS44c37PfQP3
 JKCORP2ayD8JpDeIbe6N6OZxp0D13QWUoQOYsUvLnQglfQWo0ZyZVDHsR6jJuaLZE1QjOqPlxyzl
 FL2Tk2zsNl5Nqpv0qMD9gJO_9aCgFx7uNG84Mcxj5TyMbRxO9XqYrSiUF.GxIDieQwhFKgEC.vd3
 Eulo3dDZepIheyuq00rHoIdRk3Bu6SItaI0.SGtSpVQhCd62mJBnzr5VuBPk6pRGLuvunWLqhSyJ
 Hs.YCpBtFRF_TifpRIUM1I1JUoaYw5rMSSFj4wVfFAxNuy_FFxvXi4MZbCGT3KvJSAhInKtDWBJk
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.sg3.yahoo.com with HTTP; Fri, 5 Jun 2020 12:08:01 +0000
Date:   Fri, 5 Jun 2020 12:07:58 +0000 (UTC)
From:   "Mr. Edgar Oscar" <scdn1920483@gmail.com>
Reply-To: scdn-1@go2.pl
Message-ID: <2042759130.1339979.1591358878387@mail.yahoo.com>
Subject: Hello, Thanks
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <2042759130.1339979.1591358878387.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16037 YMailNodin Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Hello,
my name is Mr. Edgar Oscar. i'm a Business Man Dealing with Exportation Diamond & Cold. please i'm so sorry I got your mail through search to let you know my Situation Am a dying Man here in Hospital Bed in United State here. I Lost my Wife and my only Daught for Covid-19 and i'm Covid-19 Patient i have a Heart disease. and my Doctor open-up to me Mr. Edgar Oscar we are sorry i know to myself that my Life is not Guarrantee any more, i want to handover my project to you. i have already instructed the Bank to transfer my fund sum of usd $4,500,000.00 to you as to enable you give 50% to the Less Privilege Home and take 50% i have given all i have here in America to the Less Privilege and the needy I ask my Doctor to help me keep you inform if you did not hear from again. please reply me Urgent. this is my Doctor Whatsapp to reach me very urgent. +13019692737

Thanks.

Mr. Edgar Oscar
CEO
