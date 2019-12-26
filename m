Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D75212AE4B
	for <lists+stable@lfdr.de>; Thu, 26 Dec 2019 20:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbfLZTVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Dec 2019 14:21:18 -0500
Received: from mx2.jps.go.cr ([201.201.87.195]:36468 "EHLO mx2.jps.go.cr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbfLZTVS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Dec 2019 14:21:18 -0500
X-Greylist: delayed 825 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Dec 2019 14:21:16 EST
Received: from mx2.jps.go.cr (localhost [127.0.0.1])
        by mx2.jps.go.cr (Postfix) with ESMTP id D85015FDA7;
        Thu, 26 Dec 2019 13:07:09 -0600 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jps.go.cr;
        s=e14e82cc-1d27-11ea-9b01-9e190f93e7f4; t=1577387229;
        bh=AxoqOKW6Kpq1wCNwV3CIsVRnqwbOBgKwO3zoOf3yOyc=;
        h=Date:From:Reply-To:Message-ID:MIME-Version:Content-Type:Subject;
        b=TQC7NaBUptavvTqLaRKarvvNGZ/MWvkFWy7W2shtPj7j9cJfu/HVxu8+FXPCenMc0
         4Mux1u+Kap+g76txA1cIT3vTyOjK/57AnkVjSKesRs3SI6Ed89nmJosspKHjNZy0eC
         bj3g7pX880VNzqTK//Smx0mAK5jmzq6EUz/IdAwSsLWBjmeHcoVD+Ori/SEPoypKhJ
         TO6f5Hpf8z8wnMRp9u/R5S6ddmrFBQ1QaAJwszp7F/7UuAkaiMv33LM4jBOTqlIPSS
         wCf1mnMmT37FWg/8HSVwUWcqImti3ydlkMBmI2YyoGROII/F6PnSgHQv7fjov0jutO
         7QknHGsDnhx8Q==
Received: from mail.jps.go.cr (unknown [10.0.0.247])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by mx2.jps.go.cr (Postfix) with ESMTPS;
        Thu, 26 Dec 2019 13:07:03 -0600 (CST)
Received: from localhost (localhost [127.0.0.1])
        by mail.jps.go.cr (Postfix) with ESMTP id A8A8163C09;
        Thu, 26 Dec 2019 13:07:10 -0600 (CST)
Received: from mail.jps.go.cr ([127.0.0.1])
        by localhost (mail.jps.go.cr [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id BDlM4hb9Mzlf; Thu, 26 Dec 2019 13:07:10 -0600 (CST)
Received: from localhost (localhost [127.0.0.1])
        by mail.jps.go.cr (Postfix) with ESMTP id BD73C63C35;
        Thu, 26 Dec 2019 13:07:08 -0600 (CST)
X-Virus-Scanned: amavisd-new at mail.jps.go.cr
Received: from mail.jps.go.cr ([127.0.0.1])
        by localhost (mail.jps.go.cr [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id JnAmPu_DQGBi; Thu, 26 Dec 2019 13:07:08 -0600 (CST)
Received: from zimbra.jps.go.cr (zimbra.jps.go.cr [10.0.0.246])
        by mail.jps.go.cr (Postfix) with ESMTP id 378ED63BB0;
        Thu, 26 Dec 2019 13:07:06 -0600 (CST)
Date:   Thu, 26 Dec 2019 13:07:05 -0600 (CST)
From:   Terry Owen <rquesada@jps.go.cr>
Reply-To: Terry Owen <terry.owen@myfairpoint.net>
Message-ID: <950839041.1456618.1577387225881.JavaMail.zimbra@jps.go.cr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.0.0.247]
X-Mailer: Zimbra 8.8.12_GA_3803 (zclient/8.8.12_GA_3803)
Thread-Index: qA3mrvhginCeeUrQTGYmGK2j+IOsMw==
Thread-Topic: Greetings!!!
X-KSMG-Rule-ID: 1
X-KSMG-Message-Action: skipped, AntiSpam
X-KSMG-AntiSpam-Lua-Profiles: 149261 [Dec 26 2019]
X-KSMG-AntiSpam-Version: 5.8.14.0
X-KSMG-AntiSpam-Envelope-From: rquesada@jps.go.cr
X-KSMG-AntiSpam-Rate: 100
X-KSMG-AntiSpam-Status: spam
X-KSMG-AntiSpam-Method: content [main]
X-KSMG-AntiSpam-Info: LuaCore: 336 336 9396dd2f401bf2feca9da187509bda34e224ee24, {Tracking_content_type, plain}, {Prob_reply_not_match_from}, {Prob_Reply_to_without_To}, {Content: Spam}, myfairpoint.net:7.1.1;jps.go.cr:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;mail.jps.go.cr:7.1.1
X-MS-Exchange-Organization-SCL: 9
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2019/12/26 18:06:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.12, bases: 2019/12/26 14:55:00 #14893305
X-KSMG-AntiVirus-Status: Clean, skipped
Subject: [Spam]Greetings!!!
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Internet Technology Research Center
London SW1W 9TQ United Kingdom


Your email account has been picked as a winner of (&pound;120,000.00) in cash by
Internet Technology Research Center through email balotting system.Contact Agent: Miss Rachael (Foreign Services Directorate)

NAME: Mr Terry Owen
Email: terry.owen@myfairpoint.net
Make sure you reply to both emailsProvide the details below in contacting Mr. Owen.


Fill the below:
1. Full Name:_____________________
2. Address:_____________________
3. Nationality:___________Sex:________
4. Age:________Date of Birth:___________
5. Occupation:_____________________
6. Cell Phone:___________Fax:___________
7. State of Origin:_________Country:_______



Sincerely
Management
