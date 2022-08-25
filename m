Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4B25A10F3
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 14:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242045AbiHYMqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 08:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242056AbiHYMqv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 08:46:51 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE31A6C6F
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 05:46:49 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id a4so24514464wrq.1
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 05:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=jCJsXsDD/iNK9yC84Ot8gXJYydwvdgJYruOO+RMKvrI=;
        b=MdbG8cocCQZamkCs8NWUYzEZD3jRIjul4ca83Rv4yUBe+w28w9pSf7wnD5vP7A6LJZ
         12i4tWdELq1HcZrkdde3wSsetZWk8f3IRBjpzLF863BRojIll0P5row5bYhN0ACNjsdK
         mLTOc2EzPg/In4qONCXu+DIeGWG1Q7UVzG9E70ksT6g9B5Nn66zZuMetI6YZutVwRcgo
         Q12MbHi+wRafZSEhJD0umEw8WevesFpXAh7YvYT351+1i0WuEjEE61UUmYmk28BrCu3P
         vqoZr1ahCwvigVixXHk6VJysUS+XsQb7PLXo85rvB8UcY88mwKynGu8fZtFB6IMOAsGR
         0QbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=jCJsXsDD/iNK9yC84Ot8gXJYydwvdgJYruOO+RMKvrI=;
        b=BIb7HribkyGAF3+qv1gbzf/sYgg6ggY/LNB327iSMJBjnnveshYzUGKKmrxXEkDZBW
         Be5KKMDSoPLuUc4w6P1tjxyKn8soDc2Iq6pLbYwM7Ecp+zxsgL47ukBSQZWviQDsvaWX
         N9FPvP1Hswi44hVcMKAS3kF2UJeWmF33G1OuMES+UI74DKhwoVZz2LE6QezfcnCr8i/l
         NWNW8WrILowUdrVGMiViij197kfneIsHE3ocGMwsFCh+JRRiD59t7Hh16cF4G7vFMQ/6
         kPto2I8vFqCBQXzi0DQ7GK4m94Ex3LYXiMNy9QgryGA2c3r4RL5aflZ2nt2eAnFnHA8d
         5jMQ==
X-Gm-Message-State: ACgBeo15veGOcVdz9lYmwFM4iIOioqQzgYzI/CSahceX7zgxfYGuB9Kd
        /nIflQXfQLaplY24ceWkb5KLqYmojvuqIlFGwbOhhWJPnkCrUbisFSuyTg==
X-Google-Smtp-Source: AA6agR7RCmNlZRR+2TDbk8Bi5HHLY9OXHOlB6zDmPdIFDktj2bDqtf1AwfpnO7JF7CywCzSWgZMHl9m4X321ix8ALGk=
X-Received: by 2002:a2e:844a:0:b0:255:46b9:5e86 with SMTP id
 u10-20020a2e844a000000b0025546b95e86mr986220ljh.388.1661431288354; Thu, 25
 Aug 2022 05:41:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab2:584e:0:b0:154:d744:a405 with HTTP; Thu, 25 Aug 2022
 05:41:27 -0700 (PDT)
Reply-To: abdwabbom447@gmail.com
From:   Maddah Hussain <amaddah453@gmail.com>
Date:   Thu, 25 Aug 2022 05:41:27 -0700
Message-ID: <CAPs6YASaRcuuOF-d73epgim5aagNnfRdW2FCVBZhCPdM0LL01A@mail.gmail.com>
Subject: Get Back to me (URGENT)
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: *  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was
        *      blocked.  See
        *      http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
        *      for more information.
        *      [URIs: again.it]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:441 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [amaddah453[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [amaddah453[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [abdwabbom447[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Dear,
I had sent you a mail but i don't think you received it that's why am
writing you again.It is important you get back to me as soon as you
can.

Maddah Hussain
