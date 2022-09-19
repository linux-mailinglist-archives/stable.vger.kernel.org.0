Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCA65BCC75
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 15:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiISNED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 09:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiISNEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 09:04:00 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA3A2F656
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 06:03:57 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-1278a61bd57so61706489fac.7
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 06:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version:from
         :to:cc:subject:date;
        bh=wERC1dAKO5PL7pICmuBQieROEUKf+Gdl0m2+8GmdLMc=;
        b=c7qVCF52nzZhFVDyX3gOS+XnTUF38Dpt55e8fGujtm/sqdztavQX2ULjx86KTQtOGB
         ++UjjneWWichr8AhgQ1dEzfYkOJThlDvZMRgtUFl8fkC2pfj7JlBpeMF+Qj7ihr27/XT
         ZdD8GnLH7skTRv3r4v8tY+WbEukNJPsVN4+bnds6KVHbejL0dvphE3vxwcfGzIZfZU5d
         A7cN98S3xDGvr2nLCRlkqNw9CVwlTIEx7vmNOqv7ficLA0SH+/X8DGDA3ghSz4j8Es49
         3gb7f5t6sXvpETrr/rsgUTMNGOgs8fXoJhcXz94BmZOjXbUhlO7YOH5UMCIZe1pPntE8
         XPbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=wERC1dAKO5PL7pICmuBQieROEUKf+Gdl0m2+8GmdLMc=;
        b=4GS1ROy3IWe4JUukLsEBeinFFEPd8P5JFLRHtb7WRjbROE3thAYzx95ZFKsf9xayeD
         WSvRadNGFsPCLrqW91v7PzXTXwT+fTmOkUtN3GEvOqq79wCqoFJSnORDv6GsSzxZK3oj
         wMbUZWyQuGC9F3KcSNpTrbIkJnDOxrPDa7qPaxECK6EEhmA667nvNGGF3bo1jq1waJZo
         lLRYLZpjzx/OBPgrdIk10wVSIV8AmYzSg1BqNRl5r7TF3Yk+3Vrb636k72CVSBkGWMdR
         2mcp3SIoY+gSOFwPw9gzGcBBhHcVWbOYYB6qpgJoxYJfOaroK7jq8OjBYPiysI7If604
         KDzQ==
X-Gm-Message-State: ACrzQf3jfl/IIYGnP3lMUC+XSL/Iq3qYfBwKmJuYQEv1ruge/Nqe+sgi
        xBcKof3p07RAgYwYAaxJc4dEhuiopqQE1xA2kRM=
X-Google-Smtp-Source: AMsMyM6wUsreWg6tnF/seZAtrdVB0nErNZy3YCrvdXvKW/ksJxbDmZC2yAmD5DT5e0fChwqPQCB619BOAaaymIMVGkk=
X-Received: by 2002:a05:6870:5704:b0:12c:be39:504 with SMTP id
 k4-20020a056870570400b0012cbe390504mr5039068oap.18.1663592636348; Mon, 19 Sep
 2022 06:03:56 -0700 (PDT)
MIME-Version: 1.0
Reply-To: honbarristermatthias@gmail.com
Sender: peterfuller301@gmail.com
Received: by 2002:a05:6358:4051:b0:bd:43d6:121d with HTTP; Mon, 19 Sep 2022
 06:03:55 -0700 (PDT)
From:   "Hon. Barrister Matthias" <honbarristermatthias@gmail.com>
Date:   Mon, 19 Sep 2022 06:03:55 -0700
X-Google-Sender-Auth: bXYVFnrZEchNaZPmW778Om6dwxY
Message-ID: <CACzHKneNT-+RmyDKzvtBuzMHjJ1E_SJMqYSW3-e3Hkx6LBJgpA@mail.gmail.com>
Subject: My Greetings
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNCLAIMED_MONEY,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5460]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [honbarristermatthias[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [peterfuller301[at]gmail.com]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:35 listed in]
        [list.dnswl.org]
        *  2.4 UNCLAIMED_MONEY BODY: People just leave money laying around
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  2.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

My Greetings,

My name's Hon. Barrister Matthias, I am sending this brief letter to
solicit your support. I had a client who is an Indian and his name is
Mr. Gurbhagat Singh Bhatti , he was a dealer in magnesite minerals
here in Austria and also a Gas dealer in Russia.  He died six years
ago in Russia after a Gas explosion in one of his dealing offices
which led to the death of both him and his wife.

He deposited the sum of 4.5 million euro in one of the legendary banks
here in Austria. I have tried all I could to get in touch with any of
his friends or family members but, no way because he had no child. And
the recent death of Covid 19 killed his only brothers in India last
year.

So I want you to apply to the bank as his Business partner so that the
bank can release Mr. Gurbhagat Singh Bhatti funds into your bank
account. I will provide you the guidelines on how to contact the bank
and we have to do this with trust, because I don't want the bank to
transfer the fund into Government treasury account as an unclaimed
fund, so i need your response

Warm Regards,
Hon. Barrister Matthias
