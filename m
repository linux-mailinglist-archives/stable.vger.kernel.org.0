Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F574C59CA
	for <lists+stable@lfdr.de>; Sun, 27 Feb 2022 07:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiB0GGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Feb 2022 01:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiB0GGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Feb 2022 01:06:09 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680A01B9
        for <stable@vger.kernel.org>; Sat, 26 Feb 2022 22:05:31 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id t13so4203817lfd.9
        for <stable@vger.kernel.org>; Sat, 26 Feb 2022 22:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=iDVml5xfbk36oHa8VrWbFp+G4WP/9Ja65IB3k6j7o0RssMoShthgCI80I2LsmVTZuG
         Iu/CGqD5wtKcZQWrRKxKMNgej8N/+O88xlterNEwhCGVw/lo+Y3CBxE+cpgHnz7Y6AR2
         pL1J/YO1IVjihgcMz8diSIUlnGGCOZBzZYpHtZybyDdN/Tyq1GwuMvqqT2wtqpI+67Td
         gtpIOMQLSQHErQjPhqU75tscCU1/Lhns/E9r+29CKcINQgJT/bJeq5mBrkyQt4LkfEnA
         kuC5r2P8UN2WSHGEKZ6euc3QlXXcjaFhTCaRPBdI2g2btCchqL2yGYBN51MCi6BUSF69
         TyFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=Px5I1I2glEWzsWO4tHz8uDrnp1+/Zv51k/tyUz0Ebl4Y/249aqBM3yLFAbJBJKM56m
         CChU1m830rsp8BnnVSuFyfZf+xY6tNQKZhmd7XUJIzkVd+yUgJW+J7lsWx5PiVEZR5YK
         zb/Thn4IBxV/gYgZwYyiAXQg4m+BSF1oGv6r0kBs83Ooj0Am+KHFGWG4Q3vo5I/VAeZd
         hEbrfcBtViYUsor6MpLiRjAxhmpMElocqgCrK5T39Ep4KcSbuHm70jdC1yGEz4Mh9EL8
         MmzpwPiFw3y3Q22g/okN5oH8SANc5wTkgq+VhHVPlt+P6bDOzTx2aejxrthE1K0XLrKs
         Kb4g==
X-Gm-Message-State: AOAM533s++32F8aqJKCp1IaKh2V/q7x7XNvk/xszhJEZfGEvxFK2SJ3z
        ZPLRfDVNEmZbIYrikBoPDy3ig1V6jLbuq0NtAYU=
X-Google-Smtp-Source: ABdhPJzeN1Z3F54+opiQho1q/QUFsgRb9/O7gLLaFtsx1XyqJCt3+CSxsFoKW+6CyjN8OfuMgePu3aIQ9bTu8GbvAYs=
X-Received: by 2002:ac2:5ec8:0:b0:443:3d7a:affe with SMTP id
 d8-20020ac25ec8000000b004433d7aaffemr9252099lfq.486.1645941929609; Sat, 26
 Feb 2022 22:05:29 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a2e:3102:0:0:0:0:0 with HTTP; Sat, 26 Feb 2022 22:05:29
 -0800 (PST)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <tracydr873@gmail.com>
Date:   Sat, 26 Feb 2022 22:05:29 -0800
Message-ID: <CAARq6VatzeVFBC79fZmoCZmqtQXeARD4nxmjwesbkmped=ftvw@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.8 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        FROM_FMBLA_NEWDOM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:12f listed in]
        [list.dnswl.org]
        * -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
        *      [score: 0.0734]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [tracydr873[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dravasmith27[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [tracydr873[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  1.5 FROM_FMBLA_NEWDOM From domain was registered in last 7 days
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello Dear,
how are you today?hope you are fine
My name is Dr Ava Smith ,Am an English and French nationalities.
I will give you pictures and more details about me as soon as i hear from you
Thanks
Ava
