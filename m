Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C0C668BB9
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 06:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbjAMFuB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 13 Jan 2023 00:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234415AbjAMFtK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 00:49:10 -0500
X-Greylist: delayed 1100 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 12 Jan 2023 21:47:38 PST
Received: from yudhisthira.itb.ac.id (yudhisthira.itb.ac.id [167.205.1.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B3768C80
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 21:47:37 -0800 (PST)
X-ASG-Debug-ID: 1673587639-0ef5d76f4233ae0001-OJig3u
Received: from mbox3.itb.ac.id (mbox3.itb.ac.id [167.205.59.29]) by yudhisthira.itb.ac.id with ESMTP id hVuaz5C3jAdRp4NW (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Fri, 13 Jan 2023 12:27:19 +0700 (WIB)
X-Barracuda-Envelope-From: verasadarviana@gd.itb.ac.id
X-Barracuda-Effective-Source-IP: mbox3.itb.ac.id[167.205.59.29]
X-Barracuda-Apparent-Source-IP: 167.205.59.29
Received: from localhost (localhost [127.0.0.1])
        by mbox3.itb.ac.id (Postfix) with ESMTP id B4A0B801BDB02;
        Fri, 13 Jan 2023 12:24:49 +0700 (WIB)
Received: from mbox3.itb.ac.id ([127.0.0.1])
        by localhost (mbox3.itb.ac.id [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id prCBM7XGPSE7; Fri, 13 Jan 2023 12:24:49 +0700 (WIB)
Received: from localhost (localhost [127.0.0.1])
        by mbox3.itb.ac.id (Postfix) with ESMTP id B9D8F801BDB0C;
        Fri, 13 Jan 2023 12:24:48 +0700 (WIB)
X-Virus-Scanned: amavisd-new at mbox3.itb.ac.id
Received: from mbox3.itb.ac.id ([127.0.0.1])
        by localhost (mbox3.itb.ac.id [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id CK3RAxfkxda4; Fri, 13 Jan 2023 12:24:48 +0700 (WIB)
Received: from mbox3.itb.ac.id (localhost [127.0.0.1])
        by mbox3.itb.ac.id (Postfix) with ESMTP id C1ECA801BD6BE;
        Fri, 13 Jan 2023 12:24:46 +0700 (WIB)
Date:   Fri, 13 Jan 2023 12:24:46 +0700 (WIB)
From:   =?utf-8?B?0YHQuNGB0YLQtdC80L3QuNC5INCw0LTQvNGW0L3RltGB0YLRgNCw0YLQvtGA?= 
        <verasadarviana@gd.itb.ac.id>
Reply-To: sistemassadmins@mail2engineer.com
Message-ID: <603604656.840501.1673587486463.JavaMail.zimbra@gd.itb.ac.id>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Originating-IP: [223.225.83.36]
X-Mailer: Zimbra 8.8.6_GA_1906 (zclient/8.8.6_GA_1906)
Thread-Index: 7J/VgGxVS4Gyz5bpkfuL33feLVZUIg==
Thread-Topic: 
Content-Transfer-Encoding: 8BIT
X-Barracuda-Connect: mbox3.itb.ac.id[167.205.59.29]
X-Barracuda-Start-Time: 1673587639
X-Barracuda-URL: https://167.205.1.122:443/cgi-mod/mark.cgi
X-Barracuda-License: Expired
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at itb.ac.id
X-Barracuda-Scan-Msg-Size: 1150
X-Spam-Status: Yes, score=6.9 required=5.0 tests=BAYES_50,
        FREEMAIL_FORGED_REPLYTO,MISSING_HEADERS,RCVD_IN_MSPIKE_H2,
        RCVD_IN_VALIDITY_RPBL,REPLYTO_WITHOUT_TO_CC,SPF_HELO_NEUTRAL,
        T_SPF_TEMPERROR,UPPERCASE_50_75 autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5001]
        *  1.3 RCVD_IN_VALIDITY_RPBL RBL: Relay in Validity RPBL,
        *      https://senderscore.org/blocklistlookup/
        *      [167.205.1.122 listed in bl.score.senderscore.com]
        * -0.0 RCVD_IN_MSPIKE_H2 RBL: Average reputation (+2)
        *      [167.205.1.122 listed in wl.mailspike.net]
        *  0.1 SPF_HELO_NEUTRAL SPF: HELO does not match SPF record (neutral)
        *  1.0 MISSING_HEADERS Missing To: header
        *  0.0 T_SPF_TEMPERROR SPF: test of record failed (temperror)
        *  1.6 REPLYTO_WITHOUT_TO_CC No description available.
        *  0.0 UPPERCASE_50_75 message body is 50-75% uppercase
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

увага;

Ваша електронна пошта перевищила обмеження пам'яті, яке становить 5 ГБ, визначене адміністратором, яке в даний час працює на 10,9 ГБ. Ви не зможете надсилати або отримувати нову пошту, доки не перевірите поштову скриньку "Вхідні". Щоб відновити справність поштової скриньки, надішліть такі відомості
нижче:

Ім'я:
Ім'я користувача:
пароль:
Підтвердження пароля:
Адреса електронної пошти:
телефон:

Якщо не вдається повторно перевірити повідомлення, ваша поштова скринька буде
Вимкнуто!

Приносимо вибачення за незручності.
Код підтвердження: UA:@UA.WEB.ADMIN.WEBUR431MeP453.UA
Технічна підтримка Пошти Системний адміністратор © 2023
