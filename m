Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7AC6A3E5C
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 10:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjB0Jbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 04:31:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjB0Jbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 04:31:32 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901189770
        for <stable@vger.kernel.org>; Mon, 27 Feb 2023 01:31:25 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-536cd8f6034so157586817b3.10
        for <stable@vger.kernel.org>; Mon, 27 Feb 2023 01:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677490285;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dBDMlMkLoASgaz9f5d/hsoljdZ4QfI+/2xs9WyTgJdQ=;
        b=RIYJ5e0xzzpVuLKcmTCaAleq7XLhxvSZ1FNsIrgEKk9/i4IiilWirp7UE+3X19/Tr8
         LXuAOWENRpKlU8qK+aSUrZM5ojNoPUzEQd0xNOWl7MC4OpxL6P8E8eK0QNnmZfMxMSVb
         ImYJW1qamGSdphD3TWPpgk4Asa5N/AkegUK+sTEdJjX7In2ZfgIYI3TDJkGwFUs7dUEz
         LCtBSiSr2F95woAsPLO+zmJzOO94CNOgUDh+vZHRLHmz8lCn5hp51XUNjXC5Yi7/jJzP
         l4s9uUinticyuDxxezKYerO8l9pWvk/RpGh7Z5umqDHeqqIb+9/c8jQXUnTO6IWZPAPe
         v5LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677490285;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dBDMlMkLoASgaz9f5d/hsoljdZ4QfI+/2xs9WyTgJdQ=;
        b=Fc+bryTzzz8DZoIYs1XzC6mDdxBxazJ8vSLkkqge4O9B0dkWvW9tKmUoJDE9vzW7UB
         Qw1L47ffDvsaDSK03nNLiOEp41hFQMHdkf3qMK8DERcOkvu2q6/dq6Dy2HKuf1g5OIv/
         nhut9b+iLN8QCpZ0bfd/ZuRre3erG/RTbroFTcmoTEHZAOZPWcchJ094ZaIPw17WX4ew
         tKEmRnWdGugYifv18iavl9jZ6wZemUNgAl4j5K6Zh/LX5OkIt49VkkKU0OkwgGdK4mhV
         T0tUhv/b6g2WIEz6WvATIkvXhWjwPe/2Xrz03Ji1epgbSk2D/ttLIKkkxZdfwzUs2nLg
         o3lw==
X-Gm-Message-State: AO0yUKVXdpdh9+YAausjb4miU3aSocRdqG10ZPO/HQ0yfP5oeIJzgHIs
        A8imYszOtP63BbeRBYwY+kHDXoVC1XYtBkqF5Tk=
X-Google-Smtp-Source: AK7set8AF6+oYAm7oxUXvJzanzWryq+jRW5a/NhkgfwMf+8yKNsuSUgl6kDxMrceXUL9R7toh7ys2s7rxXs8si8MjrQ=
X-Received: by 2002:a81:b71b:0:b0:533:8f19:4576 with SMTP id
 v27-20020a81b71b000000b005338f194576mr9930562ywh.0.1677490284750; Mon, 27 Feb
 2023 01:31:24 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:1001:b0:1d2:8b4:1e71 with HTTP; Mon, 27 Feb 2023
 01:31:24 -0800 (PST)
Reply-To: katerynamudrik01@gmail.com
From:   kateryna mudrik <mrchechnz.7801@gmail.com>
Date:   Mon, 27 Feb 2023 09:31:24 +0000
Message-ID: <CAD27ePUTYoCyaCZG3m7yVwQfXabS1CyMztezC4zQ2dRy+KZs5Q@mail.gmail.com>
Subject: Hello, good day,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.8 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1130 listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.7577]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrchechnz.7801[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mrchechnz.7801[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [katerynamudrik01[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello, good day,
Please don't be offended by my unsolicited email. First of all, I
would like to briefly introduce myself. My name is kateryna mudrik, I
come from Mariupol in the Donetsk oblast in northern Ukraine. We may
have been humiliated by the Russian invasion of Ukraine, but I still
believe that we Ukrainians can be friends with good people like you.
Now, time won't allow me to say much, but I will tell you the main
reason I contacted you when I get your response.
Thank you and waiting for your response.
